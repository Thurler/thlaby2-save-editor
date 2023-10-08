import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/mixins/navigate.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/save/enums/character.dart';
import 'package:thlaby2_save_editor/widgets/button.dart';
import 'package:thlaby2_save_editor/widgets/character_roster.dart';
import 'package:thlaby2_save_editor/widgets/common_scaffold.dart';

class CharacterDataWidget extends StatefulWidget {
  const CharacterDataWidget({super.key});

  @override
  State<CharacterDataWidget> createState() => CharacterUnlockState();
}

class CharacterUnlockState extends State<CharacterDataWidget>
    with Loggable, SaveReader, Navigatable<CharacterDataWidget> {
  Character? _hover;

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Choose a character to edit',
      children: <Widget>[
        TButton(
          text: 'Edit character unlock flags',
          icon: Icons.lock_open,
          onPressed: navigateToCharacterUnlock,
          usesMaxWidth: false,
        ),
        CharacterRoster(
          highlight: _hover,
          unlockFlags: saveFile.characterUnlockFlags,
          onTap: navigateToCharacterEdit,
          onEnter: (Character character) => setState(() {
            _hover = character;
          }),
          onExit: (Character character) => setState(() {
            _hover = null;
          }),
        ),
      ],
    );
  }
}
