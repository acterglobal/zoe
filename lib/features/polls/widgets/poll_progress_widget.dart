import 'package:flutter/material.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/utils/poll_utils.dart';

class PollProgressWidget extends StatelessWidget {
  final PollOption option;
  final PollModel poll;
  final double height;
  final Color color;
  final double maxWidth;
  final bool showPercentage;
  final TextStyle? percentageStyle;
  final EdgeInsets? margin;

  const PollProgressWidget({
    super.key,
    required this.option,
    required this.poll,
    required this.color,
    this.height = 8.0,
    this.maxWidth = 0.8, // 80% of parent width by default
    this.showPercentage = true,
    this.percentageStyle,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (option.votes.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: height,
          child: LinearProgressIndicator(
            value: PollUtils.calculateVotePercentage(option, poll) / 100,
            backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.6),
            valueColor: AlwaysStoppedAnimation<Color>(color.withValues(alpha: 0.8)),
            borderRadius: BorderRadius.circular(height / 2),
          ),
        ),
        if (showPercentage) ...[
          SizedBox(height: height / 2),
          Text(
            '${PollUtils.calculateVotePercentage(option, poll).toStringAsFixed(1)}%',
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
