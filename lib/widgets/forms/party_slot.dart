import 'package:flutter/material.dart';
import 'package:tfields/logging.dart';
import 'package:tfields/widgets.dart';
import 'package:thlaby2_save_editor/mixins/navigate.dart';
import 'package:thlaby2_save_editor/save/enums/character.dart';
import 'package:thlaby2_save_editor/save/party_slot.dart';
import 'package:thlaby2_save_editor/widgets/character_box.dart';

typedef PartySlotFormKey = GlobalKey<PartySlotFormState>;

class PartySlotForm extends TForm<PartySlot> {
  final void Function() hoverUpdateCallback;

  const PartySlotForm({
    required PartySlot super.initialValue,
    required this.hoverUpdateCallback,
    super.onValueChanged,
    super.validationCallback,
    super.saveWithErrorOptions,
    super.enabled = true,
    super.readonly,
    super.key,
  }) : super(title: '');

  @override
  PartySlotFormState createState() => PartySlotFormState();
}

class PartySlotFormState extends TFormState<PartySlot, PartySlotForm>
    with TLoggable, Navigatable<PartySlotForm> {
  @override
  PartySlot? copyValue(PartySlot? source) =>
      source != null ? PartySlot.from(source) : null;

  Future<void> _selectNewCharacter() async {
    Character? selected = await navigateToCharacterSelect();
    if (selected != null) {
      await _changeCharacter(selected);
    }
  }

  Future<void> _changeCharacter(Character? character) async {
    if (character == null && value?.character != null) {
      await log(TLogLevel.debug, 'Removed ${value!.character!.name}');
    }
    value?.character = character;
    widget.onValueChanged?.call(value);
    // This is done just to trigger super's value change
    value = value;
  }

  bool get _isEmpty => value?.character == null;

  bool get _isNotEmpty => !_isEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: <Widget>[
        CharacterBoxHover(
          title: title,
          unlocked: true,
          filename: _isNotEmpty ? value!.character!.filename : 'Empty',
          hoverEnabled: enabled,
          hoverUpdateCallback: widget.hoverUpdateCallback,
          onHoverTap: enabled && !readonly ? _selectNewCharacter : null,
        ),
        TButton.iconAndLabel(
          icon: TIcon(
            icon: Icons.cancel_outlined,
            color: Theme.of(context).colorScheme.primaryContainer.withAlpha(
              _isNotEmpty ? 255 : 127,
            ),
          ),
          text: 'Remove',
          textStyle: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(
              _isNotEmpty ? 255 : 127,
            ),
          ),
          onPressed: enabled && !readonly && _isNotEmpty
            ? () => _changeCharacter(null)
            : null,
        ),
      ],
    );
  }
}
