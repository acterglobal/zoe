import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class DrawerSettingsWidget extends StatelessWidget {
  const DrawerSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: StyledIconContainer(
          icon: Icons.settings_rounded,
          iconSize: 24,
          size: 40,
        ),
        title: Text(
          L10n.of(context).settings,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          size: 16,
        ),
        onTap: () => _navigateToSettings(context),
      ),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.of(context).pop();
    context.push(AppRoutes.settings.route);
  }
}
