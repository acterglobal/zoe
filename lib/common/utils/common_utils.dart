import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
}
