import 'package:flutter/material.dart';
import 'package:tfields/widgets.dart';
import 'package:thlaby2_save_editor/save/gem.dart';

enum CharacterGemsFormField implements TFormField {
  hp,
  mp,
  tp,
  atk,
  def,
  mag,
  mnd,
  spd;
}

class CharacterGemsFormGroup
    extends TFormGroup<GemData, void, CharacterGemsFormField> {
  final GemData initialData;

  CharacterGemsFormGroup({
    required this.initialData,
    required super.enabled,
    required super.setState,
  }) {
    for (CharacterGemsFormField field in CharacterGemsFormField.values) {
      addIntegerForm(
        formName: field,
        initialValue: initialData.getStatData(field.index),
        title: 'Gems used in ${field.name.toUpperCase()}',
        minValue: 0,
        maxValue: GemData.gemCap,
        snapToMinOnEmpty: true,
        snapToMaxWhenOver: true,
      );
    }
  }

  @override
  GemData makeEntity(void additionalData) => GemData(
    hp: level(CharacterGemsFormField.hp),
    mp: level(CharacterGemsFormField.mp),
    tp: level(CharacterGemsFormField.tp),
    atk: level(CharacterGemsFormField.atk),
    def: level(CharacterGemsFormField.def),
    mag: level(CharacterGemsFormField.mag),
    mnd: level(CharacterGemsFormField.mnd),
    spd: level(CharacterGemsFormField.spd),
  );

  int level(CharacterGemsFormField field) =>
      this[field].dropdownValue() ?? initialData.getStatData(field.index);
}

class CharacterGemsFormWidget extends TFormGroupWidget<CharacterGemsFormGroup> {
  const CharacterGemsFormWidget({required super.form, super.key}) :
    super.noSubmit();

  @override
  Widget build(BuildContext context) {
    return TGridRow(
      xxlFlexLimit: 1,
      children: CharacterGemsFormField.values.map(
        (CharacterGemsFormField field) => TGridItem(child: form[field]),
      ).toList(),
    );
  }
}

typedef CharacterGemsFormKey
    = GlobalKey<TGroupFormState<GemData, CharacterGemsFormGroup>>;

class CharacterGemsForm extends TGroupForm<GemData, CharacterGemsFormGroup> {
  CharacterGemsForm({
    required GemData super.initialValue,
    required super.enabled,
    required super.setState,
    super.key,
  }) : super(
    groupBuilder: ({
      required bool enabled,
      required GroupSetState? setState,
      GemData? initialData,
    }) {
      return CharacterGemsFormGroup(
        initialData: initialValue,
        enabled: enabled,
        setState: setState,
      );
    },
    groupWidgetBuilder: (CharacterGemsFormGroup form) =>
        CharacterGemsFormWidget(form: form),
  );
}
