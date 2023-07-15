import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/mixins/alert.dart';
import 'package:thlaby2_save_editor/mixins/breakablechanges.dart';
import 'package:thlaby2_save_editor/mixins/discardablechanges.dart';
import 'package:thlaby2_save_editor/mixins/exception.dart';
import 'package:thlaby2_save_editor/save.dart';

abstract class CommonState<T extends StatefulWidget> extends State<T> with
    Loggable, SaveReader, AlertHandler<T>, ExceptionHandler<T>,
    DiscardableChanges<T>, BreakableChanges<T> {}
