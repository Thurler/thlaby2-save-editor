import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/mixins/alert.dart';
import 'package:thlaby2_save_editor/widgets/dialog.dart';

mixin ExceptionHandler<T extends StatefulWidget> on Loggable, AlertHandler<T> {
  Future<void> handleException({
    required String logMessage,
    required String dialogTitle,
    required String dialogBody,
  }) async {
    await log(LogLevel.error, logMessage);
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
}
