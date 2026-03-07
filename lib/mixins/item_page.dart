import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tfields/widgets.dart';
import 'package:thlaby2_save_editor/save/enums/item.dart';
import 'package:thlaby2_save_editor/save/item_slot.dart';

const int itemPageSize = 20;

typedef _ItemPageKey<I extends Item> = GlobalKey<_ItemPageState<I>>;

class _PageSelector<I extends Item> extends StatelessWidget {
  final List<_ItemPageKey<I>> pageKeys;

  final void Function(int) onHeaderPressed;

  final int selectedIndex;

  const _PageSelector({
    required this.pageKeys,
    required this.onHeaderPressed,
    required this.selectedIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: pageKeys.indexed.map(((int, _ItemPageKey<I>) indexedKey) {
        _ItemPageState<I>? state = indexedKey.$2.currentState;
        return Expanded(
          child: TClickable(
            onTap: () => onHeaderPressed(indexedKey.$1),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(strokeAlign: BorderSide.strokeAlignCenter),
                color: selectedIndex == indexedKey.$1
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.surface,
              ),
              child: Text(
                ((state?.widget.pageNumber ?? indexedKey.$1) + 1).toString(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ItemPage<I extends Item> extends StatefulWidget {
  final int pageNumber;
  final int itemCount;
  final Widget Function(int, BuildContext) buildItem;

  const _ItemPage({
    required this.pageNumber,
    required this.buildItem,
    required this.itemCount,
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

  void forceRedraw() => setState(() {});

  @override
  Widget build(BuildContext context) {
    int offset = widget.pageNumber * widget.itemCount;
    return Column(
      spacing: 10,
      children: List<Widget>.generate(
        (widget.itemCount / 2).ceil(),
        (int i) => Row(
          spacing: 20,
          children: <Widget>[
            Flexible(child: widget.buildItem(i * 2 + offset, context)),
            Flexible(child: widget.buildItem(i * 2 + offset + 1, context)),
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
  int _selectedIndex = 0;
  late final List<_ItemPageKey<I>> _pageKeys;
  late final List<_ItemPage<I>> _pages;

  Widget buildItem(int itemIndex, BuildContext context);

  void _changePage(int index) {
    setState(() {
      _selectedIndex = index;
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
        itemCount: itemPageSize,
        buildItem: buildItem,
        key: _pageKeys[i],
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void setState(void Function() fn) {
    for (_ItemPageKey<I> key in _pageKeys) {
      key.currentState?.forceRedraw();
    }
    super.setState(fn);
  }

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: <Widget>[
        _PageSelector<I>(
          pageKeys: _pageKeys,
          selectedIndex: _selectedIndex,
          onHeaderPressed: _changePage,
        ),
        IndexedStack(index: _selectedIndex, children: _pages),
        _PageSelector<I>(
          pageKeys: _pageKeys,
          selectedIndex: _selectedIndex,
          onHeaderPressed: _changePage,
        ),
      ],
    );
  }
}
