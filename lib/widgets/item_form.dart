import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/save/item_slot.dart';
import 'package:thlaby2_save_editor/widgets/clickable.dart';
import 'package:thlaby2_save_editor/widgets/form.dart';

typedef ItemFormKey = GlobalKey<TFormItemState>;

class TFormItem extends TFormNumber {
  final ItemSlot itemSlot;

  TFormItem({
    required this.itemSlot,
    super.onValueChanged,
    super.key,
  }) : super(
    enabled: true,
    title: itemSlot.item.name,
    subtitle: 'Must be at most 200',
    minValue: BigInt.from(0),
    maxValue: BigInt.from(itemSlot.isUnlocked ? 200 : 0),
    initialValue: itemSlot.amount.toString(),
  );

  @override
  State<TFormNumber> createState() => TFormItemState();
}

class TFormItemState extends TFormNumberState<TFormItem> {
  void _toggleItemLock() {
    widget.itemSlot.isUnlocked = !widget.itemSlot.isUnlocked;
    if (widget.itemSlot.isUnlocked) {
      maxValue = BigInt.from(200);
    } else {
      maxValue = BigInt.from(0);
      value = '0';
    }
    widget.onValueChanged?.call(value);
  }

  @override
  TFormField get field {
    return TFormStringField(
      enabled: widget.enabled,
      hintText: widget.hintText,
      controller: controller,
      formatters: formatters,
      icons: <Widget>[
        TClickable(
          onTap: _toggleItemLock,
          child: Icon(
            widget.itemSlot.isUnlocked ? Icons.lock_open : Icons.lock,
            color: widget.itemSlot.isUnlocked
              ? Colors.green.shade300
              : Colors.red.shade300,
          ),
        ),
      ],
    );
  }
}
