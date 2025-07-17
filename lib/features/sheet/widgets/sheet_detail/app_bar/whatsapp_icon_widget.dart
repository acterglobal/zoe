import 'package:flutter/material.dart';
import 'package:zoey/core/theme/app_theme.dart';

/// A reusable widget for displaying WhatsApp connection status icon
class WhatsAppIconWidget extends StatelessWidget {
  final bool isConnected;

  const WhatsAppIconWidget({super.key, required this.isConnected});

  @override
  Widget build(BuildContext context) {
    final color = isConnected
        ? const Color(0xFF25D366)
        : AppTheme.getTextSecondary(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Background circle (WhatsApp green or gray)
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        // Phone icon in white
        const Icon(Icons.phone_rounded, size: 12, color: Colors.white),
      ],
    );
  }
}
