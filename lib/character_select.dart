import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/common.dart';
import 'package:thlaby2_save_editor/list_extension.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/string_extension.dart';

class CharacterSelectWidget extends StatefulWidget {
  const CharacterSelectWidget({super.key});

  @override
  State<CharacterSelectWidget> createState() => CharacterSelectState();
}

class CharacterSelectState extends CommonState<CharacterSelectWidget> {
  CharacterName? _hover;

  //
  // Helper functions to draw stuff on screen, helps declutter the build method
  //

  Widget _drawCharacter(CharacterName character) {
    int index = character.index;
    SaveFile saveFile = saveFileWrapper.saveFile;
    bool isUnlocked = saveFile.characterUnlockFlags[index].isUnlocked;
    bool highlighted = _hover == character && isUnlocked;
    // Character name acts as a title for the box
    String name = character.name;
    Widget title = Text(
      name.upperCaseFirstChar(),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: highlighted ? Colors.green : null,
      ),
    );
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
    if (isUnlocked) {
      result = GestureDetector(
        onTap: ()=>Navigator.of(context).pop(character),
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
    Wrap characterWrap = Wrap(
      spacing: 10,
      runSpacing: 10,
      children: characters,
    );
    List<Widget> columnChildren = <Widget>[
      characterWrap,
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a character to include in the party'),
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
