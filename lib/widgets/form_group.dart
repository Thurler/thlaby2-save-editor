import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/widgets/badge.dart';
import 'package:thlaby2_save_editor/widgets/form.dart';

class TFormGroup {
  final String title;
  final Map<FormKey, TForm> forms;
  bool expanded;

  TFormGroup({
    required this.title,
    required this.forms,
    this.expanded = false,
  });

  void toggleExpanded() => expanded = !expanded;

  bool get hasChanges => forms.keys.any(
    (FormKey formKey) => formKey.currentState?.hasChanges ?? false,
  );

  bool get hasErrors => forms.keys.any(
    (FormKey formKey) => formKey.currentState?.hasErrors ?? false,
  );

  ExpansionPanel get expansionPanel => ExpansionPanel(
    backgroundColor: Colors.white.withOpacity(0.9),
    canTapOnHeader: true,
    isExpanded: expanded,
    headerBuilder: (BuildContext context, bool isExpanded) => ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          if (hasChanges)
            const TBadge(
              text: 'Has Changes',
              color: Colors.green,
            ),
          if (hasChanges && hasErrors) const SizedBox(width: 5),
          if (hasErrors)
            const TBadge(
              text: 'Has Issues',
              color: Colors.red,
            ),
        ],
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
      child: Column(
        children: forms.values.toList(),
      ),
    ),
  );
}
