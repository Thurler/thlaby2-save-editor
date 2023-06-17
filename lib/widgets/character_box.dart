import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/widgets/clickable.dart';

class CharacterBox extends StatelessWidget {
  final String title;
  final double? titleFontSize;
  final String filename;
  final bool highlighted;
  final void Function() onTap;
  final void Function(PointerEnterEvent)? onEnter;
  final void Function(PointerExitEvent)? onExit;

  const CharacterBox({
    required this.title,
    required this.filename,
    required this.onTap,
    this.onEnter,
    this.onExit,
    this.titleFontSize,
    this.highlighted = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TClickable(
      onTap: onTap,
      onEnter: onEnter,
      onExit: onExit,
      child: Column(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: highlighted ? Colors.green : null,
            ),
          ),
          DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              border: Border.all(
                width: highlighted ? 2 : 1,
                color: highlighted ? Colors.green : Colors.grey.shade700,
              ),
            ),
            child: Image.asset(
              'img/character/${filename}_S.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
