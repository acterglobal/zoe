import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';
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
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    try {
      if (!isValidUrl(url)) {
        showSnackBar(context, L10n.of(context).couldNotOpenLink);
        return false;
      }
      final uri = Uri.parse(getUrlWithProtocol(url));
      return await launchUrl(uri, mode: mode);
    } catch (e) {
      return false;
    }
  }

  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;

    url = getUrlWithProtocol(url);

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

  static String getUrlWithProtocol(String url) {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'https://$url';
    }
    return url;
  }
}
