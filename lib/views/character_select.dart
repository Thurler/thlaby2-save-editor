import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/common.dart';
import 'package:thlaby2_save_editor/extensions/string_extension.dart';
import 'package:thlaby2_save_editor/save/character.dart';
import 'package:thlaby2_save_editor/widgets/character_box.dart';
import 'package:thlaby2_save_editor/widgets/common_scaffold.dart';

class CharacterSelectWidget extends StatefulWidget {
  const CharacterSelectWidget({super.key});

  @override
  State<CharacterSelectWidget> createState() => CharacterSelectState();
}

class CharacterSelectState extends CommonState<CharacterSelectWidget> {
  Character? _hover;

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Choose a character to include in the party',
      children: <Widget>[
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: Character.values.map(
            (Character character) => CharacterBox(
              title: character.name.upperCaseFirstChar(),
              filename: character.filename,
              onTap: () => Navigator.of(context).pop(character),
              onEnter: (PointerEvent e) => setState((){_hover = character;}),
              onExit: (PointerEvent e) => setState((){_hover = null;}),
              highlighted: character == _hover,
            ),
          ).toList(),
        ),
      ],
    );
  }
}
