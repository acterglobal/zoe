import 'package:flutter/material.dart';

class AppColors {
  //General Colors - Warm Orange Palette
  static const Color primaryColor = Color.fromARGB(
    255,
    222,
    136,
    61,
  ); // Vibrant warm orange
  static const Color secondaryColor = Color.fromARGB(
    255,
    228,
    167,
    97,
  ); // Golden amber
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFEF4444);

  // Light Theme Colors
  static const Color lightBackground = Color(
    0xFFFFFDF7,
  ); // Warm paper-like white
  static const Color lightSurface = Color(0xFFFFFDF7); // Warm paper-like white
  static const Color lightOnSurface = Colors.black;

  // Dark Theme Colors - Warm black tones
  static const Color darkSurface = Color(0xFF1C1C1E); // Warm dark gray
  static const Color darkBackground = Color(0xFF000000); // Pure black
  static const Color darkOnSurface = Colors.white;

  // Warm Paper Colors - Centralized
  static const Color warmPaperWhite = Color(0xFFFFFDF7);
  static const Color warmPaperCenter = Color(0xFFFFFBF0);

  // Warm Dark Colors - Centralized
  static const Color warmDarkPrimary = Color(0xFF1C1C1E); // Main dark surface
  static const Color warmDarkSecondary = Color(0xFF2C2C2E); // Slightly lighter
  static const Color warmDarkTertiary = Color(0xFF3A3A3C); // Card backgrounds

  /// Get warm surface colors for both light and dark modes
  static Color getWarmSurface(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? warmDarkPrimary : warmPaperWhite;
  }

  /// Get warm gradient colors for both light and dark modes
  static List<Color> getWarmPaperGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return isDark
        ? [warmDarkPrimary, warmDarkSecondary, warmDarkPrimary]
        : [warmPaperWhite, warmPaperCenter, warmPaperWhite];
  }

  /// Get warm paper color with alpha for glassmorphism effects
  static Color getWarmSurfaceWithAlpha(BuildContext context, double alpha) {
    return getWarmSurface(context).withValues(alpha: alpha);
  }
}
