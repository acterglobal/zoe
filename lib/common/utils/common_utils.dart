import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoe/common/utils/validation_utils.dart';
import 'package:zoe/core/constants/app_constants.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class CommonUtils {
  static String generateRandomId() => const Uuid().v4();

  static const List<TargetPlatform> desktopPlatforms = [
    TargetPlatform.macOS,
    TargetPlatform.linux,
    TargetPlatform.windows,
  ];

  static bool isDesktop(BuildContext context) =>
      desktopPlatforms.contains(Theme.of(context).platform);

  static Future<bool> openUrl(
    String url,
    BuildContext context, {
    bool isCheckProtocols = true,
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    try {
      if (!ValidationUtils.isValidUrl(url)) {
        showSnackBar(context, L10n.of(context).couldNotOpenLink);
        return false;
      }
      final uri = Uri.parse(isCheckProtocols ? getUrlWithProtocol(url) : url);
      return await launchUrl(uri, mode: mode);
    } catch (e) {
      return false;
    }
  }

  static String getUrlWithProtocol(String url) {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'https://$url';
    }
    return url;
  }

  Color getRandomColorFromName(String name) {
    final colors = [
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.deepOrange,
      Colors.brown,
    ];

    // color based on the name
    int hash = name.hashCode;
    return colors[hash.abs() % colors.length];
  }

  static void showSnackBar(BuildContext context, String message) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: theme.colorScheme.surface,
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  static void shareText(String text, {String? subject}) {
    final params = ShareParams(text: text, subject: subject);
    SharePlus.instance.share(params);
  }

  static T? findAncestorWidgetOfExactType<T extends Widget>(
    BuildContext context,
  ) {
    return context.findAncestorWidgetOfExactType<T>();
  }

  /// Returns true if the keyboard is visible, false otherwise
  static bool isKeyboardOpen(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    return viewInsets.bottom > 0;
  }

  //-----------------------------------------------------------#
  // EXTERNAL LINK & SHARE UTILITIES
  // Handles navigation to Stores, Legal Docs, and Sharing
  //-----------------------------------------------------------#
  static void shareApp(BuildContext context) {
    final l10n = L10n.of(context);
    return shareText(
      l10n.shareAppMessage(
        AppConstants.appName,
        AppConstants.playStoreUrl,
        AppConstants.appStoreUrl,
      ),
      subject: l10n.share,
    );
  }

  static Future<bool> openStoreUrl(BuildContext context) async {
    return await openUrl(AppConstants.storeUrl, context);
  }

  static Future<bool> openPrivacyPolicyUrl(BuildContext context) async {
    return await openUrl(AppConstants.privacyPolicyUrl, context);
  }

  static Future<bool> openTermsAndConditionsUrl(BuildContext context) async {
    return await openUrl(AppConstants.termsAndConditionsUrl, context);
  }

  static Future<bool> openContactEmail(BuildContext context) async {
    final url = 'mailto:${AppConstants.contactEmail}';
    return await openUrl(url, context, isCheckProtocols: false);
  }
}
