import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';

class StepIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final double height;
  final double spacing;
  final double borderRadius;
  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? inactiveColor;

  const StepIndicatorWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.height = 6.0,
    this.spacing = 8.0,
    this.borderRadius = 3.0,
    this.primaryColor,
    this.secondaryColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlassyContainer(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(children: _buildStepIndicators(context)),
    );
  }

  /// Builds the list of step indicator widgets
  List<Widget> _buildStepIndicators(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = primaryColor ?? colorScheme.primary;
    final secondary = secondaryColor ?? colorScheme.secondary;
    final inactive =
        inactiveColor ?? colorScheme.outline.withValues(alpha: 0.2);

    final List<Widget> indicators = [];

    for (int i = 1; i <= totalSteps; i++) {
      final isActive = i <= currentStep;

      // Add step indicator
      indicators.add(
        Expanded(
          child: Container(
            height: height,
            decoration: BoxDecoration(
              gradient: isActive
                  ? LinearGradient(colors: [primary, secondary])
                  : null,
              color: isActive ? null : inactive,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
      );

      // Add spacing between steps (except after the last step)
      if (i < totalSteps) {
        indicators.add(SizedBox(width: spacing));
      }
    }

    return indicators;
  }
}
