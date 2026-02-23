import 'package:flutter/material.dart';
import 'package:tfields/widgets.dart';
import 'package:thlaby2_save_editor/save/enums/item.dart';
import 'package:thlaby2_save_editor/save/item_slot.dart';
import 'package:thlaby2_save_editor/widgets/item_page.dart';

typedef ItemSelectKey<I extends Item> = GlobalKey<ItemSelectState<I>>;

class ItemSelect<I extends Item> extends ItemPageBrowser<I>
    with TStandardColorer {
  final bool allowLockedSelection;
  final void Function(ItemSlot<I>) onItemSelect;

  const ItemSelect({
    required this.allowLockedSelection,
    required this.onItemSelect,
    required super.items,
    super.key,
  });

  @override
  ItemSelectState<I> createState() => ItemSelectState<I>();
}

class ItemSelectState<I extends Item>
    extends ItemPageBrowserState<I, ItemSelect<I>> {
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
  Widget buildItem(ItemSlot<I> item, BuildContext context) {
    return TClickableRoundedBorder(
      hoverEnabled: item.isUnlocked || allowLockedSelection,
      hoverUpdateCallback: () => setState(() {}),
      onHoverTap: () => widget.onItemSelect(item),
      child: Row(
        children: <Widget>[
          Flexible(child: Text('${item.item.prettyName} x${item.amount}')),
          Flexible(
            flex: 0,
            child: Icon(
              item.isUnlocked ? Icons.lock_open : Icons.lock,
              color: item.isUnlocked
                ? widget.successColor(context)
                : widget.errorColor(context),
            ),
          ),
        ],
      ),
    );
  }
}
