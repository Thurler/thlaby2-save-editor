import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/extensions/iterable_extension.dart';
import 'package:thlaby2_save_editor/widgets/badge.dart';
import 'package:thlaby2_save_editor/widgets/button.dart';

class ItemCategory extends StatelessWidget {
  final String text;
  final bool hasChanges;
  final bool isSelected;
  final void Function()? onPressed;

  const ItemCategory({
    required this.text,
    required this.hasChanges,
    required this.isSelected,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TButton(text: text, onPressed: onPressed),
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Opacity(
              opacity: isSelected ? 1 : 0,
              child: const Divider(color: Colors.green),
            ),
            Opacity(
              opacity: hasChanges ? 1 : 0,
              child: TBadge(
                text: 'Has Changes',
                color: Colors.green[300]!,
              ),
            ),
          ],
        ),
      ].separateWith(const SizedBox(height: 8)),
    );
  }
}
