import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/extensions/string_extension.dart';
import 'package:thlaby2_save_editor/save/character.dart';
import 'package:thlaby2_save_editor/widgets/character_box.dart';

class CharacterRoster extends StatelessWidget {
  final Character? highlight;
  final Future<void> Function(Character character) onTap;
  final void Function(Character character) onEnter;
  final void Function(Character character) onExit;

  const CharacterRoster({
    required this.highlight,
    required this.onTap,
    required this.onEnter,
    required this.onExit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: Character.values.map(
        (Character character) => CharacterBox(
          title: character.name.upperCaseFirstChar(),
          filename: character.filename,
          onTap: () async => onTap(character),
          onEnter: (PointerEvent e) => onEnter(character),
          onExit: (PointerEvent e) => onExit(character),
          highlighted: character == highlight,
        ),
      ).toList(),
    );
  }
}
