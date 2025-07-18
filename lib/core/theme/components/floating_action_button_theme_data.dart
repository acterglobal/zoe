import 'package:flutter/material.dart';

FloatingActionButtonThemeData floatingActionButtonTheme(
  ColorScheme colorScheme,
) => FloatingActionButtonThemeData(
  backgroundColor: colorScheme.primary,
  foregroundColor: colorScheme.onSurface,
);
