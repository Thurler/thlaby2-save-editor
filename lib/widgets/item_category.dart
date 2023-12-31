import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/extensions/iterable_extension.dart';
import 'package:thlaby2_save_editor/save/item_slot.dart';
import 'package:thlaby2_save_editor/widgets/badge.dart';
import 'package:thlaby2_save_editor/widgets/button.dart';
import 'package:thlaby2_save_editor/widgets/clickable.dart';
import 'package:thlaby2_save_editor/widgets/form.dart';
import 'package:thlaby2_save_editor/widgets/item_form.dart';
import 'package:thlaby2_save_editor/widgets/rounded_border.dart';
import 'package:thlaby2_save_editor/widgets/spaced_row.dart';

typedef ItemCategoryKey = GlobalKey<ItemCategoryState>;
typedef ItemPageKey = GlobalKey<ItemPageState>;

class PageSelector extends StatelessWidget {
  final List<ItemPageKey> pageKeys;

  const PageSelector({required this.pageKeys, super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: pageKeys.map(
        (ItemPageKey key) => key.currentState?.header ?? Container(),
      ).toList(),
    );
  }
}

class FormSectionHeader extends StatelessWidget {
  final String text;
  final bool hasChanges;
  final bool isSelected;
  final bool usesMaxWidth;
  final void Function()? onPressed;

  const FormSectionHeader({
    required this.text,
    required this.hasChanges,
    required this.isSelected,
    this.usesMaxWidth = true,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget ret = ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 150,
      ),
      child: Column(
        children: <Widget>[
          TButton(text: text, onPressed: onPressed),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Opacity(
                opacity: isSelected ? 1 : 0,
                child: const Divider(color: Colors.green),
              ),
              Opacity(
                opacity: hasChanges ? 1 : 0,
                child: TBadge(
                  text: 'Has Changes',
                  color: Colors.green[300]!,
                ),
              ),
            ],
          ),
        ].separateWith(const SizedBox(height: 8)),
      ),
    );
    return usesMaxWidth ? ret : IntrinsicWidth(child: ret);
  }
}

class ItemOption extends StatelessWidget {
  final TFormItem item;
  final bool editable;
  final TFormItem? highlighted;
  final void Function(TFormItem)? onTap;
  final void Function(TFormItem)? onEnter;
  final void Function()? onExit;

  const ItemOption({
    required this.item,
    this.editable = true,
    this.highlighted,
    this.onTap,
    this.onEnter,
    this.onExit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isHighlighted = item == highlighted;
    Widget border = RoundedBorder(
      color: isHighlighted
        ? Colors.green
        : TFormTitle.subtitleColor.withOpacity(0.5),
      childPadding: const EdgeInsets.only(right: 15),
      child: item,
    );
    if (editable) {
      return border;
    }
    return TClickable(
      onTap: () => onTap?.call(item),
      onEnter: (_) => onEnter?.call(item),
      onExit: (_) => onExit?.call(),
      child: border,
    );
  }
}

class ItemPage extends StatefulWidget {
  final int pageNumber;
  final List<ItemSlot> items;
  final void Function()? onHeaderPressed;
  final void Function()? onValueChanged;
  final void Function(ItemSlot)? onTap;
  final bool editable;

  const ItemPage({
    required this.pageNumber,
    required this.items,
    required this.onHeaderPressed,
    required this.onValueChanged,
    required this.onTap,
    this.editable = true,
    super.key,
  });

  @override
  ItemPageState createState() => ItemPageState();
}

class ItemPageState extends State<ItemPage> {
  bool isSelected = false;
  late final List<TFormItem> itemForms;
  late final List<ItemFormKey> itemFormKeys;
  TFormItem? _hover;

  void onHeaderPressed() {
    setState(() {
      isSelected = true;
    });
    widget.onHeaderPressed?.call();
  }

  void onValueChanged(String? value) {
    setState(() {});
    widget.onValueChanged?.call();
  }

  void deselect() {
    setState(() {
      isSelected = false;
    });
  }

  void _hoverEnter(TFormItem item) {
    setState(() {
      _hover = item;
    });
  }

  void _hoverExit() {
    setState(() {
      _hover = null;
    });
  }

  bool get hasChanges => itemFormKeys.any(
    (ItemFormKey key) => key.currentState?.hasChanges ?? false,
  );

  Widget get header => FormSectionHeader(
    text: 'Page ${widget.pageNumber + 1}',
    hasChanges: hasChanges,
    isSelected: isSelected,
    onPressed: onHeaderPressed,
    usesMaxWidth: false,
  );

  @override
  void initState() {
    super.initState();
    itemFormKeys = List<ItemFormKey>.generate(
      widget.items.length,
      (int i) => ItemFormKey(),
    );
    itemForms = List<TFormItem>.generate(
      widget.items.length,
      (int i) => TFormItem(
        itemSlot: widget.items[i],
        onValueChanged: onValueChanged,
        enabled: widget.editable,
        key: itemFormKeys[i],
      ),
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(
        (itemForms.length / 2).ceil(),
        (int i) => SpacedRow(
          spacer: const SizedBox(width: 20),
          children: <Widget>[
            ItemOption(
              item: itemForms[i * 2],
              editable: widget.editable,
              highlighted: _hover,
              onEnter: _hoverEnter,
              onExit: _hoverExit,
              onTap: (TFormItem form) => widget.onTap?.call(form.itemSlot),
            ),
            ItemOption(
              item: itemForms[(i * 2) + 1],
              editable: widget.editable,
              highlighted: _hover,
              onEnter: _hoverEnter,
              onExit: _hoverExit,
              onTap: (TFormItem form) => widget.onTap?.call(form.itemSlot),
            ),
          ],
        ),
      ).separateWith(const SizedBox(height: 10)),
    );
  }
}

class ItemCategory extends StatefulWidget {
  final String title;
  final List<ItemSlot> items;
  final void Function()? onHeaderPressed;
  final void Function()? onValueChanged;
  final void Function(ItemSlot)? onTap;
  final bool editable;

  const ItemCategory({
    required this.title,
    required this.items,
    this.editable = true,
    this.onHeaderPressed,
    this.onValueChanged,
    this.onTap,
    super.key,
  });

  @override
  ItemCategoryState createState() => ItemCategoryState();
}

class ItemCategoryState extends State<ItemCategory> {
  late final bool enabled;
  bool isSelected = false;

  late ItemPage selected;
  late final List<ItemPageKey> pageKeys;
  late final List<ItemPage> pages;

  void onHeaderPressed() {
    setState(() {
      isSelected = true;
    });
    widget.onHeaderPressed?.call();
  }

  void onPagePressed(int index) {
    for (int i = 0; i < pages.length; i++) {
      if (i != index) {
        pageKeys[i].currentState!.deselect();
      }
    }
    setState(() {
      selected = pages[index];
    });
  }

  void onValueChanged() {
    setState(() {});
    widget.onValueChanged?.call();
  }

  void deselect() {
    setState(() {
      isSelected = false;
    });
  }

  bool get hasChanges => pageKeys.any(
    (ItemPageKey key) => key.currentState?.hasChanges ?? false,
  );

  Widget get header => FormSectionHeader(
    text: widget.title,
    hasChanges: hasChanges,
    isSelected: isSelected,
    onPressed: enabled ? onHeaderPressed : null,
  );

  @override
  void initState() {
    super.initState();
    enabled = widget.onHeaderPressed != null;
    pageKeys = List<ItemPageKey>.generate(
      (widget.items.length / 20).ceil(),
      (int i) => ItemPageKey(),
    );
    pages = List<ItemPage>.generate(
      pageKeys.length,
      (int i) => ItemPage(
        pageNumber: i,
        items: widget.items.sublist(i * 20, (i + 1) * 20),
        onHeaderPressed: () => onPagePressed(i),
        onValueChanged: () => onValueChanged(),
        onTap: widget.onTap,
        editable: widget.editable,
        key: pageKeys[i],
      ),
    );
    selected = pages[0];
    // Call setState one last time after build runs for the first time
    WidgetsBinding.instance.addPostFrameCallback((Duration d) {
      setState(() {
        pageKeys[0].currentState!.isSelected = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        PageSelector(pageKeys: pageKeys),
        IndexedStack(
          index: pages.indexOf(selected),
          children: pages,
        ),
        PageSelector(pageKeys: pageKeys),
      ].separateWith(
        const SizedBox(height: 20),
      ),
    );
  }
}
