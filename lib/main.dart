import 'dart:io';
import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/views/main.dart';
import 'package:thlaby2_save_editor/views/settings.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // If settings file doesn't exist, create one from defaults
  File settingsFile = File('./settings.json');
  try {
    if (!settingsFile.existsSync()) {
      Settings settings = Settings.fromDefault();
      settingsFile.writeAsStringSync('${settings.toJson()}\n');
    }
  } catch (e) {
    // Failed to create a default settings file, keep going as is
  }
  // Set minimum width and height to stop my responsive nightmares
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Touhou Labyrinth 2 Save Editor');
    setWindowMinSize(const Size(800, 400));
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
        primarySwatch: Colors.green,
        scrollbarTheme: ScrollbarThemeData(
          trackColor: MaterialStateProperty.all(Colors.white.withOpacity(0.5)),
          thumbColor: MaterialStateProperty.all(Colors.green),
          trackVisibility: MaterialStateProperty.all(true),
          thumbVisibility: MaterialStateProperty.all(true),
        ),
      ),
      home: const MainWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}
