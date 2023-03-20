import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/common.dart';
import 'package:thlaby2_save_editor/list_extension.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/widgets/button.dart';

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
    return showUnsavedChangesDialog();
  }

  Future<void> _saveChanges() async {
    // Display a warning if trying to lock one of the 4 starting characters
    if (_flags.sublist(0, 4).any((CharacterUnlockFlag f)=>!f.isUnlocked)) {
      bool doSave = await showSaveWarningDialog(
        'Reimu, Marisa, Rinnosuke, and Keine are starting characters. They '
        'cannot be recruited again if you lock them back',
      );
      if (!doSave) {
        return;
      }
    }
    setState(() {
      _original = _flags.deepCopyElements(CharacterUnlockFlag.from);
      saveFileWrapper.saveFile.characterUnlockFlags = _original;
    });
  }

  //
  // Functions to manipulate unlocked state - be that for individual characters
  // or for entire groups from the preset buttons
  //

  void _toggleUnlockedData(CharacterUnlockFlag flag) {
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

  void _pressOnlyStartingCharacters() {
    _unlockCharactersUpToIndex(4);
  }

  void _pressOnlyBase48Characters() {
    _unlockCharactersUpToIndex(48);
  }

  void _pressAllCharacters() {
    _unlockCharactersUpToIndex(_flags.length);
  }

  //
  // Helper functions to draw stuff on screen, helps declutter the build method
  //

  Widget _drawCharacter(CharacterUnlockFlag flag) {
    // Character name acts as a title for the box, along with an explicit
    // description of the state - "locked"/"unlocked" and an icon
    String name = flag.character.name;
    Widget title = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          '${name.replaceRange(0, 1, name[0].toUpperCase())}:',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 5),
        Text(
          (flag.isUnlocked) ? 'Unlocked' : 'Locked',
          style: TextStyle(
            color: Colors.grey.shade700,
          ),
        ),
        Icon(
          (flag.isUnlocked) ? Icons.lock_open : Icons.lock,
          size: 14,
          color: Colors.grey.shade700,
        ),
      ],
    );
    // Main image using SS variant
    String characterFilename = getCharacterFilename(flag.character);
    String filename = 'img/character/${characterFilename}_SS.png';
    Widget image = Image.asset(
      filename,
      fit: BoxFit.contain,
      width: 200,
      height: 29,
    );
    // Add a grayscale filter if the character is locked
    if (!flag.isUnlocked) {
      image = ColorFiltered(
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.saturation,
        ),
        child: image,
      );
    }
    // Put it in a DecoratedBox to give it a border - hides the portrait cutoffs
    image = DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: image,
    );
    List<Widget> elements = <Widget>[title, image];
    return GestureDetector(
      onTap: ()=>_toggleUnlockedData(flag),
      child: Column(
        children: elements.separateWith(const SizedBox(height: 2)),
      ),
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
    List<Widget> characters = _flags.map(_drawCharacter).toList();
    Wrap characterWrap = Wrap(
      spacing: 10,
      runSpacing: 10,
      children: characters,
    );
    List<Widget> columnChildren = <Widget>[
      _toggleButtons,
      characterWrap,
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