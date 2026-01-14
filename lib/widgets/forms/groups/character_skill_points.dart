import 'package:flutter/material.dart';
import 'package:tfields/extensions.dart';
import 'package:tfields/widgets.dart';
import 'package:thlaby2_save_editor/save/character.dart';

enum CharacterSkillPointsFormField implements TFormField {
  unused,
  trainingManual;
}

class CharacterSkillPointsFormGroup
    extends TFormGroup<(int, int), void, CharacterSkillPointsFormField> {
  final int initialUnused;
  final int initialManuals;
  final void Function(int?) onManualsChange;

  CharacterSkillPointsFormGroup({
    required this.initialUnused,
    required this.initialManuals,
    required this.onManualsChange,
    required super.enabled,
    required super.setState,
  }) {
    addIntegerForm(
      enabledOverride: false,
      formName: CharacterSkillPointsFormField.unused,
      initialValue: initialUnused,
      title: 'Unused skill points',
      subtitle: 'Updated automatically with skill levels and manuals',
      minValue: 3 - CharacterData.skillPointBonusCap,
      maxValue:
          CharacterData.skillPointBonusCap + CharacterData.trainingManualsCap,
      commaSeparate: true,
    );

    addIntegerForm(
      formName: CharacterSkillPointsFormField.trainingManual,
      initialValue: initialManuals,
      title: 'Training manuals used',
      subtitle:
          'Must be at most ${CharacterData.trainingManualsCap.commaSeparate()}',
      maxValue: CharacterData.trainingManualsCap,
      onValueChanged: onManualsChange,
      commaSeparate: true,
    );
  }

  @override
  set enabled(bool newValue) {
    super.enabled = newValue;
    CharacterSkillPointsFormField forceFalse =
        CharacterSkillPointsFormField.unused;
    this[forceFalse].genericKey.currentState?.enabled = false;
  }

  @override
  (int, int) makeEntity(void additionalData) => (unused, trainingManual);

  int get unused =>
      this[CharacterSkillPointsFormField.unused].integerValue ?? initialUnused;

  set unused(int value) {
    _unusedKey.currentState?.value = value;
    onGroupValueChanged();
  }

  int get trainingManual =>
      this[CharacterSkillPointsFormField.trainingManual].integerValue ??
      initialManuals;

  TIntegerFormKey get _unusedKey =>
      this[CharacterSkillPointsFormField.unused].integerKey;
}

class CharacterSkillPointsFormWidget
    extends TFormGroupWidget<CharacterSkillPointsFormGroup> {
  const CharacterSkillPointsFormWidget({required super.form, super.key}) :
    super.noSubmit();

  @override
  Widget build(BuildContext context) {
    return TGridRow(
      xxlFlexLimit: 1,
      children: CharacterSkillPointsFormField.values.map(
        (CharacterSkillPointsFormField field) => TGridItem(child: form[field]),
      ).toList(),
    );
  }
}

typedef CharacterSkillPointsFormKey
    = GlobalKey<TGroupFormState<(int, int), CharacterSkillPointsFormGroup>>;

class CharacterSkillPointsForm
    extends TGroupForm<(int, int), CharacterSkillPointsFormGroup> {
  CharacterSkillPointsForm({
    required void Function(int?) onManualsChange,
    required (int, int) super.initialValue,
    required super.enabled,
    required super.setState,
    super.key,
  }) : super(
    groupBuilder: ({
      required bool enabled,
      required GroupSetState? setState,
      (int, int)? initialData,
    }) {
      return CharacterSkillPointsFormGroup(
        initialUnused: initialValue.$1,
        initialManuals: initialValue.$2,
        enabled: enabled,
        setState: setState,
        onManualsChange: onManualsChange,
      );
    },
    groupWidgetBuilder: (CharacterSkillPointsFormGroup form) =>
        CharacterSkillPointsFormWidget(form: form),
  );
}
