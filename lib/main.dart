import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:thlaby2_save_editor/logger.dart';
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
      home: const MyHomePage(title: 'Touhou Labyrinth 2 Save Editor'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<T> buildSeparatedList<T>(List<T> base, T separator) {
  List<T> result = <T>[separator];
  for (T element in base) {
    result.addAll(<T>[element, separator]);
  }
  return result;
}

class _MyHomePageState extends State<MyHomePage> {
  final Logger logger = Logger();

  Future<void> _loadSteamSaveFile() async {
    try {
      File f = File('save.dat');
      List<int> bytes = await f.readAsBytes();
      SteamSaveFile s = SteamSaveFile.fromBytes(bytes);
      await logger.log(s);
    } on FileSystemException {
      // Do nothing for now
    } on FileSizeException {
      // Do nothing for now
    } on InvalidHeaderException {
      // Do nothing for now
    } catch (e) {
      await logger.log(e);
    }
    print("shit's fine");
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
