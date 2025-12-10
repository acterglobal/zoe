import 'package:flutter/material.dart';

extension ColorExtension on Color {
  /// Converts the color to a hex string with a leading #.
  String toHex() => '#${value.toRadixString(16).padLeft(8, '0')}';
}

extension StringToColorExtension on String {
  /// Converts a hex string (with or without a leading #) to a Color.
  Color toColor() => Color(int.parse(replaceAll('#', ''), radix: 16));
}
