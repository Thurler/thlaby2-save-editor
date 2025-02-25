import 'package:flutter/material.dart';
import 'package:tfields/settings.dart';
import 'package:tfields/views/settings.dart';
import 'package:thlaby2_save_editor/widgets/exception.dart';

class CommonSettingsWidget extends AbstractSettingsWidget<CommonSettings> {
  const CommonSettingsWidget({required super.title, super.key});

  @override
  State<CommonSettingsWidget> createState() => CommonSettingsState();
}

class CommonSettingsState
    extends AbstractSettingsState<CommonSettings, CommonSettingsWidget> {
  @override
  CommonSettings settingsFromJson(String fileContents) =>
      CommonSettings.fromJson(fileContents);

  @override
  CommonSettings settingsFromDefault() => CommonSettings.fromDefault();

  @override
  List<Widget> get additionalForms => const <Widget>[];

  @override
  String get unhandledExceptionMessage => ExceptionWidget.dialogBody;
}
