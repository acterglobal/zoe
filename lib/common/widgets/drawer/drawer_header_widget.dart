import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/app_icon_widget.dart';
import 'package:zoe/core/constants/app_constants.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          AppIconWidget(size: 42),
          const SizedBox(width: 16),
          Expanded(child: _buildAppInfo(context)),
        ],
      ),
    );
  }

  Widget _buildAppInfo(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppConstants.appName,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
            letterSpacing: -0.3,
          ),
        ),
        Text(
          L10n.of(context).nextGenProductivity,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
