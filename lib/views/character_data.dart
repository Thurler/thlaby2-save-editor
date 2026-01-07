import 'package:flutter/material.dart';
import 'package:tfields/logging.dart';
import 'package:tfields/widgets.dart';
import 'package:thlaby2_save_editor/mixins/navigate.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/widgets/character_roster.dart';

class CharacterDataWidget extends StatefulWidget {
  const CharacterDataWidget({super.key});

  @override
  State<CharacterDataWidget> createState() => CharacterUnlockState();
}

class CharacterUnlockState extends State<CharacterDataWidget>
    with TLoggable, SaveEditor, Navigatable<CharacterDataWidget> {
  @override
  Widget build(BuildContext context) {
    return TCommonScaffold(
      title: 'Choose a character to edit',
      children: <Widget>[
        TButton.elevated(
          text: 'Edit character unlock flags',
          icon: const TIcon(icon: Icons.lock_open),
          onPressed: navigateToCharacterUnlock,
        ),
        CharacterRoster(
          unlockFlags: saveFile.characterUnlockFlags,
          onTap: navigateToCharacterEdit,
          stateUpdateCallback: () => setState(() {}),
        ),
      ],
    );
  }
}
