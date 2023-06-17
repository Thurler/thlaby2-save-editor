import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/common.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/widgets/common_scaffold.dart';
import 'package:thlaby2_save_editor/widgets/form.dart';
import 'package:thlaby2_save_editor/widgets/rounded_border.dart';
import 'package:thlaby2_save_editor/widgets/save_button.dart';

class Settings {
  late LogLevel logLevel;

  Settings.from(Settings other) : logLevel = other.logLevel;

  Settings.fromDefault() : logLevel = LogLevel.info;

  Settings.fromJson(String raw) {
    Map<String, dynamic> jsonContents = json.decode(raw);
    if (jsonContents.containsKey('logLevel')) {
      logLevel = LogLevel.values.firstWhere(
        (LogLevel l) => l.name == jsonContents['logLevel'],
      );
    } else {
      logLevel = LogLevel.info;
    }
  }

  String toJson() {
    Map<String, dynamic> result = <String, dynamic>{
      'logLevel': logLevel.name,
    };
    return json.encode(result);
  }
}

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key});

  @override
  State<SettingsWidget> createState() => SettingsState();
}

class SettingsState extends CommonState<SettingsWidget> {
  static const List<String> _options = <String>[
    'Debug (everything is logged)',
    'Info (major actions and higher are logged)',
    'Warning (warnings and higher are logged)',
    'Error (only errors are logged)',
    'None (nothing is logged)',
  ];

  late Settings _original;
  late Settings _editable;

  bool _hasChanges() {
    return _editable.logLevel != _original.logLevel;
  }

  Future<bool> _checkChangesAndConfirm() async {
    if (!_hasChanges()) {
      return true;
    }
    bool canDiscard = await showUnsavedChangesDialog();
    if (canDiscard) {
      await logger.log(LogLevel.info, 'Discarding changes to settings');
    }
    return canDiscard;
  }

  Future<void> _handleFileSystemException(FileSystemException e) {
    return handleException(
      logMessage: 'FileSystem Exception when saving settings: ${e.message}',
      dialogTitle: 'An error occured when saving the settings!',
      dialogBody: 'Make sure your user has permission to write a file in '
        'the folder this app is in.',
    );
  }

  Future<void> _saveChanges() async {
    try {
      File settingsFile = File('./settings.json');
      settingsFile.writeAsStringSync('${_editable.toJson()}\n');
    } on FileSystemException catch (e) {
      await _handleFileSystemException(e);
      return;
    } on Exception catch (e, s) {
      await handleUnexpectedException(e, s);
      return;
    }
    await logger.log(
      LogLevel.info,
      'Applying log level ${_editable.logLevel.name}',
    );
    await logger.log(LogLevel.info, 'Saved changes');
    setState(() {
      _original = Settings.from(_editable);
      logger.logLevel = _editable.logLevel;
    });
  }

  Future<void> _changeLogLevel(String? chosen) async {
    if (chosen == null) {
      return;
    }
    LogLevel chosenLevel = LogLevel.values[_options.indexOf(chosen)];
    await logger.log(
      LogLevel.debug,
      'Log level changed to ${chosenLevel.name}',
    );
    setState(() {
      _editable.logLevel = chosenLevel;
    });
  }

  @override
  void initState() {
    super.initState();
    _original = Settings.fromDefault();
    try {
      File settingsFile = File('./settings.json');
      if (settingsFile.existsSync()) {
        _original = Settings.fromJson(settingsFile.readAsStringSync());
      }
    } catch (e) {
      // If we fail to load the settings file, keep going with default settings
    }
    _editable = Settings.from(_original);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _checkChangesAndConfirm,
      child: CommonScaffold(
        title: 'Touhou Labyrinth 2 Save Editor - Settings',
        floatingActionButton: _hasChanges()
          ? TSaveButton(onPressed: _saveChanges)
          : null,
        children: <Widget>[
          RoundedBorder(
            color: TFormTitle.subtitleColor,
            childPadding: const EdgeInsets.only(right: 15),
            child: TForm(
              title: const TFormTitle(
                title: 'Log level',
                subtitle: 'Specifies severity of information to be logged',
              ),
              field: TFormDropdownField(
                hintText: 'Select a log level',
                options: _options,
                onChanged: _changeLogLevel,
                value: _options[_editable.logLevel.index],
                enabled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
