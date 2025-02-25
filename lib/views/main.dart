import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tfields/logger.dart';
import 'package:tfields/mixins/alert.dart';
import 'package:tfields/mixins/loggable.dart';
import 'package:tfields/mixins/settings_reader.dart';
import 'package:tfields/mixins/update_checker.dart';
import 'package:tfields/settings.dart';
import 'package:tfields/update_checker.dart';
import 'package:tfields/widgets/button.dart';
import 'package:tfields/widgets/common_scaffold.dart';
import 'package:tfields/widgets/dialog.dart';
import 'package:tfields/widgets/spaced_row.dart';
import 'package:tfields/widgets/update_status.dart';
import 'package:thlaby2_save_editor/mixins/navigate.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/widgets/exception.dart';

class MainUpdateCheck extends UpdateCheck {
  @override
  String get githubEndpoint =>
      'https://api.github.com/repos/thurler/thlaby2-save-editor/releases/latest';
}

class MainWidget extends StatefulWidget {
  static const String version = '0.5.1';

  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => MainState();
}

class MainState extends State<MainWidget>
    with
        SaveReader,
        SaveWriter,
        Loggable,
        SettingsReader<CommonSettings>,
        CommonSettingsReader,
        UpdateChecker<MainUpdateCheck>,
        AlertHandler<MainWidget>,
        Navigatable<MainWidget> {
  @override
  void updateCheckCallback() => setState(() {});

  @override
  Future<void> navigateToSettings() async {
    await super.navigateToSettings();
    setState(() {
      loadSettings();
    });
    unawaited(checkForUpdates(MainWidget.version));
  }

  @override
  MainUpdateCheck get updateChecker => MainUpdateCheck();

  Future<void> _handleFileSystemException(FileSystemException e) {
    return handleException(
      logMessage: 'FileSystem Exception when loading file: ${e.message}',
      dialogTitle: 'An error occured when reading the file!',
      dialogBody: 'Make sure your user has permission to read the file you '
          'chose.',
    );
  }

  Future<void> _handleSteamException(String logMessage) {
    return handleException(
      logMessage: logMessage,
      dialogTitle: 'The selected file is invalid!',
      dialogBody: 'Make sure you chose a Steam save file. It should be a file '
          'like "save1.dat" inside the %APPDATA%/CUBETYPE/tohoLaby folder.',
    );
  }

  Future<void> _loadSteamSaveFile() async {
    await log(LogLevel.debug, 'Load Steam Save File called');
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['dat'],
    );
    if (result == null) {
      await log(LogLevel.debug, 'No file selected');
      return;
    }
    try {
      await log(LogLevel.info, 'Loading save file in Steam format');
      String path = result.files.first.path ?? '';
      String name = path.split('/').last.split(r'\').last;
      await log(LogLevel.debug, 'File selected: $name');
      File rawFile = File(path);
      List<int> bytes = await rawFile.readAsBytes();
      saveFile = SaveFile.fromSteamBytes(bytes);
      await logFlush();
      await log(LogLevel.info, 'Steam save file loaded successfully');
    } on FileSystemException catch (e) {
      await _handleFileSystemException(e);
      return;
    } on FileSizeException {
      await _handleSteamException(
        'File loaded does not have correct number of bytes',
      );
      return;
    } on InvalidHeaderException {
      await _handleSteamException(
        'File loaded does not have the correct header bytes',
      );
      return;
    } on Exception catch (e, s) {
      await handleUnexpectedException(
        e,
        s,
        dialogBody: ExceptionWidget.dialogBody,
      );
      return;
    }
    if (saveFile.loadedWithErrors) {
      await showCommonDialog(
        TDialog.warning(
          titleText: 'The loaded save file had errors',
          bodyText: 'Some of the data that was read seemed to contain invalid '
              'values. Please check the "applicationlog.txt" file for more '
              'information.\n\nIf you are sure the uploaded file was not '
              'tampered with, please report this as an issue at the link '
              'below, including your save file and the "applicationlog.txt" '
              'file:\nhttps://github.com/Thurler/thlaby2-save-editor/issues',
          confirmText: 'OK',
        ),
      );
      return;
    }
    return navigateToMainMenu();
  }

  @override
  void initState() {
    super.initState();
    loadSettings();
    unawaited(checkForUpdates(MainWidget.version));
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Touhou Labyrinth 2 Save Editor',
      settingsLink: navigateToSettings,
      children: <Widget>[
        Image.asset('img/title.png'),
        const Text('Version ${MainWidget.version}'),
        if (settings.checkUpdates)
          UpdateStatus(
            hasCheckedForUpdates: updateChecker.hasCheckedForUpdates,
            updateCheckSucceeded: updateChecker.updateCheckSucceeded,
            hasUpdate: updateChecker.hasUpdate,
            latestVersion: updateChecker.latestVersion,
            onUpdateTap: updateChecker.openLatestVersion,
          ),
        TSpacedRow(
          spacer: const SizedBox(width: 20),
          children: <Widget>[
            const TButton(
              text: 'Open DLSite save file',
              icon: Icons.upload_file,
            ),
            TButton(
              text: 'Open Steam save file',
              icon: Icons.upload_file,
              onPressed: _loadSteamSaveFile,
            ),
          ],
        ),
      ],
    );
  }
}
