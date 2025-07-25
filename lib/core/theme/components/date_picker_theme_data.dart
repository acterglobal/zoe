import 'package:flutter/material.dart';

DatePickerThemeData datePickerTheme(ColorScheme colorScheme) =>
    DatePickerThemeData(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      headerBackgroundColor: colorScheme.primary,
      headerForegroundColor: Colors.white,
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return colorScheme.onSurface;
      }),
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return colorScheme.primary;
        return Colors.transparent;
      }),
      todayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return colorScheme.primary;
      }),
      todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return colorScheme.primary;
        return Colors.transparent;
      }),
      todayBorder: BorderSide(color: colorScheme.primary),
      dividerColor: colorScheme.outline,
      cancelButtonStyle: TextButton.styleFrom(
        foregroundColor: colorScheme.onSurface.withValues(alpha: 0.6),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      confirmButtonStyle: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
    );

TimePickerThemeData timePickerTheme(ColorScheme colorScheme) =>
    TimePickerThemeData(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      hourMinuteColor: colorScheme.onSurface.withValues(alpha: 0.05),
      dayPeriodColor: colorScheme.onSurface.withValues(alpha: 0.05),
      dayPeriodTextColor: colorScheme.onSurface,
      dialHandColor: colorScheme.primary,
      dialBackgroundColor: colorScheme.onSurface.withValues(alpha: 0.05),
      dialTextColor: colorScheme.onSurface,
      cancelButtonStyle: TextButton.styleFrom(
        foregroundColor: colorScheme.onSurface.withValues(alpha: 0.6),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      confirmButtonStyle: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
    );
