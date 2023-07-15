import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/save/character.dart';
import 'package:thlaby2_save_editor/widgets/character_roster.dart';
import 'package:thlaby2_save_editor/widgets/common_scaffold.dart';

class CharacterSelectWidget extends StatefulWidget {
  const CharacterSelectWidget({super.key});

  @override
  State<CharacterSelectWidget> createState() => CharacterSelectState();
}

class CharacterSelectState extends State<CharacterSelectWidget> with
    SaveReader {
  Character? _hover;

  Future<void> _selectCharacter(Character character) async {
    Navigator.of(context).pop(character);
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Choose a character to include in the party',
      children: <Widget>[
        CharacterRoster(
          highlight: _hover,
          unlockFlags: saveFile.characterUnlockFlags,
          onTap: _selectCharacter,
          onEnter: (Character character) => setState((){_hover = character;}),
          onExit: (Character character) => setState((){_hover = null;}),
        ),
      ],
    );
  }
}
