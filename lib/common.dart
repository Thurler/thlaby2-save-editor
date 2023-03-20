import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/list_extension.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/widgets/dialog.dart';

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

  Row makeRowFromWidgets(List<Widget> widgets, {bool expanded = false}) {
    if (expanded) {
      widgets = widgets.map((Widget w)=>Expanded(child: w)).toList();
    } else {
      widgets = widgets.map((Widget w)=>Flexible(child: w)).toList();
    }
    return Row(
      children: widgets.separateWith(const SizedBox(width: 20)),
    );
  }

  Future<bool> showBoolDialog(TBoolDialog dialog) async {
    bool? canDiscard = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
    return canDiscard ?? false;
  }

  Future<bool> showUnsavedChangesDialog() {
    TBoolDialog dialog = const TBoolDialog(
      title: 'You have unsaved changes!',
      body: 'Are you sure you want to go back and discard your changes?',
      confirmText: 'Yes, discard them',
      cancelText: 'No, keep me here',
    );
    return showBoolDialog(dialog);
  }

  Future<bool> showSaveWarningDialog(String warning) {
    TBoolDialog dialog = TBoolDialog(
      title: 'Your changes might break the game!',
      body: '$warning. Are you sure you want to save these changes?',
      confirmText: 'Yes, save them',
      cancelText: 'No, take me back',
    );
    return showBoolDialog(dialog);
  }
}
