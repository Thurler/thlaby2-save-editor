import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/mixins/alert.dart';
import 'package:thlaby2_save_editor/mixins/exception.dart';
import 'package:thlaby2_save_editor/mixins/navigate.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/widgets/button.dart';
import 'package:thlaby2_save_editor/widgets/character_roster.dart';
import 'package:thlaby2_save_editor/widgets/common_scaffold.dart';
import 'package:thlaby2_save_editor/widgets/dialog.dart';
import 'package:thlaby2_save_editor/widgets/spaced_row.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({super.key});

  @override
  State<MenuWidget> createState() => MenuState();
}

class MenuState extends State<MenuWidget>
    with
        SaveReader,
        Loggable,
        AlertHandler<MenuWidget>,
        ExceptionHandler<MenuWidget>,
        Navigatable<MenuWidget> {
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
      await log(
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

  Future<void> _saveSteamSaveFile() async {
    await log(LogLevel.debug, 'Export Steam Save File called');
    String? result = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select where to save the file:',
      fileName: 'steam.dat',
    );
    if (result == null) {
      await log(LogLevel.debug, 'No file selected');
      return;
    }
    await log(LogLevel.debug, 'Exporting save file in Steam format');
    try {
      File rawFile = File(result);
      List<int> contents = saveFile.exportSteam();
      await logFlush();
      await rawFile.writeAsBytes(contents);
    } on FileSystemException catch (e) {
      await _handleFileSystemException(e);
      return;
    } on Exception catch (e, s) {
      await handleUnexpectedException(e, s);
      return;
    }
    await log(LogLevel.info, 'Steam save file exported successfully');
    await showCommonDialog(
      const TSuccessDialog(title: 'Save file exported successfully'),
    );
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await CharacterRoster.precachePortraits(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _alertUnexportedChanges,
      child: CommonScaffold(
        title: 'Touhou Labyrinth 2 Save Editor - Menu',
        settingsLink: navigateToSettings,
        children: <Widget>[
          const SpacedRow(
            spacer: SizedBox(width: 20),
            children: <Widget>[
              TButton(
                text: 'General Data',
                icon: Icons.info_outline,
              ),
              TButton(
                text: 'Event Data',
                icon: Icons.warning_amber,
              ),
            ],
          ),
          SpacedRow(
            spacer: const SizedBox(width: 20),
            children: <Widget>[
              TButton(
                text: 'Character Data',
                icon: Icons.person,
                onPressed: navigateToCharacterData,
              ),
              TButton(
                text: 'Party Data',
                icon: Icons.groups,
                onPressed: navigateToPartyEdit,
              ),
            ],
          ),
          const SpacedRow(
            spacer: SizedBox(width: 20),
            children: <Widget>[
              TButton(
                text: 'Achievement Data',
                icon: Icons.star_border_purple500,
              ),
              TButton(
                text: 'Bestiary Data',
                icon: Icons.school_outlined,
              )
            ],
          ),
          SpacedRow(
            spacer: const SizedBox(width: 20),
            children: <Widget>[
              TButton(
                text: 'Inventory Data',
                icon: Icons.inventory_2_outlined,
                onPressed: navigateToItemEdit,
              ),
              const TButton(
                text: 'Map Data',
                icon: Icons.map,
              ),
            ],
          ),
          const Divider(),
          SpacedRow(
            spacer: const SizedBox(width: 20),
            children: <Widget>[
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
        ],
      ),
    );
  }
}
