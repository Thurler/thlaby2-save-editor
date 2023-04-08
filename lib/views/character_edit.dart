import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/common.dart';
import 'package:thlaby2_save_editor/extensions/int_extension.dart';
import 'package:thlaby2_save_editor/extensions/list_extension.dart';
import 'package:thlaby2_save_editor/extensions/string_extension.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/save/character.dart';
import 'package:thlaby2_save_editor/widgets/form_wrapper.dart';

class TCharacterNumberForm extends TNumberFormWrapper {
  TCharacterNumberForm.library({
    required super.title,
    required super.setStateCallback,
  }) : super(
    minValue: BigInt.from(0),
    maxValue: BigInt.from(CharacterEditState.libraryCap),
    subtitle: 'Must be below '
      '${CharacterEditState.libraryCap.toCommaSeparatedNotation()}',
  );

  TCharacterNumberForm.libraryElement({
    required super.title,
    required super.setStateCallback,
  }) : super(
    minValue: BigInt.from(0),
    maxValue: BigInt.from(CharacterEditState.libraryElementCap),
    subtitle: 'Must be below '
      '${CharacterEditState.libraryElementCap.toCommaSeparatedNotation()}',
  );

  TCharacterNumberForm.levelBonus({
    required super.title,
    required super.onValueUpdate,
    required super.setStateCallback,
  }) : super(
    minValue: BigInt.from(0),
    maxValue: BigInt.from(CharacterEditState.levelBonusCap),
    subtitle: 'Sum of all points must be below '
      '${CharacterEditState.levelBonusCap.toCommaSeparatedNotation()}\n',
  );

  TCharacterNumberForm.gem({
    required super.title,
    required super.setStateCallback,
  }) : super(
    minValue: BigInt.from(0),
    maxValue: BigInt.from(CharacterEditState.gemCap),
    subtitle: 'Must be below '
      '${CharacterEditState.gemCap.toCommaSeparatedNotation()}',
  );
}

class CharacterEditWidget extends StatefulWidget {
  final CharacterName character;
  const CharacterEditWidget({required this.character, super.key});

  @override
  State<CharacterEditWidget> createState() => CharacterEditState();
}

class CharacterEditState extends CommonState<CharacterEditWidget> {
  static const List<String> stats = <String>[
    'HP', 'ATK', 'DEF', 'MAG', 'MND', 'SPD',
  ];
  static const List<String> gemStats = <String>[
    'HP', 'MP', 'TP', 'ATK', 'DEF', 'MAG', 'MND', 'SPD',
  ];
  static const List<String> elements = <String>[
    'FIR', 'CLD', 'WND', 'NTR', 'MYS', 'SPI', 'DRK', 'PHY',
  ];
  static const String expCap = '999999999999999999'; // Can go higher, but why
  static const int levelCap = 9999999; // Save load sets it to this if higher
  static const int levelBonusCap = levelCap - 1;
  static const int bpCap = 2147483647; // Goes negative past this
  static const int libraryCap = 99999999; // Hard cap at library
  static const int libraryElementCap = 100; // Hard cap at library
  static const int gemCap = 20; // Hard cap at shrine

  late List<TFormGroup> expansionGroups;

  late final TNumberFormWrapper levelForm = TNumberFormWrapper(
    title: 'Level',
    subtitle: 'Must be between 1 and ${levelCap.toCommaSeparatedNotation()}',
    minValue: BigInt.from(1),
    maxValue: BigInt.from(levelCap),
    setStateCallback: setState,
    onValueUpdate: _updateLevelPoints,
  );

  late final TNumberFormWrapper expForm = TNumberFormWrapper(
    title: 'Experience',
    subtitle: 'Must be below 1 quintillion',
    minValue: BigInt.from(0),
    maxValue: BigInt.parse(expCap),
    setStateCallback: setState,
  );

  late final TNumberFormWrapper bpForm = TNumberFormWrapper(
    title: 'Battle Points',
    subtitle: 'Must be below ${bpCap.toCommaSeparatedNotation()}',
    minValue: BigInt.from(0),
    maxValue: BigInt.from(bpCap),
    setStateCallback: setState,
  );

  late final TDropdownFormWrapper subclassForm = TDropdownFormWrapper(
    title: 'Subclass',
    subtitle: 'Changing this will affect skills data',
    setStateCallback: setState,
    options: Subclass.values.map((Subclass s)=>s.prettyName).toList(),
  );

  late final List<TNumberFormWrapper> libraryForms = stats.map(
    (String stat) => TCharacterNumberForm.library(
      title: '$stat Level',
      setStateCallback: setState,
    ),
  ).toList();

  late final List<TNumberFormWrapper> libraryElementForms = elements.map(
    (String element) => TCharacterNumberForm.libraryElement(
      title: '$element Level',
      setStateCallback: setState,
    ),
  ).toList();

  late final TNumberFormWrapper unusedLevelForm = TNumberFormWrapper(
    title: 'Unused points',
    subtitle: 'Updated automatically with level and used points',
    minValue: BigInt.from(-levelBonusCap),
    maxValue: BigInt.from(levelBonusCap),
    setStateCallback: setState,
    readOnly: true,
  );

  late final List<TNumberFormWrapper> levelBonusForms = stats.map(
    (String stat) => TCharacterNumberForm.levelBonus(
      title: 'Points in $stat',
      setStateCallback: setState,
      onValueUpdate: _updateLevelPoints,
    ),
  ).toList();

  late final List<TNumberFormWrapper> gemForms = gemStats.map(
    (String stat) => TCharacterNumberForm.gem(
      title: 'Gems used in $stat',
      setStateCallback: setState,
    ),
  ).toList();

  late final TStringFormWrapper mainEquipmentForm = TStringFormWrapper(
    title: 'Main equipment',
    subtitle: 'Item occupying main slot',
    readOnly: true,
    setStateCallback: setState,
  );

  late final List<TStringFormWrapper> subEquipmentForms = <int>[1, 2, 3].map(
    (int i) => TStringFormWrapper(
      title: 'Sub equipment $i',
      subtitle: 'Item occupying sub slot $i',
      readOnly: true,
      setStateCallback: setState,
    ),
  ).toList();

  //
  // Properly check for and validate changes, save/commit them
  //

  void _updateLevelPoints() {
    int cap = levelBonusCap;
    int points = levelForm.getIntValue().toInt() - 1;
    for (TNumberFormWrapper form in levelBonusForms) {
      int value = form.getIntValue().toInt();
      points -= value;
      cap -= value;
    }
    setState((){
      for (TNumberFormWrapper form in levelBonusForms) {
        form.updateMaxValue(BigInt.from(cap) + form.getIntValue());
      }
      unusedLevelForm.controller.text = points.toCommaSeparatedNotation();
    });
  }

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
    for (TFormGroup group in expansionGroups) {
      ret |= group.checkChanges();
    }
    return ret;
  }

  bool _validateFields() {
    bool ret = false;
    for (TFormGroup group in expansionGroups) {
      ret |= group.checkErrors();
    }
    return !ret;
  }

  List<String> _validateMessages() {
    List<String> messages = <String>[];
    // Subclass validation - do nothing, simply warn
    if (subclassForm.error != '') {
      messages.add('${subclassForm.error} - no action will be taken');
    }
    return messages;
  }

  void _fixValidationErrors() {}

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
    // Check if there are invalid fields, properly show them to user
    if (!_validateFields()) {
      await logger.log(
        LogLevel.warning,
        'Attempting to save invalid data',
      );
      List<String> messages = _validateMessages();
      bool doSave = await showSaveWarningDialog(
        'Some validation errors were detected, and some of them might require '
        'an action to be taken in order to save:\n\n${messages.join('\n')}\n\n '
        'Please make sure you are fine with the actions above',
        breaking: false,
      );
      if (!doSave) {
        return;
      }
      // If user wants to save anyway, we must convert the invalid values that
      // will cause errors back into valid values that closely match the input
      _fixValidationErrors();
    }

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

    // Library data + Level bonus data
    for (int i = 0; i < stats.length; i++) {
      data.libraryLevels.setStatData(i, libraryForms[i].saveValue());
      data.levelBonus.setStatData(i, levelBonusForms[i].saveValue());
    }
    for (int i = 0; i < elements.length; i++) {
      data.libraryLevels.setElementData(i, libraryElementForms[i].saveValue());
    }
    data.unusedBonusPoints = int.parse(unusedLevelForm.saveValue());

    // Gem data
    for (int i = 0; i < gemStats.length; i++) {
      data.gems.setStatData(i, gemForms[i].saveValue());
    }

    // Refresh widget to get rid of the save symbol
    setState((){});
  }

  @override
  void initState() {
    super.initState();
    // Set the expansion group titles and form structure
    expansionGroups = <TFormGroup>[
      TFormGroup(
        title: 'Level, EXP, BP, Subclass',
        forms: <TFormWrapper>[levelForm, expForm, bpForm, subclassForm],
      ),
      TFormGroup(
        title: 'Library points',
        forms: libraryForms + libraryElementForms,
      ),
      TFormGroup(
        title: 'Level up bonuses',
        forms: <TFormWrapper>[unusedLevelForm] + levelBonusForms,
      ),
      TFormGroup(title: 'Skill points', forms: <TFormWrapper>[]),
      TFormGroup(title: 'Tomes', forms: <TFormWrapper>[]),
      TFormGroup(
        title: 'Gems',
        forms: gemForms,
      ),
      TFormGroup(
        title: 'Equipment',
        forms: <TFormWrapper>[mainEquipmentForm] + subEquipmentForms,
      ),
    ];

    // Initialize form data based on save data
    int characterIndex = widget.character.index;
    CharacterData data = saveFileWrapper.saveFile.characterData[characterIndex];

    // Basic info - level, exp, bp, subclass
    levelForm.initNumberForm(BigInt.from(data.level));
    expForm.initNumberForm(data.experience);
    bpForm.initNumberForm(BigInt.from(data.bp));
    subclassForm.initDropdownForm(
      data.subclass.prettyName,
      _checkForDuplicateUniqueSubclasses,
    );

    // Library info + Level up info
    for (int i = 0; i < stats.length; i++) {
      libraryForms[i].initNumberForm(
        BigInt.from(data.libraryLevels.getStatData(i)),
      );
      levelBonusForms[i].initNumberForm(
        BigInt.from(data.levelBonus.getStatData(i)),
      );
    }
    for (int i = 0; i < elements.length; i++) {
      libraryElementForms[i].initNumberForm(
        BigInt.from(data.libraryLevels.getElementData(i)),
      );
    }

    // Gems info
    for (int i = 0; i < gemStats.length; i++) {
      gemForms[i].initNumberForm(
        BigInt.from(data.gems.getStatData(i)),
      );
    }

    // Equipment info
    mainEquipmentForm.initForm(data.mainEquip.id.toString());
    for (int i = 0; i < 3; i++) {
      subEquipmentForms[i].initForm(data.subEquips[i].id.toString());
    }

    // Set and update unused level up bonus info
    unusedLevelForm.initNumberForm(
      BigInt.from(data.unusedBonusPoints),
    );
    _updateLevelPoints();
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
        children: expansionGroups.map(
          (TFormGroup group) => group.build(),
        ).toList(),
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
