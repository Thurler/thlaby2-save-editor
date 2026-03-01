import 'package:flutter/material.dart' hide Material;
import 'package:tfields/widgets.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/save/enums/item.dart';
import 'package:thlaby2_save_editor/save/item_slot.dart';
import 'package:thlaby2_save_editor/widgets/item_select.dart';

class ItemSelectWidget<I extends Item> extends StatefulWidget {
  const ItemSelectWidget({super.key});

  @override
  ItemSelectState<I> createState() => ItemSelectState<I>();
}

class ItemSelectState<I extends Item> extends State<ItemSelectWidget<I>>
    with SaveEditor {
  final TCheckboxFormKey _lockedItemCheckboxKey = TCheckboxFormKey();
  final ItemSelectKey<I> _itemSelectKey = ItemSelectKey<I>();

  late final TFormCheckbox _lockedItemCheckbox;
  late final ItemSelect<I> _itemSelect;

  bool get _allowLocked => _lockedItemCheckboxKey.currentState?.value ?? false;

  List<ItemSlot<I>> get _itemSlots => switch (this) {
    ItemSelectState<MainEquip>() => saveFile.mainInventoryData,
    ItemSelectState<SubEquip>() => saveFile.subInventoryData,
    ItemSelectState<Material>() => saveFile.materialInventoryData,
    ItemSelectState<SpecialItem>() => saveFile.specialInventoryData,
    // Unfortunately need this since compiler can't see the sealed class here?
    ItemSelectState<Item>() => throw UnimplementedError(),
    // Also need this cast since we need to re-generic-ify the return type
  } as List<ItemSlot<I>>;

  Future<void> _selectItem(ItemSlot<I> item) async {
    // If item is locked and we are not allowing selecting locked items, nop
    if (!item.isUnlocked && !_allowLocked) {
      return;
    }
    Navigator.of(context).pop(item.item);
  }

  void _changeLockedItemToggle(bool? value) {
    setState(() {
      _itemSelectKey.currentState?.allowLockedSelection = value ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    _lockedItemCheckbox = TFormCheckbox(
      enabled: true,
      text: 'Allow locked items to be selected',
      title: 'Locked item selection',
      subtitle: 'Selecting a locked item will automatically unlock it when '
          'saving character data',
      initialValue: false,
      onValueChanged: _changeLockedItemToggle,
      key: _lockedItemCheckboxKey,
    );
    _itemSelect = ItemSelect<I>(
      items: _itemSlots,
      allowLockedSelection: false,
      onItemSelect: _selectItem,
      key: _itemSelectKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TCommonScaffold(
      title: 'Choose which item to equip',
      children: <Widget>[_lockedItemCheckbox, _itemSelect],
    );
  }
}
