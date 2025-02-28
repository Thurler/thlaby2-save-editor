import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tfields/logger.dart';
import 'package:tfields/mixins/alert.dart';
import 'package:tfields/mixins/discardable_changes.dart';
import 'package:tfields/mixins/loggable.dart';
import 'package:tfields/mixins/settings_reader.dart';
import 'package:tfields/mixins/update_checker.dart';
import 'package:tfields/settings.dart';
import 'package:tfields/widgets/button.dart';
import 'package:tfields/widgets/common_scaffold.dart';
import 'package:tfields/widgets/dialog.dart';
import 'package:tfields/widgets/spaced_row.dart';
import 'package:tfields/widgets/update_status.dart';
import 'package:thlaby2_save_editor/mixins/navigate.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/views/main.dart';
import 'package:thlaby2_save_editor/widgets/character_roster.dart';
import 'package:thlaby2_save_editor/widgets/exception.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({super.key});

  @override
  State<MenuWidget> createState() => MenuState();
}

class MenuState extends State<MenuWidget>
    with
        SaveReader,
        Loggable,
        SettingsReader<CommonSettings>,
        CommonSettingsReader,
        UpdateChecker<MainUpdateCheck>,
        AlertHandler<MenuWidget>,
        DiscardableChanges<MenuWidget>,
        Navigatable<MenuWidget> {
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
      Uint8List contents = saveFile.exportSteam();
      await logFlush();
      await rawFile.writeAsBytes(contents);
    } on FileSystemException catch (e) {
      await _handleFileSystemException(e);
      return;
    } on Exception catch (e, s) {
      await handleUnexpectedException(
        e,
        s,
        dialogBody: ExceptionWidget.dialogBody,
      );
      return;
    }
    await log(LogLevel.info, 'Steam save file exported successfully');
    await showCommonDialog(
      TDialog.success(titleText: 'Save file exported successfully'),
    );
  }

  @override
  MainUpdateCheck updateChecker = MainUpdateCheck();

  @override
  void updateCheckCallback() => setState(() {});

  @override
  Future<bool> showUnsavedChangesDialog() async {
    TDialog dialog = TDialog.boolWarning(
      titleText: 'Did you export your changes?',
      bodyText: 'Are you sure you want to go back and load a different save '
          'file? Any changes that have not been exported will be discarded!',
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

  @override
  bool get hasChanges => true;

  @override
  Future<void> saveChanges() async {}

  @override
  Future<void> navigateToSettings() async {
    await super.navigateToSettings();
    setState(() {
      loadSettings();
    });
    unawaited(checkForUpdates(MainWidget.version));
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await CharacterRoster.precachePortraits(context);
  }

  @override
  void initState() {
    super.initState();
    loadSettings();
    unawaited(checkForUpdates(MainWidget.version));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !hasChanges,
      onPopInvokedWithResult: onPopInvoked,
      child: CommonScaffold(
        title: 'Touhou Labyrinth 2 Save Editor - Menu',
        settingsLink: navigateToSettings,
        children: <Widget>[
          const TSpacedRow(
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
          TSpacedRow(
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
          const TSpacedRow(
            spacer: SizedBox(width: 20),
            children: <Widget>[
              TButton(
                text: 'Achievement Data',
                icon: Icons.star_border_purple500,
              ),
              TButton(
                text: 'Bestiary Data',
                icon: Icons.school_outlined,
              ),
            ],
          ),
          TSpacedRow(
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
          TSpacedRow(
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
          const Text('Version ${MainWidget.version}'),
          if (settings.checkUpdates)
            UpdateStatus(
              hasCheckedForUpdates: updateChecker.hasCheckedForUpdates,
              updateCheckSucceeded: updateChecker.updateCheckSucceeded,
              hasUpdate: updateChecker.hasUpdate,
              latestVersion: updateChecker.latestVersion,
              onUpdateTap: updateChecker.openLatestVersion,
            ),
        ],
      ),
    );
  }
}
