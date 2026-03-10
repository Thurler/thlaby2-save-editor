import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tfields/settings.dart';
import 'package:tfields/theme.dart';
import 'package:thlaby2_save_editor/views/main.dart';
import 'package:thlaby2_save_editor/widgets/exception.dart';
import 'package:window_size/window_size.dart';

/// Globally access the minimum window width/height constraints
class GlobalWindowConstraints {
  /// Minimum width
  static const double width = 640;

  /// Minimum height
  static const double height = 360;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // If settings file doesn't exist, create one from defaults
  File settingsFile = File('./settings.json');
  try {
    if (!settingsFile.existsSync()) {
      TCommonSettings settings = TCommonSettings.fromDefault();
      settingsFile.writeAsStringSync('${settings.toJson()}\n');
    }
  } catch (e) {
    // Failed to create a default settings file, keep going as is
  }
  // Set minimum width and height to stop my responsive nightmares
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Touhou Labyrinth 2 Save Editor');
    setWindowMinSize(
      const Size(GlobalWindowConstraints.width, GlobalWindowConstraints.height),
    );
  }
  runApp(
    TThemedApp(
      themeBuilder: (Color color, _) => CommonSettingsThemeProvider(color),
      title: 'Touhou Labyrinth 2 Save Editor',
      seedColor: Colors.green,
      home: const MainWidget(),
      materialAppBuilder: (BuildContext context, Widget? widget) {
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return ExceptionWidget(details: details);
        };
        return widget!;
      },
    ),
  );
}
