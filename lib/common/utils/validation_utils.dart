import 'package:flutter/material.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class ValidationUtils {
  static bool isValidName(String name) {
    if (name.isEmpty) return false;
    return true;
  }

  static String? validateFirstName(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return L10n.of(context).pleaseEnterAValidFirstName;
    }
    return null;
  }

  static String? validateLastName(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return L10n.of(context).pleaseEnterAValidLastName;
    }
    return null;
  }

  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;

    url = CommonUtils.getUrlWithProtocol(url);

    final urlRegex = RegExp(
      r'((([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,})|' // domain
      r'localhost|' // localhost
      r'(\d{1,3}\.){3}\d{1,3})' // OR ip (v4)
      r'(:\d+)?' // optional port
      r'(\/[^\s]*)?$', // optional path
      caseSensitive: false,
    );

    if (urlRegex.hasMatch(url)) {
      try {
        final uri = Uri.parse(url);
        return uri.hasScheme && uri.hasAuthority;
      } catch (e) {
        return false;
      }
    }

    return false;
  }

  static bool isValidWhatsAppGroupLink(String link) {
    final whatsappGroupLinkPattern = RegExp(
      r'^https?:\/\/chat\.whatsapp\.com\/([A-Za-z0-9]{22})(?:\/)?(?:\?[^\s#]*)?$',
    );
    return whatsappGroupLinkPattern.hasMatch(link);
  }

  /// Validates email format
  /// Returns error message if invalid, null if valid
  static String? validateEmail(BuildContext context, String? value) {
    final l10n = L10n.of(context);
    if (value == null || value.isEmpty) {
      return l10n.pleaseEnterYourEmail;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return l10n.pleaseEnterAValidEmail;
    }
    return null;
  }

  /// Validates password (minimum 6 characters)
  /// Returns error message if invalid, null if valid
  static String? validatePassword(BuildContext context, String? value) {
    final l10n = L10n.of(context);
    if (value == null || value.isEmpty) {
      return l10n.pleaseEnterAPassword;
    }
    if (value.length < 6) {
      return l10n.passwordMustBeAtLeast6Characters;
    }
    return null;
  }

  /// Validates confirm password matches the original password
  /// Returns error message if invalid, null if valid
  static String? validateConfirmPassword(BuildContext context, String? value, String password) {
    final l10n = L10n.of(context);
    if (value == null || value.isEmpty) {
      return l10n.pleaseConfirmYourPassword; 
    }
    if (value != password) {
      return l10n.passwordsDoNotMatch;
    }
    return null;
  }
}
