import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/extensions/list_extension.dart';
import 'package:thlaby2_save_editor/widgets/appbar_button.dart';

class CommonScaffold extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final void Function()? settingsLink;
  final FloatingActionButton? floatingActionButton;

  const CommonScaffold({
    required this.title,
    required this.children,
    this.settingsLink,
    this.floatingActionButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          if (settingsLink != null)
            // Only add settings action if we pass the function in
            TAppBarButton(
              text: 'Settings',
              icon: Icons.settings,
              onTap: settingsLink!,
            ),
        ],
      ),
      floatingActionButton: floatingActionButton,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: children.separateWith(
                const SizedBox(height: 20),
                separatorOnEnds: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
