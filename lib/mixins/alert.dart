import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/widgets/dialog.dart';

mixin AlertHandler<T extends StatefulWidget> on State<T> {
  Future<void> showCommonDialog(TDialog dialog) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  Future<bool> showBoolDialog(TBoolDialog dialog) async {
    bool? canDiscard = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
    return canDiscard ?? false;
  }
}
