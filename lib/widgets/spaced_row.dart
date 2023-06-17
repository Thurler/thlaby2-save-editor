import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/extensions/iterable_extension.dart';

class SpacedRow extends StatelessWidget {
  final List<Widget> children;
  final bool expanded;
  final Widget? spacer;

  const SpacedRow({
    required this.children,
    this.expanded = false,
    this.spacer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: children.map<Widget>(
        (Widget w) => expanded ? Expanded(child: w) : Flexible(child: w),
      ).separateWith(spacer),
    );
  }
}
