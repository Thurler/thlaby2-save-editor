import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/extensions/string_extension.dart';
import 'package:thlaby2_save_editor/save/party_slot.dart';
import 'package:thlaby2_save_editor/widgets/character_box.dart';
import 'package:thlaby2_save_editor/widgets/party_remove_button.dart';
import 'package:thlaby2_save_editor/widgets/spaced_row.dart';

class PartyRow extends StatelessWidget {
  final List<PartySlot> slots;
  final PartySlot? characterHighlight;
  final PartySlot? removeHighlight;
  final Future<void> Function(PartySlot slot) characterOnTap;
  final Future<void> Function(PartySlot slot) removeOnTap;
  final void Function(PartySlot slot) characterOnEnter;
  final void Function(PartySlot slot) removeOnEnter;
  final void Function(PartySlot slot) characterOnExit;
  final void Function(PartySlot slot) removeOnExit;

  const PartyRow({
    required this.slots,
    required this.characterOnTap,
    required this.characterOnEnter,
    required this.characterOnExit,
    required this.characterHighlight,
    required this.removeOnTap,
    required this.removeOnEnter,
    required this.removeOnExit,
    required this.removeHighlight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SpacedRow(
      mainAxisAlignment: MainAxisAlignment.center,
      spacer: const SizedBox(width: 20),
      children: slots.map(
        (PartySlot slot) => Column(
          children: <Widget>[
            CharacterBox(
              title: slot.toString().upperCaseFirstChar(),
              titleFontSize: 20,
              filename: slot.isUsed ? slot.character.filename : 'Empty',
              onTap: () async => characterOnTap(slot),
              onEnter: (PointerEvent e) => characterOnEnter(slot),
              onExit: (PointerEvent e) => characterOnExit(slot),
              highlighted: slot == characterHighlight,
            ),
            const SizedBox(height: 2),
            PartyRemoveButton(
              enabled: slot.isUsed,
              onTap: () async => removeOnTap(slot),
              onEnter: (PointerEvent e) => removeOnEnter(slot),
              onExit: (PointerEvent e) => removeOnExit(slot),
              highlighted: slot == removeHighlight,
            ),
          ],
        ),
      ).toList(),
    );
  }
}
