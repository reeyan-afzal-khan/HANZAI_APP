import 'package:flutter/material.dart';

bool checkTheme(context) {
  bool darkMode = false;
  final ThemeData theme = Theme.of(context);
  theme.brightness == Brightness.dark ? darkMode = true : darkMode = false;
  return darkMode;
}
