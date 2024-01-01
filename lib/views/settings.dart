import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/mixins/alert.dart';
import 'package:thlaby2_save_editor/mixins/discardablechanges.dart';
import 'package:thlaby2_save_editor/mixins/exception.dart';
import 'package:thlaby2_save_editor/widgets/common_scaffold.dart';
import 'package:thlaby2_save_editor/widgets/form.dart';
import 'package:thlaby2_save_editor/widgets/rounded_border.dart';

class Settings {
  LogLevel logLevel = LogLevel.info;
  bool checkUpdates = true;

  Settings.from(Settings other) :
    logLevel = other.logLevel,
    checkUpdates = other.checkUpdates;

  Settings.fromDefault();

  Settings.fromJson(String raw) {
    Map<String, dynamic> jsonContents = json.decode(raw);
    if (jsonContents.containsKey('logLevel')) {
      logLevel = LogLevel.fromName(jsonContents['logLevel']);
    }
    if (jsonContents.containsKey('checkUpdates')) {
      checkUpdates = jsonContents['checkUpdates'];
    }
  }

  String toJson() {
    Map<String, dynamic> result = <String, dynamic>{
      'logLevel': logLevel.name,
      'checkUpdates': checkUpdates,
    };
    return json.encode(result);
  }
}

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key});

  @override
  State<SettingsWidget> createState() => SettingsState();
}

class SettingsState extends State<SettingsWidget>
    with
        SettingsReader,
        Loggable,
        AlertHandler<SettingsWidget>,
        ExceptionHandler<SettingsWidget>,
        DiscardableChanges<SettingsWidget> {
  final List<String> _options = LogLevel.values.map(
    (LogLevel level) => level.dropdownText,
  ).toList();

  late TFormDropdown _logLevelForm;
  final DropdownFormKey _logLevelFormKey = DropdownFormKey();

  late TFormSwitch _checkUpdatesForm;
  final SwitchFormKey _checkUpdatesFormKey = SwitchFormKey();

  @override
  bool get hasChanges =>
      (_logLevelFormKey.currentState?.hasChanges ?? false) ||
      (_checkUpdatesFormKey.currentState?.hasChanges ?? false);

  Future<void> _handleFileSystemException(FileSystemException e) {
    return handleException(
      logMessage: 'FileSystem Exception when saving settings: ${e.message}',
      dialogTitle: 'An error occured when saving the settings!',
      dialogBody: 'Make sure your user has permission to write a file in '
          'the folder this app is in.',
    );
  }

  @override
  Future<void> saveChanges() async {
    String chosenLogLevel = _logLevelFormKey.currentState!.value;
    settings.logLevel = LogLevel.values[_options.indexOf(chosenLogLevel)];
    settings.checkUpdates = _checkUpdatesFormKey.currentState!.value;
    try {
      File settingsFile = File('./settings.json');
      settingsFile.writeAsStringSync('${settings.toJson()}\n');
    } on FileSystemException catch (e) {
      await _handleFileSystemException(e);
      return;
    } on Exception catch (e, s) {
      await handleUnexpectedException(e, s);
      return;
    }
    await log(
      LogLevel.info,
      'Applying log level ${settings.logLevel.name}',
    );
    await log(LogLevel.info, 'Saved settings changes');
    logLevel = settings.logLevel;
    // Reset initial value to remove the has changes flag
    _logLevelFormKey.currentState!.resetInitialValue();
    _checkUpdatesFormKey.currentState!.resetInitialValue();
    setState(() {});
  }

  Future<void> _changeLogLevel(String? chosen) async {
    if (chosen == null) {
      return;
    }
    LogLevel chosenLevel = LogLevel.values[_options.indexOf(chosen)];
    await log(
      LogLevel.debug,
      'Log level changed to ${chosenLevel.name}',
    );
    // Refresh has changes flag
    setState(() {});
  }

  Future<void> _changeUpdateCheck(bool? chosen) async {
    if (chosen == null) {
      return;
    }
    await log(
      LogLevel.debug,
      'Auto update checks ${chosen ? 'enabled' : 'disabled'}',
    );
    // Refresh has changes flag
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadSettings();
    _logLevelForm = TFormDropdown(
      enabled: true,
      title: 'Log level',
      subtitle: 'Specifies severity of information to be logged',
      hintText: 'Select a log level',
      options: _options,
      initialValue: _options[settings.logLevel.index],
      onValueChanged: _changeLogLevel,
      key: _logLevelFormKey,
    );
    _checkUpdatesForm = TFormSwitch(
      enabled: true,
      title: 'Check for updates',
      subtitle: 'Whether to check for updates on startup',
      offText: "Don't check for updates",
      onText: 'Check for updates',
      onValueChanged: _changeUpdateCheck,
      initialValue: settings.checkUpdates,
      key: _checkUpdatesFormKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: checkChangesAndConfirm,
      child: CommonScaffold(
        title: 'Touhou Labyrinth 2 Save Editor - Settings',
        floatingActionButton: saveButton,
        children: <Widget>[
          RoundedBorder(
            color: TFormTitle.subtitleColor,
            childPadding: const EdgeInsets.only(right: 15),
            child: _logLevelForm,
          ),
          RoundedBorder(
            color: TFormTitle.subtitleColor,
            childPadding: const EdgeInsets.only(right: 15),
            child: _checkUpdatesForm,
          ),
        ],
      ),
    );
  }
}

mixin SettingsReader {
  late Settings settings;

  void loadSettings() {
    try {
      File settingsFile = File('./settings.json');
      if (settingsFile.existsSync()) {
        settings = Settings.fromJson(settingsFile.readAsStringSync());
      }
    } catch (e) {
      // If we fail to load the settings file, keep going with default settings
      settings = Settings.fromDefault();
    }
  }
}
