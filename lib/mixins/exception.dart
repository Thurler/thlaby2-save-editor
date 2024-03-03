import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/extensions/iterable_extension.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/mixins/alert.dart';
import 'package:thlaby2_save_editor/widgets/common_scaffold.dart';
import 'package:thlaby2_save_editor/widgets/dialog.dart';

mixin ExceptionHandler<T extends StatefulWidget> on Loggable, AlertHandler<T> {
  static const String dialogBody = 'Please report this as an issue at the link '
      'below. Please include the "applicationlog.txt" file that should be next '
      'to your .exe file when submitting the issue, as well as your save file:'
      '\nhttps://github.com/Thurler/thlaby2-save-editor/issues';

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
      dialogBody: dialogBody,
    );
  }
}

class ExceptionWidget extends StatelessWidget {
  final FlutterErrorDetails details;

  const ExceptionWidget({required this.details, super.key});

  String get detailMessage => '${details.exception}}\n${details.summary}\n'
      '$details\n\n${details.stack}';

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'An error occured',
      children: <Widget>[
        const SelectableText(
          ExceptionHandler.dialogBody,
          textAlign: TextAlign.center,
        ),
        const SelectableText('Please include the below information as well:'),
        SelectableText(detailMessage),
      ].separateWith(const SizedBox(height: 10)),
    );
  }
}
