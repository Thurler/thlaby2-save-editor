import 'package:flutter/material.dart';

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
    return ElevatedButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisSize: usesMaxWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (icon != null)
              Icon(icon),
              const SizedBox(width: 10),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
