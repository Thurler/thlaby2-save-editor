import 'package:flutter/material.dart';
import 'package:tfields/forms.dart';
import 'package:tfields/widgets.dart';
import 'package:thlaby2_save_editor/save/enums/item.dart';
import 'package:thlaby2_save_editor/save/item_slot.dart';
import 'package:thlaby2_save_editor/widgets/item_lock.dart';

typedef ItemSlotFormKey<I extends Item> = GlobalKey<ItemSlotFormState<I>>;

class ItemSlotForm<I extends Item> extends TForm<ItemSlot<I>> {
  final void Function() hoverUpdateCallback;

  const ItemSlotForm({
    required ItemSlot<I> super.initialValue,
    required this.hoverUpdateCallback,
    super.onValueChanged,
    super.validationCallback,
    super.saveWithErrorOptions,
    super.enabled = true,
    super.readonly,
    super.key,
  }) : super(title: '');

  @override
  ItemSlotFormState<I> createState() => ItemSlotFormState<I>();
}

class ItemSlotFormState<I extends Item>
    extends TFormState<ItemSlot<I>, ItemSlotForm<I>> {
  final TIntegerFormKey _amountFormKey = TIntegerFormKey();

  late final TFormInteger _amountForm;

  void _updateAmount(int? newAmount) {
    if (value == null || newAmount == null) {
      return;
    }
    value!.amount = newAmount;
    widget.onValueChanged?.call(value);
    // This is done just to trigger super's value change
    value = value;
  }

  void _updateLock() {
    value!.isUnlocked = !_isUnlocked;
    widget.onValueChanged?.call(value);
    // Propagate change to the amount form
    _amountFormKey.currentState?.readonly = readonly && _isUnlocked;
    _amountFormKey.currentState?.maxValue = _isUnlocked ? 200 : 0;
    // If we just locked the form, reset the amount to zero
    if (!_isUnlocked) {
      _amountFormKey.currentState?.value = 0;
    }
    // This is done just to trigger super's value change
    value = value;
  }

  bool get _isUnlocked => value?.isUnlocked ?? false;

  Widget get _suffixIcon => ItemSlotIconButton(
    isUnlocked: _isUnlocked,
    onPressed: _updateLock,
  );

  @override
  void initState() {
    super.initState();
    _amountForm = TFormInteger(
      enabled: enabled,
      readonly: readonly && _isUnlocked,
      title: value?.item.prettyName ?? '',
      subtitle: 'Amount must not exceed 200',
      initialValue: value?.amount ?? 0,
      minValue: 0,
      maxValue: _isUnlocked ? 200 : 0,
      snapToMinOnEmpty: true,
      snapToMaxWhenOver: true,
      onValueChanged: _updateAmount,
      suffixIcon: _suffixIcon,
      key: _amountFormKey,
    );
  }

  @override
  ItemSlot<I>? copyValue(ItemSlot<I>? source) =>
      source != null ? ItemSlot<I>.from(source) : null;

  @override
  set enabled(bool newValue) {
    _amountFormKey.currentState?.enabled = newValue;
    super.enabled = newValue;
  }

  @override
  set readonly(bool newValue) {
    _amountFormKey.currentState?.readonly = newValue && _isUnlocked;
    super.readonly = newValue;
  }

  @override
  Widget build(BuildContext context) => _amountForm;
}
