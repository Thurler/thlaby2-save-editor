import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/common.dart';
import 'package:thlaby2_save_editor/list_extension.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/menu.dart';
import 'package:thlaby2_save_editor/steam.dart';
import 'package:thlaby2_save_editor/widgets/button.dart';
import 'package:thlaby2_save_editor/widgets/dialog.dart';

void main() {
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
          thumbColor: MaterialStateProperty.all(Colors.green),
          thumbVisibility: MaterialStateProperty.all(true),
        ),
      ),
      home: const MainWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => MainState();
}

class MainState extends CommonState<MainWidget> {
  Future<void> _handleException({
    required String logMessage,
    required String dialogTitle,
    required String dialogBody,
  }) async {
    await logger.log(LogLevel.error, logMessage);
    await showErrorDialog(
      TDialog(
        title: dialogTitle,
        body: dialogBody,
        confirmText: 'OK',
      ),
    );
  }

  Future<void> _handleFileSystemException(FileSystemException e) {
    return _handleException(
      logMessage: 'FileSystem Exception when loading file: ${e.message}',
      dialogTitle: 'An error occured when reading the file!',
      dialogBody: 'Make sure your user has permission to read the file you '
        'chose.',
    );
  }

  Future<void> _handleSteamException(String logMessage) {
    return _handleException(
      logMessage: logMessage,
      dialogTitle: 'The selected file is invalid!',
      dialogBody: 'Make sure you chose a Steam save file. It should be a file '
        'like "save1.dat" inside the %APPDATA%/CUBETYPE/tohoLaby folder.',
    );
  }

  Future<void> _handleUnexpectedException(String logMessage) {
    return _handleException(
      logMessage: logMessage,
      dialogTitle: 'An unexpected error occured!',
      dialogBody: 'Please report this as an issue at the link below. Please '
        'include the "applicationlog.txt" file that should be next to your '
        '.exe file when submitting the issue:\n '
        'https://github.com/Thurler/thlaby2-save-editor/issues',
    );
  }

  Future<void> _loadSteamSaveFile() async {
    NavigatorState state = Navigator.of(context);
    await logger.log(LogLevel.debug, 'Load Steam Save File called');
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['dat'],
    );
    if (result == null) {
      await logger.log(LogLevel.debug, 'No file selected');
      return;
    }
    try {
      String path = result.files.first.path ?? '';
      String name = path.split('/').last.split(r'\').last;
      await logger.log(LogLevel.debug, 'File selected: $name');
      File rawFile = File(path);
      List<int> bytes = await rawFile.readAsBytes();
      StringBuffer logBuffer = StringBuffer();
      saveFileWrapper.saveFile = SteamSaveFile.fromBytes(bytes, logBuffer);
      for (String line in LineSplitter.split(logBuffer.toString())) {
        await logger.log(LogLevel.debug, line);
      }
      await logger.log(LogLevel.debug, 'File loaded successfully');
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
    } catch (e, s) {
      await _handleUnexpectedException('Unknown exception: $e | $s');
      return;
    }
    if (!state.mounted) {
      return;
    }
    await state.push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const MenuWidget(),
      ),
    );
  }

  Future<void> _logApplicationStart() async {
    await logger.log(LogLevel.info, Logger.delimiter);
    await logger.log(LogLevel.info, 'Save Editor v0.1.0 opened');
  }

  @override
  void initState() {
    super.initState();
    // ignore: discarded_futures
    _logApplicationStart();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = <Widget>[
      const TButton(
        text: 'Open DLSite save file',
        icon: Icons.upload_file,
      ),
      TButton(
        text: 'Open Steam save file',
        onPressed: _loadSteamSaveFile,
        icon: Icons.upload_file,
      ),
    ];
    List<Widget> columnChildren = <Widget>[
      Image.asset('img/title.png'),
      makeRowFromWidgets(buttons),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Touhou Labyrinth 2 Save Editor'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: columnChildren.separateWith(
                const SizedBox(height: 20),
                separatorOnEnds: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
