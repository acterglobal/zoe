 import 'package:flutter/material.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/polls/models/poll_model.dart';

Widget pollCheckboxWidget(
    BuildContext context,
    PollModel poll,
    PollOption option,
    bool isVoted,
  ) {
    final color = AppColors.brightMagentaColor.withValues(alpha: 0.6);
    final themeColor = Theme.of(context).colorScheme;
    return Container(
      width: 16,
      height: 16,
      decoration: poll.isMultipleChoice
          ? BoxDecoration(
              shape: BoxShape.rectangle,
              color: isVoted
                  ? color
                  : themeColor.surface.withValues(alpha: 0.8),
              border: Border.all(
                color: isVoted
                    ? color
                    : themeColor.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            )
          : BoxDecoration(
              shape: BoxShape.circle,
              color: isVoted
                  ? color
                  : themeColor.surface.withValues(alpha: 0.8),
              border: Border.all(
                color: isVoted
                    ? color
                    : themeColor.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
      child: isVoted
          ? Icon(
              poll.isMultipleChoice ? Icons.check : Icons.circle,
              color: AppColors.darkOnSurface,
              size: 10,
            )
          : null,
    );
  }