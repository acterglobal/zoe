import 'package:flutter/material.dart';

class AppColors {
  //General Colors
  static const Color primaryColor = Color.fromARGB(255, 54, 115, 176);
  static const Color secondaryColor = Color.fromARGB(255, 61, 179, 143);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFEF4444);

  // Light Theme Colors
  static const Color lightBackground = Color(
    0xFFFFFDF7,
  ); // Warm paper-like white
  static const Color lightSurface = Color(0xFFFFFDF7); // Warm paper-like white
  static const Color lightOnSurface = Colors.black;

  // Dark Theme Colors
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkOnSurface = Colors.white;

  // Warm Paper Colors - Centralized
  static const Color warmPaperWhite = Color(0xFFFFFDF7);
  static const Color warmPaperCenter = Color(0xFFFFFBF0);

  /// Get warm paper colors for light mode, theme surface for dark mode
  static Color getWarmSurface(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Theme.of(context).colorScheme.surface : warmPaperWhite;
  }

  /// Get warm paper gradient colors
  static List<Color> getWarmPaperGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = Theme.of(context).colorScheme.surface;

    return isDark
        ? [surface, surface.withValues(alpha: 0.95), surface]
        : [warmPaperWhite, warmPaperCenter, warmPaperWhite];
  }

  /// Get warm paper color with alpha for glassmorphism effects
  static Color getWarmSurfaceWithAlpha(BuildContext context, double alpha) {
    return getWarmSurface(context).withValues(alpha: alpha);
  }
}
