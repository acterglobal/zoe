import 'package:flutter/material.dart';
import 'package:zoey/core/theme/colors/app_colors.dart';
import 'package:zoey/core/theme/colors/colors_cheme.dart';
import 'package:zoey/core/theme/components/app_bar_theme_data.dart';
import 'package:zoey/core/theme/components/button_theme_data.dart';
import 'package:zoey/core/theme/components/text_theme_data.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      appBarTheme: appBarTheme(lightColorScheme),
      dividerTheme: DividerThemeData(
        color: lightColorScheme.onSurface.withValues(alpha: 0.1),
        thickness: 0.5,
        space: 1,
      ),
      elevatedButtonTheme: elevatedButtonTheme(lightColorScheme),
      textTheme: textTheme(lightColorScheme),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: appBarTheme(darkColorScheme),
      dividerTheme: DividerThemeData(
        color: darkColorScheme.onSurface.withValues(alpha: 0.1),
        thickness: 0.5,
        space: 1,
      ),
      elevatedButtonTheme: elevatedButtonTheme(darkColorScheme),
      textTheme: textTheme(darkColorScheme),
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
