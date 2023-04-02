import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/common.dart';
import 'package:thlaby2_save_editor/extensions/list_extension.dart';
import 'package:thlaby2_save_editor/extensions/string_extension.dart';
import 'package:thlaby2_save_editor/save/character.dart';
import 'package:thlaby2_save_editor/widgets/form.dart';

class ExpansionGroup {
  final String title;
  bool expanded;

  void toggleExpanded() {
    expanded = !expanded;
  }

  ExpansionGroup({required this.title, this.expanded = false});
}

class CharacterEditWidget extends StatefulWidget {
  final CharacterName character;
  const CharacterEditWidget({required this.character, super.key});

  @override
  State<CharacterEditWidget> createState() => CharacterEditState();
}

class CharacterEditState extends CommonState<CharacterEditWidget> {
  late List<ExpansionGroup> expansionGroups;

  @override
  void initState() {
    super.initState();
    expansionGroups = <ExpansionGroup>[
      ExpansionGroup(title: 'Edit level, exp, subclass, BP'),
      ExpansionGroup(title: 'Edit library points'),
      ExpansionGroup(title: 'Edit level up bonuses'),
      ExpansionGroup(title: 'Edit skill points'),
      ExpansionGroup(title: 'Edit tomes'),
      ExpansionGroup(title: 'Edit gems'),
      ExpansionGroup(title: 'Edit equipment'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    String characterName = widget.character.name.upperCaseFirstChar();
    Widget backgroundPortrait = Opacity(
      opacity: 0.8,
      child: Image.asset(
        'img/character/${getCharacterFilename(widget.character)}.png',
        alignment: Alignment.bottomRight,
        fit: BoxFit.fitHeight,
        width: double.infinity,
        height: double.infinity,
      ),
    );
    List<Widget> columnChildren = <Widget>[
      ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            expansionGroups[index].toggleExpanded();
          });
        },
        children: expansionGroups.map((ExpansionGroup group) {
          return ExpansionPanel(
            backgroundColor: Colors.white.withOpacity(0.9),
            canTapOnHeader: true,
            isExpanded: group.expanded,
            headerBuilder: (BuildContext context, bool isExpanded) => ListTile(
              title: Text(
                group.title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
              child: Column(
                children: <Widget>[
                  TNumberForm(
                    title: 'Level',
                    subtitle: "$characterName's current level",
                    controller: TextEditingController(),
                    minValue: 1,
                    maxValue: 9999999,
                    validationCallback: (String value){},
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    ];
    return WillPopScope(
      onWillPop: ()=>Future<bool>.value(true),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edit $characterName's data"),
        ),
        backgroundColor: Colors.white.withOpacity(0.2),
        body: Stack(
          children: <Widget>[
            backgroundPortrait,
            Positioned.fill(
              child: ListView(
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
      ),
    );
  }
}
