import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/common.dart';
import 'package:thlaby2_save_editor/menu.dart';
import 'package:thlaby2_save_editor/steam.dart';
import 'package:thlaby2_save_editor/widgets/button.dart';

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
  Future<void> _loadSteamSaveFile() async {
    NavigatorState state = Navigator.of(context);
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['dat'],
    );
    if (result == null) {
      return;
    }
    try {
      File rawFile = File(result.files.first.name);
      List<int> bytes = await rawFile.readAsBytes();
      saveFileWrapper.saveFile = SteamSaveFile.fromBytes(bytes);
    } on FileSystemException {
      // Do nothing for now
    } on FileSizeException {
      // Do nothing for now
    } on InvalidHeaderException {
      // Do nothing for now
    } catch (e) {
      await logger.log(e);
      return;
    }
    if (!state.mounted) {
      return;
    }
    await state.pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const MenuWidget(),
      ),
    );
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
              children: buildSeparatedList(
                columnChildren,
                const SizedBox(height: 20),
                separateEnds: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
