import 'package:flutter/material.dart';
import 'package:zoe/features/polls/utils/poll_utils.dart';

class PollProgressWidget extends StatelessWidget {
  final double percentage;
  final int optionIndex;
  final double height;
  final double maxWidth;
  final bool showPercentage;
  final TextStyle? percentageStyle;
  final EdgeInsets? margin;

  const PollProgressWidget({
    super.key,
    required this.percentage,
    required this.optionIndex,
    this.height = 8.0,
    this.maxWidth = 0.8, // 80% of parent width by default
    this.showPercentage = true,
    this.percentageStyle,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = PollUtils.getColorFromOptionIndex(optionIndex);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              height: height,
              width:
                  (MediaQuery.of(context).size.width *
                          maxWidth *
                          (percentage / 100))
                      .clamp(0, MediaQuery.of(context).size.width * maxWidth),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ],
        ),
        if (showPercentage) ...[
          SizedBox(height: height / 2),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style:
                percentageStyle ??
                theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
          ),
        ],
      ],
    );
  }
}
