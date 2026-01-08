import 'package:flutter/material.dart';
import 'package:tfields/logging.dart';
import 'package:tfields/widgets.dart';
import 'package:thlaby2_save_editor/mixins/breakablechanges.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/save/party_slot.dart';
import 'package:thlaby2_save_editor/widgets/forms/party_slot.dart';

class PartyDataWidget extends StatefulWidget {
  const PartyDataWidget({super.key});

  @override
  State<PartyDataWidget> createState() => PartyDataState();
}

class PartyDataState extends State<PartyDataWidget>
    with
        SaveEditor,
        TLoggable,
        TDialogDisplayer<PartyDataWidget>,
        TDiscardableChanges<PartyDataWidget>,
        BreakableChanges<PartyDataWidget> {
  final List<PartySlotForm> _slotForms = <PartySlotForm>[];

  final List<PartySlotFormKey> _slotFormKeys = List<PartySlotFormKey>.generate(
    12,
    (_) => PartySlotFormKey(),
    growable: false,
  );

  @override
  bool get hasChanges => _slotFormKeys.any(
    (PartySlotFormKey key) => key.currentState?.hasChanges ?? false,
  );

  Future<bool> _showDuplicatesWarning(List<PartySlot> slots) async {
    Iterable<PartySlot> nonEmptySlots =
        slots.where((PartySlot slot) => slot.isUsed);
    Set<PartySlot> nonEmptySet = Set<PartySlot>.from(nonEmptySlots);
    if (nonEmptySet.length == nonEmptySlots.length) {
      return true;
    }
    await log(TLogLevel.warning, 'Attempting to include duplicates in party');
    return showSaveWarningDialog(
      'Having duplicates in the frontline can confuse the game when computing '
      "a duplicated character's MP and TP after a battle",
    );
  }

  Future<bool> _showEmptyFrontWarning() async {
    await log(TLogLevel.warning, 'Attempting to empty the entire front row');
    return showSaveWarningDialog(
      'An empty frontline can crash the game if you go into battle',
    );
  }

  @override
  Future<void> saveChanges() async {
    List<PartySlot> newSlots = _slotFormKeys.map(
      (PartySlotFormKey key) => key.currentState?.value,
    ).nonNulls.toList();
    // Display a warning if trying to include duplicates
    bool proceed = await _showDuplicatesWarning(newSlots);
    if (!proceed) {
      return;
    }
    // Display a warning if trying to empty the front line
    if (newSlots.sublist(0, 4).every((PartySlot s) => !s.isUsed)) {
      proceed = await _showEmptyFrontWarning();
      if (!proceed) {
        return;
      }
    }
    saveFile.partyData = newSlots;
    for (PartySlotFormKey key in _slotFormKeys) {
      key.currentState?.saveValue();
    }
    setState(() {});
    await log(TLogLevel.info, 'Saved party data changes');
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _slotFormKeys.length; i++) {
      _slotForms.add(
        PartySlotForm(
          initialValue: saveFile.partyData[i],
          hoverUpdateCallback: () => setState(() {}),
          onValueChanged: (_) => setState(() {}),
          key: _slotFormKeys[i],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !hasChanges,
      onPopInvokedWithResult: onPopInvoked,
      child: TCommonScaffold(
        title: 'Edit which characters are in the party',
        floatingActionButton: saveButton,
        children: <Widget>[
          TGridRow(
            xxlFlexLimit: 4,
            children: <int>[8, 9, 10, 11, 4, 5, 6, 7].map<TGridItem>(
              (int index) => TGridItem(child: _slotForms[index]),
            ).toList(),
          ),
          const Divider(),
          TGridRow(
            xxlFlexLimit: 4,
            children: <int>[0, 1, 2, 3].map<TGridItem>(
              (int index) => TGridItem(child: _slotForms[index]),
            ).toList(),
          ),
        ],
      ),
    );
  }
}
