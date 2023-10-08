import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/widgets/clickable.dart';

class TAppBarButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function() onTap;

  const TAppBarButton({
    required this.text,
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TClickable(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: <Widget>[
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
          ],
        ),
      ),
    );
  }
}
