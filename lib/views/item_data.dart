import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/mixins/alert.dart';
import 'package:thlaby2_save_editor/mixins/discardablechanges.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/widgets/common_scaffold.dart';
import 'package:thlaby2_save_editor/widgets/item_category.dart';
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
    items: saveFile.mainInventoryData,
    onHeaderPressed: widget.allowSub ? _changeToSubEquips : null,
    onValueChanged: () => setState(() {}),
    key: subEquipsKey,
  );

  late final ItemCategory materials = ItemCategory(
    title: 'Materials',
    items: saveFile.mainInventoryData,
    onHeaderPressed: widget.allowMaterial ? _changeToMaterials : null,
    onValueChanged: () => setState(() {}),
    key: materialsKey,
  );

  late final ItemCategory specials = ItemCategory(
    title: 'Special Items',
    items: saveFile.mainInventoryData,
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

  @override
  Future<void> saveChanges() async {}

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
            children: categories,
          ),
        ],
      ),
    );
  }
}
