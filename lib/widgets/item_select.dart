import 'package:flutter/material.dart';
import 'package:tfields/widgets.dart';
import 'package:thlaby2_save_editor/mixins/item_page.dart';
import 'package:thlaby2_save_editor/save/enums/item.dart';
import 'package:thlaby2_save_editor/save/item_slot.dart';
import 'package:thlaby2_save_editor/widgets/item_lock.dart';

typedef ItemSelectKey<I extends Item> = GlobalKey<ItemSelectState<I>>;

class ItemSelect<I extends Item> extends StatefulWidget
    with TStandardColorer, ItemPageBrowser<I> {
  final bool allowLockedSelection;
  final void Function(ItemSlot<I>) onItemSelect;

  @override
  final List<ItemSlot<I>> items;

  const ItemSelect({
    required this.allowLockedSelection,
    required this.onItemSelect,
    required this.items,
    super.key,
  });

  @override
  ItemSelectState<I> createState() => ItemSelectState<I>();
}

class ItemSelectState<I extends Item> extends State<ItemSelect<I>>
    with ItemPageBrowserState<I, ItemSelect<I>> {
  late bool _allowLockedSelection;

  bool get allowLockedSelection => _allowLockedSelection;
  set allowLockedSelection(bool newValue) => setState(() {
    _allowLockedSelection = newValue;
  });

  @override
  void initState() {
    super.initState();
    _allowLockedSelection = widget.allowLockedSelection;
  }

  @override
  Widget buildItem(int itemIndex, BuildContext context) {
    ItemSlot<I> item = widget.items[itemIndex];
    return TClickableRoundedBorder(
      hoverEnabled: item.isUnlocked || allowLockedSelection,
      hoverUpdateCallback: () => setState(() {}),
      onHoverTap: () => widget.onItemSelect(item),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: <Widget>[
            Expanded(child: Text('${item.item.prettyName} x${item.amount}')),
            Flexible(flex: 0, child: ItemSlotIcon(isUnlocked: item.isUnlocked)),
          ],
        ),
      ),
    );
  }
}
