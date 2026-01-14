import 'package:flutter/material.dart';
import 'package:tfields/logging.dart';
import 'package:tfields/settings.dart';
import 'package:thlaby2_save_editor/save/enums/character.dart';
import 'package:thlaby2_save_editor/save/enums/item.dart';
import 'package:thlaby2_save_editor/save/item_slot.dart';
import 'package:thlaby2_save_editor/views/character_data.dart';
import 'package:thlaby2_save_editor/views/character_edit.dart';
import 'package:thlaby2_save_editor/views/character_select.dart';
import 'package:thlaby2_save_editor/views/character_unlock.dart';
import 'package:thlaby2_save_editor/views/item_data.dart';
import 'package:thlaby2_save_editor/views/item_select.dart';
import 'package:thlaby2_save_editor/views/menu.dart';
import 'package:thlaby2_save_editor/views/party_data.dart';

mixin Navigatable<T extends StatefulWidget> on TLoggable, State<T> {
  Future<U?> _navigate<U>(StatefulWidget target, String name) async {
    NavigatorState state = Navigator.of(context);
    await log(TLogLevel.debug, 'Opening $name widget');
    if (!state.mounted) {
      return null;
    }
    U? result = await state.push(
      MaterialPageRoute<U>(builder: (BuildContext context) => target),
    );
    await log(TLogLevel.debug, 'Closed $name widget');
    return result;
  }

  Future<void> navigateToSettings() => _navigate(
    const TCommonSettingsWidget(
      title: 'Touhou Labyrinth 2 Save Editor - Settings',
    ),
    'settings',
  );

  Future<void> navigateToMainMenu() =>
      _navigate(const MenuWidget(), 'main menu');

  Future<void> navigateToCharacterData() =>
      _navigate(const CharacterDataWidget(), 'character data');

  Future<void> navigateToCharacterUnlock() =>
      _navigate(const CharacterUnlockWidget(), 'character unlock edit');

  Future<void> navigateToCharacterEdit(Character character) => _navigate(
    CharacterEditWidget(character: character),
    'character data edit',
  );

  Future<Character?> navigateToCharacterSelect() async {
    Character? selected = await _navigate(
      const CharacterSelectWidget(),
      'character select',
    );
    if (selected != null) {
      await log(TLogLevel.debug, 'Chosen character: ${selected.name}');
    }
    return selected;
  }

  Future<void> navigateToPartyEdit() =>
      _navigate(const PartyDataWidget(), 'party data edit');

  Future<void> navigateToItemEdit() =>
      _navigate(const ItemDataWidget(), 'item data edit');

  Future<I?> navigateToItemSelect<I extends Item>() async {
    Item? selected =
        await _navigate(ItemSelectWidget(items: items), 'item select');
    if (selected != null) {
      await log(TLogLevel.debug, 'Chosen item: ${selected.name}');
    }
    return selected;
  }
}
