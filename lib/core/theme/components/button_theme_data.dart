import 'package:flutter/material.dart';

ElevatedButtonThemeData elevatedButtonTheme(ColorScheme colorScheme) =>
    ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );

TextButtonThemeData textButtonTheme(ColorScheme colorScheme) =>
    TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        minimumSize: Size.zero,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface.withValues(alpha: 0.6),
      ),
    );

OutlinedButtonThemeData outlinedButtonTheme(ColorScheme colorScheme) =>
    OutlinedButtonThemeData(
      style: TextButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: BorderSide(
          color: colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
    );