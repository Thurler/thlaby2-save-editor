import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/mixins/alert.dart';
import 'package:thlaby2_save_editor/widgets/dialog.dart';

mixin DiscardableChanges<T extends StatefulWidget> on Loggable,
    AlertHandler<T> {
  bool get hasChanges;

  Future<bool> _showUnsavedChangesDialog() {
    return showBoolDialog(
      const TBoolDialog(
        title: 'You have unsaved changes!',
        body: 'Are you sure you want to go back and discard your changes?',
        confirmText: 'Yes, discard them',
        cancelText: 'No, keep me here',
      ),
    );
  }

  Future<bool> checkChangesAndConfirm() async {
    if (!hasChanges) {
      return true;
    }
    bool canDiscard = await _showUnsavedChangesDialog();
    if (canDiscard) {
      await log(LogLevel.info, 'Discarding changes to character data');
    }
    return canDiscard;
  }
}
