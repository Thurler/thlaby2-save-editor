import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/widgets/button.dart';

class TDialogTitle extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;

  const TDialogTitle({
    required this.text,
    required this.icon,
    required this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          color: iconColor,
          size: 30,
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class TDialogBody extends StatelessWidget {
  final String text;

  const TDialogBody({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 2 / 3,
      child: SelectableText(text, textAlign: TextAlign.center),
    );
  }
}

class TDialogActionConfirm extends StatelessWidget {
  final String text;

  const TDialogActionConfirm({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return TButton(
      text: text,
      icon: Icons.check_circle_outline,
      usesMaxWidth: false,
      fontSize: 16,
      onPressed: () {
        Navigator.of(context).pop(true);
      },
    );
  }
}

class TDialogActionCancel extends StatelessWidget {
  final String text;

  const TDialogActionCancel({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return TButton(
      text: text,
      icon: Icons.cancel_outlined,
      usesMaxWidth: false,
      fontSize: 16,
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );
  }
}

class TAlertDialog extends StatelessWidget {
  final TDialogTitle title;
  final TDialogBody? body;
  final TDialogActionConfirm? confirm;
  final TDialogActionCancel? cancel;

  const TAlertDialog({
    required this.title,
    this.body,
    this.confirm,
    this.cancel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool hasAction = confirm != null || cancel != null;
    return AlertDialog(
      title: title,
      content: body,
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: EdgeInsets.fromLTRB(20, 0, 20, hasAction ? 18 : 5),
      actions: <Widget>[
        Wrap(
          runSpacing: 10,
          spacing: 20,
          children: <Widget>[
            if (confirm != null) confirm!,
            if (cancel != null) cancel!,
          ],
        ),
      ],
    );
  }
}

abstract class TDialog extends StatelessWidget {
  final String title;

  const TDialog({required this.title, super.key});
}

class TSuccessDialog extends TDialog {
  const TSuccessDialog({required super.title, super.key});

  @override
  Widget build(BuildContext context) {
    return TAlertDialog(
      title: TDialogTitle(
        text: title,
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
      ),
    );
  }
}

class TWarningDialog extends TDialog {
  final String body;
  final String confirmText;

  const TWarningDialog({
    required super.title,
    required this.body,
    required this.confirmText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TAlertDialog(
      title: TDialogTitle(
        text: title,
        icon: Icons.warning,
        iconColor: Colors.red,
      ),
      body: TDialogBody(text: body),
      confirm: TDialogActionConfirm(text: confirmText),
    );
  }
}

class TBoolDialog extends TDialog {
  final String body;
  final String confirmText;
  final String cancelText;

  const TBoolDialog({
    required super.title,
    required this.body,
    required this.confirmText,
    required this.cancelText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TAlertDialog(
      title: TDialogTitle(
        text: title,
        icon: Icons.warning,
        iconColor: Colors.red,
      ),
      body: TDialogBody(text: body),
      confirm: TDialogActionConfirm(text: confirmText),
      cancel: TDialogActionCancel(text: cancelText),
    );
  }
}
