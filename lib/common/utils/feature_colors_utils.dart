import 'package:flutter/material.dart';

class FeatureColorsUtils {
  /// Get feature-specific colors based on feature name
  static Map<String, Color> getFeatureColors(
    String featureName,
    BuildContext context,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (featureName.toLowerCase()) {
      case 'organize':
        return {
          'primary': isDark
              ? const Color(0xFF66BB6A).withValues(alpha: 0.8)
              : const Color(0xFF4CAF50).withValues(alpha: 0.7),
          'secondary': const Color(0xFFA5D6A7).withValues(alpha: 0.6),
        };
      case 'plan':
        return {
          'primary': isDark
              ? const Color(0xFF42A5F5).withValues(alpha: 0.8)
              : const Color(0xFF1976D2).withValues(alpha: 0.7),
          'secondary': const Color(0xFF90CAF9).withValues(alpha: 0.6),
        };
      case 'create':
        return {
          'primary': isDark
              ? const Color(0xFFFFB74D).withValues(alpha: 0.8)
              : const Color(0xFFF57C00).withValues(alpha: 0.7),
          'secondary': const Color(0xFFFFCC02).withValues(alpha: 0.5),
        };
      case 'settings':
        return {
          'primary': isDark
              ? const Color(0xFF78909C).withValues(alpha: 0.8)
              : const Color(0xFF455A64).withValues(alpha: 0.7),
          'secondary': const Color(0xFFB0BEC5).withValues(alpha: 0.6),
        };
      case 'profile':
        return {
          'primary': isDark
              ? const Color(0xFFAB47BC).withValues(alpha: 0.8)
              : const Color(0xFF7B1FA2).withValues(alpha: 0.7),
          'secondary': const Color(0xFFE1BEE7).withValues(alpha: 0.6),
        };
      default:
        return {
          'primary': colorScheme.primary.withValues(alpha: 0.7),
          'secondary': colorScheme.secondary.withValues(alpha: 0.6),
        };
    }
  }

  /// Get feature primary color only
  static Color getFeaturePrimaryColor(
    String featureName,
    BuildContext context,
  ) {
    return getFeatureColors(featureName, context)['primary']!;
  }

  /// Get feature secondary color only
  static Color getFeatureSecondaryColor(
    String featureName,
    BuildContext context,
  ) {
    return getFeatureColors(featureName, context)['secondary']!;
  }
}
