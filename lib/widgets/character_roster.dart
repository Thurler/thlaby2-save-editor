import 'package:flutter/material.dart';
import 'package:tfields/extensions.dart';
import 'package:tfields/widgets.dart';
import 'package:thlaby2_save_editor/save/character_unlock.dart';
import 'package:thlaby2_save_editor/save/enums/character.dart';
import 'package:thlaby2_save_editor/widgets/character_box.dart';

class CharacterRoster extends StatelessWidget {
  final void Function(Character character) onTap;
  final List<CharacterUnlockFlag> unlockFlags;
  final bool interactWhenLocked;
  final void Function() stateUpdateCallback;

  const CharacterRoster({
    required this.onTap,
    required this.unlockFlags,
    required this.stateUpdateCallback,
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
    return TGridRow.withExpandedSizes(
      smFlexLimit: 2,
      xxlFlexLimit: 4,
      uhdFlexLimit: 7,
      mainAxisAlignment: MainAxisAlignment.center,
      children: Character.values.map(
        (Character character) => TGridItem(
          child: CharacterBoxHover(
            title: character.name.upperCaseFirstChar(),
            filename: character.filename,
            unlocked: unlockFlags[character.index].isUnlocked,
            onHoverTap: () async => onTap(character),
            hoverUpdateCallback: stateUpdateCallback,
            interactWhenLocked: interactWhenLocked,
          ),
        ),
      ).toList(),
    );
  }
}
