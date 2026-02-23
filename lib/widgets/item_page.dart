import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/save/enums/item.dart';
import 'package:thlaby2_save_editor/save/item_slot.dart';
import 'package:thlaby2_save_editor/widgets/item_section.dart';

typedef _ItemPageKey<I extends Item> = GlobalKey<_ItemPageState<I>>;

class _PageSelector<I extends Item> extends StatelessWidget {
  final List<_ItemPageKey<I>> pageKeys;

  const _PageSelector({required this.pageKeys, super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: pageKeys.map(
        (_ItemPageKey<I> key) =>
            key.currentState?.buildHeader(context) ?? Container(),
      ).toList(),
    );
  }
}

class _ItemPage<I extends Item> extends StatefulWidget {
  final int pageNumber;
  final bool startsSelected;
  final List<ItemSlot<I>> items;
  final Widget Function(ItemSlot<I>, BuildContext) buildItem;

  const _ItemPage({
    required this.pageNumber,
    required this.buildItem,
    required this.items,
    this.startsSelected = false,
    super.key,
  });

  @override
  _ItemPageState<I> createState() => _ItemPageState<I>();
}

class _ItemPageState<I extends Item> extends State<_ItemPage<I>> {
  late bool isSelected;

  void deselect() {
    setState(() {
      isSelected = false;
    });
  }

  Widget buildHeader(BuildContext context) => ItemSectionHeader(
    text: 'Page ${widget.pageNumber + 1}',
    hasChanges: false,
    isSelected: isSelected,
    //onPressed: onHeaderPressed,
    usesMaxWidth: false,
  );

  @override
  void initState() {
    super.initState();
    isSelected = widget.startsSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: List<Widget>.generate(
        (widget.items.length / 2).ceil(),
        (int i) => Row(
          spacing: 20,
          children: <Widget>[
            widget.buildItem(widget.items[i * 2], context),
            widget.buildItem(widget.items[i * 2 + 1], context),
          ],
        ),
      ),
    );
  }
}

abstract class ItemPageBrowser<I extends Item> extends StatefulWidget {
  final List<ItemSlot<I>> items;

  const ItemPageBrowser({required this.items, super.key});

  @override
  ItemPageBrowserState<I, ItemPageBrowser<I>> createState();
}

abstract class ItemPageBrowserState<I extends Item,
    W extends ItemPageBrowser<I>> extends State<W> {
  late _ItemPage<I> _selected;
  late final List<_ItemPageKey<I>> _pageKeys;
  late final List<_ItemPage<I>> _pages;

  Widget buildItem(ItemSlot<I> item, BuildContext context);

  @override
  void initState() {
    super.initState();
    _pageKeys = List<_ItemPageKey<I>>.generate(
      (widget.items.length / 20).ceil(),
      (int i) => _ItemPageKey<I>(),
    );
    _pages = List<_ItemPage<I>>.generate(
      _pageKeys.length,
      (int i) => _ItemPage<I>(
        pageNumber: i,
        startsSelected: i == 0, // Start with first page selected
        items: widget.items.sublist(i * 20, (i + 1) * 20),
        buildItem: buildItem,
        key: _pageKeys[i],
      ),
    );
    _selected = _pages[0];
  }

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: <Widget>[
        _PageSelector<I>(pageKeys: _pageKeys),
        IndexedStack(index: _pages.indexOf(_selected), children: _pages),
        _PageSelector<I>(pageKeys: _pageKeys),
      ],
    );
  }
}
