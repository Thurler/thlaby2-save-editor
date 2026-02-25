import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/save/enums/item.dart';
import 'package:thlaby2_save_editor/save/item_slot.dart';
import 'package:thlaby2_save_editor/widgets/item_section.dart';

const int itemPageSize = 20;

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
  final int itemCount;
  final void Function() onHeaderPressed;
  final Widget Function(int, BuildContext) buildItem;

  const _ItemPage({
    required this.pageNumber,
    required this.onHeaderPressed,
    required this.buildItem,
    required this.itemCount,
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
    onPressed: widget.onHeaderPressed,
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
        (widget.itemCount / 2).ceil(),
        (int i) => Row(
          spacing: 20,
          children: <Widget>[
            widget.buildItem(i * 2, context),
            widget.buildItem(i * 2 + 1, context),
          ],
        ),
      ),
    );
  }
}

mixin ItemPageBrowser<I extends Item> on StatefulWidget {
  List<ItemSlot<I>> get items;

  @override
  ItemPageBrowserState<I, ItemPageBrowser<I>> createState();
}

mixin ItemPageBrowserState<I extends Item, W extends ItemPageBrowser<I>>
    on State<W> {
  late _ItemPage<I> _selected;
  late final List<_ItemPageKey<I>> _pageKeys;
  late final List<_ItemPage<I>> _pages;

  Widget buildItem(int itemIndex, BuildContext context);

  void _changePage(int index) {
    setState(() {
      _selected = _pages[index];
    });
  }

  @override
  void initState() {
    super.initState();
    _pageKeys = List<_ItemPageKey<I>>.generate(
      (widget.items.length / itemPageSize).ceil(),
      (int i) => _ItemPageKey<I>(),
    );
    _pages = List<_ItemPage<I>>.generate(
      _pageKeys.length,
      (int i) => _ItemPage<I>(
        pageNumber: i,
        startsSelected: i == 0, // Start with first page selected
        itemCount: widget.items.length,
        onHeaderPressed: () => _changePage(i),
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
