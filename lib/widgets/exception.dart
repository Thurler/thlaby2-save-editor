import 'package:flutter/material.dart';
import 'package:tfields/extensions/iterable.dart';
import 'package:tfields/widgets/common_scaffold.dart';

class ExceptionWidget extends StatelessWidget {
  static const String dialogBody = 'Please report this as an issue at the link '
      'below. Please include the "applicationlog.txt" file that should be next '
      'to your .exe file when submitting the issue, as well as your save file:'
      '\nhttps://github.com/Thurler/thlaby2-save-editor/issues';

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
          dialogBody,
          textAlign: TextAlign.center,
        ),
        const SelectableText('Please include the below information as well:'),
        SelectableText(detailMessage),
      ].separateWith(const SizedBox(height: 10)),
    );
  }
}
