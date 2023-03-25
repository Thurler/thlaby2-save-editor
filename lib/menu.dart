import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/character_unlock.dart';
import 'package:thlaby2_save_editor/common.dart';
import 'package:thlaby2_save_editor/list_extension.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/widgets/button.dart';
import 'package:thlaby2_save_editor/widgets/dialog.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({super.key});

  @override
  State<MenuWidget> createState() => MenuState();
}

class MenuState extends CommonState<MenuWidget> {
  Future<bool> _alertUnexportedChanges() async {
    TBoolDialog dialog = const TBoolDialog(
      title: 'Did you export your changes?',
      body: 'Are you sure you want to go back and load a different save file? '
            'Any changes that have not been exported will be discarded!',
      confirmText: 'Yes, change files',
      cancelText: 'No, keep me here',
    );
    bool canReturn = await showBoolDialog(dialog);
    if (canReturn) {
      await logger.log(
        LogLevel.info,
        'User confirmed going back to file select without exporting',
      );
    }
    return canReturn;
  }

  Future<void> _handleFileSystemException(FileSystemException e) {
    return handleException(
      logMessage: 'FileSystem Exception when exporting file: ${e.message}',
      dialogTitle: 'An error occured when exporting the file!',
      dialogBody: 'Make sure your user has permission to write the file in '
        'the folder you chose.',
    );
  }

  Future<void> _editCharacterUnlock() async {
    NavigatorState state = Navigator.of(context);
    await logger.log(LogLevel.debug, 'Opening character unlock edit widget');
    if (!state.mounted) {
      return;
    }
    await state.push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const CharacterUnlockWidget(),
      ),
    );
    await logger.log(LogLevel.debug, 'Closed character unlock edit widget');
  }

  Future<void> _saveSteamSaveFile() async {
    await logger.log(LogLevel.debug, 'Export Steam Save File called');
    String? result = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select where to save the file:',
      fileName: 'steam.dat',
    );
    if (result == null) {
      await logger.log(LogLevel.debug, 'No file selected');
      return;
    }
    await logger.log(LogLevel.debug, 'Exporting save file in Steam format');
    try {
      File rawFile = File(result);
      StringBuffer logBuffer = StringBuffer();
      List<int> contents = saveFileWrapper.saveFile.exportSteam(logBuffer);
      await rawFile.writeAsBytes(contents);
      for (String line in LineSplitter.split(logBuffer.toString())) {
        await logger.log(LogLevel.debug, line);
      }
    } on FileSystemException catch (e) {
      await _handleFileSystemException(e);
      return;
    } catch (e, s) {
      await handleUnexpectedException('Unknown exception: $e | $s');
      return;
    }
    await logger.log(LogLevel.info, 'Steam save file exported successfully');
    await showCommonDialog(
      const TSuccessDialog(title: 'Save file exported successfully'),
    );
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
    return WillPopScope(
      onWillPop: _alertUnexportedChanges,
      child: Scaffold(
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
      ),
    );
  }
}
