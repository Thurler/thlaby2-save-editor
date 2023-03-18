import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/save.dart';

abstract class CommonState<T extends StatefulWidget> extends State<T> {
  final Logger logger = Logger();
  late SaveFile saveFile;

  List<U> buildSeparatedList<U>(List<U> base, U separator) {
    List<U> result = <U>[separator];
    for (U element in base) {
      result.addAll(<U>[element, separator]);
    }
    return result;
  }
}
