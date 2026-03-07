import 'package:flutter/material.dart';
import 'package:tfields/widgets.dart';
import 'package:thlaby2_save_editor/save/enums/character.dart';
import 'package:thlaby2_save_editor/save/tome.dart';

enum CharacterTomesFormField implements TFormField {
  hp,
  mp,
  tp,
  atk,
  def,
  mag,
  mnd,
  spd,
  eva,
  acc,
  aff,
  res;
}

class CharacterTomesFormGroup
    extends TFormGroup<TomeData, void, CharacterTomesFormField> {
  final Character character;
  final TomeData initialData;
  final void Function(TomeStat) onTomeChange;

  CharacterTomesFormGroup({
    required this.character,
    required this.initialData,
    required this.onTomeChange,
    required super.enabled,
    required super.setState,
  }) {
    for (CharacterTomesFormField field in CharacterTomesFormField.values) {
      TomeStat stat = TomeStat.values[field.index];
      addDropdownForm(
        formName: field,
        initialValue: initialData.getStatData(field.index),
        title: stat.prettyName,
        hintText: 'Select a tome level',
        options: character.tomeDropdownOptions(stat),
        toDropdownText: (TomeLevel level) => level.prettyName,
        sortLogic: TDropdownSortLogic.none,
        onValueChanged: (_) => onTomeChange(stat),
      );
    }
  }

  @override
  TomeData makeEntity(void additionalData) => TomeData(
    hp: level(CharacterTomesFormField.hp),
    mp: level(CharacterTomesFormField.mp),
    tp: level(CharacterTomesFormField.tp),
    atk: level(CharacterTomesFormField.atk),
    def: level(CharacterTomesFormField.def),
    mag: level(CharacterTomesFormField.mag),
    mnd: level(CharacterTomesFormField.mnd),
    spd: level(CharacterTomesFormField.spd),
    eva: level(CharacterTomesFormField.eva),
    acc: level(CharacterTomesFormField.acc),
    aff: level(CharacterTomesFormField.aff),
    res: level(CharacterTomesFormField.res),
  );

  TomeLevel level(CharacterTomesFormField field) =>
      this[field].dropdownValue() ?? initialData.getStatData(field.index);
}

class CharacterTomesFormWidget
    extends TFormGroupWidget<CharacterTomesFormGroup> {
  const CharacterTomesFormWidget({required super.form, super.key}) :
    super.noSubmit();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: <Widget>[
        const TIconChip.information(
          'Changing tome levels will affect common skills data!',
          mainAxisSize: MainAxisSize.max,
        ),
        TGridRow.withExpandedSizes(
          mdFlexLimit: 2,
          lgFlexLimit: 3,
          xxlFlexLimit: 4,
          uhdFlexLimit: 6,
          children: CharacterTomesFormField.values.map(
            (CharacterTomesFormField field) => TGridItem(child: form[field]),
          ).toList(),
        ),
      ],
    );
  }
}

typedef CharacterTomesFormKey
    = GlobalKey<TGroupFormState<TomeData, CharacterTomesFormGroup>>;

class CharacterTomesForm extends TGroupForm<TomeData, CharacterTomesFormGroup> {
  CharacterTomesForm({
    required Character character,
    required void Function(TomeStat) onTomeChange,
    required TomeData super.initialValue,
    required super.enabled,
    required super.setState,
    super.key,
  }) : super(
    groupBuilder: ({
      required bool enabled,
      required GroupSetState? setState,
      TomeData? initialData,
    }) {
      return CharacterTomesFormGroup(
        initialData: initialValue,
        character: character,
        onTomeChange: onTomeChange,
        enabled: enabled,
        setState: setState,
      );
    },
    groupWidgetBuilder: (CharacterTomesFormGroup form) =>
        CharacterTomesFormWidget(form: form),
  );
}
