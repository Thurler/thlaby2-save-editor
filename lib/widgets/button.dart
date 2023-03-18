import 'package:flutter/material.dart';

@immutable
class TButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Icon? icon;

  const TButton({
    required this.text,
    this.onPressed,
    this.icon,
    super.key,
  }) : super();

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[
      Flexible(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ];
    if (icon != null) {
      children.insertAll(0, <Widget>[
        icon!,
        const SizedBox(width: 10),
      ]);
    }
    return ElevatedButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
