import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/extensions/iterable_extension.dart';
import 'package:thlaby2_save_editor/widgets/appbar_button.dart';

class CommonScaffold extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final void Function()? settingsLink;
  final Widget? background;
  final FloatingActionButton? floatingActionButton;
  final EdgeInsets padding;

  const CommonScaffold({
    required this.title,
    required this.children,
    this.settingsLink,
    this.background,
    this.floatingActionButton,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
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
      body: Stack(
        children: <Widget>[
          if (background != null) background!,
          Positioned.fill(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: padding,
                  child: Column(
                    children: children.separateWith(
                      const SizedBox(height: 20),
                      separatorOnEnds: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
