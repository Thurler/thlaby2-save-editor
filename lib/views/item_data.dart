import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/mixins/alert.dart';
import 'package:thlaby2_save_editor/mixins/discardablechanges.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/save/item_slot.dart';
import 'package:thlaby2_save_editor/widgets/common_scaffold.dart';
import 'package:thlaby2_save_editor/widgets/item_category.dart';
import 'package:thlaby2_save_editor/widgets/item_form.dart';
import 'package:thlaby2_save_editor/widgets/spaced_row.dart';

class ItemDataWidget extends StatefulWidget {
  final bool allowMain;
  final bool allowSub;
  final bool allowMaterial;
  final bool allowSpecial;

  const ItemDataWidget({
    this.allowMain = true,
    this.allowSub = true,
    this.allowMaterial = true,
    this.allowSpecial = true,
    super.key,
  });

  @override
  State<ItemDataWidget> createState() => ItemDataState();
}

class ItemDataState extends State<ItemDataWidget>
    with
        SaveReader,
        Loggable,
        AlertHandler<ItemDataWidget>,
        DiscardableChanges<ItemDataWidget> {
  late ItemCategory selected;

  final ItemCategoryKey mainEquipsKey = ItemCategoryKey();
  final ItemCategoryKey subEquipsKey = ItemCategoryKey();
  final ItemCategoryKey materialsKey = ItemCategoryKey();
  final ItemCategoryKey specialsKey = ItemCategoryKey();

  late final ItemCategory mainEquips = ItemCategory(
    title: 'Main Equips',
    items: saveFile.mainInventoryData,
    onHeaderPressed: widget.allowMain ? _changeToMainEquips : null,
    onValueChanged: () => setState(() {}),
    key: mainEquipsKey,
  );

  late final ItemCategory subEquips = ItemCategory(
    title: 'Sub Equips',
    items: saveFile.subInventoryData,
    onHeaderPressed: widget.allowSub ? _changeToSubEquips : null,
    onValueChanged: () => setState(() {}),
    key: subEquipsKey,
  );

  late final ItemCategory materials = ItemCategory(
    title: 'Materials',
    items: saveFile.materialInventoryData,
    onHeaderPressed: widget.allowMaterial ? _changeToMaterials : null,
    onValueChanged: () => setState(() {}),
    key: materialsKey,
  );

  late final ItemCategory specials = ItemCategory(
    title: 'Special Items',
    items: saveFile.specialInventoryData,
    onHeaderPressed: widget.allowSpecial ? _changeToSpecials : null,
    onValueChanged: () => setState(() {}),
    key: specialsKey,
  );

  late final List<ItemCategory> categories = <ItemCategory>[
    mainEquips,
    subEquips,
    materials,
    specials,
  ];

  late final List<ItemCategoryKey> categoryKeys = <ItemCategoryKey>[
    mainEquipsKey,
    subEquipsKey,
    materialsKey,
    specialsKey,
  ];

  void _disableOtherKeys(ItemCategoryKey enabledKey) {
    for (ItemCategoryKey key in categoryKeys) {
      if (enabledKey != key) {
        key.currentState!.deselect();
      }
    }
  }

  void _changeToMainEquips() {
    _disableOtherKeys(mainEquipsKey);
    setState(() {
      selected = mainEquips;
    });
  }

  void _changeToSubEquips() {
    _disableOtherKeys(subEquipsKey);
    setState(() {
      selected = subEquips;
    });
  }

  void _changeToMaterials() {
    _disableOtherKeys(materialsKey);
    setState(() {
      selected = materials;
    });
  }

  void _changeToSpecials() {
    _disableOtherKeys(specialsKey);
    setState(() {
      selected = specials;
    });
  }

  @override
  bool get hasChanges => categoryKeys.any(
    (ItemCategoryKey key) => key.currentState?.hasChanges ?? false,
  );

  void _iterateAndSaveItemSlots(
    ItemCategoryKey categoryKey,
    List<ItemSlot> slots,
  ) {
    // Iterate on a category's pages and then on a page's items, saving each
    // item's amount and unlock status. We must also call setState on each
    // page and category, to refresh the Has Changes flag
    int index = 0;
    for (ItemPageKey pageKey in categoryKey.currentState!.pageKeys) {
      for (ItemFormKey itemKey in pageKey.currentState!.itemFormKeys) {
        slots[index].isUnlocked = itemKey.currentState!.saveUnlockValue();
        slots[index].amount = itemKey.currentState!.saveIntValue();
        index++;
      }
      pageKey.currentState!.setState(() {});
    }
    categoryKey.currentState!.setState(() {});
  }

  @override
  Future<void> saveChanges() async {
    // Save information for main equipment
    _iterateAndSaveItemSlots(mainEquipsKey, saveFile.mainInventoryData);
    // Save information for sub equipment
    _iterateAndSaveItemSlots(subEquipsKey, saveFile.subInventoryData);
    // Save information for materials
    _iterateAndSaveItemSlots(materialsKey, saveFile.materialInventoryData);
    // Save information for special items
    _iterateAndSaveItemSlots(specialsKey, saveFile.specialInventoryData);
    await log(LogLevel.info, 'Saved item data changes');
    // Refresh widget to get rid of the save symbol
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    selected = mainEquips;
    // Call setState one last time after build runs for the first time
    WidgetsBinding.instance.addPostFrameCallback((Duration d) {
      setState(() {
        mainEquipsKey.currentState!.isSelected = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: checkChangesAndConfirm,
      child: CommonScaffold(
        title: 'Edit item unlock flags and amounts',
        floatingActionButton: saveButton,
        children: <Widget>[
          SpacedRow(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacer: const SizedBox(width: 20),
            children: categoryKeys.map(
              (ItemCategoryKey key) => key.currentState?.header ?? Container(),
            ).toList(),
          ),
          const Divider(),
          IndexedStack(
            index: categories.indexOf(selected),
            children: categories.map(
              (ItemCategory category) => SizedBox(
                height: category == selected ? null : 1,
                child: category,
              ),
            ).toList(),
          ),
        ],
      ),
    );
  }
}
