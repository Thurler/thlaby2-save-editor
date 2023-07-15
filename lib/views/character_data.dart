import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/common.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/save/character.dart';
import 'package:thlaby2_save_editor/views/character_edit.dart';
import 'package:thlaby2_save_editor/views/character_unlock.dart';
import 'package:thlaby2_save_editor/widgets/button.dart';
import 'package:thlaby2_save_editor/widgets/character_roster.dart';
import 'package:thlaby2_save_editor/widgets/common_scaffold.dart';

class CharacterDataWidget extends StatefulWidget {
  const CharacterDataWidget({super.key});

  @override
  State<CharacterDataWidget> createState() => CharacterUnlockState();
}

class CharacterUnlockState extends CommonState<CharacterDataWidget> {
  Character? _hover;

  Future<void> _navigateToCharacterUnlock() async {
    NavigatorState state = Navigator.of(context);
    await log(LogLevel.debug, 'Opening character unlock edit widget');
    if (!state.mounted) {
      return;
    }
    await state.push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const CharacterUnlockWidget(),
      ),
    );
    await log(LogLevel.debug, 'Closed character unlock edit widget');
  }

  Future<void> _navigateToCharacterData(Character character) async {
    NavigatorState state = Navigator.of(context);
    await log(LogLevel.debug, 'Opening character unlock edit widget');
    if (!state.mounted) {
      return;
    }
    await state.push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => CharacterEditWidget(
          character: character,
        ),
      ),
    );
    await log(LogLevel.debug, 'Closed character unlock edit widget');
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Choose a character to edit',
      children: <Widget>[
        TButton(
          text: 'Edit character unlock flags',
          icon: Icons.lock_open,
          onPressed: _navigateToCharacterUnlock,
          usesMaxWidth: false,
        ),
        CharacterRoster(
          highlight: _hover,
          unlockFlags: saveFile.characterUnlockFlags,
          onTap: _navigateToCharacterData,
          onEnter: (Character character) => setState((){_hover = character;}),
          onExit: (Character character) => setState((){_hover = null;}),
        ),
      ],
    );
  }
}
