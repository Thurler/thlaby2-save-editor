import 'package:flutter/material.dart';
import 'package:tfields/widgets.dart';

class CharacterBox extends StatelessWidget {
  static const List<double> identityR = <double>[1, 0, 0, 0, 0];
  static const List<double> identityG = <double>[0, 1, 0, 0, 0];
  static const List<double> identityB = <double>[0, 0, 1, 0, 0];
  static const List<double> identityA = <double>[0, 0, 0, 1, 0];
  static const List<double> greyscaleC = <double>[0.2126, 0.7152, 0.0722, 0, 0];

  static final ColorFilter identity = ColorFilter.matrix(
    identityR + identityG + identityB + identityA,
  );
  static final ColorFilter greyscale = ColorFilter.matrix(
    greyscaleC + greyscaleC + greyscaleC + identityA,
  );

  static Image imageFromName(String filename) =>
      Image.asset('img/character/${filename}_S.png', fit: BoxFit.contain);

  final String title;
  final Widget? titleAppend;
  final String filename;
  final bool isHighlighted;
  final bool unlocked;

  const CharacterBox({
    required this.title,
    required this.filename,
    required this.unlocked,
    required this.isHighlighted,
    this.titleAppend,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '$title${titleAppend != null ? ':' : ''}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isHighlighted ? Colors.green : null,
              ),
            ),
            if (titleAppend != null) ...<Widget>[
              const SizedBox(width: 5),
              titleAppend!,
            ],
          ],
        ),
        DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            border: Border.all(
              width: isHighlighted ? 2 : 1,
              color: isHighlighted
                ? Theme.of(context).primaryColor
                : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: ColorFiltered(
            colorFilter: unlocked ? identity : greyscale,
            child: CharacterBox.imageFromName(filename),
          ),
        ),
      ],
    );
  }
}

class CharacterBoxHover extends StatefulWidget with THoverWidget {
  final String title;
  final Widget? titleAppend;
  final String filename;
  final bool unlocked;
  final bool interactWhenLocked;

  @override
  final bool hoverEnabled;

  @override
  final void Function() hoverUpdateCallback;

  @override
  final void Function()? onHoverTap;

  const CharacterBoxHover({
    required this.title,
    required this.filename,
    required this.unlocked,
    required this.onHoverTap,
    required this.hoverUpdateCallback,
    this.titleAppend,
    this.interactWhenLocked = false,
    super.key,
  }) : hoverEnabled = unlocked || interactWhenLocked;

  @override
  State<StatefulWidget> createState() => CharacterBoxState();
}

class CharacterBoxState extends State<CharacterBoxHover>
    with THoverState<CharacterBoxHover> {
  @override
  Widget buildChild(BuildContext context) {
    return CharacterBox(
      title: widget.title,
      titleAppend: widget.titleAppend,
      filename: widget.filename,
      unlocked: widget.unlocked,
      isHighlighted: isHighlighted,
    );
  }
}
