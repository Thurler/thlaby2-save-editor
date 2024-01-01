import 'package:flutter/material.dart';

class TSwitch extends StatelessWidget {
  final TextStyle titleStyle = const TextStyle(fontWeight: FontWeight.w700);
  final TextStyle disableStyle = const TextStyle(color: Colors.grey);
  final void Function(bool) onChanged;
  final String offText;
  final String onText;
  final String title;
  final bool value;
  final bool expanded;

  const TSwitch({
    required this.onChanged,
    required this.value,
    this.expanded = true,
    this.offText = '',
    this.onText = '',
    this.title = '',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget mainRow = Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      children: <Widget>[
        if (offText != '')
          Expanded(
            child: Text(
              offText,
              textAlign: TextAlign.right,
              style: value ? disableStyle : null,
            ),
          ),
        Switch(
          value: value,
          activeTrackColor: Colors.green.withOpacity(0.4),
          activeColor: Colors.green,
          onChanged: onChanged,
        ),
        if (onText != '')
          Expanded(
            child: Text(
              onText,
              style: value ? null : disableStyle,
            ),
          ),
      ],
    );
    if (!expanded) {
      mainRow = IntrinsicWidth(child: mainRow);
    }
    return Column(
      children: <Widget>[
        if (title != '') Text(title, style: titleStyle),
        mainRow,
      ],
    );
  }
}
