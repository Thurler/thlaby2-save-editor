import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/widgets/clickable.dart';
import 'package:thlaby2_save_editor/widgets/spaced_row.dart';

class UpdateStatus extends StatelessWidget {
  final bool hasCheckedForUpdates;
  final bool updateCheckSucceeded;
  final bool hasUpdate;
  final String latestVersion;
  final void Function() onUpdateTap;

  const UpdateStatus({
    required this.hasCheckedForUpdates,
    required this.updateCheckSucceeded,
    required this.hasUpdate,
    required this.latestVersion,
    required this.onUpdateTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool clickable = false;
    Widget icon = const SizedBox(height: 1);
    String text;

    if (!hasCheckedForUpdates) {
      icon = const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(),
      );
      text = 'Checking for updates...';
    } else if (!updateCheckSucceeded) {
      icon = const Icon(Icons.cancel_outlined, color: Colors.red);
      text = 'Update check failed, check log for details';
    } else if (hasUpdate) {
      icon = const Icon(Icons.warning, color: Colors.red);
      text = 'Version $latestVersion available, click here to download it';
      clickable = true;
    } else {
      icon = const Icon(Icons.check_circle_outlined, color: Colors.green);
      text = 'This is the latest version of the software';
    }

    Widget row = SpacedRow(
      mainAxisAlignment: MainAxisAlignment.center,
      spacer: const SizedBox(width: 5),
      children: <Widget>[
        icon,
        Text(text),
      ],
    );

    if (!clickable) {
      return row;
    }
    return TClickable(onTap: onUpdateTap, child: row);
  }
}

class UpdateCheck with Loggable {
  static final UpdateCheck _checker = UpdateCheck._internal();

  String latestVersion = Logger.version;
  bool hasCheckedForUpdates = false;
  bool updateCheckSucceeded = false;
  bool hasUpdate = false;

  factory UpdateCheck() {
    return _checker;
  }

  // ignore: empty_constructor_bodies
  UpdateCheck._internal() {}

  Future<void> checkForUpdates(Function() callback) async {
    if (hasCheckedForUpdates) {
      return;
    }
    callback();
  }

  Future<void> openLatestVersion() async {}
}

mixin UpdateChecker {
  final UpdateCheck updateChecker = UpdateCheck();

  void updateCheckCallback();

  Future<void> checkForUpdates() => updateChecker.checkForUpdates(
    updateCheckCallback,
  );
}
