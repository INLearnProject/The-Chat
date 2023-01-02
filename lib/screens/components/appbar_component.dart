import 'package:flutter/material.dart';

class ComponentAppBar {
  final String titleAppBar;
  final List<Widget>? actions;
  ComponentAppBar({required this.titleAppBar, this.actions});

  PreferredSizeWidget build() {
    return AppBar(
      actions: actions,
      title: Text(
        "The Chat $titleAppBar",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
