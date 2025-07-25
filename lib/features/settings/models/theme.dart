import 'package:flutter/material.dart';
import 'package:zoey/l10n/generated/l10n.dart';

enum AppThemeMode {
  light,
  dark,
  system;

  String getTitle(BuildContext context) {
    switch (this) {
      case AppThemeMode.light:
        return L10n.of(context).light;
      case AppThemeMode.dark:
        return L10n.of(context).dark;
      case AppThemeMode.system:
        return L10n.of(context).system;
    }
  }

  String getDescription(BuildContext context) {
    switch (this) {
      case AppThemeMode.light:
        return L10n.of(context).alwaysUseLightTheme;
      case AppThemeMode.dark:
        return L10n.of(context).alwaysUseDarkTheme;
      case AppThemeMode.system:
        return L10n.of(context).followSystemThemeSetting;
    }
  }

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
