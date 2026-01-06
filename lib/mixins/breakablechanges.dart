import 'package:flutter/material.dart';
import 'package:tfields/widgets.dart';

mixin BreakableChanges<T extends StatefulWidget> on TDialogDisplayer<T> {
  Future<bool> showSaveWarningDialog(String warning, {bool breaking = true}) {
    return showConfirmation(
      '$warning. Are you sure you want to save these changes?',
      title: breaking
        ? 'Your changes might break the game!'
        : 'Your changes will have side effects!',
      confirmText: 'Yes, save them',
      cancelText: 'No, take me back',
    );
  }
}
