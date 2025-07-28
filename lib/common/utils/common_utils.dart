import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoey/l10n/generated/l10n.dart';

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

  /// Launch URL - simplified without redundant error handling
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
}
