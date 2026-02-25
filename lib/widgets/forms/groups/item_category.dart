import 'package:flutter/material.dart';
import 'package:tfields/forms.dart';
import 'package:thlaby2_save_editor/mixins/item_page.dart';
import 'package:thlaby2_save_editor/save/enums/item.dart';
import 'package:thlaby2_save_editor/save/item_slot.dart';
import 'package:thlaby2_save_editor/widgets/forms/item_slot.dart';

class ItemCategoryFormField implements TFormField {
  final int index;

  const ItemCategoryFormField(this.index);

  @override
  bool operator ==(Object other) =>
      other is ItemCategoryFormField && index == other.index;

  @override
  int get hashCode => index;
}

class ItemCategoryForm<I extends Item>
    extends TFormGroup<List<ItemSlot<I>>, void, ItemCategoryFormField> {
  final String title;

  final List<ItemSlot<I>> initialData;

  ItemCategoryForm({
    required this.title,
    required this.initialData,
    required super.enabled,
    required super.setState,
  }) {
    for (int index = 0; index < initialData.length; index++) {
      ItemSlotFormKey<I> key = ItemSlotFormKey<I>();
      addGenericForm(
        formName: ItemCategoryFormField(index),
        key: key,
        form: ItemSlotForm<I>(
          initialValue: initialData[index],
          hoverUpdateCallback: onGroupValueChanged,
          onValueChanged: (_) => onGroupValueChanged(),
          enabled: enabled,
          key: key,
        ),
      );
    }
  }

  ItemSlotFormKey<I> _getKeyForIndex(int index) =>
      this[ItemCategoryFormField(index)].genericKey as ItemSlotFormKey<I>;

  @override
  List<ItemSlot<I>> makeEntity(void additionalData) {
    return List<ItemSlot<I>>.generate(
      initialData.length,
      (int index) =>
          _getKeyForIndex(index).currentState?.value ?? initialData[index],
    );
  }
}

class _ItemCategoryFormWidget<I extends Item> extends StatefulWidget
    with ItemPageBrowser<I> {
  final ItemCategoryForm<I> formGroup;

  _ItemCategoryFormWidget(this.formGroup);

  @override
  List<ItemSlot<I>> get items => formGroup.initialData;

  @override
  _ItemCategoryFormWidgetState<I> createState() =>
      _ItemCategoryFormWidgetState<I>();
}

class _ItemCategoryFormWidgetState<I extends Item>
    extends State<_ItemCategoryFormWidget<I>>
    with ItemPageBrowserState<I, _ItemCategoryFormWidget<I>> {
  @override
  Widget buildItem(int itemIndex, BuildContext context) =>
      widget.formGroup[ItemCategoryFormField(itemIndex)];
}

class ItemCategoryFormWidget<I extends Item>
    extends TFormGroupWidget<ItemCategoryForm<I>> {
  final _ItemCategoryFormWidget<I> _widget;

  ItemCategoryFormWidget({
    required super.form,
    super.key,
  }) : _widget = _ItemCategoryFormWidget<I>(form), super.noSubmit();

  @override
  Widget build(BuildContext context) => _widget;
}
