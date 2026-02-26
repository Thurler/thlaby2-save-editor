import 'package:flutter/material.dart';
import 'package:tfields/extensions.dart';
import 'package:tfields/widgets.dart';
import 'package:thlaby2_save_editor/save/character.dart';
import 'package:thlaby2_save_editor/save/enums/character.dart';
import 'package:thlaby2_save_editor/save/enums/subclass.dart';

class CharacterBasic {
  static const int levelCap = 9999999; // Save load sets it to this if higher
  static const String expCap = '999999999999999999'; // Can go higher, but why
  static const int bpCap = 2147483647; // Goes negative past this

  final int level;
  final BigInt exp;
  final int battlePoints;
  final Subclass subclass;

  const CharacterBasic({
    required this.level,
    required this.exp,
    required this.battlePoints,
    required this.subclass,
  });

  CharacterBasic.fromCharacterData(CharacterData data) :
    this(
      level: data.level,
      exp: data.experience,
      battlePoints: data.bp,
      subclass: data.subclass,
    );
}

enum CharacterBasicFormField implements TFormField {
  level,
  exp,
  battlePoints,
  subclass;
}

class CharacterBasicFormGroup
    extends TFormGroup<CharacterBasic, void, CharacterBasicFormField> {
  final int initialLevel;
  final BigInt initialExp;
  final int initialBattlePoints;
  final Subclass initialSubclass;
  final Map<Character, Subclass> usedUniqueSubclasses;
  final void Function(int?) onLevelChange;
  final void Function(Subclass?) onSubclassChange;

  CharacterBasicFormGroup({
    required CharacterBasic initialData,
    required this.onLevelChange,
    required this.onSubclassChange,
    required super.enabled,
    required super.setState,
    this.usedUniqueSubclasses = const <Character, Subclass>{},
  }) :
    initialLevel = initialData.level,
    initialExp = initialData.exp,
    initialBattlePoints = initialData.battlePoints,
    initialSubclass = initialData.subclass {
    addIntegerForm(
      formName: CharacterBasicFormField.level,
      initialValue: initialLevel,
      title: 'Level',
      subtitle:
          'Must be between 1 and ${CharacterBasic.levelCap.commaSeparate()}',
      minValue: 1,
      maxValue: CharacterBasic.levelCap,
      onValueChanged: onLevelChange,
      validationCallback: (int? value) =>
          value == null ? 'Level cannot be empty!' : '',
      commaSeparate: true,
      snapToMaxWhenOver: true,
    );

    addBigIntegerForm(
      formName: CharacterBasicFormField.exp,
      initialValue: initialExp,
      title: 'Experience',
      subtitle: 'Must be below 1 quintillion',
      minValue: BigInt.zero,
      maxValue: BigInt.parse(CharacterBasic.expCap),
      commaSeparate: true,
      snapToMinOnEmpty: true,
      snapToMaxWhenOver: true,
    );

    addIntegerForm(
      formName: CharacterBasicFormField.battlePoints,
      initialValue: initialBattlePoints,
      title: 'Battle Points',
      subtitle: 'Must be at most ${CharacterBasic.bpCap.commaSeparate()}',
      minValue: 0,
      maxValue: CharacterBasic.bpCap,
      commaSeparate: true,
      snapToMinOnEmpty: true,
      snapToMaxWhenOver: true,
    );

    addDropdownForm(
      formName: CharacterBasicFormField.subclass,
      initialValue: initialSubclass,
      title: 'Subclass',
      subtitle: 'Changing this will affect skills data!',
      hintText: 'Select a subclass',
      options: Subclass.values,
      toDropdownText: (Subclass subclass) => subclass.prettyName,
      sortLogic: TDropdownSortLogic.none,
      validationCallback: _checkForDuplicateUniqueSubclasses,
      onValueChanged: onSubclassChange,
      saveWithErrorOptions: TFormSaveWithErrorOptions<Subclass>(
        warningMessageBuilder: (_, String message) =>
            '$message - no action will be taken',
      ),
    );
  }

  String _checkForDuplicateUniqueSubclasses(Subclass? subclass) {
    // If the chosen subclass is not a unique one, aceept the value
    if (subclass == null || !subclass.isUnique) {
      return '';
    }
    // Otherwise, no other character must have his subclass
    Character? overlap = usedUniqueSubclasses.entries.firstWhereOrNull(
      (MapEntry<Character, Subclass> entry) => entry.value == subclass,
    )?.key;
    // Properly inform which character has the overlapping subclass
    return overlap != null
      ? '${overlap.name.upperCaseFirstChar()} already has this subclass'
      : '';
  }

  @override
  CharacterBasic makeEntity(void additionalData) => CharacterBasic(
    level: level,
    exp: exp,
    battlePoints: battlePoints,
    subclass: subclass,
  );

  int get level =>
      this[CharacterBasicFormField.level].integerValue ?? initialLevel;

  BigInt get exp =>
      this[CharacterBasicFormField.exp].bigIntegerValue ?? initialExp;

  int get battlePoints =>
      this[CharacterBasicFormField.battlePoints].integerValue ??
      initialBattlePoints;

  Subclass get subclass =>
      this[CharacterBasicFormField.subclass].dropdownValue() ?? initialSubclass;

  TGenericFormKey get _subclassKey =>
      this[CharacterBasicFormField.subclass].genericKey;

  String get subclassError => _subclassKey.currentState?.errorMessage ?? '';
}

class CharacterBasicFormWidget
    extends TFormGroupWidget<CharacterBasicFormGroup> {
  const CharacterBasicFormWidget({required super.form, super.key}) :
    super.noSubmit();

  @override
  Widget build(BuildContext context) {
    return TGridRow(
      xxlFlexLimit: 1,
      children: CharacterBasicFormField.values.map(
        (CharacterBasicFormField field) => TGridItem(child: form[field]),
      ).toList(),
    );
  }
}

typedef CharacterBasicFormKey
    = GlobalKey<TGroupFormState<CharacterBasic, CharacterBasicFormGroup>>;

class CharacterBasicForm
    extends TGroupForm<CharacterBasic, CharacterBasicFormGroup> {
  CharacterBasicForm({
    required void Function(int?) onLevelChange,
    required void Function(Subclass?) onSubclassChange,
    required CharacterBasic super.initialValue,
    required super.enabled,
    required super.setState,
    Map<Character, Subclass> usedUniqueSubclasses =
        const <Character, Subclass>{},
    super.key,
  }) : super(
    groupBuilder: ({
      required bool enabled,
      required GroupSetState? setState,
      CharacterBasic? initialData,
    }) {
      return CharacterBasicFormGroup(
        initialData: initialValue,
        enabled: enabled,
        setState: setState,
        usedUniqueSubclasses: usedUniqueSubclasses,
        onLevelChange: onLevelChange,
        onSubclassChange: onSubclassChange,
      );
    },
    groupWidgetBuilder: (CharacterBasicFormGroup form) =>
        CharacterBasicFormWidget(form: form),
  );
}
