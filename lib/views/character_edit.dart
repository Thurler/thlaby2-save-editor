import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/common.dart';
import 'package:thlaby2_save_editor/extensions/int_extension.dart';
import 'package:thlaby2_save_editor/extensions/list_extension.dart';
import 'package:thlaby2_save_editor/extensions/string_extension.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/save/character.dart';
import 'package:thlaby2_save_editor/widgets/badge.dart';
import 'package:thlaby2_save_editor/widgets/form.dart';

typedef SetStateFunction = void Function(void Function());

class ExpansionGroup {
  final String title;
  bool expanded;
  List<ExpansionForm> forms;
  bool hasChanges = false;
  bool hasErrors = false;

  void toggleExpanded() {
    expanded = !expanded;
  }

  ExpansionGroup({
    required this.title,
    required this.forms,
    this.expanded = false,
  });

  bool checkChanges() {
    return hasChanges = forms.any(
      (ExpansionForm form) => form.initialValue != form.getValue(),
    );
  }

  bool checkErrors() {
    return hasErrors = forms.any((ExpansionForm form) => form.error != '');
  }

  // ignore: avoid_positional_boolean_parameters
  Widget buildHeader(BuildContext context, bool isExpanded) {
    Widget titleWidget = Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w700),
    );
    List<Widget> badges = <Widget>[];
    if (hasChanges) {
      badges.add(
        const TBadge(
          text: 'Has Changes',
          color: Colors.green,
        ),
      );
    }
    if (hasErrors) {
      badges.add(
        const TBadge(
          text: 'Has Issues',
          color: Colors.red,
        ),
      );
    }
    if (badges.isNotEmpty) {
      titleWidget = Row(
        children: <Widget>[
          Expanded(child: titleWidget),
          ...badges.separateWith(const SizedBox(width: 5)),
        ],
      );
    }
    return ListTile(title: titleWidget);
  }
}

abstract class ExpansionForm {
  late SetStateFunction setStateCallback;
  final TextEditingController controller;
  final String title;
  final String subtitle;
  String initialValue = '';
  String error = '';

  ExpansionForm({
    required this.controller,
    required this.title,
    required this.subtitle,
  });

  String getValue() {
    return controller.text;
  }

  String saveValue() {
    return initialValue = getValue();
  }

  void initForm(SetStateFunction setStateFunc, String value) {
    setStateCallback = setStateFunc;
    initialValue = value;
    controller.text = initialValue;
  }

  Widget toForm();
}

class NumberExpansionForm extends ExpansionForm {
  final BigInt minValue;
  final BigInt maxValue;

  NumberExpansionForm({
    required super.controller,
    required super.title,
    required super.subtitle,
    required this.minValue,
    required this.maxValue,
  });

  void validate(String raw, {bool callSetState = true}) {
    BigInt value = BigInt.parse(raw);
    if (value < minValue) {
      error = 'Value must be at least ${minValue.toCommaSeparatedNotation()}';
    } else if (value > maxValue) {
      error = 'Value must be at most ${maxValue.toCommaSeparatedNotation()}';
    } else {
      error = '';
    }
    if (callSetState) {
      setStateCallback((){});
    }
  }

  @override
  void initForm(SetStateFunction setStateFunc, String value) {
    validate(value.replaceAll(',', ''), callSetState: false);
    super.initForm(setStateFunc, value);
  }

  @override
  String saveValue() {
    return super.saveValue().replaceAll(',', '');
  }

  @override
  Widget toForm() {
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

class DropdownExpansionForm extends ExpansionForm {
  final List<String> options;
  late String Function(String) validateFunction;

  DropdownExpansionForm({
    required super.controller,
    required super.title,
    required super.subtitle,
    required this.options,
  });

  void onChanged(String? chosen, {bool callSetState = true}) {
    if (chosen != null) {
      error = validateFunction(chosen);
      controller.text = chosen;
      if (callSetState) {
        setStateCallback((){});
      }
    }
  }

  void initDropdown(
    SetStateFunction setStateFunc,
    String value,
    String Function(String) validation,
  ) {
    validateFunction = validation;
    onChanged(value, callSetState: false);
    super.initForm(setStateFunc, value);
  }

  @override
  Widget toForm() {
    return TDropdownForm(
      title: title,
      subtitle: subtitle,
      errorMessage: error,
      value: controller.text,
      options: options,
      onChanged: onChanged,
      hintText: '',
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

  final NumberExpansionForm levelForm = NumberExpansionForm(
    controller: TextEditingController(),
    title: 'Level',
    subtitle: 'Must be between 1 and 9,999,999',
    minValue: BigInt.from(1),
    maxValue: BigInt.from(9999999),
  );

  final NumberExpansionForm expForm = NumberExpansionForm(
    controller: TextEditingController(),
    title: 'Experience',
    subtitle: 'Must be between 0 and 9 quintillion',
    minValue: BigInt.from(0),
    maxValue: BigInt.parse('9000000000000000000'),
  );

  final NumberExpansionForm bpForm = NumberExpansionForm(
    controller: TextEditingController(),
    title: 'Battle Points',
    subtitle: 'Must be between 0 and 2,147,483,647',
    minValue: BigInt.from(0),
    maxValue: BigInt.from(2147483647),
  );

  final DropdownExpansionForm subclassForm = DropdownExpansionForm(
    controller: TextEditingController(),
    title: 'Subclass',
    subtitle: 'Changing this will affect skills data',
    options: Subclass.values.map((Subclass s)=>s.prettyName).toList(),
  );

  //
  // Properly check for and validate changes, save/commit them
  //

  String _checkForDuplicateUniqueSubclasses(String value) {
    Subclass chosen = Subclass.values.firstWhere(
      (Subclass s) => s.prettyName == value,
    );
    // If the chosen subclass is not a unique one, aceept the value
    if (!chosen.isUnique) {
      return '';
    }
    // Otherwise, no other character must have his subclass
    List<CharacterData> original = saveFileWrapper.saveFile.characterData;
    Iterable<CharacterData> overlap = original.where((CharacterData data) {
      return data.character != widget.character && data.subclass == chosen;
    });
    if (overlap.isEmpty) {
      return '';
    }
    // Properly inform which character has the overlapping subclass
    String overlapName = overlap.first.character.name.upperCaseFirstChar();
    return '$overlapName already has this subclass';
  }

  bool _hasChanges() {
    bool ret = false;
    for (ExpansionGroup group in expansionGroups) {
      ret |= group.checkChanges();
    }
    return ret;
  }

  bool _validateFields() {
    bool ret = false;
    for (ExpansionGroup group in expansionGroups) {
      ret |= group.checkErrors();
    }
    return ret;
  }

  Future<bool> _checkChangesAndConfirm() async {
    if (!_hasChanges()) {
      return true;
    }
    bool canDiscard = await showUnsavedChangesDialog();
    if (canDiscard) {
      await logger.log(
        LogLevel.info,
        'Discarding changes to character data',
      );
    }
    return canDiscard;
  }

  Future<void> _saveChanges() async {
    // Get save file reference and commit changes to forms
    int characterIndex = widget.character.index;
    CharacterData data = saveFileWrapper.saveFile.characterData[characterIndex];

    // Basic info - level, exp, bp, subclass
    data.level = int.parse(levelForm.saveValue());
    data.experience = BigInt.parse(expForm.saveValue());
    data.bp = int.parse(bpForm.saveValue());
    Subclass chosen = Subclass.values.firstWhere(
      (Subclass s) => s.prettyName == subclassForm.saveValue(),
    );
    data.subclass = chosen;

    // Refresh widget to get rid of the save symbol
    setState((){});
  }

  @override
  void initState() {
    super.initState();
    // Set the expansion group titles and form structure
    expansionGroups = <ExpansionGroup>[
      ExpansionGroup(
        title: 'Level, EXP, BP, Subclass',
        forms: <ExpansionForm>[levelForm, expForm, bpForm, subclassForm],
      ),
      ExpansionGroup(title: 'Library points', forms: <ExpansionForm>[]),
      ExpansionGroup(title: 'Level up bonuses', forms: <ExpansionForm>[]),
      ExpansionGroup(title: 'Skill points', forms: <ExpansionForm>[]),
      ExpansionGroup(title: 'Tomes', forms: <ExpansionForm>[]),
      ExpansionGroup(title: 'Gems', forms: <ExpansionForm>[]),
      ExpansionGroup(title: 'Equipment', forms: <ExpansionForm>[]),
    ];

    // Initialize form data based on save data
    int characterIndex = widget.character.index;
    CharacterData data = saveFileWrapper.saveFile.characterData[characterIndex];

    // Basic info - level, exp, bp, subclass
    levelForm.initForm(setState, data.level.toCommaSeparatedNotation());
    expForm.initForm(setState, data.experience.toCommaSeparatedNotation());
    bpForm.initForm(setState, data.bp.toCommaSeparatedNotation());
    subclassForm.initDropdown(
      setState,
      data.subclass.prettyName,
      _checkForDuplicateUniqueSubclasses,
    );
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
            headerBuilder: group.buildHeader,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
              child: Column(
                children: group.forms.map(
                  (ExpansionForm f)=>f.toForm(),
                ).toList(),
              ),
            ),
          );
        }).toList(),
      ),
    ];
    _validateFields();
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
          title: Text("Edit $characterName's data"),
        ),
        floatingActionButton: floatingActionButton,
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
