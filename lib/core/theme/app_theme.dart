import 'package:flutter/material.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/core/theme/colors/colors_cheme.dart';
import 'package:zoe/core/theme/components/app_bar_theme_data.dart';
import 'package:zoe/core/theme/components/button_theme_data.dart';
import 'package:zoe/core/theme/components/input_decoration.dart';
import 'package:zoe/core/theme/components/text_theme_data.dart';
import 'package:zoe/core/theme/components/date_picker_theme_data.dart';
import 'package:zoe/core/theme/components/floating_action_button_theme_data.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      floatingActionButtonTheme: floatingActionButtonTheme(darkColorScheme),
      appBarTheme: appBarTheme(lightColorScheme),
      dividerTheme: DividerThemeData(
        color: lightColorScheme.onSurface.withValues(alpha: 0.1),
        thickness: 0.5,
        space: 1,
      ),
      inputDecorationTheme: inputDecorationTheme(lightColorScheme),
      elevatedButtonTheme: elevatedButtonTheme(lightColorScheme),
      textButtonTheme: textButtonTheme(lightColorScheme),
      outlinedButtonTheme: outlinedButtonTheme(lightColorScheme),
      textTheme: textTheme(lightColorScheme),
      datePickerTheme: datePickerTheme(lightColorScheme),
      timePickerTheme: timePickerTheme(lightColorScheme),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      floatingActionButtonTheme: floatingActionButtonTheme(darkColorScheme),
      appBarTheme: appBarTheme(darkColorScheme),
      dividerTheme: DividerThemeData(
        color: darkColorScheme.onSurface.withValues(alpha: 0.1),
        thickness: 0.5,
        space: 1,
      ),
      inputDecorationTheme: inputDecorationTheme(darkColorScheme),
      elevatedButtonTheme: elevatedButtonTheme(darkColorScheme),
      textButtonTheme: textButtonTheme(darkColorScheme),
      textTheme: textTheme(darkColorScheme),
      datePickerTheme: datePickerTheme(darkColorScheme),
      timePickerTheme: timePickerTheme(darkColorScheme),
    );
  }
}
