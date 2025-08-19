import 'package:flutter/material.dart';

class ZoeIconButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double? size;
  final double? padding;

  const ZoeIconButtonWidget({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 24,
    this.padding = 10,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return IconButton.outlined(
      onPressed: onTap,
      style: IconButton.styleFrom(
        minimumSize: Size.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: EdgeInsets.all(padding ?? 10),
        backgroundColor: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.05),
        side: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.black.withValues(alpha: 0.1),
        ),
      ),
      icon: Icon(icon, color: theme.colorScheme.onSurface, size: size),
    );
  }
}
