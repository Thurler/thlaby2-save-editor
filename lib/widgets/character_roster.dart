import 'package:flutter/material.dart';
import 'package:tfields/extensions.dart';
import 'package:thlaby2_save_editor/save/character_unlock.dart';
import 'package:thlaby2_save_editor/save/enums/character.dart';
import 'package:thlaby2_save_editor/widgets/character_box.dart';

class CharacterRoster extends StatelessWidget {
  final Future<void> Function(Character character) onTap;
  final Map<Character, Widget> titleAppendMap;
  final List<CharacterUnlockFlag> unlockFlags;
  final bool interactWhenLocked;
  final void Function() stateUpdateCallback;

  const CharacterRoster({
    required this.onTap,
    required this.unlockFlags,
    required this.stateUpdateCallback,
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
      await precacheImage(
        CharacterBox.imageFromName('Empty').image,
        state.context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: Character.values.map(
        (Character character) => CharacterBoxHover(
          title: character.name.upperCaseFirstChar(),
          titleAppend: titleAppendMap[character],
          filename: character.filename,
          unlocked: unlockFlags[character.index].isUnlocked,
          onHoverTap: () async => onTap(character),
          hoverUpdateCallback: stateUpdateCallback,
          interactWhenLocked: interactWhenLocked,
        ),
      ).toList(),
    );
  }
}
