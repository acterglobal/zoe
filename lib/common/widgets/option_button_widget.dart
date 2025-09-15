import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';

class OptionButtonWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final TextStyle? titleStyle;
  final String? subtitle;
  final TextStyle? subtitleStyle;
  final Color color;
  final VoidCallback? onTap;

  const OptionButtonWidget({
    super.key,
    required this.icon,
    required this.title,
    this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: GlassyContainer(
        padding: const EdgeInsets.all(10),
        borderRadius: BorderRadius.circular(16),
        borderOpacity: 0.1,
        shadowOpacity: 0.05,
        child: Row(
          children: [
            StyledIconContainer(
              icon: icon,
              size: 50,
              primaryColor: color,
              borderRadius: BorderRadius.circular(24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: titleStyle ?? theme.textTheme.titleMedium),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: subtitleStyle ?? theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
