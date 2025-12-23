import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';

class SettingItemWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? leadingWidget;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback onTap;

  const SettingItemWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.leadingWidget,
    this.icon,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: _buildLeadingWidget(),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
          height: 1.3,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        size: 20,
      ),
      onTap: onTap,
    );
  }

  Widget? _buildLeadingWidget() {
    if (leadingWidget != null) return leadingWidget;
    if (icon != null) {
      return StyledIconContainer(
        icon: icon!,
        primaryColor: iconColor,
        size: 48,
        iconSize: 24,
        backgroundOpacity: 0.1,
        borderOpacity: 0.15,
        shadowOpacity: 0.12,
      );
    }
    return null;
  }
}
