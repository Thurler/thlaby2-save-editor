import 'package:flutter/material.dart';
import 'package:tfields/mixins/alert.dart';
import 'package:tfields/widgets/dialog.dart';

mixin BreakableChanges<T extends StatefulWidget> on AlertHandler<T> {
  Future<bool> showSaveWarningDialog(String warning, {bool breaking = true}) {
    return showBoolDialog(
      TDialog.boolWarning(
        titleText: breaking
          ? 'Your changes might break the game!'
          : 'Your changes will have side effects!',
        bodyText: '$warning. Are you sure you want to save these changes?',
        confirmText: 'Yes, save them',
        cancelText: 'No, take me back',
      ),
    );
  }
}
