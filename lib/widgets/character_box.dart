import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/widgets/clickable.dart';

class CharacterBox extends StatelessWidget {
  static const ColorFilter identity = ColorFilter.matrix(<double>[
    1, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 1, 0, 0,
    0, 0, 0, 1, 0,
  ]);
  static const ColorFilter greyscale = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0,      0,      0,      1, 0,
  ]);

  final String title;
  final double? titleFontSize;
  final Widget? titleAppend;
  final String filename;
  final bool unlocked;
  final bool interactWhenLocked;
  final bool highlighted;
  final void Function() onTap;
  final void Function(PointerEnterEvent)? onEnter;
  final void Function(PointerExitEvent)? onExit;

  const CharacterBox({
    required this.title,
    required this.filename,
    required this.unlocked,
    required this.onTap,
    this.onEnter,
    this.onExit,
    this.titleAppend,
    this.titleFontSize,
    this.highlighted = false,
    this.interactWhenLocked = false,
    super.key,
  });

  static Image imageFromName(String filename) {
    return Image.asset(
      'img/character/${filename}_S.png',
      fit: BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool enabled = unlocked || interactWhenLocked;
    bool highlight = highlighted && enabled;
    return TClickable(
      enabled: enabled,
      onTap: onTap,
      onEnter: onEnter,
      onExit: onExit,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '$title${titleAppend != null ? ':' : ''}',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: highlight ? Colors.green : null,
                ),
              ),
              if (titleAppend != null)
                ...<Widget>[
                  const SizedBox(width: 5),
                  titleAppend!,
                ],
            ],
          ),
          DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              border: Border.all(
                width: highlight ? 2 : 1,
                color: highlight ? Colors.green : Colors.grey.shade700,
              ),
            ),
            child: ColorFiltered(
              colorFilter: unlocked ? identity : greyscale,
              child: imageFromName(filename),
            ),
          ),
        ],
      ),
    );
  }
}
