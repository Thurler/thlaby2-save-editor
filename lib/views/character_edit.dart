import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/common.dart';
import 'package:thlaby2_save_editor/extensions/int_extension.dart';
import 'package:thlaby2_save_editor/extensions/string_extension.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/save/character.dart';
import 'package:thlaby2_save_editor/save/equip.dart';
import 'package:thlaby2_save_editor/save/skill.dart';
import 'package:thlaby2_save_editor/save/tome.dart';
import 'package:thlaby2_save_editor/widgets/common_scaffold.dart';
import 'package:thlaby2_save_editor/widgets/form.dart';
import 'package:thlaby2_save_editor/widgets/form_group.dart';
import 'package:thlaby2_save_editor/widgets/save_button.dart';

// class TCharacterNumberForm extends TNumberFormWrapper {
//   TCharacterNumberForm.library({
//     required super.title,
//     required super.setStateCallback,
//   }) : super(
//     minValue: BigInt.from(0),
//     maxValue: BigInt.from(CharacterEditState.libraryCap),
//     subtitle: 'Must be at most '
//       '${CharacterEditState.libraryCap.toCommaSeparatedNotation()}',
//   );

//   TCharacterNumberForm.libraryElement({
//     required super.title,
//     required super.setStateCallback,
//   }) : super(
//     minValue: BigInt.from(0),
//     maxValue: BigInt.from(CharacterEditState.libraryElementCap),
//     subtitle: 'Must be at most '
//       '${CharacterEditState.libraryElementCap.toCommaSeparatedNotation()}',
//   );

//   TCharacterNumberForm.levelBonus({
//     required super.title,
//     required super.onValueUpdate,
//     required super.setStateCallback,
//   }) : super(
//     minValue: BigInt.from(0),
//     maxValue: BigInt.from(CharacterEditState.levelBonusCap),
//     subtitle: 'Sum of all points must be at most '
//       '${CharacterEditState.levelBonusCap.toCommaSeparatedNotation()}\n',
//   );

//   TCharacterNumberForm.gem({
//     required super.title,
//     required super.setStateCallback,
//   }) : super(
//     minValue: BigInt.from(0),
//     maxValue: BigInt.from(CharacterEditState.gemCap),
//     subtitle: 'Must be at most '
//       '${CharacterEditState.gemCap.toCommaSeparatedNotation()}',
//   );

//   TCharacterNumberForm.skill({
//     required Skill skill,
//     required super.setStateCallback,
//   }) : super(
//     minValue: BigInt.from(0),
//     maxValue: BigInt.from(skill.maxLevel),
//     title: skill.name,
//     subtitle: CharacterEditState.skillSubtitle(skill),
//   );

//   TCharacterNumberForm.spell({
//     required Skill skill,
//     required super.setStateCallback,
//   }) : super(
//     minValue: BigInt.from(1),
//     maxValue: BigInt.from(skill.maxLevel),
//     title: skill.name,
//     subtitle: CharacterEditState.spellSubtitle(skill),
//   );
// }

typedef NumberFieldMap = Map<String, TFormNumberField>;
typedef NumberFormKeyMap = Map<String, NumberFormKey>;

class CharacterEditWidget extends StatefulWidget {
  final Character character;
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
  static const List<Skill> boostSkills = BoostSkill.values;
  static const List<Skill> expSkills = ExpSkill.values;
  static const String expCap = '999999999999999999'; // Can go higher, but why
  static const int levelCap = 9999999; // Save load sets it to this if higher
  static const int levelBonusCap = levelCap - 1;
  static const int bpCap = 2147483647; // Goes negative past this
  static const int libraryCap = 99999999; // Hard cap at library
  static const int libraryElementCap = 100; // Hard cap at library
  static const int gemCap = 20; // Hard cap at shrine

  static final String librarySubtitle = 'Must be at most '
    '${libraryCap.commaSeparate()}';
  static final String libraryElementSubtitle = 'Must be at most '
    '${libraryElementCap.commaSeparate()}';

  static String skillSubtitle(Skill skill) => 'Must be at most '
    '${skill.maxLevel} | Uses ${skill.levelCost} skill points per level';

  static String spellSubtitle(Skill skill) => 'Must be between 1 and '
    '${skill.maxLevel} | Uses ${skill.levelCost} skill points per level';

  Character get character => widget.character;

  late final TFormNumberField _levelForm;
  final NumberFormKey _levelFormKey = NumberFormKey();

  late final TFormNumberField _expForm;
  final NumberFormKey _expFormKey = NumberFormKey();

  late final TFormNumberField _bpForm;
  final NumberFormKey _bpFormKey = NumberFormKey();

  late final TFormDropdownField _subclassForm;
  final DropdownFormKey _subclassFormKey = DropdownFormKey();

  late final NumberFieldMap _libraryForms = <String, TFormNumberField>{};
  final NumberFormKeyMap _libraryFormsKeys = NumberFormKeyMap.fromEntries(
    (stats + elements).map(
      (String stat) => MapEntry<String, NumberFormKey>(stat, NumberFormKey()),
    ),
  );

  Iterable<MapEntry<FormKey, TFormData>> _formMapEntriesFromList({
    required Map<String, FormKey> keys,
    required Map<String, TFormField> forms,
    required List<String> names,
    required String Function(String) titleBuilder,
    required String Function(String) subtitleBuilder,
  }) {
    return names.map(
      (String name) => MapEntry<FormKey, TFormData>(
        keys[name]!,
        TFormData(
          title: titleBuilder(name),
          subtitle: subtitleBuilder(name),
          field: forms[name]!,
        ),
      ),
    );
  }

  late final List<TFormGroup> _expansionGroups = <TFormGroup>[
    TFormGroup(
      title: 'Level, EXP, BP, Subclass',
      forms: <FormKey, TFormData>{
        _levelFormKey: TFormData(
          title: 'Level',
          subtitle: 'Must be between 1 and ${levelCap.commaSeparate()}',
          field: _levelForm,
        ),
        _expFormKey: TFormData(
          title: 'Experience',
          subtitle: 'Must be below 1 quintillion',
          field: _expForm,
        ),
        _bpFormKey: TFormData(
          title: 'Battle Points',
          subtitle: 'Must be at most ${bpCap.commaSeparate()}',
          field: _bpForm,
        ),
        _subclassFormKey: TFormData(
          title: 'Subclass',
          subtitle: 'Changing this will affect skills data',
          field: _subclassForm,
        ),
      },
    ),
    TFormGroup(
      title: 'Library points',
      forms: Map<FormKey, TFormData>.fromEntries(
        _formMapEntriesFromList(
          names: stats,
          keys: _libraryFormsKeys,
          forms: _libraryForms,
          titleBuilder: (String stat) => '$stat Level',
          subtitleBuilder: (String stat) => librarySubtitle,
        ).followedBy(
          _formMapEntriesFromList(
            names: elements,
            keys: _libraryFormsKeys,
            forms: _libraryForms,
            titleBuilder: (String element) => '$element Level',
            subtitleBuilder: (String element) => libraryElementSubtitle,
          ),
        ),
      ),
    ),
    // TFormGroup(
    //   title: 'Level up bonuses',
    //   forms: <TFormWrapper>[unusedLevelForm] + levelBonusForms,
    // ),
    // TFormGroup(
    //   title: 'Skill points (Common)',
    //   forms: boostSkillForms + expSkillForms,
    // ),
    // TFormGroup(
    //   title: 'Skill points (Personal)',
    //   forms: personalSkillForms + personalSpellForms + awakeningSpellForms,
    // ),
    // TFormGroup(title: 'Skill points (Subclass)', forms: <TFormWrapper>[]),
    // TFormGroup(title: 'Tomes', forms: tomeForms),
    // TFormGroup(title: 'Gems', forms: gemForms),
    // TFormGroup(
    //   title: 'Equipment',
    //   forms: <TFormWrapper>[mainEquipForm] + subEquipForms,
    // ),
  ];

  // late final TNumberFormWrapper unusedLevelForm = TNumberFormWrapper(
  //   title: 'Unused points',
  //   subtitle: 'Updated automatically with level and used points',
  //   minValue: BigInt.from(-levelBonusCap),
  //   maxValue: BigInt.from(levelBonusCap),
  //   setStateCallback: setState,
  //   readOnly: true,
  // );

  // late final List<TNumberFormWrapper> levelBonusForms = stats.map(
  //   (String stat) => TCharacterNumberForm.levelBonus(
  //     title: 'Points in $stat',
  //     setStateCallback: setState,
  //     onValueUpdate: _updateLevelPoints,
  //   ),
  // ).toList();

  // late final List<TNumberFormWrapper> boostSkillForms = boostSkills.map(
  //   (Skill skill) => TCharacterNumberForm.skill(
  //     skill: skill,
  //     setStateCallback: setState,
  //   ),
  // ).toList();

  // late final List<TNumberFormWrapper> expSkillForms = expSkills.map(
  //   (Skill skill) => TCharacterNumberForm.skill(
  //     skill: skill,
  //     setStateCallback: setState,
  //   ),
  // ).toList();

  // late final List<TNumberFormWrapper> personalSkillForms = character.skills.map(
  //   (Skill skill) => TCharacterNumberForm.skill(
  //     skill: skill,
  //     setStateCallback: setState,
  //   ),
  // ).toList();

  // late final List<TNumberFormWrapper> personalSpellForms = character.spells.map(
  //   (Skill skill) => TCharacterNumberForm.spell(
  //     skill: skill,
  //     setStateCallback: setState,
  //   ),
  // ).toList();

  // late final List<TNumberFormWrapper> awakeningSpellForms =
  // character.awakeningSpells.map(
  //   (Skill skill) => TCharacterNumberForm.skill(
  //     skill: skill,
  //     setStateCallback: setState,
  //   ),
  // ).toList();

  // late final List<TDropdownFormWrapper> tomeForms = TomeStat.values.map(
  //   (TomeStat stat) => TDropdownFormWrapper(
  //     title: 'Tomes used in ${stat.name}',
  //     subtitle: 'Changing this will affect skills data',
  //     setStateCallback: setState,
  //     options: character.tomeDropdownOptions(stat),
  //     onValueUpdate: _updateTomeSkills,
  //   ),
  // ).toList();

  // late final List<TNumberFormWrapper> gemForms = gemStats.map(
  //   (String stat) => TCharacterNumberForm.gem(
  //     title: 'Gems used in $stat',
  //     setStateCallback: setState,
  //   ),
  // ).toList();

  // late final TFixedStringFormWrapper mainEquipForm = TFixedStringFormWrapper(
  //   title: 'Main equipment',
  //   subtitle: 'Item occupying main slot',
  //   setStateCallback: setState,
  //   addCallback: ()=>_editMainEquipment(mainEquipForm),
  //   editCallback: ()=>_editMainEquipment(mainEquipForm),
  //   removeCallback: ()=>_removeEquipment(mainEquipForm),
  //   emptyValue: MainEquip.slot0.name,
  // );

  // late final List<TFixedStringFormWrapper> subEquipForms = <int>[1, 2, 3].map(
  //   (int i) => TFixedStringFormWrapper(
  //     title: 'Sub equipment $i',
  //     subtitle: 'Item occupying sub slot $i',
  //     setStateCallback: setState,
  //     addCallback: ()=>_editSubEquipment(subEquipForms[i-1]),
  //     editCallback: ()=>_editSubEquipment(subEquipForms[i-1]),
  //     removeCallback: ()=>_removeEquipment(subEquipForms[i-1]),
  //     emptyValue: 'Empty',
  //   ),
  // ).toList();

  CharacterData get characterData => saveFileWrapper.saveFile.characterData[
    character.index
  ];

  //
  // Helper methods to handle state changes when forms get altered
  //

  // void _editMainEquipment(TFixedStringFormWrapper form) {}

  // void _editSubEquipment(TFixedStringFormWrapper form) {}

  // void _removeEquipment(TFixedStringFormWrapper form) {
  //   setState((){
  //     form.controller.text = form.emptyValue;
  //   });
  // }

  void _updateLevelPoints(int points) {
    int remainingCap = levelBonusCap;
    // The available points are always 1 less than current level
    int available = points - 1;
    // for (TNumberFormWrapper form in levelBonusForms) {
    //   // For each point allocated, we decrease the global cap and how many
    //   // points are left over - this second one can go into the negatives
    //   int value = form.getIntValue().toInt();
    //   remainingCap -= value;
    //   available -= value;
    // }
    setState((){
      // The cap for each individual stat becomes whatever has been allocated,
      // plus whatever is left from the global cap
      // for (TNumberFormWrapper form in levelBonusForms) {
      //   form.updateMaxValue(BigInt.from(remainingCap) + form.getIntValue());
      // }
      // The unused level up points form should be updated automatically
      // unusedLevelForm.controller.text = available.toCommaSeparatedNotation();
    });
  }

  void _onLevelChange(String? value) => _updateLevelPoints(
    int.parse(value!.replaceAll(',', '')),
  );

  // void _updateTomeSkills() {
  //   // First we map out what the skill names and attributes will be for our
  //   // current tome configuration
  //   List<Skill> commonSkills = characterData.getCommonSkills(
  //     tomeForms.map((TDropdownFormWrapper f) => f.getValue()),
  //   );
  //   setState((){
  //     for (int i = 0; i < BoostSkill.values.length; i++) {
  //       Skill skill = commonSkills[i];
  //       // The title is always updated to match the skill name
  //       boostSkillForms[i].title = skill.name;
  //       // If the stat has no tomes attached to it and it is not a natural stat
  //       // for this character, we must zero out the corresponding skill and
  //       // update the subtitle to convey this new information
  //       bool isUnused = tomeForms[i].getValue() == TomeLevel.unused.name;
  //       TomeStat stat = TomeStat.values.elementAt(i);
  //       bool isNatural = character.isNaturalTomeStat(stat);
  //       BigInt maxValue;
  //       String subtitle;
  //       if (isUnused && !isNatural) {
  //         // Zero out the skill and hint at the need for a tome of insight
  //         maxValue = BigInt.from(0);
  //         subtitle = 'Needs a Tome of Insight to unlock';
  //       } else {
  //         // Unlock the skill from the zero cap and return to regular subtitle
  //         maxValue = BigInt.from(skill.maxLevel);
  //         subtitle = skillSubtitle(skill);
  //       }
  //       boostSkillForms[i].updateMaxValue(maxValue);
  //       boostSkillForms[i].subtitle = subtitle;
  //     }
  //   });
  // }

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
      return data.character != character && data.subclass == chosen;
    });
    if (overlap.isEmpty) {
      return '';
    }
    // Properly inform which character has the overlapping subclass
    String overlapName = overlap.first.character.name.upperCaseFirstChar();
    return '$overlapName already has this subclass';
  }

  bool get _hasChanges => _expansionGroups.any(
    (TFormGroup group) => group.hasChanges,
  );

  bool get _hasErrors => _expansionGroups.any(
    (TFormGroup group) => group.hasErrors,
  );

  List<String> _validateMessages() {
    List<String> messages = <String>[];
    // Subclass validation - do nothing, simply warn
    String subclassError = _subclassFormKey.currentState!.errorMessage;
    if (subclassError != '') {
      messages.add('$subclassError - no action will be taken');
    }
    return messages;
  }

  void _fixValidationErrors() {}

  Future<bool> _checkChangesAndConfirm() async {
    if (!_hasChanges) {
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
    if (_hasErrors) {
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
    CharacterData data = characterData;

    // Basic info - level, exp, bp, subclass
    data.level = _levelFormKey.currentState!.saveIntValue();
    data.experience = _expFormKey.currentState!.saveBigIntValue();
    data.bp = _bpFormKey.currentState!.saveIntValue();
    String chosenSubclass = _subclassFormKey.currentState!.saveValue();
    data.subclass = Subclass.values.firstWhere(
      (Subclass s) => s.prettyName == chosenSubclass,
    );

    // Library data + Level bonus data
    for (int i = 0; i < stats.length; i++) {
      data.libraryLevels.setStatData(
        i, _libraryFormsKeys[stats[i]]!.currentState!.saveIntValue(),
      );
      // data.levelBonus.setStatData(i, levelBonusForms[i].saveValue());
    }
    for (int i = 0; i < elements.length; i++) {
      data.libraryLevels.setElementData(
        i, _libraryFormsKeys[stats[i]]!.currentState!.saveIntValue(),
      );
    }
    // data.unusedBonusPoints = int.parse(unusedLevelForm.saveValue());

    // // Common skills data
    // for (int i = 0; i < BoostSkill.values.length; i++) {
    //   data.skills.setBoostData(i, boostSkillForms[i].saveValue());
    // }
    // for (int i = 0; i < ExpSkill.values.length; i++) {
    //   data.skills.setExpData(i, expSkillForms[i].saveValue());
    // }

    // // Personal skills and spells data
    // for (int i = 0; i < character.skills.length; i++) {
    //   data.skills.personalSkills[i] = int.parse(
    //     personalSkillForms[i].saveValue(),
    //   );
    // }
    // int spellLength = (character.spells + character.awakeningSpells).length;
    // for (int i = 0; i < spellLength; i++) {
    //   data.skills.personalSpells[i] = int.parse(
    //     (personalSpellForms + awakeningSpellForms)[i].saveValue(),
    //   );
    // }

    // // Tome data
    // for (TomeStat stat in TomeStat.values) {
    //   data.tomes.setStatData(
    //     stat.index,
    //     tomeForms[stat.index].saveValue(),
    //     isNatural: character.isNaturalTomeStat(stat),
    //   );
    // }

    // // Gem data
    // for (int i = 0; i < gemStats.length; i++) {
    //   data.gems.setStatData(i, gemForms[i].saveValue());
    // }

    // // Equipment data
    // MainEquip chosenMain = MainEquip.values.firstWhere(
    //   (MainEquip e) => e.name == mainEquipForm.saveValue(),
    // );
    // data.mainEquip = chosenMain;
    // for (int i = 0; i < 3; i++) {
    //   SubEquip chosenSub = SubEquip.values.firstWhere(
    //     (SubEquip e) => e.name == subEquipForms[i].saveValue(),
    //   );
    //   data.subEquips[i] = chosenSub;
    // }

    // Refresh widget to get rid of the save symbol
    setState((){});
  }

  //
  // Init and build the state
  //

  @override
  void initState() {
    super.initState();

    // Initialize form data based on save data
    CharacterData data = characterData;

    // Basic info - level, exp, bp, subclass
    _levelForm = TFormNumberField(
      enabled: true,
      initialValue: data.level.commaSeparate(),
      minValue: BigInt.from(1),
      maxValue: BigInt.from(levelCap),
      onValueChanged: _onLevelChange,
      key: _levelFormKey,
    );
    _expForm = TFormNumberField(
      enabled: true,
      initialValue: data.experience.commaSeparate(),
      minValue: BigInt.from(0),
      maxValue: BigInt.parse(expCap),
      onValueChanged: (String? value) => setState((){}),
      key: _expFormKey,
    );
    _bpForm = TFormNumberField(
      enabled: true,
      initialValue: data.bp.commaSeparate(),
      minValue: BigInt.from(0),
      maxValue: BigInt.from(bpCap),
      onValueChanged: (String? value) => setState((){}),
      key: _bpFormKey,
    );
    _subclassForm = TFormDropdownField(
      enabled: true,
      hintText: 'Select a subclass',
      options: Subclass.values.map((Subclass s) => s.prettyName).toList(),
      initialValue: data.subclass.prettyName,
      validationCallback: _checkForDuplicateUniqueSubclasses, 
      onValueChanged: (String? value) => setState((){}),
      key: _subclassFormKey,
    );

    // Library info + Level up info
    for (int i = 0; i < stats.length; i++) {
      _libraryForms[stats[i]] = TFormNumberField(
        enabled: true,
        initialValue: data.libraryLevels.getStatData(i).commaSeparate(),
        minValue: BigInt.from(0),
        maxValue: BigInt.from(libraryCap),
        onValueChanged: (String? value) => setState((){}),
        key: _libraryFormsKeys[stats[i]],
      );
      // levelBonusForms[i].initNumberForm(
      //   BigInt.from(data.levelBonus.getStatData(i)),
      // );
    }
    for (int i = 0; i < elements.length; i++) {
      _libraryForms[elements[i]] = TFormNumberField(
        enabled: true,
        initialValue: data.libraryLevels.getElementData(i).commaSeparate(),
        minValue: BigInt.from(0),
        maxValue: BigInt.from(libraryElementCap),
        onValueChanged: (String? value) => setState((){}),
        key: _libraryFormsKeys[elements[i]],
      );
    }

    // // Common skills info
    // for (int i = 0; i < BoostSkill.values.length; i++) {
    //   boostSkillForms[i].initNumberForm(
    //     BigInt.from(data.skills.getBoostData(i)),
    //   );
    // }
    // for (int i = 0; i < ExpSkill.values.length; i++) {
    //   expSkillForms[i].initNumberForm(
    //     BigInt.from(data.skills.getExpData(i)),
    //   );
    // }

    // // Personal skills and spells info
    // for (int i = 0; i < character.skills.length; i++) {
    //   personalSkillForms[i].initNumberForm(
    //     BigInt.from(data.skills.personalSkills[i]),
    //   );
    // }
    // for (int i = 0; i < character.spells.length; i++) {
    //   personalSpellForms[i].initNumberForm(
    //     BigInt.from(data.skills.personalSpells[i]),
    //   );
    // }
    // for (int i = 0; i < character.awakeningSpells.length; i++) {
    //   awakeningSpellForms[i].initNumberForm(
    //     BigInt.from(data.skills.personalSpells[i + character.spells.length]),
    //   );
    // }

    // // Tomes info
    // for (int i = 0; i < TomeStat.values.length; i++) {
    //   tomeForms[i].initDropdownForm(data.tomes.getStatData(i).name);
    // }
    // _updateTomeSkills();

    // // Gems info
    // for (int i = 0; i < gemStats.length; i++) {
    //   gemForms[i].initNumberForm(
    //     BigInt.from(data.gems.getStatData(i)),
    //   );
    // }

    // // Equipment info
    // mainEquipForm.initForm(data.mainEquip.name);
    // for (int i = 0; i < 3; i++) {
    //   subEquipForms[i].initForm(data.subEquips[i].name);
    // }

    // // Set and update unused level up bonus info
    // unusedLevelForm.initNumberForm(
    //   BigInt.from(data.unusedBonusPoints),
    // );
    _updateLevelPoints(data.level);

    // Call setState one last time after build runs for the first time
    // This causes the hasChanges and hasErrors to show up from initState
    WidgetsBinding.instance.addPostFrameCallback((Duration d)=>setState((){}));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _checkChangesAndConfirm,
      child: CommonScaffold(
        title: "Edit ${character.name.upperCaseFirstChar()}'s data",
        floatingActionButton: _hasChanges
          ? TSaveButton(onPressed: _saveChanges)
          : null,
        padding: const EdgeInsets.fromLTRB(20, 0, 250, 0),
        background: Opacity(
          opacity: 0.8,
          child: Image.asset(
            'img/character/${character.filename}.png',
            alignment: Alignment.bottomRight,
            fit: BoxFit.fitHeight,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        children: <Widget>[
          ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                _expansionGroups[index].toggleExpanded();
              });
            },
            children: _expansionGroups.map(
              (TFormGroup group) => group.expansionPanel,
            ).toList(),
          ),
        ],
      ),
    );
  }
}
