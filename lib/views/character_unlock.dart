import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/extensions/list_extension.dart';
import 'package:thlaby2_save_editor/extensions/string_extension.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/mixins/alert.dart';
import 'package:thlaby2_save_editor/mixins/breakablechanges.dart';
import 'package:thlaby2_save_editor/mixins/discardablechanges.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/save/character_unlock.dart';
import 'package:thlaby2_save_editor/save/enums/character.dart';
import 'package:thlaby2_save_editor/save/party_slot.dart';
import 'package:thlaby2_save_editor/widgets/button.dart';
import 'package:thlaby2_save_editor/widgets/character_box_title_unlock.dart';
import 'package:thlaby2_save_editor/widgets/character_roster.dart';
import 'package:thlaby2_save_editor/widgets/common_scaffold.dart';

class CharacterUnlockWidget extends StatefulWidget {
  const CharacterUnlockWidget({super.key});

  @override
  State<CharacterUnlockWidget> createState() => CharacterUnlockState();
}

class CharacterUnlockState extends State<CharacterUnlockWidget>
    with
        Loggable,
        SaveReader,
        AlertHandler<CharacterUnlockWidget>,
        DiscardableChanges<CharacterUnlockWidget>,
        BreakableChanges<CharacterUnlockWidget> {
  late List<CharacterUnlockFlag> _flags;
  late List<CharacterUnlockFlag> _original;
  Character? _hover;

  bool _flagLocksAPartyCharacter(CharacterUnlockFlag flag) {
    if (flag.isUnlocked) {
      return false;
    }
    return saveFile.partyData.any(
      (PartySlot s) => s.isUsed && s.character == flag.character,
    );
  }

  @override
  bool get hasChanges {
    for (int i = 0; i < _flags.length; i++) {
      if (_flags[i].isUnlocked != _original[i].isUnlocked) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<void> saveChanges() async {
    // Display a warning if trying to lock characters that are in the party
    List<CharacterUnlockFlag> lockedPartyCharacters = _flags.where(
      _flagLocksAPartyCharacter,
    ).toList();
    if (lockedPartyCharacters.isNotEmpty) {
      await log(
        LogLevel.warning,
        'Attempting to lock a character that is in the party',
      );
      String affectedCharacters = lockedPartyCharacters.map(
        (CharacterUnlockFlag f) => f.character.name.upperCaseFirstChar(),
      ).join(', ');
      bool doSave = await showSaveWarningDialog(
        '$affectedCharacters are being locked, but they are in your party. '
        'Saving will remove them from your party',
        breaking: false,
      );
      if (!doSave) {
        return;
      }
      for (CharacterUnlockFlag flag in lockedPartyCharacters) {
        PartySlot slot = saveFile.partyData.firstWhere(
          (PartySlot s) => s.isUsed && s.character == flag.character,
        );
        slot.isUsed = false;
      }
    }
    // Display a warning if trying to lock one of the 4 starting characters
    if (_flags.sublist(0, 4).any((CharacterUnlockFlag f) => !f.isUnlocked)) {
      await log(
        LogLevel.warning,
        'Attempting to lock one of the initial 4 characters',
      );
      bool doSave = await showSaveWarningDialog(
        'Reimu, Marisa, Rinnosuke, and Keine are starting characters. They '
        'cannot be recruited again if you lock them back',
      );
      if (!doSave) {
        return;
      }
    }
    // Display a warning if trying to lock all characters
    if (_flags.every((CharacterUnlockFlag f) => !f.isUnlocked)) {
      await log(LogLevel.warning, 'Attempting to lock all characters');
      bool doSave = await showSaveWarningDialog(
        'If you lock all characters, you will be unable to do anything in-game',
      );
      if (!doSave) {
        return;
      }
    }
    await log(LogLevel.info, 'Saved character unlock changes');
    setState(() {
      _original = _flags.deepCopyElements(CharacterUnlockFlag.from);
      saveFile.characterUnlockFlags = _original;
    });
  }

  Future<void> _characterTap(Character character) async {
    CharacterUnlockFlag flag = _flags.firstWhere(
      (CharacterUnlockFlag f) => f.character == character,
    );
    await _toggleUnlockedData(flag);
  }

  Future<void> _toggleUnlockedData(CharacterUnlockFlag flag) async {
    String state = (flag.isUnlocked) ? 'locked' : 'unlocked';
    await log(LogLevel.debug, '${flag.character.name} is now $state');
    setState(() {
      flag.isUnlocked = !flag.isUnlocked;
    });
  }

  void _unlockCharactersUpToIndex(int index) {
    setState(() {
      for (int i = 0; i < index; i++) {
        _flags[i].isUnlocked = true;
      }
      for (int i = index; i < _flags.length; i++) {
        _flags[i].isUnlocked = false;
      }
    });
  }

  Future<void> _pressOnlyStartingCharacters() async {
    await log(LogLevel.debug, 'Applying preset: starting 4 characters');
    _unlockCharactersUpToIndex(4);
  }

  Future<void> _pressOnlyBase48Characters() async {
    await log(LogLevel.debug, 'Applying preset: base 48 characters');
    _unlockCharactersUpToIndex(48);
  }

  Future<void> _pressAllCharacters() async {
    await log(LogLevel.debug, 'Applying preset: all 56 characters');
    _unlockCharactersUpToIndex(_flags.length);
  }

  @override
  void initState() {
    super.initState();
    // Make a reference and a deep copy of the list we're changing
    _original = saveFile.characterUnlockFlags;
    _flags = _original.deepCopyElements(CharacterUnlockFlag.from);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: checkChangesAndConfirm,
      child: CommonScaffold(
        title: 'Edit which characters are unlocked',
        floatingActionButton: saveButton,
        children: <Widget>[
          Wrap(
            spacing: 20,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: <Widget>[
              TButton(
                text: 'Only starting characters',
                icon: Icons.person,
                onPressed: _pressOnlyStartingCharacters,
                usesMaxWidth: false,
              ),
              TButton(
                text: 'Only 48 base characters',
                icon: Icons.group,
                onPressed: _pressOnlyBase48Characters,
                usesMaxWidth: false,
              ),
              TButton(
                text: 'All 56 characters',
                icon: Icons.group_add,
                onPressed: _pressAllCharacters,
                usesMaxWidth: false,
              ),
            ],
          ),
          CharacterRoster(
            interactWhenLocked: true,
            highlight: _hover,
            onTap: _characterTap,
            onEnter: (Character character) => setState(() {
              _hover = character;
            }),
            onExit: (Character character) => setState(() {
              _hover = null;
            }),
            unlockFlags: _flags,
            titleAppendMap: Map<Character, Widget>.fromEntries(
              Character.values.map(
                (Character character) => MapEntry<Character, Widget>(
                  character,
                  CharacterBoxTitleUnlockAppend(
                    isHighlighted: character == _hover,
                    isUnlocked: _flags[character.index].isUnlocked,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
