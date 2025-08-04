import 'package:flutter/material.dart';

class ZoeIconButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const ZoeIconButtonWidget({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.05),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Icon(icon, color: theme.colorScheme.onSurface, size: 24),
      ),
    );
  }
}
