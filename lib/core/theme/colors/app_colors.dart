import 'package:flutter/material.dart';

class AppColors {
  // Modern 2025 Color Palette - Inspired by Future Dusk & Teal trends
  static const Color primaryColor = Color(
    0xFF4C5578,
  ); // Future Dusk - sophisticated purple-blue
  static const Color secondaryColor = Color(
    0xFF71ADBA,
  ); // Retro Blue - calming teal
  static const Color accentColor = Color(0xFF9B59B6); // Modern Purple accent
  static const Color successColor = Color(0xFF10B981); // Emerald green
  static const Color warningColor = Color(0xFFEDEAB1); // Celestial Yellow
  static const Color errorColor = Color(0xFFEF4444); // Modern red

  // Light Theme Colors - Modern clean aesthetic
  static const Color lightBackground = Color(0xFFFBFBFD); // Clean modern white
  static const Color lightSurface = Color(0xFFFFFFFF); // Pure white surfaces
  static const Color lightOnSurface = Color(0xFF1A1A1A); // Soft black

  // Dark Theme Colors - Deep sophisticated tones
  static const Color darkSurface = Color(0xFF0F0F11); // Deep charcoal
  static const Color darkBackground = Color(0xFF000000); // Pure black
  static const Color darkOnSurface = Color(0xFFF5F5F7); // Off-white text

  // Modern Gradient Colors - 2025 Trends
  static const Color gradientStart = Color(0xFF4C5578); // Future Dusk
  static const Color gradientMiddle = Color(0xFF71ADBA); // Retro Blue
  static const Color gradientEnd = Color(0xFF9B59B6); // Modern Purple

  // Modern Surface Colors - Clean & sophisticated
  static const Color modernSurfacePrimary = Color(0xFF0F0F11); // Deep charcoal
  static const Color modernSurfaceSecondary = Color(
    0xFF1A1A1D,
  ); // Slightly lighter
  static const Color modernSurfaceTertiary = Color(
    0xFF2D2D30,
  ); // Card backgrounds

  /// Get modern surface colors for both light and dark modes
  static Color getModernSurface(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? modernSurfacePrimary : lightSurface;
  }

  /// Get modern gradient colors for both light and dark modes
  static List<Color> getModernGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return isDark
        ? [modernSurfacePrimary, modernSurfaceSecondary, modernSurfacePrimary]
        : [
            // Light theme: subtle but visible gradient using modern colors
            const Color(0xFFF8F9FB), // Very light blue-gray
            const Color(0xFFF5F7FA), // Slightly different tint
            const Color(0xFFF2F4F8), // Soft gradient end
          ];
  }

  /// Get modern color with alpha for glassmorphism effects
  static Color getModernSurfaceWithAlpha(BuildContext context, double alpha) {
    return getModernSurface(context).withValues(alpha: alpha);
  }

  /// Get 2025 trending gradient - Future Dusk to Retro Blue
  static List<Color> getTrendingGradient() {
    return [gradientStart, gradientMiddle, gradientEnd];
  }

  /// Get accent color variations for modern UI
  static List<Color> getAccentVariations() {
    return [
      accentColor.withValues(alpha: 0.1), // Very light
      accentColor.withValues(alpha: 0.3), // Light
      accentColor, // Full
      Color(0xFF7B3F98), // Darker variation
    ];
  }

  /// Get paper sheet gradient specifically optimized for backgrounds
  static List<Color> getPaperSheetGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return isDark
        ? [modernSurfacePrimary, modernSurfaceSecondary, modernSurfacePrimary]
        : [
            // Light theme: warm paper-like gradient with subtle depth
            const Color(0xFFFBFCFE), // Pure white with blue hint
            const Color(0xFFF7F9FC), // Light blue-gray
            const Color(0xFFF3F6FA), // Slightly deeper
          ];
  }
}
