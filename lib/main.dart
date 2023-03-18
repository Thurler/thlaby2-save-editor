import 'package:flutter/material.dart';

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
  Future<void> _loadDLSiteSaveFile() async {
    // Do nothing for now
  }

  Future<void> _loadSteamSaveFile() async {
    // Do nothing for now
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = <Widget>[
      Flexible(
        child: TButton(
          text: 'Open DLSite save file',
          onPressed: _loadDLSiteSaveFile,
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
