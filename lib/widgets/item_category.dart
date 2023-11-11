import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/extensions/iterable_extension.dart';
import 'package:thlaby2_save_editor/save/item_slot.dart';
import 'package:thlaby2_save_editor/widgets/badge.dart';
import 'package:thlaby2_save_editor/widgets/button.dart';
import 'package:thlaby2_save_editor/widgets/form.dart';
import 'package:thlaby2_save_editor/widgets/item_form.dart';
import 'package:thlaby2_save_editor/widgets/rounded_border.dart';
import 'package:thlaby2_save_editor/widgets/spaced_row.dart';

typedef ItemCategoryKey = GlobalKey<ItemCategoryState>;

class ItemCategoryHeader extends StatelessWidget {
  final String text;
  final bool hasChanges;
  final bool isSelected;
  final void Function()? onPressed;

  const ItemCategoryHeader({
    required this.text,
    required this.hasChanges,
    required this.isSelected,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

class ItemCategoryPaginator extends StatelessWidget {
  final int pageCount;

  const ItemCategoryPaginator({required this.pageCount, super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: List<Widget>.generate(
        pageCount,
        (int i) => TButton(text: 'Page ${i + 1}', usesMaxWidth: false),
      ),
    );
  }
}

class ItemCategory extends StatefulWidget {
  final String title;
  final List<ItemSlot> items;
  final void Function()? onHeaderPressed;

  const ItemCategory({
    required this.title,
    required this.items,
    required this.onHeaderPressed,
    super.key,
  });

  @override
  ItemCategoryState createState() => ItemCategoryState();
}

class ItemCategoryState extends State<ItemCategory> {
  late final bool enabled;
  bool hasChanges = false;
  bool isSelected = false;
  late final List<TFormItem> itemForms;

  void onHeaderPressed() {
    setState(() {
      isSelected = true;
    });
    widget.onHeaderPressed?.call();
  }

  void deselect() {
    setState(() {
      isSelected = false;
    });
  }

  Widget get header => ItemCategoryHeader(
    text: widget.title,
    hasChanges: hasChanges,
    isSelected: isSelected,
    onPressed: enabled ? onHeaderPressed : null,
  );

  @override
  void initState() {
    super.initState();
    enabled = widget.onHeaderPressed != null;
    itemForms = widget.items.map(
      (ItemSlot item) => TFormItem(
        itemSlot: item,
        onValueChanged: (String? value) => setState(() {}),
      ),
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ItemCategoryPaginator(pageCount: (itemForms.length / 20).ceil()),
        ...List<Widget>.generate(
          10,
          (int i) => SpacedRow(
            spacer: const SizedBox(width: 20),
            children: <Widget>[
              RoundedBorder(
                color: TFormTitle.subtitleColor.withOpacity(0.5),
                childPadding: const EdgeInsets.only(right: 15),
                child: itemForms[i * 2],
              ),
              RoundedBorder(
                color: TFormTitle.subtitleColor.withOpacity(0.5),
                childPadding: const EdgeInsets.only(right: 15),
                child: itemForms[(i * 2) + 1],
              ),
            ],
          ),
        ),
        ItemCategoryPaginator(pageCount: (itemForms.length / 20).ceil()),
      ].separateWith(
        const SizedBox(height: 20),
      ),
    );
  }
}
