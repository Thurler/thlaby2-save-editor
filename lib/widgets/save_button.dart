import 'package:flutter/material.dart';

class TSaveButton extends FloatingActionButton {
  const TSaveButton({required super.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: const Icon(Icons.save),
    );
  }
}
