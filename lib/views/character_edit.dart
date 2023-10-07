import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/extensions/int_extension.dart';
import 'package:thlaby2_save_editor/extensions/string_extension.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/mixins/alert.dart';
import 'package:thlaby2_save_editor/mixins/breakablechanges.dart';
import 'package:thlaby2_save_editor/mixins/discardablechanges.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/save/character.dart';
import 'package:thlaby2_save_editor/save/enums/character.dart';
import 'package:thlaby2_save_editor/save/enums/item.dart';
import 'package:thlaby2_save_editor/save/enums/skill.dart';
import 'package:thlaby2_save_editor/save/enums/subclass.dart';
import 'package:thlaby2_save_editor/save/library.dart';
import 'package:thlaby2_save_editor/save/tome.dart';
import 'package:thlaby2_save_editor/widgets/common_scaffold.dart';
import 'package:thlaby2_save_editor/widgets/form.dart';
import 'package:thlaby2_save_editor/widgets/form_group.dart';

typedef DropdownFormKeyMap = Map<String, DropdownFormKey>;
typedef NumberFormKeyMap = Map<String, NumberFormKey>;
typedef SkillFormKeyMap = Map<Skill, NumberFormKey>;
typedef FixedFormKeyMap = Map<String, FixedFormKey>;

class CharacterEditWidget extends StatefulWidget {
  final Character character;
  const CharacterEditWidget({required this.character, super.key});

  @override
  State<CharacterEditWidget> createState() => CharacterEditState();
}

class CharacterEditState extends State<CharacterEditWidget>
    with
        Loggable,
        SaveReader,
        AlertHandler<CharacterEditWidget>,
        DiscardableChanges<CharacterEditWidget>,
        BreakableChanges<CharacterEditWidget> {
  static const List<String> stats = <String>[
    'HP',
    'ATK',
    'DEF',
    'MAG',
    'MND',
    'SPD',
  ];
  static const List<String> gemStats = <String>[
    'HP',
    'MP',
    'TP',
    'ATK',
    'DEF',
    'MAG',
    'MND',
    'SPD',
  ];
  static const List<String> elements = <String>[
    'FIR',
    'CLD',
    'WND',
    'NTR',
    'MYS',
    'SPI',
    'DRK',
    'PHY',
  ];
  static const List<Skill> boostSkills = BoostSkill.values;
  static const List<Skill> expSkills = ExpSkill.values;
  static const List<TomeStat> tomeStats = TomeStat.values;
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

  final NumberFormKey _levelFormKey = NumberFormKey();
  final NumberFormKey _expFormKey = NumberFormKey();
  final NumberFormKey _bpFormKey = NumberFormKey();
  final DropdownFormKey _subclassFormKey = DropdownFormKey();

  final NumberFormKeyMap _libraryFormsKeys = NumberFormKeyMap.fromEntries(
    (stats + elements).map(
      (String stat) => MapEntry<String, NumberFormKey>(stat, NumberFormKey()),
    ),
  );

  final NumberFormKey _unusedLevelFormKey = NumberFormKey();
  final NumberFormKeyMap _levelBonusFormsKeys = NumberFormKeyMap.fromEntries(
    stats.map(
      (String stat) => MapEntry<String, NumberFormKey>(stat, NumberFormKey()),
    ),
  );

  List<Skill> get _allSkills =>
      <Skill>[] + // The runtime type casting is dumb
      boostSkills +
      expSkills +
      character.skills +
      character.spells +
      character.awakeningSpells;

  late final SkillFormKeyMap _skillsFormsKeys = SkillFormKeyMap.fromEntries(
    _allSkills.map(
      (Skill skill) => MapEntry<Skill, NumberFormKey>(skill, NumberFormKey()),
    ),
  );

  final DropdownFormKeyMap _tomeFormsKeys = DropdownFormKeyMap.fromEntries(
    tomeStats.map(
      (TomeStat stat) => MapEntry<String, DropdownFormKey>(
        stat.name,
        DropdownFormKey(),
      ),
    ),
  );

  final NumberFormKeyMap _gemFormsKeys = NumberFormKeyMap.fromEntries(
    gemStats.map(
      (String stat) => MapEntry<String, NumberFormKey>(stat, NumberFormKey()),
    ),
  );

  final FixedFormKey _mainEquipFormKey = FixedFormKey();
  final List<FixedFormKey> _subEquipFormKeys = <FixedFormKey>[
    FixedFormKey(),
    FixedFormKey(),
    FixedFormKey(),
  ];

  late final List<TFormGroup> _expansionGroups;

  Iterable<MapEntry<FormKey, TForm>> _formMapEntriesFromList({
    required List<String> names,
    required Map<String, FormKey> keys,
    required String Function(String) titleBuilder,
    required String Function(String) subtitleBuilder,
    required int Function(int) initialValueBuilder,
    required BigInt maxValue,
    BigInt? minValue,
    void Function(String?)? onValueChanged,
  }) {
    return names.asMap().keys.map(
      (int i) => MapEntry<FormKey, TForm>(
        keys[names[i]]!,
        TFormNumber(
          enabled: true,
          title: titleBuilder(names[i]),
          subtitle: subtitleBuilder(names[i]),
          initialValue: initialValueBuilder(i).commaSeparate(),
          minValue: minValue ?? BigInt.from(0),
          maxValue: maxValue,
          onValueChanged: onValueChanged ?? (String? value) => setState(() {}),
          key: keys[names[i]],
        ),
      ),
    );
  }

  Iterable<MapEntry<FormKey, TForm>> _formMapEntriesFromSkillList({
    required List<Skill> skills,
    required Map<Skill, FormKey> keys,
    required int Function(int) initialValueBuilder,
    String Function(Skill) subtitleBuilder = skillSubtitle,
  }) {
    return skills.asMap().keys.map(
      (int i) => MapEntry<FormKey, TForm>(
        keys[skills[i]]!,
        TFormNumber(
          enabled: true,
          title: skills[i].name,
          subtitle: subtitleBuilder(skills[i]),
          initialValue: initialValueBuilder(i).commaSeparate(),
          minValue: BigInt.from(skills[i].minLevel),
          maxValue: BigInt.from(skills[i].maxLevel),
          onValueChanged: (String? value) => setState(() {}),
          key: keys[skills[i]],
        ),
      ),
    );
  }

  CharacterData get characterData => saveFile.characterData[character.index];

  //
  // Helper methods to handle state changes when forms get altered
  //

  void _updateLevelPoints(int points) {
    int remainingCap = levelBonusCap;
    // The available points are always 1 less than current level
    int available = points - 1;
    for (String stat in stats) {
      // For each point allocated, we decrease the global cap and how many
      // points are left over - this second one can go into the negatives
      int value = _levelBonusFormsKeys[stat]!.currentState!.intValue;
      remainingCap -= value;
      available -= value;
    }
    setState(() {
      // The cap for each individual stat becomes whatever has been allocated,
      // plus whatever is left from the global cap
      for (String stat in stats) {
        TFormNumberState state = _levelBonusFormsKeys[stat]!.currentState!;
        state.maxValue = BigInt.from(remainingCap + state.intValue);
      }
      // The unused level up points form should be updated automatically
      _unusedLevelFormKey.currentState!.value = available.commaSeparate();
    });
  }

  void _onLevelChange(String? value) => _updateLevelPoints(
    int.parse(value!.replaceAll(',', '')),
  );

  void _onLevelBonusChange(String? value) => _updateLevelPoints(
    _levelFormKey.currentState!.intValue,
  );

  void _updateTomeSkills(String? value) {
    // First we map out what the skill names and attributes will be for our
    // current tome configuration
    List<Skill> commonSkills = characterData.getCommonSkills(
      _tomeFormsKeys.values.map(
        (DropdownFormKey key) => key.currentState!.value,
      ),
    );
    setState(() {
      for (int i = 0; i < boostSkills.length; i++) {
        Skill base = boostSkills[i];
        Skill skill = commonSkills[i];
        TomeStat stat = TomeStat.values.elementAt(i);
        TFormNumberState boostSkill = _skillsFormsKeys[base]!.currentState!;
        // The title is always updated to match the skill name
        boostSkill.title = skill.name;
        // If the stat has no tomes attached to it and it is not a natural stat
        // for this character, we must zero out the corresponding skill and
        // update the subtitle to convey this new information
        String value = _tomeFormsKeys[stat.name]!.currentState!.value;
        bool isUnused = value == TomeLevel.unused.name;
        bool isNatural = character.isNaturalTomeStat(stat);
        BigInt maxValue;
        String subtitle;
        if (isUnused && !isNatural) {
          // Zero out the skill and hint at the need for a tome of insight
          maxValue = BigInt.from(0);
          subtitle = 'Needs a Tome of Insight to unlock';
          // Also zero the value, since a locked skill can't have points
          boostSkill.value = '0';
        } else {
          // Unlock the skill from the zero cap and return to regular subtitle
          maxValue = BigInt.from(skill.maxLevel);
          subtitle = skillSubtitle(skill);
        }
        boostSkill.subtitle = subtitle;
        boostSkill.maxValue = maxValue;
      }
    });
  }

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
    List<CharacterData> original = saveFile.characterData;
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

  @override
  bool get hasChanges => _expansionGroups.any(
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

  @override
  Future<void> saveChanges() async {
    // Check if there are invalid fields, properly show them to user
    if (_hasErrors) {
      await log(LogLevel.warning, 'Attempting to save invalid data');
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
        i,
        _libraryFormsKeys[stats[i]]!.currentState!.saveIntValue(),
      );
      data.levelBonus.setStatData(
        i,
        _levelBonusFormsKeys[stats[i]]!.currentState!.saveIntValue(),
      );
    }
    for (int i = 0; i < elements.length; i++) {
      data.libraryLevels.setElementData(
        i,
        _libraryFormsKeys[elements[i]]!.currentState!.saveIntValue(),
      );
    }
    data.unusedBonusPoints = _unusedLevelFormKey.currentState!.saveIntValue();

    // Common skills data
    for (int i = 0; i < boostSkills.length; i++) {
      data.skills.setBoostData(
        i,
        _skillsFormsKeys[boostSkills[i]]!.currentState!.saveIntValue(),
      );
    }
    for (int i = 0; i < expSkills.length; i++) {
      data.skills.setExpData(
        i,
        _skillsFormsKeys[expSkills[i]]!.currentState!.saveIntValue(),
      );
    }

    // Personal skills and spells data
    for (int i = 0; i < character.skills.length; i++) {
      NumberFormKey key = _skillsFormsKeys[character.skills[i]]!;
      data.skills.personalSkills[i] = key.currentState!.saveIntValue();
    }
    List<Skill> spells = <Skill>[];
    spells += character.spells;
    spells += character.awakeningSpells;
    for (int i = 0; i < spells.length; i++) {
      NumberFormKey key = _skillsFormsKeys[spells[i]]!;
      data.skills.personalSpells[i] = key.currentState!.saveIntValue();
    }

    // Tome data
    for (TomeStat stat in tomeStats) {
      data.tomes.setStatData(
        stat.index,
        _tomeFormsKeys[stat.name]!.currentState!.saveValue(),
        isNatural: character.isNaturalTomeStat(stat),
      );
    }

    // Gem data
    for (int i = 0; i < gemStats.length; i++) {
      data.gems.setStatData(
        i,
        _gemFormsKeys[gemStats[i]]!.currentState!.saveIntValue(),
      );
    }

    // Equipment data
    String chosenName = _mainEquipFormKey.currentState!.saveValue();
    MainEquip chosenMain = MainEquip.values.firstWhere(
      (MainEquip e) => e.name == chosenName,
    );
    data.mainEquip = chosenMain;
    for (int i = 0; i < 3; i++) {
      chosenName = _subEquipFormKeys[i].currentState!.saveValue();
      SubEquip chosenSub = SubEquip.values.firstWhere(
        (SubEquip e) => e.name == chosenName,
      );
      data.subEquips[i] = chosenSub;
    }

    // Refresh widget to get rid of the save symbol
    setState(() {});
  }

  //
  // Init and build the state
  //

  @override
  void initState() {
    super.initState();

    // Initialize form data based on save data
    CharacterData data = characterData;
    LibraryData libraryData = data.libraryLevels;

    // Initialize subclass skill group separately since it can change forms
    // dynamically as we change subclasses
    TFormGroup subclassSkillGroup = TFormGroup(
      title: 'Skill levels (Subclass)',
      forms: <FormKey, TForm>{},
    );

    _expansionGroups = <TFormGroup>[
      // Basic info - level, exp, bp, subclass
      TFormGroup(
        title: 'Level, EXP, BP, Subclass',
        forms: <FormKey, TForm>{
          _levelFormKey: TFormNumber(
            enabled: true,
            title: 'Level',
            subtitle: 'Must be between 1 and ${levelCap.commaSeparate()}',
            initialValue: data.level.commaSeparate(),
            minValue: BigInt.from(1),
            maxValue: BigInt.from(levelCap),
            onValueChanged: _onLevelChange,
            key: _levelFormKey,
          ),
          _expFormKey: TFormNumber(
            enabled: true,
            title: 'Experience',
            subtitle: 'Must be below 1 quintillion',
            initialValue: data.experience.commaSeparate(),
            minValue: BigInt.from(0),
            maxValue: BigInt.parse(expCap),
            onValueChanged: (String? value) => setState(() {}),
            key: _expFormKey,
          ),
          _bpFormKey: TFormNumber(
            enabled: true,
            title: 'Battle Points',
            subtitle: 'Must be at most ${bpCap.commaSeparate()}',
            initialValue: data.bp.commaSeparate(),
            minValue: BigInt.from(0),
            maxValue: BigInt.from(bpCap),
            onValueChanged: (String? value) => setState(() {}),
            key: _bpFormKey,
          ),
          _subclassFormKey: TFormDropdown(
            enabled: true,
            title: 'Subclass',
            subtitle: 'Changing this will affect skills data',
            hintText: 'Select a subclass',
            options: Subclass.values.map((Subclass s) => s.prettyName).toList(),
            initialValue: data.subclass.prettyName,
            validationCallback: _checkForDuplicateUniqueSubclasses,
            onValueChanged: (String? value) => setState(() {}),
            key: _subclassFormKey,
          ),
        },
      ),
      // Library info
      TFormGroup(
        title: 'Library points',
        forms: Map<FormKey, TForm>.fromEntries(
          _formMapEntriesFromList(
            names: stats,
            keys: _libraryFormsKeys,
            titleBuilder: (String name) => '$name Level',
            subtitleBuilder: (String name) => librarySubtitle,
            initialValueBuilder: (int i) => libraryData.getStatData(i),
            maxValue: BigInt.from(libraryCap),
          ).followedBy(
            _formMapEntriesFromList(
              names: elements,
              keys: _libraryFormsKeys,
              titleBuilder: (String name) => '$name Level',
              subtitleBuilder: (String name) => libraryElementSubtitle,
              initialValueBuilder: (int i) => libraryData.getElementData(i),
              maxValue: BigInt.from(libraryElementCap),
            ),
          ),
        ),
      ),
      // Level up info and unused level bonus
      TFormGroup(
        title: 'Level up bonuses',
        forms: <FormKey, TForm>{
          _unusedLevelFormKey: TFormNumber(
            enabled: false,
            title: 'Unused points',
            subtitle: 'Updated automatically with level and used points',
            initialValue: data.unusedBonusPoints.commaSeparate(),
            minValue: BigInt.from(-levelBonusCap),
            maxValue: BigInt.from(levelBonusCap),
            key: _unusedLevelFormKey,
          ),
        }..addEntries(
          _formMapEntriesFromList(
            names: stats,
            keys: _levelBonusFormsKeys,
            titleBuilder: (String name) => 'Points in $name',
            subtitleBuilder: (String name) => '',
            initialValueBuilder: (int i) => data.levelBonus.getStatData(i),
            maxValue: BigInt.from(levelCap - 1),
            onValueChanged: _onLevelBonusChange,
          ),
        ),
      ),
      // Common skill data
      TFormGroup(
        title: 'Skill levels (Common)',
        forms: Map<FormKey, TForm>.fromEntries(
          _formMapEntriesFromSkillList(
            skills: boostSkills,
            keys: _skillsFormsKeys,
            initialValueBuilder: (int i) => data.skills.getBoostData(i),
          ).followedBy(
            _formMapEntriesFromSkillList(
              skills: expSkills,
              keys: _skillsFormsKeys,
              initialValueBuilder: (int i) => data.skills.getExpData(i),
            ),
          ),
        ),
      ),
      // Personal skill data
      TFormGroup(
        title: 'Skill levels (Personal)',
        forms: Map<FormKey, TForm>.fromEntries(
          _formMapEntriesFromSkillList(
            skills: character.skills,
            keys: _skillsFormsKeys,
            initialValueBuilder: (int i) => data.skills.personalSkills[i],
          ).followedBy(
            _formMapEntriesFromSkillList(
              skills: character.spells,
              keys: _skillsFormsKeys,
              subtitleBuilder: spellSubtitle,
              initialValueBuilder: (int i) => data.skills.personalSpells[i],
            ),
          ).followedBy(
            _formMapEntriesFromSkillList(
              skills: character.awakeningSpells,
              keys: _skillsFormsKeys,
              initialValueBuilder: (int i) =>
                  data.skills.personalSpells[character.spells.length + i],
            ),
          ),
        ),
      ),
      // Subclass skill data
      subclassSkillGroup,
      // Tome level data
      TFormGroup(
        title: 'Tomes',
        forms: Map<FormKey, TForm>.fromEntries(
          tomeStats.map(
            (TomeStat stat) => MapEntry<FormKey, TForm>(
              _tomeFormsKeys[stat.name]!,
              TFormDropdown(
                enabled: true,
                title: 'Tomes used in ${stat.name}',
                subtitle: 'Changing this will affect skills data',
                hintText: 'Select a tome level',
                options: character.tomeDropdownOptions(stat),
                initialValue: data.tomes.getStatData(stat.index).name,
                onValueChanged: _updateTomeSkills,
                key: _tomeFormsKeys[stat.name],
              ),
            ),
          ),
        ),
      ),
      // Gem level data
      TFormGroup(
        title: 'Gems',
        forms: Map<FormKey, TForm>.fromEntries(
          _formMapEntriesFromList(
            names: gemStats,
            keys: _gemFormsKeys,
            titleBuilder: (String name) => 'Gems used in $name',
            subtitleBuilder: (String name) => '',
            initialValueBuilder: (int i) => data.gems.getStatData(i),
            maxValue: BigInt.from(gemCap),
          ),
        ),
      ),
      // Equipment data
      TFormGroup(
        title: 'Equipment',
        forms: <FormKey, TForm>{
          _mainEquipFormKey: TFormFixed(
            title: 'Main equipment',
            subtitle: 'Item occupying the main slot',
            initialValue: data.mainEquip.name,
            setCallback: () {},
            onValueChanged: (String? value) => setState(() {}),
            emptyValue: MainEquip.slot0.name,
            key: _mainEquipFormKey,
          ),
        }..addEntries(
          <int>[1, 2, 3].map(
            (int i) => MapEntry<FormKey, TForm>(
              _subEquipFormKeys[i - 1],
              TFormFixed(
                title: 'Sub equipment $i',
                subtitle: 'Item occupying sub slot $i',
                initialValue: data.subEquips[i - 1].name,
                setCallback: () {},
                onValueChanged: (String? value) => setState(() {}),
                emptyValue: SubEquip.slot0.name,
                key: _subEquipFormKeys[i - 1],
              ),
            ),
          ),
        ),
      ),
    ];

    // Call setState one last time after build runs for the first time
    // This causes the hasChanges and hasErrors to show up from initState
    WidgetsBinding.instance.addPostFrameCallback((Duration d) {
      _updateLevelPoints(data.level);
      _updateTomeSkills(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: checkChangesAndConfirm,
      child: CommonScaffold(
        title: "Edit ${character.name.upperCaseFirstChar()}'s data",
        floatingActionButton: saveButton,
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
