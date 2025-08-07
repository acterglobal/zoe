import 'package:flutter/material.dart';

class ZoeIconButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const ZoeIconButtonWidget({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return IconButton.outlined(
      onPressed: onTap,
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(10),
        backgroundColor: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.05),
        side: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.black.withValues(alpha: 0.1),
        ),
      ),
      icon: Icon(icon, color: theme.colorScheme.onSurface, size: 24),
    );
  }
}
