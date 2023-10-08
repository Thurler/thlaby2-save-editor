import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/mixins/alert.dart';
import 'package:thlaby2_save_editor/widgets/dialog.dart';

mixin BreakableChanges<T extends StatefulWidget> on AlertHandler<T> {
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
