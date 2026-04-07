import 'package:flutter/material.dart';
import 'package:tfields/widgets.dart';

class ItemSlotIcon extends StatelessWidget with TStandardColorer {
  final bool isUnlocked;

  const ItemSlotIcon({required this.isUnlocked, super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      isUnlocked ? Icons.lock_open : Icons.lock,
      color: isUnlocked ? successColor(context) : errorColor(context),
    );
  }
}

class ItemSlotIconButton extends StatelessWidget with TStandardColorer {
  final bool isUnlocked;
  final void Function() onPressed;

  const ItemSlotIconButton({
    required this.isUnlocked,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TButton.iconOnly(
      icon: TIcon(
        icon: isUnlocked ? Icons.lock_open : Icons.lock,
        color: isUnlocked ? successColor(context) : errorColor(context),
      ),
      onPressed: onPressed,
      text: isUnlocked ? 'Click to lock the item' : 'Click to unlock the item',
    );
  }
}
