import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonUtils {
  static String generateRandomId() => const Uuid().v4();

  static String getNextEmoji(String currentEmoji) {
    const emojis = ['📝', '📅', '📌', '🎯', '🔍', '📋', '📂', '📅'];
    final currentIndex = emojis.indexOf(currentEmoji);
    final nextIndex = (currentIndex + 1) % emojis.length;
    return emojis[nextIndex];
  }

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
      final uri = Uri.parse(url);
      return await launchUrl(uri, mode: mode);
    } catch (e) {
      return false;
    }
  }

  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;

    // Add protocol if missing
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

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
}
