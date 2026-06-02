import 'package:flutter/material.dart';
import 'package:tfields/extensions.dart';
import 'package:tfields/logging.dart';
import 'package:tfields/widgets.dart';
import 'package:thlaby2_save_editor/mixins/breakablechanges.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/save/character_unlock.dart';
import 'package:thlaby2_save_editor/save/enums/character.dart';
import 'package:thlaby2_save_editor/save/party_slot.dart';
import 'package:thlaby2_save_editor/widgets/forms/character_unlock.dart';

class CharacterUnlockWidget extends StatefulWidget {
  const CharacterUnlockWidget({super.key});

  @override
  State<CharacterUnlockWidget> createState() => CharacterUnlockState();
}

class CharacterUnlockState extends State<CharacterUnlockWidget>
    with
        TLoggable,
        SaveEditor,
        TDialogDisplayer<CharacterUnlockWidget>,
        TDiscardableChanges<CharacterUnlockWidget>,
        BreakableChanges<CharacterUnlockWidget> {
  final Map<Character, CharacterUnlockForm> _unlockForms =
      <Character, CharacterUnlockForm>{};

  final Map<Character, CharacterUnlockFormKey> _unlockFormKeys =
      <Character, CharacterUnlockFormKey>{
    for (Character character in Character.values)
      character: CharacterUnlockFormKey(),
  };

  bool _flagLocksAPartyCharacter(CharacterUnlockFlag flag) {
    if (flag.isUnlocked) {
      return false;
    }
    return saveFile.partyData.any(
      (PartySlot s) => s.isUsed && s.character == flag.character,
    );
  }

  @override
  bool get hasChanges => _unlockFormKeys.values.any(
    (CharacterUnlockFormKey key) => key.currentState?.hasChanges ?? false,
  );

  Future<bool> _showPartyMembersWarning(
    Iterable<CharacterUnlockFlag> lockedPartyCharacters,
  ) async {
    // Display a warning if trying to lock characters that are in the party
    await log(
      TLogLevel.warning,
      'Attempting to lock a character that is in the party',
    );
    String affectedCharacters = lockedPartyCharacters.map(
      (CharacterUnlockFlag f) => f.character.name.upperCaseFirstChar(),
    ).join(', ');
    return showSaveWarningDialog(
      '$affectedCharacters are being locked, but they are in your party. '
      'Saving will remove them from your party',
      breaking: false,
    );
  }

  Future<bool> _showInitialMembersWarning() async {
    await log(
      TLogLevel.warning,
      'Attempting to lock one of the initial 4 characters',
    );
    return showSaveWarningDialog(
      'Reimu, Marisa, Rinnosuke, and Keine are starting characters. They '
      'cannot be recruited again if you lock them back',
    );
  }

  Future<bool> _showAllMembersLockWarning() async {
    await log(TLogLevel.warning, 'Attempting to lock all characters');
    return showSaveWarningDialog(
      'If you lock all characters, you will be unable to do anything in-game',
    );
  }

  @override
  Future<void> saveChanges() async {
    List<CharacterUnlockFlag> newFlags = _unlockFormKeys.values.map(
      (CharacterUnlockFormKey key) => key.currentState?.value,
    ).nonNulls.toList();
    Iterable<CharacterUnlockFlag> lockedPartyCharacters =
        newFlags.where(_flagLocksAPartyCharacter);
    if (lockedPartyCharacters.isNotEmpty) {
      bool proceed = await _showPartyMembersWarning(lockedPartyCharacters);
      if (!proceed) {
        return;
      }
    }
    // Display a warning if trying to lock one of the 4 starting characters
    if (newFlags.sublist(0, 4).any((CharacterUnlockFlag f) => !f.isUnlocked)) {
      bool proceed = await _showInitialMembersWarning();
      if (!proceed) {
        return;
      }
    }
    // Display a warning if trying to lock all characters
    if (newFlags.every((CharacterUnlockFlag f) => !f.isUnlocked)) {
      bool proceed = await _showAllMembersLockWarning();
      if (!proceed) {
        return;
      }
    }
    // If we are locking party members, remove them now
    if (lockedPartyCharacters.isNotEmpty) {
      for (CharacterUnlockFlag flag in lockedPartyCharacters) {
        PartySlot slot = saveFile.partyData.firstWhere(
          (PartySlot s) => s.isUsed && s.character == flag.character,
        );
        slot.character = null;
      }
    }
    saveFile.characterUnlockFlags = newFlags;
    for (CharacterUnlockFormKey key in _unlockFormKeys.values) {
      key.currentState?.saveValue();
    }
    setState(() {});
    await log(TLogLevel.info, 'Saved character unlock changes');
  }

  Future<void> _unlockCharactersUpToIndex(int index) async {
    for (Character character in _unlockFormKeys.keys) {
      await _unlockFormKeys[character]?.currentState?.setLockValue(
        isUnlocked: character.index < index,
      );
    }
    setState(() {});
  }

  Future<void> _pressOnlyStartingCharacters() async {
    await log(TLogLevel.debug, 'Applying preset: starting 4 characters');
    await _unlockCharactersUpToIndex(4);
  }

  Future<void> _pressOnlyBase48Characters() async {
    await log(TLogLevel.debug, 'Applying preset: base 48 characters');
    await _unlockCharactersUpToIndex(48);
  }

  Future<void> _pressAllCharacters() async {
    await log(TLogLevel.debug, 'Applying preset: all 56 characters');
    await _unlockCharactersUpToIndex(_unlockFormKeys.values.length);
  }

  @override
  void initState() {
    super.initState();
    for (Character character in Character.values) {
      _unlockForms[character] = CharacterUnlockForm(
        initialValue: saveFile.characterUnlockFlags[character.index],
        hoverUpdateCallback: () => setState(() {}),
        onValueChanged: (_) => setState(() {}),
        key: _unlockFormKeys[character],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !hasChanges,
      onPopInvokedWithResult: onPopInvoked,
      child: TCommonScaffold(
        title: 'Edit which characters are unlocked',
        floatingActionButton: saveButton,
        children: <Widget>[
          Wrap(
            spacing: 20,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: <Widget>[
              TButton.elevated(
                text: 'Only starting characters',
                icon: const TIcon(icon: Icons.person),
                onPressed: _pressOnlyStartingCharacters,
              ),
              TButton.elevated(
                text: 'Only 48 base characters',
                icon: const TIcon(icon: Icons.group),
                onPressed: _pressOnlyBase48Characters,
              ),
              TButton.elevated(
                text: 'All 56 characters',
                icon: const TIcon(icon: Icons.group_add),
                onPressed: _pressAllCharacters,
              ),
            ],
          ),
          TGridRow.withExpandedSizes(
            mainAxisAlignment: MainAxisAlignment.center,
            smFlexLimit: 2,
            xxlFlexLimit: 4,
            uhdFlexLimit: 7,
            children: _unlockForms.values.map(
              (CharacterUnlockForm form) => TGridItem(child: form),
            ).toList(),
          ),
        ],
      ),
    );
  }
}
