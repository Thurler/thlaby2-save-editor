import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/save.dart';

abstract class CommonState<T extends StatefulWidget> extends State<T> {
  final Logger logger = Logger();
  final SaveFileWrapper saveFileWrapper = SaveFileWrapper();

  List<U> buildSeparatedList<U>(
    List<U> base,
    U separator, {
    bool separateEnds = false,
  }) {
    List<U> result = <U>[];
    if (separateEnds) {
      result.add(separator);
    }
    for (int i = 0; i < base.length - 1; i++) {
      result.addAll(<U>[base[i], separator]);
    }
    result.add(base[base.length - 1]);
    if (separateEnds) {
      result.add(separator);
    }
    return result;
  }

  Row makeRowFromWidgets(List<Widget> widgets, {bool expanded = false}) {
    if (expanded) {
      widgets = widgets.map((Widget w)=>Expanded(child: w)).toList();
    } else {
      widgets = widgets.map((Widget w)=>Flexible(child: w)).toList();
    }
    return Row(
      children: buildSeparatedList(
        widgets,
        const SizedBox(width: 20),
      ),
    );
  }
}
