import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

@immutable
class TClickable extends StatelessWidget {
  final void Function() onTap;
  final void Function(PointerEnterEvent)? onEnter;
  final void Function(PointerExitEvent)? onExit;
  final Widget child;

  const TClickable({
    required this.onTap,
    required this.child,
    this.onEnter,
    this.onExit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: onEnter,
        onExit: onExit,
        child: child,
      ),
    );
  }
}
