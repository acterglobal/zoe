import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/styled_content_container_widget.dart';

class ImportantNoteWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final double containerPadding;
  final double borderRadius;
  final Color? primaryColor;
  final Color? secondaryColor;
  final VoidCallback? onTap;

  const ImportantNoteWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.containerPadding = 20.0,
    this.borderRadius = 16.0,
    this.primaryColor,
    this.secondaryColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final primary = primaryColor ?? colorScheme.primary;
    final secondary = secondaryColor ?? colorScheme.secondary;

    return GestureDetector(
      onTap: onTap,
      child: GlassyContainer(
        padding: EdgeInsets.all(containerPadding),
        borderRadius: BorderRadius.circular(borderRadius),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              StyledContentContainer(
                size: 48,
                primaryColor: primary,
                secondaryColor: secondary,
                borderRadius: BorderRadius.circular(12),
                child: Icon(icon, color: primary, size: 24),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
