import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/widgets/clickable.dart';

class PartyRemoveButton extends StatelessWidget {
  final bool enabled;
  final bool highlighted;
  final void Function() onTap;
  final void Function(PointerEnterEvent)? onEnter;
  final void Function(PointerExitEvent)? onExit;

  const PartyRemoveButton({
    required this.enabled,
    required this.onTap,
    this.onEnter,
    this.onExit,
    this.highlighted = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TClickable(
      enabled: enabled,
      onTap: onTap,
      onEnter: onEnter,
      onExit: onExit,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: (enabled ? Colors.red.shade700 : Colors.grey).withOpacity(
            highlighted ? 1.0 : 0.7,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.cancel_outlined,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  'Remove',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: highlighted && enabled
                      ? FontWeight.bold
                      : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
