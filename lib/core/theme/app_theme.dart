import 'package:flutter/material.dart';
import 'package:zoey/core/theme/colors/color_constants.dart';
import 'package:zoey/core/theme/colors/colors_cheme.dart';
import 'package:zoey/core/theme/components/button_theme_data.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: lightBackground,
      elevatedButtonTheme: elevatedButtonTheme(lightColorScheme),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: darkBackground,
      elevatedButtonTheme: elevatedButtonTheme(darkColorScheme),
    );
  }

  // Helper methods for theme-dependent colors
  static Color getTextSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkColorScheme.secondary
        : lightColorScheme.secondary;
  }

  static Color getTextTertiary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkColorScheme.secondary
        : lightColorScheme.secondary;
  }
}
