import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/mixins/alert.dart';
import 'package:thlaby2_save_editor/mixins/discardablechanges.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/widgets/button.dart';
import 'package:thlaby2_save_editor/widgets/common_scaffold.dart';
import 'package:thlaby2_save_editor/widgets/form.dart';
import 'package:thlaby2_save_editor/widgets/item_category.dart';
import 'package:thlaby2_save_editor/widgets/item_form.dart';
import 'package:thlaby2_save_editor/widgets/rounded_border.dart';
import 'package:thlaby2_save_editor/widgets/spaced_row.dart';

class ItemDataWidget extends StatefulWidget {
  const ItemDataWidget({super.key});

  @override
  State<ItemDataWidget> createState() => ItemDataState();
}

class ItemDataState extends State<ItemDataWidget>
    with
        SaveReader,
        Loggable,
        AlertHandler<ItemDataWidget>,
        DiscardableChanges<ItemDataWidget> {
  void _changeToMainEquips() {}

  @override
  bool get hasChanges {
    return false;
  }

  @override
  Future<void> saveChanges() async {}

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
            children: <Widget>[
              ItemCategory(
                text: 'Main Equips',
                hasChanges: true,
                isSelected: true,
                onPressed: _changeToMainEquips,
              ),
              const ItemCategory(
                text: 'Sub Equips',
                hasChanges: true,
                isSelected: false,
              ),
              const ItemCategory(
                text: 'Materials',
                hasChanges: true,
                isSelected: false,
              ),
              const ItemCategory(
                text: 'Special Items',
                hasChanges: true,
                isSelected: false,
              ),
            ],
          ),
          const SpacedRow(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.arrow_left, size: 40, color: Colors.grey),
              Text('Page 1/3', style: TextStyle(fontSize: 20)),
              Icon(Icons.arrow_right, size: 40),
            ],
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: List<Widget>.generate(
              10,
              (int i) => TButton(text: 'Page ${i + 1}', usesMaxWidth: false),
            ),
          ),
          ...List<Widget>.generate(
            10,
            (int i) => SpacedRow(
              spacer: const SizedBox(width: 20),
              children: <Widget>[
                RoundedBorder(
                  color: TFormTitle.subtitleColor.withOpacity(0.5),
                  childPadding: const EdgeInsets.only(right: 15),
                  child: TFormItem(
                    itemSlot: saveFile.mainInventoryData[i * 2],
                    onValueChanged: (String? value) => setState(() {}),
                  ),
                ),
                RoundedBorder(
                  color: TFormTitle.subtitleColor.withOpacity(0.5),
                  childPadding: const EdgeInsets.only(right: 15),
                  child: TFormItem(
                    itemSlot: saveFile.mainInventoryData[i * 2 + 1],
                    onValueChanged: (String? value) => setState(() {}),
                  ),
                ),
              ],
            ),
          ),
          const SpacedRow(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.arrow_left, size: 40, color: Colors.grey),
              Text('Page 1/3', style: TextStyle(fontSize: 20)),
              Icon(Icons.arrow_right, size: 40),
            ],
          ),
        ],
      ),
    );
  }
}
