import 'package:flutter/material.dart';

class CharacterBoxTitleUnlockAppend extends StatelessWidget {
  final bool isHighlighted;
  final bool isUnlocked;

  const CharacterBoxTitleUnlockAppend({
    required this.isHighlighted,
    required this.isUnlocked,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          isUnlocked ? 'Unlocked' : 'Locked',
          style: TextStyle(
            color: isHighlighted ? Colors.green : Colors.grey.shade700,
          ),
        ),
        Icon(
          isUnlocked ? Icons.lock_open : Icons.lock,
          size: 14,
          color: isHighlighted ? Colors.green : Colors.grey.shade700,
        ),
      ],
    );
  }
}
