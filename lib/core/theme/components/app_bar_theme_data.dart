import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

AppBarTheme appBarTheme(ColorScheme colorScheme) {
  final isDark = colorScheme.brightness == Brightness.dark;
  return AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    systemOverlayStyle: isDark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark,
  );
}
