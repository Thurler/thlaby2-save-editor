import 'package:flutter/material.dart';

class RoundedBorder extends StatelessWidget {
  final Color color;
  final EdgeInsets childPadding;
  final Widget child;

  const RoundedBorder({
    required this.child,
    required this.color,
    this.childPadding = EdgeInsets.zero,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color),
      ),
      child: Padding(
        padding: childPadding,
        child: child,
      ),
    );
  }
}
