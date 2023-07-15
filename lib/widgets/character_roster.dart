import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/extensions/string_extension.dart';
import 'package:thlaby2_save_editor/save/character.dart';
import 'package:thlaby2_save_editor/save/character_unlock.dart';
import 'package:thlaby2_save_editor/widgets/character_box.dart';

class CharacterRoster extends StatelessWidget {
  final Character? highlight;
  final Future<void> Function(Character character) onTap;
  final void Function(Character character) onEnter;
  final void Function(Character character) onExit;
  final Map<Character, Widget> titleAppendMap;
  final List<CharacterUnlockFlag> unlockFlags;
  final bool interactWhenLocked;

  const CharacterRoster({
    required this.highlight,
    required this.onTap,
    required this.onEnter,
    required this.onExit,
    required this.unlockFlags,
    this.titleAppendMap = const <Character, Widget>{},
    this.interactWhenLocked = false,
    super.key,
  });

  static Future<void> precachePortraits(BuildContext context) async {
    NavigatorState state = Navigator.of(context);
    for (Character character in Character.values) {
      await precacheImage(
        CharacterBox.imageFromName(character.filename).image,
        context,
      );
    }
    // Also precache the empty portrait!
    if (state.mounted) {
      await precacheImage(CharacterBox.imageFromName('Empty').image, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: Character.values.map(
        (Character character) => CharacterBox(
          title: character.name.upperCaseFirstChar(),
          titleAppend: titleAppendMap[character],
          filename: character.filename,
          unlocked: unlockFlags[character.index].isUnlocked,
          onTap: () async => onTap(character),
          onEnter: (PointerEvent e) => onEnter(character),
          onExit: (PointerEvent e) => onExit(character),
          highlighted: character == highlight,
          interactWhenLocked: interactWhenLocked,
        ),
      ).toList(),
    );
  }
}
