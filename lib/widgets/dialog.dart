import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/widgets/button.dart';

@immutable
class TBoolDialog extends StatelessWidget {
  final String title;
  final String body;
  final String confirmText;
  final String cancelText;

  const TBoolDialog({
    required this.title,
    required this.body,
    required this.confirmText,
    required this.cancelText,
    super.key,
  }) : super();

  @override
  Widget build(BuildContext context) {
    Widget titleWidget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(Icons.warning, color: Colors.red, size: 30),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
    double width = MediaQuery.of(context).size.width;
    Widget bodyWidget = SizedBox(
      width: width * 2/3,
      child: Text(body),
    );
    List<Widget> actions = <Widget>[
      TButton(
        text: confirmText,
        icon: Icons.check_circle_outline,
        usesMaxWidth: false,
        fontSize: 16,
        onPressed: () {
          Navigator.of(context).pop(true);
        },
      ),
      TButton(
        text: cancelText,
        icon: Icons.cancel_outlined,
        usesMaxWidth: false,
        fontSize: 16,
        onPressed: () {
          Navigator.of(context).pop(false);
        },
      ),
    ];
    return AlertDialog(
      title: titleWidget,
      content: bodyWidget,
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      actions: <Widget>[
        Wrap(
          runSpacing: 10,
          spacing: 20,
          children: actions,
        ),
      ],
    );
  }
}
