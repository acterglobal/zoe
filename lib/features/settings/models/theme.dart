import 'package:flutter/material.dart';

enum AppThemeMode {
  light('Light', 'Always use light theme'),
  dark('Dark', 'Always use dark theme'),
  system('System', 'Follow system theme setting');

  const AppThemeMode(this.title, this.description);

  final String title;
  final String description;

  ThemeMode get themeMode {
    switch (this) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}
