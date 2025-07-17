import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const Color primary = Color(0xFF6366F1);
  static const Color background = Color(0xFFF8F9FE);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color purple = Color(0xFF8B5CF6);

  // Dark Theme Colors - Enhanced for better contrast
  static const Color darkPrimary = Color(0xFF6366F1);
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Brighter white
  static const Color darkTextSecondary = Color(
    0xFFCBD5E1,
  ); // Brighter secondary
  static const Color darkTextTertiary = Color(0xFF94A3B8); // Dimmer tertiary
  static const Color darkSuccess = Color(0xFF22C55E); // Brighter green
  static const Color darkWarning = Color(0xFFF59E0B);
  static const Color darkError = Color(0xFFEF4444);
  static const Color darkPurple = Color(0xFF8B5CF6);
  static const Color darkBorder = Color(0xFF475569);
  static const Color darkBorderInput = Color(
    0xFF64748B,
  ); // Brighter input borders
  static const Color darkHint = Color(0xFF94A3B8); // Better hint color

  // Context-aware color getters
  static Color getBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackground
        : background;
  }

  static Color getSurface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSurface
        : surface;
  }

  static Color getSurfaceVariant(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSurfaceVariant
        : const Color(0xFFF3F4F6);
  }

  static Color getTextPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextPrimary
        : textPrimary;
  }

  static Color getTextSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextSecondary
        : textSecondary;
  }

  static Color getBorder(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBorder
        : const Color(0xFFE5E7EB);
  }

  static Color getBorderInput(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBorderInput
        : const Color(0xFFD1D5DB);
  }

  static Color getTextTertiary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextTertiary
        : const Color(0xFF9CA3AF);
  }

  static Color getHint(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkHint
        : const Color(0xFF9CA3AF);
  }

  static Color getSuccess(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSuccess
        : success;
  }

  static Color getWarning(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkWarning
        : warning;
  }

  static Color getError(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkError : error;
  }

  // Text Styles - Context-aware
  static TextStyle heading1(BuildContext context) => TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: getTextPrimary(context),
  );

  static TextStyle heading2(BuildContext context) => TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: getTextPrimary(context),
  );

  static TextStyle heading3(BuildContext context) => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: getTextPrimary(context),
  );

  static TextStyle heading4(BuildContext context) => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: getTextPrimary(context),
  );

  static TextStyle heading5(BuildContext context) => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: getTextPrimary(context),
  );

  static TextStyle heading6(BuildContext context) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: getTextPrimary(context),
  );

  static TextStyle bodyLarge(BuildContext context) =>
      TextStyle(fontSize: 16, color: getTextPrimary(context));

  static TextStyle bodyMedium(BuildContext context) =>
      TextStyle(fontSize: 14, color: getTextPrimary(context));

  static TextStyle bodySmall(BuildContext context) =>
      TextStyle(fontSize: 12, color: getTextSecondary(context));

  static TextStyle labelLarge(BuildContext context) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: getTextPrimary(context),
  );

  static TextStyle labelMedium(BuildContext context) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: getTextPrimary(context),
  );

  static TextStyle labelSmall(BuildContext context) => TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: getTextPrimary(context),
  );

  // Button Styles
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: primary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 0,
  );

  // Card Style
  static BoxDecoration cardDecoration = BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, purple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
