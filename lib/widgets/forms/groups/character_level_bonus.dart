import 'package:flutter/material.dart';
import 'package:tfields/extensions.dart';
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

  static List<CharacterLevelBonusFormField> get statValues =>
      <CharacterLevelBonusFormField>[hp, atk, def, mag, mnd, spd];

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
      readonly: true,
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
        title: field.name.toUpperCase(),
        minValue: 0,
        maxValue: LevelBonus.levelBonusCap,
        onValueChanged: onLevelChange,
        commaSeparate: true,
        snapToMinOnEmpty: true,
        snapToMaxWhenOver: true,
      );
    }
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
    return Column(
      children: <Widget>[
        TIconChip.information(
          'Level bonus caps at ${LevelBonus.levelBonusCap.commaSeparate()}',
          mainAxisSize: MainAxisSize.max,
        ),
        const SizedBox(height: 20),
        TGridRow(
          smFlexLimit: 2,
          lgFlexLimit: 3,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <TGridItem>[
            ...CharacterLevelBonusFormField.statValues.map(
              (CharacterLevelBonusFormField field) =>
                  TGridItem(child: form[field]),
            ),
            TGridItem.fixedSize(
              size: const TGridSize.fill(),
              child: form[CharacterLevelBonusFormField.unused],
            ),
          ],
        ),
      ],
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
