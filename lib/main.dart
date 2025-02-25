import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tfields/settings.dart';
import 'package:thlaby2_save_editor/views/main.dart';
import 'package:thlaby2_save_editor/widgets/exception.dart';
import 'package:window_size/window_size.dart';

/// Globally access the minimum window width/height constraints
class GlobalWindowConstraints {
  /// Minimum width
  static const double width = 800;

  /// Minimum height
  static const double height = 400;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // If settings file doesn't exist, create one from defaults
  File settingsFile = File('./settings.json');
  try {
    if (!settingsFile.existsSync()) {
      CommonSettings settings = CommonSettings.fromDefault();
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Touhou Labyrinth 2 Save Editor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        scrollbarTheme: ScrollbarThemeData(
          trackColor: WidgetStateProperty.all(Colors.white.withOpacity(0.5)),
          thumbColor: WidgetStateProperty.all(Colors.green),
          trackVisibility: WidgetStateProperty.all(true),
          thumbVisibility: WidgetStateProperty.all(true),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainWidget(),
      builder: (BuildContext context, Widget? widget) {
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return ExceptionWidget(details: details);
        };
        return widget!;
      },
    );
  }
}
