import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/widgets/button.dart';

abstract class CommonState<T extends StatefulWidget> extends State<T> {
  final Logger logger = Logger();
  final SaveFileWrapper saveFileWrapper = SaveFileWrapper();

  final List<String> characterFilenames = <String>[
    'Reimu', 'Marisa', 'Kourin', 'Keine',
    'Momiji', 'Youmu', 'Kogasa', 'Rumia',
    'Cirno', 'Minoriko', 'Komachi', 'Chen',
    'Nitori', 'Parsee', 'Wriggle', 'Kaguya',
    'Mokou', 'Aya', 'Mystia', 'Kasen',
    'Nazrin', 'Hina', 'Rin', 'Utsuho',
    'Satori', 'Yuugi', 'Meirin', 'Alice',
    'Patchouli', 'Eirin', 'Reisen', 'Sanae',
    'Iku', 'Suika', 'Ran', 'Remilia',
    'Sakuya', 'Kanako', 'Suwako', 'Tensi',
    'Flandre', 'Yuyuko', 'Yuuka', 'Yukari',
    'Hijiri', 'Eiki', 'Renko', 'Maribel',
    'Toramaru', 'Mamizou', 'Futo', 'Miko',
    'Kokoro', 'Tokiko', 'Koisi', 'Akyuu'
  ];

  String getCharacterFilename(CharacterName c) {
    return characterFilenames[c.index];
  }

  List<U> buildSeparatedList<U>(
    List<U> base,
    U separator, {
    bool separateEnds = false,
  }) {
    List<U> result = <U>[];
    if (separateEnds) {
      result.add(separator);
    }
    for (int i = 0; i < base.length - 1; i++) {
      result.addAll(<U>[base[i], separator]);
    }
    result.add(base[base.length - 1]);
    if (separateEnds) {
      result.add(separator);
    }
    return result;
  }

  Row makeRowFromWidgets(List<Widget> widgets, {bool expanded = false}) {
    if (expanded) {
      widgets = widgets.map((Widget w)=>Expanded(child: w)).toList();
    } else {
      widgets = widgets.map((Widget w)=>Flexible(child: w)).toList();
    }
    return Row(
      children: buildSeparatedList(
        widgets,
        const SizedBox(width: 20),
      ),
    );
  }

  Future<bool> showUnsavedChangesDialog() async {
    Widget title = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        Icon(Icons.warning, color: Colors.red, size: 30),
        SizedBox(width: 10),
        Flexible(
          child: Text(
            'You have unsaved changes!',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
    List<Widget> actions = <Widget>[
      TButton(
        text: 'Yes, discard them',
        icon: Icons.check_circle_outline,
        usesMaxWidth: false,
        fontSize: 16,
        onPressed: () {
          Navigator.of(context).pop(true);
        },
      ),
      TButton(
        text: 'No, keep me here',
        icon: Icons.cancel_outlined,
        usesMaxWidth: false,
        fontSize: 16,
        onPressed: () {
          Navigator.of(context).pop(false);
        },
      ),
    ];
    bool? canDiscard = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title,
          content: const Text(
            'Are you sure you want to go back and discard your changes?',
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
          actions: <Widget>[
            Wrap(
              runSpacing: 10,
              spacing: 20,
              children: actions,
            ),
          ],
        );
      },
    );
    return canDiscard ?? false;
  }
}
