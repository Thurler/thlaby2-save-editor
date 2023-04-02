import 'package:flutter/material.dart';

@immutable
class TBadge extends StatelessWidget {
  final String text;
  final Color color;

  const TBadge({
    required this.text,
    required this.color,
    super.key,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
