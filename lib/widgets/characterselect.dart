import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/common.dart';
import 'package:thlaby2_save_editor/list_extension.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/string_extension.dart';

class TCharacterSelect extends StatefulWidget {
  final void Function(CharacterName c) characterTapFunction;
  final Widget Function(bool l, bool h)? titleAppend;
  final List<CharacterUnlockFlag>? unlockFlags;
  final bool highlightIfLocked;

  const TCharacterSelect({
    required this.characterTapFunction,
    this.highlightIfLocked = false,
    this.titleAppend,
    this.unlockFlags,
    super.key,
  });

  @override
  State<TCharacterSelect> createState() => TCharacterSelectState();
}

class TCharacterSelectState extends CommonState<TCharacterSelect> {
  CharacterName? _hover;
  late List<CharacterUnlockFlag> flags;

  void callUpdateFlags() {
    setState(() {
      _updateFlags();
    });
  }

  void _updateFlags() {
    SaveFile saveFile = saveFileWrapper.saveFile;
    flags = saveFile.characterUnlockFlags;
    if (widget.unlockFlags != null) {
      flags = widget.unlockFlags!;
    }
  }

  @override
  void initState() {
    super.initState();
    _updateFlags();
  }

  //
  // Helper functions to draw stuff on screen, helps declutter the build method
  //

  Widget _drawCharacter(CharacterName character) {
    int index = character.index;
    bool isUnlocked = flags[index].isUnlocked;
    bool match = _hover == character;
    bool highlighted = match && (isUnlocked || widget.highlightIfLocked);
    // Character name acts as a title for the box
    String name = character.name;
    String titleText = name.upperCaseFirstChar();
    if (widget.titleAppend != null) {
      titleText += ':';
    }
    Widget title = Text(
      titleText,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: highlighted ? Colors.green : null,
      ),
    );
    if (widget.titleAppend != null) {
      title = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          title,
          const SizedBox(width: 5),
          widget.titleAppend!(isUnlocked, highlighted),
        ],
      );
    }
    // Main image using SS variant
    String characterFilename = getCharacterFilename(character);
    String filename = 'img/character/${characterFilename}_SS.png';
    Widget image = Image.asset(
      filename,
      fit: BoxFit.contain,
      width: 200,
      height: 29,
    );
    // Add a grayscale filter if the character is locked
    if (!isUnlocked) {
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
        border: Border.all(
          width: highlighted ? 2 : 1,
          color: highlighted ? Colors.green : Colors.grey.shade700,
        ),
      ),
      child: image,
    );
    List<Widget> elements = <Widget>[title, image];
    Widget result = Column(
      children: elements.separateWith(const SizedBox(height: 2)),
    );
    // Wrap result in a GestureDetector and a MouseRegion only if it can be
    // selected - only if the character is not locked
    if (isUnlocked || widget.highlightIfLocked) {
      result = GestureDetector(
        onTap: ()=>widget.characterTapFunction(character),
        child: MouseRegion(
          onEnter: (PointerEvent e)=>setState((){_hover = character;}),
          onExit: (PointerEvent e)=>setState((){_hover = null;}),
          cursor: SystemMouseCursors.click,
          child: result,
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> characters = CharacterName.values.map(_drawCharacter).toList();
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: characters,
    );
  }
}
