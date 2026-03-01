import 'package:flutter/material.dart';
import 'package:tfields/widgets.dart';
import 'package:thlaby2_save_editor/widgets/badge.dart';

class ItemSectionHeader extends StatelessWidget {
  final String text;
  final bool hasChanges;
  final bool isSelected;
  final bool usesMaxWidth;
  final void Function()? onPressed;

  const ItemSectionHeader({
    required this.text,
    required this.hasChanges,
    required this.isSelected,
    this.usesMaxWidth = true,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget ret = ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 150),
      child: Column(
        spacing: 8,
        children: <Widget>[
          TButton.elevated(
            text: text,
            onPressed: onPressed,
            usesMaxWidth: true,
          ),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Opacity(
                opacity: isSelected ? 1 : 0,
                child: Divider(color: Theme.of(context).primaryColor),
              ),
              Opacity(
                opacity: hasChanges ? 1 : 0,
                child: TBadge(
                  text: 'Has Changes',
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
    return usesMaxWidth ? ret : IntrinsicWidth(child: ret);
  }
}
