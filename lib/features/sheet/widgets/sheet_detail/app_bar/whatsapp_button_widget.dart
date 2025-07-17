import 'package:flutter/material.dart';
import 'package:zoey/core/theme/app_theme.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/app_bar/whatsapp_icon_widget.dart';

/// WhatsApp button widget for sheet detail app bar
class WhatsAppButtonWidget extends StatelessWidget {
  final bool isConnected;
  final VoidCallback onPressed;

  const WhatsAppButtonWidget({
    super.key,
    required this.isConnected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: IconButton(
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: isConnected
              ? const Color(0xFF25D366).withValues(alpha: 0.1)
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          foregroundColor: isConnected
              ? const Color(0xFF25D366)
              : AppTheme.getTextSecondary(context),
          padding: const EdgeInsets.all(8),
          minimumSize: const Size(40, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: WhatsAppIconWidget(isConnected: isConnected),
        tooltip: isConnected ? 'WhatsApp Connected' : 'Connect to WhatsApp',
      ),
    );
  }
}
