import 'package:flutter/material.dart';

/// Typography system using Inter font family with system fallbacks
///
/// Inter is specifically designed for user interfaces and provides excellent
/// readability for note-taking and content creation apps. It features:
/// - Optimized for digital screens
/// - High legibility at small sizes
/// - Clear distinction between similar characters
/// - Perfect for both headings and body text
/// - Great for long-form reading experiences
///
/// Falls back to system fonts if Inter is not available.
TextTheme textTheme(ColorScheme colorScheme) {
  // Define the font family with fallbacks for cross-platform compatibility
  const fontFamily = 'Inter';
  const fontFallback = [
    'SF Pro Display', // iOS
    'SF Pro Text', // iOS
    '-apple-system', // iOS/macOS
    'BlinkMacSystemFont', // macOS
    'Segoe UI', // Windows
    'Roboto', // Android
    'Ubuntu', // Ubuntu
    'Helvetica Neue', // macOS fallback
    'Arial', // Universal fallback
    'sans-serif', // Generic fallback
  ];

  return TextTheme(
    // Display styles for large headings
    displayLarge: TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFallback,
      fontWeight: FontWeight.w700,
      fontSize: 32,
      letterSpacing: -0.5,
      color: colorScheme.onSurface,
    ),
    displayMedium: TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFallback,
      fontWeight: FontWeight.w600,
      fontSize: 28,
      letterSpacing: -0.25,
      color: colorScheme.onSurface,
    ),

    // Headline styles for section headers
    headlineLarge: TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFallback,
      fontWeight: FontWeight.w600,
      fontSize: 24,
      letterSpacing: -0.25,
      color: colorScheme.onSurface,
    ),
    headlineMedium: TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFallback,
      fontWeight: FontWeight.w600,
      fontSize: 20,
      letterSpacing: -0.15,
      color: colorScheme.onSurface,
    ),
    headlineSmall: TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFallback,
      fontWeight: FontWeight.w500,
      fontSize: 18,
      letterSpacing: -0.15,
      color: colorScheme.onSurface,
    ),

    // Title styles for content blocks
    titleLarge: TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFallback,
      fontWeight: FontWeight.w500,
      fontSize: 16,
      letterSpacing: 0,
      color: colorScheme.onSurface,
    ),
    titleMedium: TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFallback,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      letterSpacing: 0,
      color: colorScheme.onSurface.withValues(alpha: 0.9),
    ),
    titleSmall: TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFallback,
      fontWeight: FontWeight.w500,
      fontSize: 12,
      letterSpacing: 0,
      color: colorScheme.onSurface.withValues(alpha: 0.8),
    ),

    // Body text - main content (optimized for reading)
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFallback,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      letterSpacing: 0.15,
      height: 1.5,
      color: colorScheme.onSurface.withValues(alpha: 0.87),
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFallback,
      fontWeight: FontWeight.w400,
      fontSize: 14,
      letterSpacing: 0.25,
      height: 1.4,
      color: colorScheme.onSurface.withValues(alpha: 0.87),
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFallback,
      fontWeight: FontWeight.w400,
      fontSize: 12,
      letterSpacing: 0.4,
      height: 1.33,
      color: colorScheme.onSurface.withValues(alpha: 0.6),
    ),

    // Label styles for UI elements
    labelLarge: TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFallback,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      letterSpacing: 0.1,
      color: colorScheme.onSurface.withValues(alpha: 0.87),
    ),
    labelMedium: TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFallback,
      fontWeight: FontWeight.w500,
      fontSize: 12,
      letterSpacing: 0.5,
      color: colorScheme.onSurface.withValues(alpha: 0.87),
    ),
    labelSmall: TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFallback,
      fontWeight: FontWeight.w500,
      fontSize: 10,
      letterSpacing: 0.5,
      color: colorScheme.onSurface.withValues(alpha: 0.6),
    ),
  );
}
