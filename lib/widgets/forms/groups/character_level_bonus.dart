import 'package:flutter/material.dart';
import 'package:tfields/widgets.dart';
import 'package:thlaby2_save_editor/save/levelbonus.dart';

enum CharacterLevelBonusFormField implements TFormField {
  hp,
  atk,
  def,
  mag,
  mnd,
  spd,
  unused(isStat: false);

  final bool isStat;

  const CharacterLevelBonusFormField({this.isStat = true});

  factory CharacterLevelBonusFormField.fromIndex(int index) =>
      CharacterLevelBonusFormField.values[index];
}

class CharacterLevelBonusFormGroup
    extends TFormGroup<(int, LevelBonus), void, CharacterLevelBonusFormField> {
  final LevelBonus initialBonus;
  final int initialUnused;
  final void Function(int?) onLevelChange;

  CharacterLevelBonusFormGroup({
    required this.initialUnused,
    required this.initialBonus,
    required this.onLevelChange,
    required super.enabled,
    required super.setState,
  }) {
    addIntegerForm(
      enabledOverride: false,
      formName: CharacterLevelBonusFormField.unused,
      initialValue: initialUnused,
      title: 'Unused points',
      subtitle: 'Updated automatically with level and used points',
      minValue: -LevelBonus.levelBonusCap,
      maxValue: LevelBonus.levelBonusCap,
      commaSeparate: true,
    );
    Iterable<CharacterLevelBonusFormField> stats =
        CharacterLevelBonusFormField.values.where(
      (CharacterLevelBonusFormField field) => field.isStat,
    );
    for (CharacterLevelBonusFormField field in stats) {
      addIntegerForm(
        formName: field,
        initialValue: initialBonus.getStatData(field.index),
        title: 'Points in ${field.name.toUpperCase()}',
        minValue: 0,
        maxValue: LevelBonus.levelBonusCap,
        onValueChanged: onLevelChange,
        commaSeparate: true,
        snapToMinOnEmpty: true,
        snapToMaxWhenOver: true,
      );
    }
  }

  @override
  set enabled(bool newValue) {
    super.enabled = newValue;
    this[CharacterLevelBonusFormField.unused].genericKey.currentState?.enabled =
        false;
  }

  void updateCapForStat({required int index, required int cap}) {
    TIntegerFormKey key = _statKey(
      CharacterLevelBonusFormField.fromIndex(index),
    );
    key.currentState?.maxValue = cap;
    onGroupValueChanged();
  }

  @override
  (int, LevelBonus) makeEntity(void additionalData) => (
    unused,
    LevelBonus(
      hp: stat(CharacterLevelBonusFormField.hp),
      atk: stat(CharacterLevelBonusFormField.atk),
      def: stat(CharacterLevelBonusFormField.def),
      mag: stat(CharacterLevelBonusFormField.mag),
      mnd: stat(CharacterLevelBonusFormField.mnd),
      spd: stat(CharacterLevelBonusFormField.spd),
    ),
  );

  int get unused =>
      this[CharacterLevelBonusFormField.unused].integerValue ?? initialUnused;

  set unused(int value) {
    _unusedKey.currentState?.value = value;
    onGroupValueChanged();
  }

  int stat(CharacterLevelBonusFormField field) =>
      this[field].integerValue ?? initialBonus.getStatData(field.index);

  TIntegerFormKey get _unusedKey =>
      this[CharacterLevelBonusFormField.unused].integerKey;

  TIntegerFormKey _statKey(CharacterLevelBonusFormField field) =>
      this[field].integerKey;
}

class CharacterLevelBonusFormWidget
    extends TFormGroupWidget<CharacterLevelBonusFormGroup> {
  const CharacterLevelBonusFormWidget({required super.form, super.key}) :
    super.noSubmit();

  @override
  Widget build(BuildContext context) {
    return TGridRow(
      xxlFlexLimit: 1,
      children: CharacterLevelBonusFormField.values.map(
        (CharacterLevelBonusFormField field) => TGridItem(child: form[field]),
      ).toList(),
    );
  }
}

typedef CharacterLevelBonusFormKey = GlobalKey<
    TGroupFormState<(int, LevelBonus), CharacterLevelBonusFormGroup>>;

class CharacterLevelBonusForm
    extends TGroupForm<(int, LevelBonus), CharacterLevelBonusFormGroup> {
  CharacterLevelBonusForm({
    required void Function(int?) onLevelChange,
    required (int, LevelBonus) super.initialValue,
    required super.enabled,
    required super.setState,
    super.key,
  }) : super(
    groupBuilder: ({
      required bool enabled,
      required GroupSetState? setState,
      (int, LevelBonus)? initialData,
    }) {
      return CharacterLevelBonusFormGroup(
        initialUnused: initialValue.$1,
        initialBonus: initialValue.$2,
        enabled: enabled,
        setState: setState,
        onLevelChange: onLevelChange,
      );
    },
    groupWidgetBuilder: (CharacterLevelBonusFormGroup form) =>
        CharacterLevelBonusFormWidget(form: form),
  );
}
