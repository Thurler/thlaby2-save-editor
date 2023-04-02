import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/common.dart';
import 'package:thlaby2_save_editor/extensions/int_extension.dart';
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

class ExpansionForm {
  final void Function(void Function()) setStateCallback;
  final TextEditingController controller;
  final String title;
  final String subtitle;
  final BigInt minValue;
  final BigInt maxValue;
  String error = '';

  ExpansionForm({
    required this.setStateCallback,
    required this.controller,
    required this.title,
    required this.subtitle,
    required this.minValue,
    required this.maxValue,
  });

  void validate(String raw) {
    BigInt value = BigInt.parse(raw);
    String oldError = error;
    if (value < minValue) {
      error = 'Value must be at least ${minValue.toCommaSeparatedNotation()}';
    } else if (value > maxValue) {
      error = 'Value must be at most ${maxValue.toCommaSeparatedNotation()}';
    } else {
      error = '';
    }
    if (oldError != error) {
      setStateCallback((){});
    }
  }

  Widget toNumberForm() {
    return TNumberForm(
      title: title,
      subtitle: subtitle,
      errorMessage: error,
      controller: controller,
      maxLength: maxValue.toString().length,
      validationCallback: validate,
    );
  }
}

class CharacterEditWidget extends StatefulWidget {
  final CharacterName character;
  const CharacterEditWidget({required this.character, super.key});

  @override
  State<CharacterEditWidget> createState() => CharacterEditState();
}

class CharacterEditState extends CommonState<CharacterEditWidget> {
  late List<ExpansionGroup> expansionGroups;
  late ExpansionForm form;
  late ExpansionForm form2;
  late ExpansionForm form3;

  @override
  void initState() {
    super.initState();
    expansionGroups = <ExpansionGroup>[
      ExpansionGroup(title: 'Level, EXP, BP, Subclass'),
      ExpansionGroup(title: 'Library points'),
      ExpansionGroup(title: 'Level up bonuses'),
      ExpansionGroup(title: 'Skill points'),
      ExpansionGroup(title: 'Tomes'),
      ExpansionGroup(title: 'Gems'),
      ExpansionGroup(title: 'Equipment'),
    ];
    int characterIndex = widget.character.index;
    form = ExpansionForm(
      setStateCallback: setState,
      controller: TextEditingController(),
      title: 'Level',
      subtitle: 'Must be between 1 and 9,999,999',
      minValue: BigInt.from(1),
      maxValue: BigInt.from(9999999),
    );
    form2 = ExpansionForm(
      setStateCallback: setState,
      controller: TextEditingController(),
      title: 'Experience',
      subtitle: 'Must be between 0 and 9 quintillion',
      minValue: BigInt.from(0),
      maxValue: BigInt.parse('9000000000000000000'),
    );
    form3 = ExpansionForm(
      setStateCallback: setState,
      controller: TextEditingController(),
      title: 'Battle Points',
      subtitle: 'Must be between 0 and 4,294,967,295',
      minValue: BigInt.from(0),
      maxValue: BigInt.from(4294967295),
    );
    CharacterData data = saveFileWrapper.saveFile.characterData[characterIndex];
    form.controller.text = data.level.toCommaSeparatedNotation();
    form2.controller.text = data.experience.toCommaSeparatedNotation();
    form3.controller.text = data.bp.toCommaSeparatedNotation();
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
                  form.toNumberForm(),
                  form2.toNumberForm(),
                  form3.toNumberForm(),
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
