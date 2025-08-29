import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class QuickSearchTabSectionHeaderWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const QuickSearchTabSectionHeaderWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
        children: [
          StyledIconContainer(
            icon: icon,
            iconSize: 15,
            primaryColor: color,
            shadowOpacity: 0.1,
            borderOpacity: 0.1,
            size: 30,
            borderRadius: BorderRadius.circular(30),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onTap,
            child: Text(
            L10n.of(context).viewAll,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],

    );
  }
}