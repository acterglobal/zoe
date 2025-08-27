import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/styled_content_container_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class GuideStepWidget extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String description;
  final String imagePath;
  final double imageHeight;
  final double containerPadding;
  final double borderRadius;

  const GuideStepWidget({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.imagePath,
    this.imageHeight = 200.0,
    this.containerPadding = 20.0,
    this.borderRadius = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return GlassyContainer(
      padding: EdgeInsets.all(containerPadding),
      borderRadius: BorderRadius.circular(borderRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(context),
          const SizedBox(height: 20),
          _buildStepImage(context),
        ],
      ),
    );
  }

  Widget _buildStepHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        StyledContentContainer(
          size: 40,
          primaryColor: colorScheme.primary,
          secondaryColor: colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
          child: Text(
            stepNumber.toString(),
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepImage(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        imagePath,
        width: double.infinity,
        height: imageHeight,
        fit: BoxFit.cover,
        errorBuilder: (context, _, _) => _buildStepImageError(context),
      ),
    );
  }

  Widget _buildStepImageError(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      height: imageHeight,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StyledContentContainer(
              size: 64,
              primaryColor: colorScheme.primary.withValues(alpha: 0.5),
              secondaryColor: colorScheme.secondary.withValues(alpha: 0.5),
              child: Icon(
                Icons.image_not_supported_outlined,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              L10n.of(context).imageNotFound,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
