import 'package:flutter/material.dart';

@immutable
class TButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final IconData? icon;
  final double fontSize;
  final bool usesMaxWidth;

  const TButton({
    required this.text,
    this.onPressed,
    this.icon,
    this.fontSize = 18,
    this.usesMaxWidth = true,
    super.key,
  }) : super();

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[
      Flexible(
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ];
    if (icon != null) {
      children.insertAll(0, <Widget>[
        Icon(icon),
        const SizedBox(width: 10),
      ]);
    }
    return ElevatedButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisSize: usesMaxWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
