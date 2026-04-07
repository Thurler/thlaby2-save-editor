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
import 'package:thlaby2_save_editor/widgets/exception.dart';

class MainUpdateCheck extends TUpdateCheck {
  @override
  String get githubEndpoint =>
      'https://api.github.com/repos/thurler/thlaby2-save-editor/releases/latest';
}

class MainWidget extends StatefulWidget {
  static const String version = '0.6.0';

  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => MainState();
}

class MainState extends State<MainWidget>
    with
        SaveEditor,
        SaveLoader,
        TLoggable,
        TSettingsJsonReader<TCommonSettings>,
        TCommonSettingsDeserializer,
        TUpdateChecker<MainUpdateCheck>,
        TDialogDisplayer<MainWidget>,
        Navigatable<MainWidget> {
  @override
  void updateCheckCallback() => setState(() {});

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
  MainUpdateCheck updateChecker = MainUpdateCheck();

  Future<void> _handleFileSystemException(FileSystemException e) {
    return showException(
      'An error occured when reading the file!',
      logMessage: 'FileSystem Exception when loading file: ${e.message}',
      body: 'Make sure your user has permission to read the file you chose.',
    );
  }

  Future<void> _handleSteamException(String logMessage) {
    return showException(
      'The selected file is invalid!',
      logMessage: logMessage,
      body: 'Make sure you chose a Steam save file. It should be a file like '
          '"save1.dat" inside the %APPDATA%/CUBETYPE/tohoLaby folder.',
    );
  }

  Future<void> _loadSteamSaveFile() async {
    await log(TLogLevel.debug, 'Load Steam Save File called');
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['dat'],
    );
    if (result == null) {
      await log(TLogLevel.debug, 'No file selected');
      return;
    }
    try {
      await log(TLogLevel.info, 'Loading save file in Steam format');
      String path = result.files.first.path ?? '';
      String name = path.split('/').last.split(r'\').last;
      await log(TLogLevel.debug, 'File selected: $name');
      File rawFile = File(path);
      Uint8List bytes = await rawFile.readAsBytes();
      saveFile = SaveFile.fromSteamBytes(bytes);
      await logFlush();
      await log(TLogLevel.info, 'Steam save file loaded successfully');
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
      await showUnexpectedException(e, s, body: ExceptionWidget.dialogBody);
      return;
    }
    if (saveFile.loadedWithErrors) {
      await showWarning(
        'The loaded save file had errors',
        body: 'Some of the data that was read seemed to contain invalid '
            'values. Please check the "applicationlog.txt" file for more '
            'information.\n\nIf you are sure the uploaded file was not '
            'tampered with, please report this as an issue at the link '
            'below, including your save file and the "applicationlog.txt" '
            'file:\nhttps://github.com/Thurler/thlaby2-save-editor/issues',
      );
      return;
    }
    return navigateToMainMenu();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (settings.checkUpdates) {
      unawaited(checkForUpdates(MainWidget.version));
    }
  }

  @override
  Widget build(BuildContext context) {
    return TCommonScaffold(
      title: 'Touhou Labyrinth 2 Save Editor',
      settingsLink: navigateToSettings,
      themeToggleCallback: Provider.of<TThemeProvider>(context).changeTheme,
      children: <Widget>[
        Image.asset('img/title.png'),
        const Text('Version ${MainWidget.version}'),
        if (settings.checkUpdates)
          TUpdateStatus(
            hasCheckedForUpdates: updateChecker.hasCheckedForUpdates,
            updateCheckSucceeded: updateChecker.updateCheckSucceeded,
            hasUpdate: updateChecker.hasUpdate,
            latestVersion: updateChecker.latestVersion,
            onUpdateTap: updateChecker.openLatestVersion,
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: <Widget>[
            TButton.elevated(
              text: 'Open DLSite save file',
              icon: const TIcon(icon: Icons.upload_file),
            ),
            TButton.elevated(
              text: 'Open Steam save file',
              icon: const TIcon(icon: Icons.upload_file),
              onPressed: _loadSteamSaveFile,
            ),
          ],
        ),
      ],
    );
  }
}
