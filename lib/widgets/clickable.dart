import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TClickable extends StatelessWidget {
  final void Function() onTap;
  final void Function(PointerEnterEvent)? onEnter;
  final void Function(PointerExitEvent)? onExit;
  final Widget child;
  final bool enabled;

  const TClickable({
    required this.child,
    required this.onTap,
    this.onEnter,
    this.onExit,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: enabled ? onEnter : null,
        onExit: enabled ? onExit : null,
        child: child,
      ),
    );
  }
}
