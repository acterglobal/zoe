import 'package:flutter/material.dart';

TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
  titleSmall: TextStyle(
    fontWeight: FontWeight.w400,
    color: colorScheme.onSurface.withValues(alpha: 0.8),
  ),
  labelMedium: TextStyle(fontWeight: FontWeight.w400),
  labelSmall: TextStyle(
    fontWeight: FontWeight.w400,
    color: colorScheme.onSurface.withValues(alpha: 0.6),
  ),
  bodyLarge: TextStyle(
    fontWeight: FontWeight.w400,
    color: colorScheme.onSurface.withValues(alpha: 0.7),
  ),
  bodyMedium: TextStyle(
    fontWeight: FontWeight.w400,
    color: colorScheme.onSurface.withValues(alpha: 0.7),
  ),
  bodySmall: TextStyle(
    fontWeight: FontWeight.w400,
    color: colorScheme.onSurface.withValues(alpha: 0.7),
  ),
);
