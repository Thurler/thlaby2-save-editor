import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/save/item_slot.dart';
import 'package:thlaby2_save_editor/widgets/common_scaffold.dart';
import 'package:thlaby2_save_editor/widgets/item_category.dart';

class ItemSelectWidget extends StatefulWidget {
  final List<ItemSlot> items;

  const ItemSelectWidget({required this.items, super.key});

  @override
  State<ItemSelectWidget> createState() => ItemSelectState();
}

class ItemSelectState extends State<ItemSelectWidget> {
  late final ItemCategory availableItems = ItemCategory(
    title: 'Available Items',
    items: widget.items,
    onTap: _selectItem,
    editable: false,
  );

  Future<void> _selectItem(ItemSlot item) async {
    Navigator.of(context).pop(item.item);
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Choose which item to equip',
      children: <Widget>[
        availableItems,
      ],
    );
  }
}
