import 'package:flutter/material.dart';
import 'package:tfields/forms.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/save/character.dart';
import 'package:thlaby2_save_editor/save/enums/character.dart';
import 'package:thlaby2_save_editor/save/enums/item.dart';
import 'package:thlaby2_save_editor/save/enums/skill.dart';
import 'package:thlaby2_save_editor/save/enums/subclass.dart';
import 'package:thlaby2_save_editor/save/gem.dart';
import 'package:thlaby2_save_editor/save/item_slot.dart';
import 'package:thlaby2_save_editor/save/levelbonus.dart';
import 'package:thlaby2_save_editor/save/library.dart';
import 'package:thlaby2_save_editor/save/skill.dart';
import 'package:thlaby2_save_editor/save/tome.dart';
import 'package:thlaby2_save_editor/widgets/forms/groups/character_basic.dart';
import 'package:thlaby2_save_editor/widgets/forms/groups/character_equips.dart';
import 'package:thlaby2_save_editor/widgets/forms/groups/character_gems.dart';
import 'package:thlaby2_save_editor/widgets/forms/groups/character_level_bonus.dart';
import 'package:thlaby2_save_editor/widgets/forms/groups/character_library.dart';
import 'package:thlaby2_save_editor/widgets/forms/groups/character_skill_levels.dart';
import 'package:thlaby2_save_editor/widgets/forms/groups/character_skill_points.dart';
import 'package:thlaby2_save_editor/widgets/forms/groups/character_tomes.dart';

enum CharacterFormField
    implements TFormField, TFormSubgroup<CharacterFormField> {
  basic('Level, EXP, BP, Subclass'),
  library('Library points'),
  levelBonus('Level up bonuses'),
  skillPoints('Skill points'),
  commonSkills('Skill levels (Common)'),
  personalSkills('Skill levels (Personal)'),
  subclassSkills('Skill levels (Subclass)'),
  tomeLevel('Tomes'),
  gemLevel('Gems'),
  equipment('Equipment');

  @override
  final String title;

  const CharacterFormField(this.title);

  @override
  List<CharacterFormField> get fields => <CharacterFormField>[this];

  @override
  bool get initiallyExpanded => true;
}

class CharacterForm extends TFormGroup<CharacterData, void, CharacterFormField>
    with
        TSubgroups<CharacterData, void, CharacterFormField,
            CharacterFormField> {
  final CharacterData initialData;

  final int skillCount;

  late final Map<Skill, int> initialCommonSkillsValue;

  late final Map<Skill, int> initialPersonalSkillsValue;

  late final Map<Skill, int> initialSubclassSkillsValue;

  final CharacterBasicFormKey _basicFormKey = CharacterBasicFormKey();

  final CharacterLibraryFormKey _libraryFormKey = CharacterLibraryFormKey();

  final CharacterLevelBonusFormKey _levelBonusFormKey =
      CharacterLevelBonusFormKey();

  final CharacterSkillPointsFormKey _skillPointsFormKey =
      CharacterSkillPointsFormKey();

  final CharacterSkillLevelFormKey _genericSkillsFormKey =
      CharacterSkillLevelFormKey();

  final CharacterSkillLevelFormKey _personalSkillsFormKey =
      CharacterSkillLevelFormKey();

  final CharacterSkillLevelFormKey _subclassSkillsFormKey =
      CharacterSkillLevelFormKey();

  final CharacterTomesFormKey _tomeFormKey = CharacterTomesFormKey();

  final CharacterGemsFormKey _gemFormKey = CharacterGemsFormKey();

  final CharacterEquipFormKey _equipFormKey = CharacterEquipFormKey();

  CharacterForm({
    required SaveFile saveFile,
    required Character character,
    required super.enabled,
    required GroupSetState? setState,
  }) :
    initialData = saveFile.characterData[character.index],
    skillCount =
        saveFile.characterData[character.index].character.skills.length,
    super(setState: setState) {
    addGenericForm(
      formName: CharacterFormField.basic,
      key: _basicFormKey,
      form: CharacterBasicForm(
        key: _basicFormKey,
        initialValue: CharacterBasic.fromCharacterData(initialData),
        onLevelChange: (_) => _onLevelDataChange(),
        onSubclassChange: _onSubclassChange,
        usedUniqueSubclasses: <Character, Subclass>{
          for (Character ch in Character.values)
            if (saveFile.getCharacterSubclass(ch).isUnique && ch != character)
              ch: saveFile.characterData[ch.index].subclass,
        },
        enabled: enabled,
        setState: setState,
      ),
    );

    addGenericForm(
      formName: CharacterFormField.library,
      key: _libraryFormKey,
      form: CharacterLibraryForm(
        key: _libraryFormKey,
        initialValue: initialData.libraryLevels,
        enabled: enabled,
        setState: setState,
      ),
    );

    addGenericForm(
      formName: CharacterFormField.levelBonus,
      key: _levelBonusFormKey,
      form: CharacterLevelBonusForm(
        key: _levelBonusFormKey,
        initialValue: (initialData.unusedBonusPoints, initialData.levelBonus),
        onLevelChange: (_) => _onLevelDataChange(),
        enabled: enabled,
        setState: setState,
      ),
    );

    addGenericForm(
      formName: CharacterFormField.skillPoints,
      key: _skillPointsFormKey,
      form: CharacterSkillPointsForm(
        key: _skillPointsFormKey,
        initialValue: (initialData.unusedSkillPoints, initialData.usedManuals),
        onManualsChange: (_) => _onSkillLevelChange(),
        enabled: enabled,
        setState: setState,
      ),
    );

    List<Skill> tomeSkills = initialData.getCommonSkills(initialData.tomes);
    List<Skill> baseSkills = <Skill>[...tomeSkills, ...ExpSkill.values];
    initialCommonSkillsValue = <Skill, int>{
      for ((int, Skill) indexedSkill in baseSkills.indexed)
        indexedSkill.$2: initialData.skills.getCommonData(indexedSkill.$1),
    };
    addGenericForm(
      formName: CharacterFormField.commonSkills,
      key: _genericSkillsFormKey,
      form: CharacterSkillLevelForm(
        key: _genericSkillsFormKey,
        initialValue: initialCommonSkillsValue,
        onLevelChange: (_) => _onSkillLevelChange(),
        dataOverrides: <Skill, ({bool? enabled, String? subtitle})>{
          for ((int, Skill) indexSkill in tomeSkills.indexed)
            indexSkill.$2: initialData.getCommonSkillLocked(indexSkill.$1)
            ? (enabled: false, subtitle: TomeData.lockedMessage)
            : (enabled: null, subtitle: null),
        },
        enabled: enabled,
        setState: setState,
      ),
    );

    initialPersonalSkillsValue = <Skill, int>{
      for ((int, Skill) indexedSkill in initialData.character.allSkills.indexed)
        indexedSkill.$2: indexedSkill.$1 < skillCount
        ? initialData.skills.personalSkills[indexedSkill.$1]
        : initialData.skills.personalSpells[indexedSkill.$1 - skillCount],
    };
    addGenericForm(
      formName: CharacterFormField.personalSkills,
      key: _personalSkillsFormKey,
      form: CharacterSkillLevelForm(
        key: _personalSkillsFormKey,
        initialValue: initialPersonalSkillsValue,
        onLevelChange: (_) => _onSkillLevelChange(),
        enabled: enabled,
        setState: setState,
      ),
    );

    initialSubclassSkillsValue = <Skill, int>{
      for ((int, Skill) indexedSkill in initialData.subclass.allSkills.indexed)
        indexedSkill.$2: initialData.skills.subclassSkills[indexedSkill.$1],
    };

    initialData.subclass.allSkills.indexed.map(
      ((int, Skill) indexSkill) =>
          (indexSkill.$2, initialData.skills.subclassSkills[indexSkill.$1]),
    ).toList();
    addGenericForm(
      formName: CharacterFormField.subclassSkills,
      key: _subclassSkillsFormKey,
      form: CharacterSkillLevelForm(
        key: _subclassSkillsFormKey,
        initialValue: initialSubclassSkillsValue,
        onLevelChange: (_) => _onSkillLevelChange(),
        enabled: enabled,
        setState: setState,
      ),
    );

    addGenericForm(
      formName: CharacterFormField.tomeLevel,
      key: _tomeFormKey,
      form: CharacterTomesForm(
        key: _tomeFormKey,
        initialValue: initialData.tomes,
        character: initialData.character,
        onTomeChange: _onTomeLevelChange,
        enabled: enabled,
        setState: setState,
      ),
    );

    addGenericForm(
      formName: CharacterFormField.gemLevel,
      key: _gemFormKey,
      form: CharacterGemsForm(
        key: _gemFormKey,
        initialValue: initialData.gems,
        enabled: enabled,
        setState: setState,
      ),
    );

    addGenericForm(
      formName: CharacterFormField.equipment,
      key: _equipFormKey,
      form: CharacterEquipForm(
        key: _equipFormKey,
        initialValue: (initialData.mainEquip, initialData.subEquips),
        availableMainEquips: saveFile.mainInventoryData.where(
          (ItemSlot<MainEquip> slot) => slot.isUnlocked,
        ).map(
          (ItemSlot<MainEquip> slot) => slot.item,
        ).toList(),
        availableSubEquips: saveFile.subInventoryData.where(
          (ItemSlot<SubEquip> slot) => slot.isUnlocked,
        ).map(
          (ItemSlot<SubEquip> slot) => slot.item,
        ).toList(),
        unlockMainEquip: (MainEquip item) =>
            _fixLockedEquip(saveFile.mainInventoryData, item),
        unlockSubEquip: (SubEquip item) =>
            _fixLockedEquip(saveFile.subInventoryData, item),
        enabled: enabled,
        setState: setState,
      ),
    );
  }

  void recalculateLimits() {
    _onLevelDataChange();
    _onSkillLevelChange();
  }

  void _onLevelDataChange() {
    int remainingCap = LevelBonus.levelBonusCap;
    // The available points are always 1 less than current level
    int available = basicData.level - 1;
    LevelBonus levelBonus = levelBonusData.$2;
    // For each point allocated, we decrease the global cap and how many points
    // are left over - this second one can go into the negatives
    for (int i = 0; i < LevelBonus.levelBonusStatCount; i++) {
      remainingCap -= levelBonus.getStatData(i);
      available -= levelBonus.getStatData(i);
    }
    // The cap for each individual stat becomes whatever has been allocated,
    // plus whatever is left from the global cap
    for (int i = 0; i < LevelBonus.levelBonusStatCount; i++) {
      _levelBonusFormKey.currentState?.widget.group.updateCapForStat(
        index: i,
        cap: remainingCap + levelBonus.getStatData(i),
      );
    }
    // The unused level up points form should be updated automatically
    _levelBonusFormKey.currentState?.widget.group.unused = available;
  }

  void _onSkillLevelChange() {
    // Available count is level + training manuals + 2
    int available = basicData.level + skillPointsData.$2 + 2;
    // First we map out all the skill data that is up for editing
    List<MapEntry<Skill, int>> allSkillsData = <MapEntry<Skill, int>>[
      ...commonSkills.entries,
      ...personalSkills.entries,
      ...subclassSkills.entries,
    ];
    // Subtract points for each skill learned based on its data
    for (MapEntry<Skill, int> skillData in allSkillsData) {
      Skill skill = skillData.key;
      int level = skillData.value;
      if (level > skill.minLevel) {
        available -= (level - skill.minLevel) * skill.levelCost;
      }
    }
    _skillPointsFormKey.currentState?.widget.group.unused = available;
  }

  void _onTomeLevelChange(TomeStat tomeStat) {
    // Find the skill that will be used after the tome data update
    TomeLevel newLevel = getTomeLevel(tomeStat);
    Skill newSkill = initialData.getCommonSkill(newLevel, tomeStat);
    // If the stat has no tomes attached to it and it is not a natural stat for
    // this character, we must disable the corresponding skill and update the
    // subtitle to convey this new information
    bool newLevelLocksSkill = newLevel == TomeLevel.unused &&
        !initialData.character.isNaturalTomeStat(tomeStat);
    _genericSkillsFormKey.currentState?.widget.group.updateSkill(
      newSkill,
      tomeStat.index,
      updateEnabledTo: !newLevelLocksSkill,
      customSubtitle: newLevelLocksSkill ? TomeData.lockedMessage : null,
    );
  }

  void _onSubclassChange(Subclass? subclass) {
    if (subclass == null) {
      return;
    }
    // Propagate the change to the group so it can reset the forms
    CharacterSkillLevelFormGroup? group =
        _subclassSkillsFormKey.currentState?.widget.group;
    group?.updateAllSkills(subclass.allSkills);
    _subclassSkillsFormKey.currentState?.redrawGroup(
      (_) => group?.onGroupValueChanged(),
    );
  }

  void _fixLockedEquip<I extends Item>(List<ItemSlot<I>> slots, I item) {
    ItemSlot<I> chosen =
        slots.firstWhere((ItemSlot<I> slot) => slot.item == item);
    chosen.isUnlocked = true;
  }

  @override
  CharacterData makeEntity(void additionalData) => CharacterData(
    character: initialData.character,
    level: basicData.level,
    unusedSkillPoints: skillPointsData.$1,
    unusedBonusPoints: levelBonusData.$1,
    usedManuals: skillPointsData.$2,
    bp: basicData.battlePoints,
    experience: basicData.exp,
    subclass: basicData.subclass,
    libraryLevels: libraryData,
    levelBonus: levelBonusData.$2,
    skills: SkillData(
      commonSkills: commonSkills.values.toList(),
      personalSkills: personalSkills.values.toList().sublist(0, skillCount),
      personalSpells: personalSkills.values.toList().sublist(skillCount),
      subclassSkills: subclassSkills.values.toList(),
    ),
    tomes: tomeData,
    gems: gemData,
    mainEquip: equipData.$1,
    subEquips: equipData.$2,
  );

  CharacterBasic get basicData =>
      _basicFormKey.currentState?.value ??
      CharacterBasic.fromCharacterData(initialData);

  LibraryData get libraryData =>
      _libraryFormKey.currentState?.value ?? initialData.libraryLevels;

  int get unusedLevelPoints => levelBonusData.$1;

  (int, LevelBonus) get levelBonusData =>
      _levelBonusFormKey.currentState?.value ?? (
    initialData.unusedBonusPoints,
    initialData.levelBonus
  );

  int get unusedSkillPoints => skillPointsData.$1;

  (int, int) get skillPointsData =>
      _skillPointsFormKey.currentState?.value ?? (
    initialData.unusedSkillPoints,
    initialData.usedManuals
  );

  Map<Skill, int> get commonSkills =>
      _genericSkillsFormKey.currentState?.value ?? initialCommonSkillsValue;

  Map<Skill, int> get personalSkills =>
      _personalSkillsFormKey.currentState?.value ?? initialPersonalSkillsValue;

  Map<Skill, int> get subclassSkills =>
      _subclassSkillsFormKey.currentState?.value ?? initialSubclassSkillsValue;

  TomeData get tomeData =>
      _tomeFormKey.currentState?.value ?? initialData.tomes;

  TomeLevel getTomeLevel(TomeStat stat) =>
      _tomeFormKey.currentState?.widget.group.level(
    CharacterTomesFormField.values[stat.index],
  ) ?? initialData.tomes.getStatData(stat.index);

  GemData get gemData => _gemFormKey.currentState?.value ?? initialData.gems;

  EquipTuple get equipData =>
      _equipFormKey.currentState?.value ?? (
    initialData.mainEquip,
    initialData.subEquips
  );

  @override
  List<CharacterFormField> get subgroups => CharacterFormField.values;
}

class CharacterFormWidget
    extends TFormSubgroupListWidget<CharacterFormField, CharacterForm> {
  const CharacterFormWidget({required super.form, super.key}) :
    super.noSubmit();

  @override
  List<Widget> buildSubgroup(
    CharacterFormField subgroup,
    BuildContext context,
  ) {
    return <Widget>[form[subgroup]];
  }
}
