import 'package:flutter/material.dart';

class ZoeIconContainer extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final VoidCallback? onTap;

  const ZoeIconContainer({
    super.key,
    required this.icon,
    this.size = 72,
    this.backgroundColor,
    this.iconColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius = 36,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = backgroundColor ?? 
        theme.colorScheme.primary.withValues(alpha: 0.15);
    final effectiveIconColor = iconColor ?? theme.colorScheme.primary;
    final effectiveBorderColor = borderColor ?? 
        theme.colorScheme.error.withValues(alpha: 0.2);

    Widget iconWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: effectiveBorderColor,
          width: borderWidth,
        ),
      ),
      child: Icon(
        icon,
        size: size * 0.5, // Icon size is half of container size
        color: effectiveIconColor,
      ),
    );

    return iconWidget;
  }
} 