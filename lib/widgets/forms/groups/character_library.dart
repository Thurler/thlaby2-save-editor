import 'package:flutter/material.dart';
import 'package:tfields/extensions.dart';
import 'package:tfields/widgets.dart';
import 'package:thlaby2_save_editor/save/library.dart';

enum CharacterLibraryFormField implements TFormField {
  hp(isElement: false),
  atk(isElement: false),
  def(isElement: false),
  mag(isElement: false),
  mnd(isElement: false),
  spd(isElement: false),
  fir,
  cld,
  wnd,
  ntr,
  mys,
  spi,
  drk,
  phy;

  final bool isElement;

  const CharacterLibraryFormField({this.isElement = true});
}

class CharacterLibraryFormGroup
    extends TFormGroup<LibraryData, void, CharacterLibraryFormField> {
  final LibraryData initialData;

  CharacterLibraryFormGroup({
    required this.initialData,
    required super.enabled,
    required super.setState,
  }) {
    for (CharacterLibraryFormField field in CharacterLibraryFormField.values) {
      addIntegerForm(
        formName: field,
        initialValue: initialData.getData(field.index),
        title: '${field.name.toUpperCase()} Level',
        subtitle: field.isElement
          ? 'Must be at most ${LibraryData.libraryElementCap.commaSeparate()}'
          : 'Must be at most ${LibraryData.libraryCap.commaSeparate()}',
        minValue: 0,
        maxValue: field.isElement
          ? LibraryData.libraryElementCap
          : LibraryData.libraryCap,
        commaSeparate: true,
        snapToMinOnEmpty: true,
        snapToMaxWhenOver: true,
      );
    }
  }

  @override
  LibraryData makeEntity(void additionalData) => LibraryData(
    hp: stat(CharacterLibraryFormField.hp),
    atk: stat(CharacterLibraryFormField.atk),
    def: stat(CharacterLibraryFormField.def),
    mag: stat(CharacterLibraryFormField.mag),
    mnd: stat(CharacterLibraryFormField.mnd),
    spd: stat(CharacterLibraryFormField.spd),
    fir: stat(CharacterLibraryFormField.fir),
    cld: stat(CharacterLibraryFormField.cld),
    wnd: stat(CharacterLibraryFormField.wnd),
    ntr: stat(CharacterLibraryFormField.ntr),
    mys: stat(CharacterLibraryFormField.mys),
    spi: stat(CharacterLibraryFormField.spi),
    drk: stat(CharacterLibraryFormField.drk),
    phy: stat(CharacterLibraryFormField.phy),
  );

  int stat(CharacterLibraryFormField field) =>
      this[field].integerValue ?? initialData.getData(field.index);
}

class CharacterLibraryFormWidget
    extends TFormGroupWidget<CharacterLibraryFormGroup> {
  const CharacterLibraryFormWidget({required super.form, super.key}) :
    super.noSubmit();

  @override
  Widget build(BuildContext context) {
    return TGridRow(
      xxlFlexLimit: 1,
      children: CharacterLibraryFormField.values.map(
        (CharacterLibraryFormField field) => TGridItem(child: form[field]),
      ).toList(),
    );
  }
}

typedef CharacterLibraryFormKey
    = GlobalKey<TGroupFormState<LibraryData, CharacterLibraryFormGroup>>;

class CharacterLibraryForm
    extends TGroupForm<LibraryData, CharacterLibraryFormGroup> {
  CharacterLibraryForm({
    required LibraryData super.initialValue,
    required super.enabled,
    required super.setState,
    super.key,
  }) : super(
    groupBuilder: ({
      required bool enabled,
      required GroupSetState? setState,
      LibraryData? initialData,
    }) {
      return CharacterLibraryFormGroup(
        initialData: initialValue,
        enabled: enabled,
        setState: setState,
      );
    },
    groupWidgetBuilder: (CharacterLibraryFormGroup form) =>
        CharacterLibraryFormWidget(form: form),
  );
}
