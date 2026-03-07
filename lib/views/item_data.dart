import 'package:flutter/material.dart' hide Material;
import 'package:provider/provider.dart';
import 'package:tfields/logging.dart';
import 'package:tfields/theme.dart';
import 'package:tfields/widgets.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/save/enums/item.dart';
import 'package:thlaby2_save_editor/widgets/forms/groups/item_category.dart';
import 'package:thlaby2_save_editor/widgets/item_section.dart';

class ItemDataWidget extends StatefulWidget {
  const ItemDataWidget({super.key});

  @override
  State<ItemDataWidget> createState() => ItemDataState();
}

class ItemDataState extends State<ItemDataWidget>
    with
        SaveEditor,
        TLoggable,
        TDialogDisplayer<ItemDataWidget>,
        TDiscardableChanges<ItemDataWidget> {
  late ItemCategoryForm<Item> _selected;

  late final ItemCategoryForm<MainEquip> _mainEquipGroup;
  late final ItemCategoryForm<SubEquip> _subEquipGroup;
  late final ItemCategoryForm<Material> _materialGroup;
  late final ItemCategoryForm<SpecialItem> _specialGroup;

  List<ItemCategoryForm<Item>> get _groups => <ItemCategoryForm<Item>>[
    _mainEquipGroup,
    _subEquipGroup,
    _materialGroup,
    _specialGroup,
  ];

  void _changeSelected(ItemCategoryForm<Item> newSelection) {
    setState(() {
      _selected = newSelection;
    });
  }

  @override
  bool get hasChanges =>
      _groups.any((ItemCategoryForm<Item> group) => group.hasChanges);

  @override
  Future<void> saveChanges() async {
    // Save information for main equipment
    saveFile.mainInventoryData = _mainEquipGroup.makeEntity(null);
    _mainEquipGroup.saveValues();
    // Save information for sub equipment
    saveFile.subInventoryData = _subEquipGroup.makeEntity(null);
    _subEquipGroup.saveValues();
    // Save information for materials
    saveFile.materialInventoryData = _materialGroup.makeEntity(null);
    _materialGroup.saveValues();
    // Save information for special items
    saveFile.specialInventoryData = _specialGroup.makeEntity(null);
    _specialGroup.saveValues();
    await log(TLogLevel.info, 'Saved item data changes');
    // Refresh widget to get rid of the save symbol
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _mainEquipGroup = ItemCategoryForm<MainEquip>(
      title: 'Main Equips',
      initialData: saveFile.mainInventoryData,
      setState: setState,
      enabled: true,
    );

    _subEquipGroup = ItemCategoryForm<SubEquip>(
      title: 'Sub Equips',
      initialData: saveFile.subInventoryData,
      setState: setState,
      enabled: true,
    );

    _materialGroup = ItemCategoryForm<Material>(
      title: 'Materials',
      initialData: saveFile.materialInventoryData,
      setState: setState,
      enabled: true,
    );

    _specialGroup = ItemCategoryForm<SpecialItem>(
      title: 'Special Items',
      initialData: saveFile.specialInventoryData,
      setState: setState,
      enabled: true,
    );

    _selected = _mainEquipGroup;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !hasChanges,
      onPopInvokedWithResult: onPopInvoked,
      child: TCommonScaffold(
        title: 'Edit item unlock flags and amounts',
        themeToggleCallback: Provider.of<TThemeProvider>(context).changeTheme,
        floatingActionButton: saveButton,
        children: <Widget>[
          Row(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _groups.map(
              (ItemCategoryForm<Item> group) => Flexible(
                child: ItemSectionHeader(
                  text: group.title,
                  hasChanges: group.hasChanges,
                  isSelected: _selected == group,
                  onPressed: () => _changeSelected(group),
                ),
              ),
            ).toList(),
          ),
          const Divider(),
          IndexedStack(
            index: _groups.indexOf(_selected),
            children: _groups.map(
              (ItemCategoryForm<Item> group) =>
                  ItemCategoryFormWidget<Item>(form: group),
            ).toList(),
          ),
          // Allows page selection behind save button
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
