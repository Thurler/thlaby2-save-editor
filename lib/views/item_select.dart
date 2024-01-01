import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/save/item_slot.dart';
import 'package:thlaby2_save_editor/widgets/common_scaffold.dart';
import 'package:thlaby2_save_editor/widgets/item_category.dart';
import 'package:thlaby2_save_editor/widgets/switch.dart';

class ItemSelectWidget extends StatefulWidget {
  final List<ItemSlot> items;

  const ItemSelectWidget({required this.items, super.key});

  @override
  State<ItemSelectWidget> createState() => ItemSelectState();
}

class ItemSelectState extends State<ItemSelectWidget> {
  bool lockedItemToggle = false;

  final ItemCategoryKey itemCategoryKey = ItemCategoryKey();

  late final ItemCategory availableItems = ItemCategory(
    title: 'Available Items',
    items: widget.items,
    onTap: _selectItem,
    editable: false,
    key: itemCategoryKey,
  );

  Future<void> _selectItem(ItemSlot item) async {
    // If item is locked and we are not allowing selecting locked items, nop
    if (!item.isUnlocked && !lockedItemToggle) {
      return;
    }
    Navigator.of(context).pop(item.item);
  }

  void _changeLockedItemToggle(bool value) {
    setState(() {
      lockedItemToggle = value;
      itemCategoryKey.currentState!.changeLockedItemToggle(value: value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Choose which item to equip',
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TSwitch(
              value: lockedItemToggle,
              onChanged: _changeLockedItemToggle,
            ),
            const Text(
              'Allow selecting a locked item - will automatically unlock it',
            ),
          ],
        ),
        availableItems,
      ],
    );
  }
}
