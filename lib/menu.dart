import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/character_unlock.dart';
import 'package:thlaby2_save_editor/common.dart';
import 'package:thlaby2_save_editor/list_extension.dart';
import 'package:thlaby2_save_editor/widgets/button.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({super.key});

  @override
  State<MenuWidget> createState() => MenuState();
}

class MenuState extends CommonState<MenuWidget> {
  Future<void> _editCharacterUnlock() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const CharacterUnlockWidget(),
      ),
    );
  }

  Future<void> _saveSteamSaveFile() async {
    String? result = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select where to save the file:',
      fileName: 'steam.dat',
    );
    if (result == null) {
      return;
    }
    try {
      File rawFile = File(result);
      List<int> contents = saveFileWrapper.saveFile.export();
      await rawFile.writeAsBytes(contents);
    } on FileSystemException {
      // Do nothing for now
    } catch (e) {
      await logger.log(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = <Widget>[
      const TButton(
        text: 'General Data',
        icon: Icons.info_outline,
      ),
      const TButton(
        text: 'Event Data',
        icon: Icons.warning_amber,
      ),
      const TButton(
        text: 'Character Data',
        icon: Icons.groups,
      ),
      TButton(
        text: 'Character Unlock Data',
        icon: Icons.lock_person_outlined,
        onPressed: _editCharacterUnlock,
      ),
      const TButton(
        text: 'Inventory Data',
        icon: Icons.inventory_2_outlined,
      ),
      const TButton(
        text: 'Inventory Unlock Data',
        icon: Icons.inventory_outlined,
      ),
      const TButton(
        text: 'Achievement Data',
        icon: Icons.star_border_purple500,
      ),
      const TButton(
        text: 'Map Data',
        icon: Icons.map,
      ),
    ];
    List<Widget> columnChildren = <Widget>[];
    for (int i = 0; i < buttons.length; i += 2) {
      columnChildren.add(makeRowFromWidgets(buttons.sublist(i, i+2)));
    }
    columnChildren.add(const Divider());
    columnChildren.add(
      makeRowFromWidgets(
        <Widget>[
          const TButton(
            text: 'Export as DLSite save',
            icon: Icons.save,
          ),
          TButton(
            text: 'Export as Steam save',
            onPressed: _saveSteamSaveFile,
            icon: Icons.save,
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Touhou Labyrinth 2 Save Editor'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: columnChildren.separateWith(
                const SizedBox(height: 20),
                separatorOnEnds: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
