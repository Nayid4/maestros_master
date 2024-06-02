import 'package:flutter/material.dart';

const Color customColor = Color.fromRGBO(0, 191, 99, 1);

const List<Color> _colorThemes = [
  customColor,
  Colors.deepPurple,
  Colors.orange
];

class Apptheme {
  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _colorThemes[0],
    );
  }
}
