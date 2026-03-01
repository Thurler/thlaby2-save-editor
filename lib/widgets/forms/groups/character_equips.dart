import 'package:flutter/material.dart';
import 'package:tfields/widgets.dart';
import 'package:thlaby2_save_editor/save/enums/item.dart';
import 'package:thlaby2_save_editor/widgets/forms/equipment.dart';

enum CharacterEquipFormField implements TFormField {
  main,
  sub1,
  sub2,
  sub3;
}

typedef EquipTuple = (MainEquip, List<SubEquip>);

class CharacterEquipFormGroup
    extends TFormGroup<EquipTuple, void, CharacterEquipFormField> {
  final EquipTuple initialData;

  final List<MainEquip> availableMainEquips;

  final List<SubEquip> availableSubEquips;

  final void Function(MainEquip) unlockMainEquip;

  final void Function(SubEquip) unlockSubEquip;

  final EquipmentFormKey<MainEquip> mainKey = EquipmentFormKey<MainEquip>();

  final List<EquipmentFormKey<SubEquip>> subKeys = <EquipmentFormKey<SubEquip>>[
    EquipmentFormKey<SubEquip>(),
    EquipmentFormKey<SubEquip>(),
    EquipmentFormKey<SubEquip>(),
  ];

  CharacterEquipFormGroup({
    required this.initialData,
    required this.unlockMainEquip,
    required this.unlockSubEquip,
    required super.enabled,
    required super.setState,
    this.availableMainEquips = const <MainEquip>[],
    this.availableSubEquips = const <SubEquip>[],
  }) {
    addGenericForm(
      formName: CharacterEquipFormField.main,
      key: mainKey,
      form: EquipmentForm<MainEquip>(
        key: mainKey,
        enabled: enabled,
        title: 'Main equipment',
        initialValue: initialData.$1,
        validationCallback: _checkForLockedMainEquip,
        onValueChanged: (_) => onGroupValueChanged(),
        emptyItem: MainEquip.slot0,
        saveWithErrorOptions: TFormSaveWithErrorOptions<MainEquip>(
          onSaveWithError: (MainEquip? equip) =>
              equip != null ? unlockMainEquip(equip) : null,
          warningMessageBuilder: (_, String message) =>
              '$message - it will be unlocked automatically',
        ),
      ),
    );
    for (int i = 0; i < initialData.$2.length; i++) {
      addGenericForm(
        formName: CharacterEquipFormField.values[i + 1],
        key: subKeys[i],
        form: EquipmentForm<SubEquip>(
          key: subKeys[i],
          enabled: enabled,
          title: 'Sub equipment ${i + 1}',
          initialValue: initialData.$2[i],
          validationCallback: _checkForLockedSubEquip,
          onValueChanged: (_) => onGroupValueChanged(),
          emptyItem: SubEquip.slot0,
          saveWithErrorOptions: TFormSaveWithErrorOptions<SubEquip>(
            onSaveWithError: (SubEquip? equip) =>
                equip != null ? unlockSubEquip(equip) : null,
            warningMessageBuilder: (_, String message) =>
                '$message - it will be unlocked automatically',
          ),
        ),
      );
    }
  }

  String _checkForLockedMainEquip(MainEquip? equip) => equip != null &&
      equip != MainEquip.slot0 &&
      !availableMainEquips.contains(equip)
    ? 'This main equip has not been unlocked'
    : '';

  String _checkForLockedSubEquip(SubEquip? equip) => equip != null &&
      equip != SubEquip.slot0 &&
      !availableSubEquips.contains(equip)
    ? 'This sub equip has not been unlocked'
    : '';

  @override
  void saveValues() {
    super.saveValues();
    // Add the saved equips to the available list, according to the save with
    // error callbacks
    if (!availableMainEquips.contains(main)) {
      availableMainEquips.add(main);
    }
    if (!availableSubEquips.contains(sub1)) {
      availableSubEquips.add(sub1);
    }
    if (!availableSubEquips.contains(sub2)) {
      availableSubEquips.add(sub2);
    }
    if (!availableSubEquips.contains(sub3)) {
      availableSubEquips.add(sub3);
    }
    // Make sure to revalidate afterwards to get rid of the errors
    validate();
  }

  @override
  EquipTuple makeEntity(void additionalData) =>
      (main, <SubEquip>[sub1, sub2, sub3]);

  MainEquip get main => mainKey.currentState?.value ?? initialData.$1;

  SubEquip get sub1 => subKeys[0].currentState?.value ?? initialData.$2[0];

  SubEquip get sub2 => subKeys[1].currentState?.value ?? initialData.$2[1];

  SubEquip get sub3 => subKeys[2].currentState?.value ?? initialData.$2[2];
}

class CharacterEquipFormWidget
    extends TFormGroupWidget<CharacterEquipFormGroup> {
  const CharacterEquipFormWidget({required super.form, super.key}) :
    super.noSubmit();

  @override
  Widget build(BuildContext context) {
    return TGridRow(
      xxlFlexLimit: 1,
      children: CharacterEquipFormField.values.map(
        (CharacterEquipFormField field) => TGridItem(child: form[field]),
      ).toList(),
    );
  }
}

typedef CharacterEquipFormKey
    = GlobalKey<TGroupFormState<EquipTuple, CharacterEquipFormGroup>>;

class CharacterEquipForm
    extends TGroupForm<EquipTuple, CharacterEquipFormGroup> {
  CharacterEquipForm({
    required void Function(MainEquip) unlockMainEquip,
    required void Function(SubEquip) unlockSubEquip,
    required EquipTuple super.initialValue,
    required super.enabled,
    required super.setState,
    List<MainEquip> availableMainEquips = const <MainEquip>[],
    List<SubEquip> availableSubEquips = const <SubEquip>[],
    super.key,
  }) : super(
    groupBuilder: ({
      required bool enabled,
      required GroupSetState? setState,
      EquipTuple? initialData,
    }) {
      return CharacterEquipFormGroup(
        initialData: initialValue,
        availableMainEquips: availableMainEquips,
        availableSubEquips: availableSubEquips,
        unlockMainEquip: unlockMainEquip,
        unlockSubEquip: unlockSubEquip,
        enabled: enabled,
        setState: setState,
      );
    },
    groupWidgetBuilder: (CharacterEquipFormGroup form) =>
        CharacterEquipFormWidget(form: form),
  );
}
