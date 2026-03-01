import 'package:flutter/material.dart';
import 'package:tfields/widgets.dart';
import 'package:thlaby2_save_editor/save/enums/skill.dart';

class CharacterSkillLevelFormField implements TFormField {
  final Skill skill;

  const CharacterSkillLevelFormField(this.skill);

  @override
  bool operator ==(Object other) =>
      other is CharacterSkillLevelFormField && skill == other.skill;

  @override
  int get hashCode => skill.hashCode;
}

class CharacterSkillLevelFormGroup
    extends TFormGroup<Map<Skill, int>, void, CharacterSkillLevelFormField> {
  final Map<Skill, int> initialData;
  final List<Skill> _currentSkillList;
  final void Function(int?) onLevelChange;

  CharacterSkillLevelFormGroup({
    required this.initialData,
    required this.onLevelChange,
    required super.enabled,
    required super.setState,
    Map<Skill, ({bool? enabled, String? subtitle})>? dataOverrides,
  }) : _currentSkillList = initialData.keys.toList() {
    for (MapEntry<Skill, int> entry in initialData.entries) {
      Skill skill = entry.key;
      int initialValue = entry.value;
      addIntegerForm(
        formName: CharacterSkillLevelFormField(skill),
        enabledOverride: dataOverrides?[skill]?.enabled,
        readonly: skill.maxLevel < 1,
        initialValue: initialValue,
        title: skill.prettyName,
        subtitle: dataOverrides?[skill]?.subtitle ?? skill.subtitle,
        minValue: skill.minLevel,
        maxValue: skill.maxLevel,
        onValueChanged: onLevelChange,
        snapToMinOnEmpty: skill.minLevel == 0,
        snapToMaxWhenOver: true,
        validationCallback: (int? value) =>
            value == null ? 'Spell level cannot be empty!' : '',
      );
    }
  }

  void _addNewSkillForm(Skill skill) {
    addIntegerForm(
      formName: CharacterSkillLevelFormField(skill),
      readonly: skill.maxLevel < 1,
      initialValue: 0,
      title: skill.prettyName,
      subtitle: skill.subtitle,
      minValue: skill.minLevel,
      maxValue: skill.maxLevel,
      onValueChanged: onLevelChange,
      snapToMinOnEmpty: skill.minLevel == 0,
      snapToMaxWhenOver: true,
      validationCallback: (int? value) =>
          value == null ? 'Spell level cannot be empty!' : '',
    );
  }

  void updateSkill(
    Skill newSkill,
    int index, {
    bool? updateEnabledTo,
    String? customSubtitle,
  }) {
    Skill oldSkill = _currentSkillList.elementAt(index);
    if (oldSkill == newSkill) {
      // If skills match, simply update the enable flag, subtitle and value
      TIntegerFormKey key = _skillLevelKey(oldSkill);
      if (updateEnabledTo != null) {
        key.currentState?.enabled = updateEnabledTo;
      }
      key.currentState?.subtitle = customSubtitle ?? newSkill.subtitle;
      key.currentState?.value = 0;
      key.currentState?.widget.onValueChanged?.call(0);
    } else {
      // Else, we need to completely rewrite the form with a new key
      removeForm(CharacterSkillLevelFormField(oldSkill));
      _currentSkillList[index] = newSkill;
      _addNewSkillForm(newSkill);
    }
    // Always call the group value changed function and the level change
    // callback, to make sure skill points and info propagates
    onLevelChange(null);
    onGroupValueChanged();
  }

  void updateAllSkills(List<Skill> newSkills) {
    for (Skill skill in _currentSkillList) {
      removeForm(CharacterSkillLevelFormField(skill));
    }
    _currentSkillList.clear();
    for (Skill skill in newSkills) {
      _addNewSkillForm(skill);
      _currentSkillList.add(skill);
    }
    // Force state to be updated since skillset changed, also update the skill
    // point data
    onLevelChange(null);
    onGroupValueChanged();
  }

  bool get hasSkills => _currentSkillList.isNotEmpty;

  List<Skill> get currentSkills => _currentSkillList.toList();

  // We need to check if any of the displayed skills changed, or if their levels
  // were changed from initial data (the forms lose track of initial data if the
  // skill set changed)
  @override
  bool get hasChanges =>
      // Differing lengths already implies a change happened
      _currentSkillList.length != initialData.keys.length ||
      _currentSkillList.any(
    (Skill skill) =>
        // If any skill name is different, or the individual level changed
        !initialData.containsKey(skill) ||
        skillLevel(skill) != initialData[skill],
  );

  @override
  Map<Skill, int> makeEntity(void additionalData) => <Skill, int>{
    for (Skill skill in _currentSkillList) skill: skillLevel(skill),
  };

  int skillLevel(Skill skill) =>
      this[CharacterSkillLevelFormField(skill)].integerValue ??
      initialData[skill] ?? 0;

  TIntegerFormKey _skillLevelKey(Skill skill) =>
      this[CharacterSkillLevelFormField(skill)].integerKey;
}

class CharacterSkillLevelFormWidget
    extends TFormGroupWidget<CharacterSkillLevelFormGroup> {
  const CharacterSkillLevelFormWidget({required super.form, super.key}) :
    super.noSubmit();

  @override
  Widget build(BuildContext context) {
    return form.hasSkills
      ? TGridRow(
          mdFlexLimit: 1,
          lgFlexLimit: 2,
          xxlFlexLimit: 3,
          children: <TGridItem>[
            for (Skill skill in form.currentSkills)
              TGridItem(child: form[CharacterSkillLevelFormField(skill)]),
          ],
        )
      : const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: TIconText.error('Character does not have a subclass selected'),
        );
  }
}

typedef CharacterSkillLevelFormKey
    = GlobalKey<TGroupFormState<Map<Skill, int>, CharacterSkillLevelFormGroup>>;

class CharacterSkillLevelForm
    extends TGroupForm<Map<Skill, int>, CharacterSkillLevelFormGroup> {
  CharacterSkillLevelForm({
    required void Function(int?) onLevelChange,
    required Map<Skill, int> super.initialValue,
    required super.enabled,
    required super.setState,
    Map<Skill, ({bool? enabled, String? subtitle})>? dataOverrides,
    super.key,
  }) : super(
    groupBuilder: ({
      required bool enabled,
      required GroupSetState? setState,
      Map<Skill, int>? initialData,
    }) {
      return CharacterSkillLevelFormGroup(
        initialData: initialValue,
        dataOverrides: dataOverrides,
        onLevelChange: onLevelChange,
        enabled: enabled,
        setState: setState,
      );
    },
    groupWidgetBuilder: (CharacterSkillLevelFormGroup form) =>
        CharacterSkillLevelFormWidget(form: form),
  );
}
