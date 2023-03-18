import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/common.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/widgets/button.dart';

class CharacterUnlockWidget extends StatefulWidget {
  const CharacterUnlockWidget({super.key});

  @override
  State<CharacterUnlockWidget> createState() => CharacterUnlockState();
}

class CharacterUnlockState extends CommonState<CharacterUnlockWidget> {
  late List<CharacterUnlockFlag> flags;

  void toggleUnlockedData(CharacterUnlockFlag flag) {
    setState((){
      flag.isUnlocked = !flag.isUnlocked;
    });
  }

  Widget drawCharacter(CharacterUnlockFlag flag) {
    String characterName = getCharacterFilename(flag.character);
    String filename = 'img/character/${characterName}_SS.png';
    Widget image = Image.asset(
      filename,
      fit: BoxFit.contain,
      width: 200,
      height: 29,
    );
    if (!flag.isUnlocked) {
      image = ColorFiltered(
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.saturation,
        ),
        child: image,
      );
    }
    return GestureDetector(
      onTap: ()=>toggleUnlockedData(flag),
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: image,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    flags = saveFileWrapper.saveFile.characterUnlockFlags;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> characters = flags.map(drawCharacter).toList();
    Wrap characterWrap = Wrap(
      spacing: 5,
      runSpacing: 5,
      children: characters,
    );
    List<Widget> columnChildren = <Widget>[
      characterWrap,
      const TButton(
        text: 'Save changes',
        icon: Icons.save,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit which characters are unlocked'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: buildSeparatedList(
                columnChildren,
                const SizedBox(height: 20),
                separateEnds: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
