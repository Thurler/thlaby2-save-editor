import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/mixins/alert.dart';
import 'package:thlaby2_save_editor/widgets/dialog.dart';

mixin DiscardableChanges<T extends StatefulWidget> on AlertHandler<T> {
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
}
