import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/common.dart';
import 'package:thlaby2_save_editor/list_extension.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/string_extension.dart';
import 'package:thlaby2_save_editor/widgets/form.dart';

class CharacterEditWidget extends StatefulWidget {
  final CharacterName character;
  const CharacterEditWidget({required this.character, super.key});

  @override
  State<CharacterEditWidget> createState() => CharacterEditState();
}

class CharacterEditState extends CommonState<CharacterEditWidget> {
  List<bool> expanded = List<bool>.filled(7, false);
  List<String> headers = <String>[
    'Edit level, exp, subclass, BP',
    'Edit library points',
    'Edit level up bonuses',
    'Edit skill points',
    'Edit tomes',
    'Edit gems',
    'Edit equipment',
  ];

  @override
  Widget build(BuildContext context) {
    String characterName = widget.character.name.upperCaseFirstChar();
    Widget backgroundPortrait = Align(
      alignment: Alignment.bottomRight,
      child: Image.asset(
        'img/character/${getCharacterFilename(widget.character)}.png',
      ),
    );
    List<Widget> columnChildren = <Widget>[
      ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            expanded[index] = !expanded[index];
          });
        },
        children: headers.asMap().entries.map((MapEntry<int, String> header) {
          return ExpansionPanel(
            backgroundColor: Colors.white,
            canTapOnHeader: true,
            isExpanded: expanded[header.key],
            headerBuilder: (BuildContext context, bool isExpanded) => ListTile(
              title: Text(
                header.value,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
              child: Column(
                children: const <Widget>[
                  SizedBox(height: 200),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    ];
    return WillPopScope(
      onWillPop: ()=>Future<bool>.value(true),
      child: Stack(
        children: <Widget>[
          backgroundPortrait,
          Scaffold(
            appBar: AppBar(
              title: Text("Editing $characterName's data"),
            ),
            backgroundColor: Colors.white.withOpacity(0.2),
            body: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 250, 0),
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
        ],
      ),
    );
  }
}
