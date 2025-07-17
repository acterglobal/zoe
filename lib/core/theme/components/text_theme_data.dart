import 'package:flutter/material.dart';

TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
  titleSmall: TextStyle(
    fontWeight: FontWeight.w400,
    color: colorScheme.onSurface.withValues(alpha: 0.8),
  ),
);
