import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/styled_content_container_widget.dart';

class InfoHeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final double containerPadding;
  final double borderRadius;
  final double iconSize;
  final double containerSize;
  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? iconColor;

  const InfoHeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.containerPadding = 20.0,
    this.borderRadius = 20.0,
    this.iconSize = 28.0,
    this.containerSize = 56.0,
    this.primaryColor,
    this.secondaryColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final primary = primaryColor ?? colorScheme.primary;
    final secondary = secondaryColor ?? colorScheme.secondary;
    final iconColor = this.iconColor ?? primary;

    return GlassyContainer(
      padding: EdgeInsets.all(containerPadding),
      borderRadius: BorderRadius.circular(borderRadius),
      child: Row(
        children: [
          StyledContentContainer(
            size: containerSize,
            primaryColor: primary,
            secondaryColor: secondary,
            borderRadius: BorderRadius.circular(16),
            child: Icon(
              icon,
              color: iconColor,
              size: iconSize,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
