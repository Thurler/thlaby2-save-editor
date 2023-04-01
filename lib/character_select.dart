import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/common.dart';
import 'package:thlaby2_save_editor/list_extension.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/widgets/characterselect.dart';

class CharacterSelectWidget extends StatefulWidget {
  const CharacterSelectWidget({super.key});

  @override
  State<CharacterSelectWidget> createState() => CharacterSelectState();
}

class CharacterSelectState extends CommonState<CharacterSelectWidget> {
  @override
  Widget build(BuildContext context) {
    TCharacterSelect characterSelect = TCharacterSelect(
      characterTapFunction: (CharacterName ch) => Navigator.of(context).pop(ch),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a character to include in the party'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[characterSelect].separateWith(
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
