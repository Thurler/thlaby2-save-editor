import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/widgets/button.dart';

@immutable
abstract class TDialog extends StatelessWidget {
  final String title;
  final String body;
  final String confirmText;
  final String cancelText;
  final IconData titleIcon;
  final Color titleIconColor;

  const TDialog({
    required this.title,
    required this.titleIcon,
    required this.titleIconColor,
    this.confirmText = '',
    this.cancelText = '',
    this.body = '',
    super.key,
  }) : super();

  @override
  Widget build(BuildContext context) {
    Widget titleWidget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          titleIcon,
          color: titleIconColor,
          size: 30,
        ),
        // const Icon(Icons.warning, color: Colors.red, size: 30),
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
    Widget? bodyWidget;
    if (body != '') {
      bodyWidget = SizedBox(
        width: width * 2/3,
        child: SelectableText(body, textAlign: TextAlign.center),
      );
    }
    List<Widget> actions = <Widget>[];
    if (confirmText != '') {
      actions.add(
        TButton(
          text: confirmText,
          icon: Icons.check_circle_outline,
          usesMaxWidth: false,
          fontSize: 16,
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );
    }
    if (cancelText != '') {
      actions.add(
        TButton(
          text: cancelText,
          icon: Icons.cancel_outlined,
          usesMaxWidth: false,
          fontSize: 16,
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      );
    }
    EdgeInsets padding = const EdgeInsets.fromLTRB(20, 0, 20, 5);
    if (actions.isNotEmpty) {
      padding = padding.copyWith(bottom: 18);
    }
    return AlertDialog(
      title: titleWidget,
      content: bodyWidget,
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: padding,
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

@immutable
class TSuccessDialog extends TDialog {
  const TSuccessDialog({
    required super.title,
    super.key,
  }) : super(
    titleIcon: Icons.check_circle_outline,
    titleIconColor: Colors.green,
  );
}

@immutable
class TWarningDialog extends TDialog {
  const TWarningDialog({
    required super.title,
    required super.body,
    required super.confirmText,
    super.cancelText,
    super.key,
  }) : super(
    titleIcon: Icons.warning,
    titleIconColor: Colors.red,
  );
}

@immutable
class TBoolDialog extends TWarningDialog {
  const TBoolDialog({
    required super.title,
    required super.body,
    required super.confirmText,
    required super.cancelText,
    super.key,
  }) : super();
}
