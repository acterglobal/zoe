import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/common/utils/feature_colors_utils.dart';

class FeatureItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const FeatureItem({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Get feature colors for the shadow effect and icon
    final featureColors = FeatureColorsUtils.getFeatureColors(title, context);

    return GlassyContainer(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      shadowColor: featureColors['primary'],
      child: Row(
        children: [
          StyledIconContainer(
            icon: icon,
            primaryColor: featureColors['primary'],
            secondaryColor: featureColors['secondary'],
          ),
          const SizedBox(width: 20),
          Expanded(child: _buildContentSection(context, theme)),
        ],
      ),
    );
  }

  Widget _buildContentSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.75),
            height: 1.4,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}
