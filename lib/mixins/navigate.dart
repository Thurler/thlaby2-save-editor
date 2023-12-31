import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/save/enums/character.dart';
import 'package:thlaby2_save_editor/views/character_data.dart';
import 'package:thlaby2_save_editor/views/character_edit.dart';
import 'package:thlaby2_save_editor/views/character_select.dart';
import 'package:thlaby2_save_editor/views/character_unlock.dart';
import 'package:thlaby2_save_editor/views/item_data.dart';
import 'package:thlaby2_save_editor/views/menu.dart';
import 'package:thlaby2_save_editor/views/party_data.dart';
import 'package:thlaby2_save_editor/views/settings.dart';

mixin Navigatable<T extends StatefulWidget> on Loggable, State<T> {
  Future<U?> _navigate<U>(StatefulWidget target, String name) async {
    NavigatorState state = Navigator.of(context);
    await log(LogLevel.debug, 'Opening $name widget');
    if (!state.mounted) {
      return null;
    }
    U? result = await state.push(
      MaterialPageRoute<U>(
        builder: (BuildContext context) => target,
      ),
    );
    await log(LogLevel.debug, 'Closed $name widget');
    return result;
  }

  Future<void> navigateToSettings() async {
    return _navigate(const SettingsWidget(), 'settings');
  }

  Future<void> navigateToMainMenu() {
    return _navigate(const MenuWidget(), 'main menu');
  }

  Future<void> navigateToCharacterData() async {
    return _navigate(const CharacterDataWidget(), 'character data');
  }

  Future<void> navigateToCharacterUnlock() {
    return _navigate(const CharacterUnlockWidget(), 'character unlock edit');
  }

  Future<void> navigateToCharacterEdit(Character character) async {
    return _navigate(
      CharacterEditWidget(character: character),
      'character data edit',
    );
  }

  Future<Character?> navigateToCharacterSelect() async {
    Character? selected = await _navigate(
      const CharacterSelectWidget(),
      'character select',
    );
    if (selected != null) {
      await log(LogLevel.debug, 'Chosen character: ${selected.name}');
    }
    return selected;
  }

  Future<void> navigateToPartyEdit() async {
    return _navigate(const PartyDataWidget(), 'party data edit');
  }

  Future<void> navigateToItemEdit() async {
    return _navigate(const ItemDataWidget(), 'item data edit');
  }
}
