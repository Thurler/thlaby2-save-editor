import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/widgets/clickable.dart';

@immutable
class TAppBarButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function() onTap;

  const TAppBarButton({
    required this.text,
    required this.icon,
    required this.onTap,
    super.key,
  }) : super();

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[
      Icon(icon),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    ];
    return TClickable(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: children,
        ),
      ),
    );
  }
}
