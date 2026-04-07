import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfields/logging.dart';
import 'package:tfields/settings.dart';
import 'package:tfields/theme.dart';
import 'package:tfields/update_check.dart';
import 'package:tfields/widgets.dart';
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
        SaveEditor,
        TLoggable,
        TSettingsJsonReader<TCommonSettings>,
        TCommonSettingsDeserializer,
        TUpdateChecker<MainUpdateCheck>,
        TDialogDisplayer<MenuWidget>,
        TDiscardableChanges<MenuWidget>,
        Navigatable<MenuWidget> {
  Future<void> _handleFileSystemException(FileSystemException e) {
    return showException(
      'An error occured when exporting the file!',
      logMessage: 'FileSystem Exception when exporting file: ${e.message}',
      body: 'Make sure your user has permission to write the file in the '
          'folder you chose.',
    );
  }

  Future<void> _saveSteamSaveFile() async {
    await log(TLogLevel.debug, 'Export Steam Save File called');
    String? result = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select where to save the file:',
      fileName: 'steam.dat',
    );
    if (result == null) {
      await log(TLogLevel.debug, 'No file selected');
      return;
    }
    await log(TLogLevel.debug, 'Exporting save file in Steam format');
    try {
      File rawFile = File(result);
      Uint8List contents = saveFile.exportSteam();
      await logFlush();
      await rawFile.writeAsBytes(contents);
    } on FileSystemException catch (e) {
      await _handleFileSystemException(e);
      return;
    } on Exception catch (e, s) {
      await showUnexpectedException(e, s, body: ExceptionWidget.dialogBody);
      return;
    }
    await log(TLogLevel.info, 'Steam save file exported successfully');
    await showSuccess('Save file exported successfully');
  }

  @override
  MainUpdateCheck updateChecker = MainUpdateCheck();

  @override
  void updateCheckCallback() => setState(() {});

  @override
  Future<bool> showUnsavedChangesDialog() async {
    bool canReturn = await showConfirmation(
      'Are you sure you want to go back and load a different save file? Any '
      'changes that have not been exported will be discarded!',
      title: 'Did you export your changes?',
      confirmText: 'Yes, change files',
      cancelText: 'No, keep me here',
    );
    if (canReturn) {
      await log(TLogLevel.info, 'User confirmed going back to file select');
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
      readSettings();
    });
    if (settings.checkUpdates) {
      unawaited(checkForUpdates(MainWidget.version));
    }
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await CharacterRoster.precachePortraits(context);
    if (settings.checkUpdates) {
      unawaited(checkForUpdates(MainWidget.version));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !hasChanges,
      onPopInvokedWithResult: onPopInvoked,
      child: TCommonScaffold(
        title: 'Touhou Labyrinth 2 Save Editor - Menu',
        settingsLink: navigateToSettings,
        themeToggleCallback: Provider.of<TThemeProvider>(context).changeTheme,
        children: <Widget>[
          TGridRow(
            mdFlexLimit: 2,
            lgFlexLimit: 3,
            xxlFlexLimit: 4,
            children: <TGridItem>[
              TGridItem(
                child: TButton.elevated(
                  usesMaxWidth: true,
                  text: 'General Data',
                  icon: const TIcon(icon: Icons.info_outline),
                ),
              ),
              TGridItem(
                child: TButton.elevated(
                  usesMaxWidth: true,
                  text: 'Event Data',
                  icon: const TIcon(icon: Icons.warning_amber),
                ),
              ),
              TGridItem(
                child: TButton.elevated(
                  usesMaxWidth: true,
                  text: 'Character Data',
                  icon: const TIcon(icon: Icons.person),
                  onPressed: navigateToCharacterData,
                ),
              ),
              TGridItem(
                child: TButton.elevated(
                  usesMaxWidth: true,
                  text: 'Party Data',
                  icon: const TIcon(icon: Icons.groups),
                  onPressed: navigateToPartyEdit,
                ),
              ),
              TGridItem(
                child: TButton.elevated(
                  usesMaxWidth: true,
                  text: 'Achievement Data',
                  icon: const TIcon(icon: Icons.star_border_purple500),
                ),
              ),
              TGridItem(
                child: TButton.elevated(
                  usesMaxWidth: true,
                  text: 'Bestiary Data',
                  icon: const TIcon(icon: Icons.school_outlined),
                ),
              ),
              TGridItem(
                child: TButton.elevated(
                  usesMaxWidth: true,
                  text: 'Inventory Data',
                  icon: const TIcon(icon: Icons.inventory_2_outlined),
                  onPressed: navigateToItemEdit,
                ),
              ),
              TGridItem(
                child: TButton.elevated(
                  usesMaxWidth: true,
                  text: 'Map Data',
                  icon: const TIcon(icon: Icons.map),
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: <Widget>[
              TButton.elevated(
                text: 'Export as DLSite save',
                icon: const TIcon(icon: Icons.save),
              ),
              TButton.elevated(
                text: 'Export as Steam save',
                icon: const TIcon(icon: Icons.save),
                onPressed: _saveSteamSaveFile,
              ),
            ],
          ),
          const Text('Version ${MainWidget.version}'),
          if (settings.checkUpdates)
            TUpdateStatus(
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
