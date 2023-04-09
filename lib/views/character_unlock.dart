import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/common.dart';
import 'package:thlaby2_save_editor/extensions/list_extension.dart';
import 'package:thlaby2_save_editor/extensions/string_extension.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/save/character.dart';
import 'package:thlaby2_save_editor/save/character_unlock.dart';
import 'package:thlaby2_save_editor/save/party_slot.dart';
import 'package:thlaby2_save_editor/widgets/button.dart';
import 'package:thlaby2_save_editor/widgets/characterselect.dart';

class CharacterUnlockWidget extends StatefulWidget {
  const CharacterUnlockWidget({super.key});

  @override
  State<CharacterUnlockWidget> createState() => CharacterUnlockState();
}

class CharacterUnlockState extends CommonState<CharacterUnlockWidget> {
  late List<CharacterUnlockFlag> _flags;
  late List<CharacterUnlockFlag> _original;
  late Widget _toggleButtons;

  //
  // Properly check for and validate changes, save/commit them
  //

  bool _hasChanges() {
    for (int i = 0; i < _flags.length; i++) {
      if (_flags[i].isUnlocked != _original[i].isUnlocked) {
        return true;
      }
    }
    return false;
  }

  Future<bool> _checkChangesAndConfirm() async {
    if (!_hasChanges()) {
      return true;
    }
    bool canDiscard = await showUnsavedChangesDialog();
    if (canDiscard) {
      await logger.log(
        LogLevel.info,
        'Discarding changes to character unlock flags',
      );
    }
    return canDiscard;
  }

  Future<void> _saveChanges() async {
    // Display a warning if trying to lock characters that are in the party
    List<PartySlot> party = saveFileWrapper.saveFile.partyData;
    List<CharacterUnlockFlag> lockedPartyCharacters = _flags.where(
      (CharacterUnlockFlag f) => !f.isUnlocked && party.any(
        (PartySlot s) => s.isUsed && s.character == f.character,
      ),
    ).toList();
    if (lockedPartyCharacters.isNotEmpty) {
      await logger.log(
        LogLevel.warning,
        'Attempting to lock a character that is in the party',
      );
      String affectedCharacters = lockedPartyCharacters.map(
        (CharacterUnlockFlag f)=>f.character.name.upperCaseFirstChar(),
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
        PartySlot slot = party.firstWhere(
          (PartySlot s) => s.isUsed && s.character == flag.character,
        );
        slot.isUsed = false;
      }
    }
    // Display a warning if trying to lock one of the 4 starting characters
    if (_flags.sublist(0, 4).any((CharacterUnlockFlag f)=>!f.isUnlocked)) {
      await logger.log(
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
    if (_flags.every((CharacterUnlockFlag f)=>!f.isUnlocked)) {
      await logger.log(
        LogLevel.warning,
        'Attempting to lock all characters',
      );
      bool doSave = await showSaveWarningDialog(
        'If you lock all characters, you will be unable to do anything in-game',
      );
      if (!doSave) {
        return;
      }
    }
    await logger.log(LogLevel.info, 'Saved changes');
    setState(() {
      _original = _flags.deepCopyElements(CharacterUnlockFlag.from);
      saveFileWrapper.saveFile.characterUnlockFlags = _original;
    });
  }

  //
  // Functions to manipulate unlocked state - be that for individual characters
  // or for entire groups from the preset buttons
  //

  void _characterTap(Character character) {
    CharacterUnlockFlag flag = _flags.firstWhere(
      (CharacterUnlockFlag f) => f.character == character,
    );
    // ignore: discarded_futures
    _toggleUnlockedData(flag);
  }

  Future<void> _toggleUnlockedData(CharacterUnlockFlag flag) async {
    String state = (flag.isUnlocked) ? 'locked' : 'unlocked';
    await logger.log(LogLevel.debug, '${flag.character.name} is now $state');
    setState((){
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
    await logger.log(LogLevel.debug, 'Applying preset: starting 4 characters');
    _unlockCharactersUpToIndex(4);
  }

  Future<void> _pressOnlyBase48Characters() async {
    await logger.log(LogLevel.debug, 'Applying preset: base 48 characters');
    _unlockCharactersUpToIndex(48);
  }

  Future<void> _pressAllCharacters() async {
    await logger.log(LogLevel.debug, 'Applying preset: all 56 characters');
    _unlockCharactersUpToIndex(_flags.length);
  }

  //
  // Function to draw specific widget on screen, helps declutter build()
  //

  Widget _drawLockedHeader(bool isUnlocked, bool isHighlighted) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          isUnlocked ? 'Unlocked' : 'Locked',
          style: TextStyle(
            color: isHighlighted ? Colors.green : Colors.grey.shade700,
          ),
        ),
        Icon(
          isUnlocked ? Icons.lock_open : Icons.lock,
          size: 14,
          color: isHighlighted ? Colors.green : Colors.grey.shade700,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    // Make a reference and a deep copy of the list we're changing
    _original = saveFileWrapper.saveFile.characterUnlockFlags;
    _flags = _original.deepCopyElements(CharacterUnlockFlag.from);
    // This widget is always the same, no matter the state we're building
    _toggleButtons = Wrap(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columnChildren = <Widget>[
      _toggleButtons,
      TCharacterSelect(
        characterTapFunction: _characterTap,
        highlightIfLocked: true,
        unlockFlags: _flags,
        titleAppend: _drawLockedHeader,
      ),
    ];
    bool shouldSave = _hasChanges();
    Widget? floatingActionButton;
    if (shouldSave) {
      floatingActionButton = FloatingActionButton(
        onPressed: _saveChanges,
        child: const Icon(Icons.save),
      );
    }
    return WillPopScope(
      onWillPop: _checkChangesAndConfirm,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit which characters are unlocked'),
        ),
        floatingActionButton: floatingActionButton,
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
      ),
    );
  }
}
