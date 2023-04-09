import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/common.dart';
import 'package:thlaby2_save_editor/extensions/list_extension.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/save/character.dart';
import 'package:thlaby2_save_editor/views/character_edit.dart';
import 'package:thlaby2_save_editor/views/character_unlock.dart';
import 'package:thlaby2_save_editor/widgets/button.dart';
import 'package:thlaby2_save_editor/widgets/characterselect.dart';

class CharacterDataWidget extends StatefulWidget {
  const CharacterDataWidget({super.key});

  @override
  State<CharacterDataWidget> createState() => CharacterUnlockState();
}

class CharacterUnlockState extends CommonState<CharacterDataWidget> {
  final GlobalKey<TCharacterSelectState> _characterSelectKey = GlobalKey();

  Future<void> _navigateToCharacterUnlock() async {
    NavigatorState state = Navigator.of(context);
    await logger.log(LogLevel.debug, 'Opening character unlock edit widget');
    if (!state.mounted) {
      return;
    }
    await state.push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const CharacterUnlockWidget(),
      ),
    );
    await logger.log(LogLevel.debug, 'Closed character unlock edit widget');
    // Update widget since characters could now be (un)locked
    _characterSelectKey.currentState?.callUpdateFlags();
  }

  void _characterTap(Character character) {
    // ignore: discarded_futures
    _navigateToCharacterData(character);
  }

  Future<void> _navigateToCharacterData(Character character) async {
    NavigatorState state = Navigator.of(context);
    await logger.log(LogLevel.debug, 'Opening character unlock edit widget');
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
    await logger.log(LogLevel.debug, 'Closed character unlock edit widget');
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columnChildren = <Widget>[
      TButton(
        text: 'Edit character unlock flags',
        icon: Icons.lock_open,
        onPressed: _navigateToCharacterUnlock,
        usesMaxWidth: false,
      ),
      TCharacterSelect(
        characterTapFunction: _characterTap,
        key: _characterSelectKey,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a character to edit'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: columnChildren.separateWith(
                const SizedBox(height: 20),
                separatorOnEnds: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
