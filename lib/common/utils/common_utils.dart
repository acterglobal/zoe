import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoe/common/utils/validation_utils.dart';
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
      if (!ValidationUtils.isValidUrl(url)) {
        showSnackBar(context, L10n.of(context).couldNotOpenLink);
        return false;
      }
      final uri = Uri.parse(getUrlWithProtocol(url));
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

  /// convert Color <-> Hex String
  static String clrToHex(Color color) =>
      '#${color.value.toRadixString(16).padLeft(8, '0')}';

  static Color clrFromHex(String hex) =>
      Color(int.parse(hex.replaceAll('#', ''), radix: 16));
}
