import 'package:flutter/material.dart';
import 'package:tfields/widgets.dart';
import 'package:thlaby2_save_editor/save/enums/skill.dart';

class CharacterSkillLevelFormField implements TFormField {
  final int index;

  const CharacterSkillLevelFormField(this.index);

  @override
  bool operator ==(Object other) =>
      other is CharacterSkillLevelFormField && index == other.index;

  @override
  int get hashCode => index;
}

class CharacterSkillLevelFormGroup
    extends TFormGroup<List<(Skill, int)>, void, CharacterSkillLevelFormField> {
  final List<(Skill, int)> initialData;
  final List<(Skill, int)> _currentData;
  final void Function(int?) onLevelChange;

  CharacterSkillLevelFormGroup({
    required this.initialData,
    required this.onLevelChange,
    required super.enabled,
    required super.setState,
    Map<Skill, ({bool? enabled, String? subtitle})>? dataOverrides,
  }) : _currentData = initialData.toList() {
    for (int index = 0; index < initialData.length; index++) {
      Skill skill = initialData[index].$1;
      int initialValue = initialData[index].$2;
      addIntegerForm(
        formName: CharacterSkillLevelFormField(index),
        enabledOverride: dataOverrides?[skill]?.enabled,
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

  void updateSkill(
    Skill newSkill,
    int index, {
    bool? updateEnabledTo,
    String? customSubtitle,
  }) {
    _currentData[index] = (newSkill, 0);
    TIntegerFormKey key = _skillLevelKey(index);
    if (updateEnabledTo != null) {
      key.currentState?.enabled = updateEnabledTo;
    }
    key.currentState?.title = newSkill.prettyName;
    key.currentState?.subtitle = customSubtitle ?? newSkill.subtitle;
    key.currentState?.minValue = newSkill.minLevel;
    key.currentState?.maxValue = newSkill.maxLevel;
    key.currentState?.value = 0;
    key.currentState?.widget.onValueChanged?.call(0);
  }

  void updateAllSkills(List<Skill> newSkills) {
    for (int index = 0; index < _currentData.length; index++) {
      removeForm(CharacterSkillLevelFormField(index));
    }
    _currentData.clear();
    for (int index = 0; index < newSkills.length; index++) {
      Skill skill = newSkills[index];
      addIntegerForm(
        formName: CharacterSkillLevelFormField(index),
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
      _currentData.add((skill, 0));
    }
  }

  bool get _hasSkillChanges =>
      _currentData.length != initialData.length ||
      _currentData.indexed.any(
    ((int, (Skill, int)) indexData) =>
        indexData.$2.$1 != initialData[indexData.$1].$1,
  );

  bool get hasSkills => _currentData.isNotEmpty;

  @override
  bool get hasChanges => _hasSkillChanges || super.hasChanges;

  @override
  List<(Skill, int)> makeEntity(void additionalData) =>
      List<(Skill, int)>.generate(
    initialData.length,
    (int index) => (_currentData[index].$1, skillLevel(index)),
  );

  int skillLevel(int index) =>
      this[CharacterSkillLevelFormField(index)].integerValue ??
      _currentData[index].$2;

  TIntegerFormKey _skillLevelKey(int index) =>
      this[CharacterSkillLevelFormField(index)].integerKey;
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
          children: List<TGridItem>.generate(
            form.initialData.length,
            (int index) =>
                TGridItem(child: form[CharacterSkillLevelFormField(index)]),
          ),
        )
      : const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: TIconText.error('Character does not have a subclass selected'),
        );
  }
}

typedef CharacterSkillLevelFormKey = GlobalKey<
    TGroupFormState<List<(Skill, int)>, CharacterSkillLevelFormGroup>>;

class CharacterSkillLevelForm
    extends TGroupForm<List<(Skill, int)>, CharacterSkillLevelFormGroup> {
  CharacterSkillLevelForm({
    required void Function(int?) onLevelChange,
    required List<(Skill, int)> super.initialValue,
    required super.enabled,
    required super.setState,
    Map<Skill, ({bool? enabled, String? subtitle})>? dataOverrides,
    super.key,
  }) : super(
    groupBuilder: ({
      required bool enabled,
      required GroupSetState? setState,
      List<(Skill, int)>? initialData,
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
