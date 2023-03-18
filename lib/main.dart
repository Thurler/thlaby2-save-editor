import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/common.dart';
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
      ),
      home: const MainWidget(title: 'Touhou Labyrinth 2 Save Editor'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget({required this.title, super.key});

  final String title;

  @override
  State<MainWidget> createState() => MainState();
}

class MainState extends CommonState<MainWidget> {
  Future<void> _loadSteamSaveFile() async {
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
      saveFile = SteamSaveFile.fromBytes(bytes);
    } on FileSystemException {
      // Do nothing for now
    } on FileSizeException {
      // Do nothing for now
    } on InvalidHeaderException {
      // Do nothing for now
    } catch (e) {
      await logger.log(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = <Widget>[
      const Flexible(
        child: TButton(
          text: 'Open DLSite save file',
        ),
      ),
      Flexible(
        child: TButton(
          text: 'Open Steam save file',
          onPressed: _loadSteamSaveFile,
        ),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset('img/title.png'),
              ),
              Row(
                children: buildSeparatedList<Widget>(
                  buttons,
                  const SizedBox(width: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
