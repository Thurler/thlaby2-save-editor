import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/extensions/list_extension.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/mixins/alert.dart';
import 'package:thlaby2_save_editor/mixins/breakablechanges.dart';
import 'package:thlaby2_save_editor/mixins/discardablechanges.dart';
import 'package:thlaby2_save_editor/mixins/navigate.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/save/enums/character.dart';
import 'package:thlaby2_save_editor/save/party_slot.dart';
import 'package:thlaby2_save_editor/widgets/common_scaffold.dart';
import 'package:thlaby2_save_editor/widgets/party_row.dart';

class PartyDataWidget extends StatefulWidget {
  const PartyDataWidget({super.key});

  @override
  State<PartyDataWidget> createState() => PartyDataState();
}

class PartyDataState extends State<PartyDataWidget>
    with
        SaveReader,
        Loggable,
        AlertHandler<PartyDataWidget>,
        DiscardableChanges<PartyDataWidget>,
        BreakableChanges<PartyDataWidget>,
        Navigatable<PartyDataWidget> {
  late List<PartySlot> _editable;
  late List<PartySlot> _original;
  PartySlot? _hover;
  PartySlot? _hoverRm;

  @override
  bool get hasChanges {
    for (int i = 0; i < _editable.length; i++) {
      bool isUsed = _editable[i].isUsed;
      if (isUsed != _original[i].isUsed) {
        return true;
      }
      if (isUsed && _editable[i].character != _original[i].character) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<void> saveChanges() async {
    // Display a warning if trying to include duplicates
    bool hasDuplicates = false;
    for (int i = 0; i < _editable.length; i++) {
      if (!_editable[i].isUsed) {
        continue;
      }
      for (int j = i + 1; j < _editable.length; j++) {
        if (!_editable[j].isUsed) {
          continue;
        }
        if (_editable[i].character == _editable[j].character) {
          hasDuplicates = true;
          break;
        }
      }
      if (hasDuplicates) {
        break;
      }
    }
    if (hasDuplicates) {
      await log(LogLevel.warning, 'Attempting to include duplicates in party');
      bool doSave = await showSaveWarningDialog(
        'Having duplicates in the frontline can confuse the game when '
        "computing a duplicated character's MP and TP after a battle",
      );
      if (!doSave) {
        return;
      }
    }
    // Display a warning if trying to empty the front line
    if (_editable.sublist(0, 4).every((PartySlot s) => !s.isUsed)) {
      await log(LogLevel.warning, 'Attempting to empty the entire front row');
      bool doSave = await showSaveWarningDialog(
        'An empty frontline can crash the game if you go into battle',
      );
      if (!doSave) {
        return;
      }
    }
    await log(LogLevel.info, 'Saved party data changes');
    setState(() {
      _original = _editable.deepCopyElements(PartySlot.from);
      saveFile.partyData = _original;
    });
  }

  Future<void> _changePartyMember(PartySlot slot) async {
    Character? selected = await navigateToCharacterSelect();
    if (selected != null) {
      setState(() {
        slot.isUsed = true;
        slot.character = selected;
      });
    }
  }

  Future<void> _removePartyMember(PartySlot slot) async {
    await log(LogLevel.debug, 'Removed ${slot.character.name}');
    setState(() {
      slot.isUsed = false;
      _hoverRm = null;
    });
  }

  @override
  void initState() {
    super.initState();
    // Make a reference and a deep copy of the list we're changing
    _original = saveFile.partyData;
    _editable = _original.deepCopyElements(PartySlot.from);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: checkChangesAndConfirm,
      child: CommonScaffold(
        title: 'Edit which characters are in the party',
        floatingActionButton: saveButton,
        children: <int>[8, 4, 0].map<Widget>(
          (int index) => PartyRow(
            slots: _editable.sublist(index, index + 4),
            characterOnTap: _changePartyMember,
            removeOnTap: _removePartyMember,
            characterHighlight: _hover,
            removeHighlight: _hoverRm,
            characterOnEnter: (PartySlot slot) => setState(() {
              _hover = slot;
            }),
            removeOnEnter: (PartySlot slot) => setState(() {
              _hoverRm = slot;
            }),
            characterOnExit: (PartySlot slot) => setState(() {
              _hover = null;
            }),
            removeOnExit: (PartySlot slot) => setState(() {
              _hoverRm = null;
            }),
          ),
        ).toList()..insert(2, const Divider()),
      ),
    );
  }
}
