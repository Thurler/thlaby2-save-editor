import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/save/character.dart';
import 'package:thlaby2_save_editor/widgets/dialog.dart';

abstract class CommonState<T extends StatefulWidget> extends State<T> {
  final Logger logger = Logger();
  final SaveFileWrapper saveFileWrapper = SaveFileWrapper();

  final List<String> characterFilenames = <String>[
    'Reimu',
    'Marisa',
    'Kourin',
    'Keine',
    'Momiji',
    'Youmu',
    'Kogasa',
    'Rumia',
    'Cirno',
    'Minoriko',
    'Komachi',
    'Chen',
    'Nitori',
    'Parsee',
    'Wriggle',
    'Kaguya',
    'Mokou',
    'Aya',
    'Mystia',
    'Kasen',
    'Nazrin',
    'Hina',
    'Rin',
    'Utsuho',
    'Satori',
    'Yuugi',
    'Meirin',
    'Alice',
    'Patchouli',
    'Eirin',
    'Reisen',
    'Sanae',
    'Iku',
    'Suika',
    'Ran',
    'Remilia',
    'Sakuya',
    'Kanako',
    'Suwako',
    'Tensi',
    'Flandre',
    'Yuyuko',
    'Yuuka',
    'Yukari',
    'Hijiri',
    'Eiki',
    'Renko',
    'Maribel',
    'Toramaru',
    'Mamizou',
    'Futo',
    'Miko',
    'Kokoro',
    'Tokiko',
    'Koisi',
    'Akyuu',
  ];

  String getCharacterFilename(Character c) {
    return characterFilenames[c.index];
  }

  Future<void> handleException({
    required String logMessage,
    required String dialogTitle,
    required String dialogBody,
  }) async {
    await logger.log(LogLevel.error, logMessage);
    await showCommonDialog(
      TWarningDialog(
        title: dialogTitle,
        body: dialogBody,
        confirmText: 'OK',
      ),
    );
  }

  Future<void> handleUnexpectedException(Exception e, StackTrace s) {
    return handleException(
      logMessage: 'Unknown exception: $e | $s',
      dialogTitle: 'An unexpected error occured!',
      dialogBody: 'Please report this as an issue at the link below. Please '
        'include the "applicationlog.txt" file that should be next to your '
        '.exe file when submitting the issue, as well as your save file:\n'
        'https://github.com/Thurler/thlaby2-save-editor/issues',
    );
  }

  Future<void> showCommonDialog(TDialog dialog) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
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
    return showBoolDialog(
      const TBoolDialog(
        title: 'You have unsaved changes!',
        body: 'Are you sure you want to go back and discard your changes?',
        confirmText: 'Yes, discard them',
        cancelText: 'No, keep me here',
      ),
    );
  }

  Future<bool> showSaveWarningDialog(String warning, {bool breaking = true}) {
    return showBoolDialog(
      TBoolDialog(
        title: breaking
          ? 'Your changes might break the game!'
          : 'Your changes will have side effects!',
        body: '$warning. Are you sure you want to save these changes?',
        confirmText: 'Yes, save them',
        cancelText: 'No, take me back',
      ),
    );
  }
}
