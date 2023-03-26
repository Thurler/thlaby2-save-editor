import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/character_select.dart';
import 'package:thlaby2_save_editor/common.dart';
import 'package:thlaby2_save_editor/iterable_extension.dart';
import 'package:thlaby2_save_editor/list_extension.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/string_extension.dart';

class PartyDataWidget extends StatefulWidget {
  const PartyDataWidget({super.key});

  @override
  State<PartyDataWidget> createState() => PartyDataState();
}

class PartyDataState extends CommonState<PartyDataWidget> {
  late List<PartySlot> _editable;
  late List<PartySlot> _original;
  PartySlot? _hover;
  PartySlot? _hoverRemove;

  //
  // Properly check for and validate changes, save/commit them
  //

  bool _hasChanges() {
    for (int i = 0; i < _editable.length; i++) {
      bool isUsed = _editable[i].isUsed;
      if (isUsed != _original[i].isUsed) {
        return true;
      }
      if (isUsed && _editable[i].character != _original[i].character) {
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
      await logger.log(LogLevel.info, 'Discarding changes to party edit flags');
    }
    return canDiscard;
  }

  Future<void> _saveChanges() async {
    // Display a warning if trying to include duplicates
    bool hasDuplicates = false;
    for (int i = 0; i < _editable.length; i++) {
      if (!_editable[i].isUsed) {
        continue;
      }
      for (int j = i+1; j < _editable.length; j++) {
        if (!_editable[j].isUsed) {
          continue;
        }
        if (_editable[i].character == _editable[j].character) {
          hasDuplicates = true;
          break;
        }
      }
      if (hasDuplicates) {
        break;
      }
    }
    if (hasDuplicates) {
      await logger.log(
        LogLevel.warning,
        'Attempting to include duplicates in party',
      );
      bool doSave = await showSaveWarningDialog(
        'Having duplicates in the frontline can confuse the game when '
        "computing a duplicated character's MP and TP after a battle",
      );
      if (!doSave) {
        return;
      }
    }
    // Display a warning if trying to empty the front line
    if (_editable.sublist(0, 4).every((PartySlot s)=>!s.isUsed)) {
      await logger.log(
        LogLevel.warning,
        'Attempting to empty the entire front row',
      );
      bool doSave = await showSaveWarningDialog(
        'An empty frontline can crash the game if you go into battle',
      );
      if (!doSave) {
        return;
      }
    }
    await logger.log(LogLevel.info, 'Saved changes');
    setState(() {
      _original = _editable.deepCopyElements(PartySlot.from);
      saveFileWrapper.saveFile.partyData = _original;
    });
  }

  Future<void> _changePartyMember(PartySlot slot) async {
    NavigatorState state = Navigator.of(context);
    await logger.log(LogLevel.info, 'Opening character select widget');
    CharacterName? selected = await state.push(
      MaterialPageRoute<CharacterName>(
        builder: (BuildContext context) => const CharacterSelectWidget(),
      ),
    );
    await logger.log(LogLevel.info, 'Closed character select widget');
    if (selected != null) {
      await logger.log(LogLevel.debug, 'Chosen character: ${selected.name}');
      setState(() {
        slot.isUsed = true;
        slot.character = selected;
      });
    }
  }

  Future<void> _removePartyMember(PartySlot slot) async {
    await logger.log(LogLevel.debug, 'Removed ${slot.character.name}');
    setState(() {
      slot.isUsed = false;
      _hoverRemove = null;
    });
  }

  //
  // Helper functions to draw stuff on screen, helps declutter the build method
  //

  Widget _drawCharacter(PartySlot slot) {
    bool highlighted = _hover == slot;
    bool highlightedRemove = _hoverRemove == slot;
    bool isUsed = slot.isUsed;
    // Character name acts as a title for the box
    String name = slot.toString();
    Widget title = Text(
      name.upperCaseFirstChar(),
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: highlighted ? Colors.green : null,
      ),
    );
    // Main image using S variant
    late Widget image;
    if (isUsed) {
      String characterFilename = getCharacterFilename(slot.character);
      String filename = 'img/character/${characterFilename}_S.png';
      image = Image.asset(
        filename,
        fit: BoxFit.contain,
      );
    } else {
      image = const SizedBox(
        width: 200,
        height: 100,
      );
    }
    // Put it in a DecoratedBox to give it a border - hides the portrait cutoffs
    image = DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        border: Border.all(
          width: highlighted ? 2 : 1,
          color: highlighted ? Colors.green : Colors.grey.shade700,
        ),
      ),
      child: image,
    );
    List<Widget> elements = <Widget>[title, image];
    // Wrap it in a GestureDetector and a MouseRegion for interaction
    Widget slotPortrait = GestureDetector(
      onTap: () async => _changePartyMember(slot),
      child: MouseRegion(
        onEnter: (PointerEvent e)=>setState((){_hover = slot;}),
        onExit: (PointerEvent e)=>setState((){_hover = null;}),
        cursor: SystemMouseCursors.click,
        child: Column(
          children: elements,
        ),
      ),
    );
    // A remove button is added, greyed out if the slot is already empty
    FontWeight weight = FontWeight.normal;
    if (highlightedRemove && isUsed) {
      weight = FontWeight.bold;
    }
    Widget removeRow = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(
          Icons.cancel_outlined,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            'Remove',
            style: TextStyle(
              color: Colors.white,
              fontWeight: weight,
            ),
          ),
        ),
      ],
    );
    Color removeColor = isUsed ? Colors.red.shade700 : Colors.grey;
    double opacity = 0.7;
    if (highlightedRemove) {
      opacity = 1.0;
    }
    Widget removeButton = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: removeColor.withOpacity(opacity),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
        child: removeRow,
      ),
    );
    // Only interactable if slot isn't already empty
    if (isUsed) {
      removeButton = GestureDetector(
        onTap: () async => _removePartyMember(slot),
        child: MouseRegion(
          onEnter: (PointerEvent e)=>setState((){_hoverRemove = slot;}),
          onExit: (PointerEvent e)=>setState((){_hoverRemove = null;}),
          cursor: SystemMouseCursors.click,
          child: removeButton,
        ),
      );
    }
    return Column(
      children: <Widget>[
        slotPortrait,
        const SizedBox(height: 2),
        removeButton,
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    // Make a reference and a deep copy of the list we're changing
    _original = saveFileWrapper.saveFile.partyData;
    _editable = _original.deepCopyElements(PartySlot.from);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> characters = _editable.map(_drawCharacter).toList();
    List<Widget> rows = <Widget>[];
    for (int i = 0; i < 3; i++) {
      int index = (2 - i) * 4;
      List<Widget> children = characters.sublist(index, index+4);
      Iterable<Widget> flexibleChildren = children.map(
        (Widget w)=>Flexible(child: w),
      );
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: flexibleChildren.separateWith(const SizedBox(width: 20)),
        ),
      );
    }
    Widget? floatingActionButton;
    bool shouldSave = _hasChanges();
    if (shouldSave) {
      floatingActionButton = FloatingActionButton(
        onPressed: _saveChanges,
        child: const Icon(Icons.save),
      );
    }
    Widget mainColumn = Column(
      children: rows.separateWith(const SizedBox(height: 10)),
    );
    return WillPopScope(
      onWillPop: _checkChangesAndConfirm,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit which characters are in the party'),
        ),
        floatingActionButton: floatingActionButton,
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[mainColumn].separateWith(
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
