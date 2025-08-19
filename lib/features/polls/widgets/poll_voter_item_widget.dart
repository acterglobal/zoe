import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/utils/date_time_utils.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/utils/poll_utils.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class PollVoterItemWidget extends ConsumerWidget {
  final Vote vote;
  final int optionIndex;
  const PollVoterItemWidget({super.key, required this.vote, required this.optionIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(loggedInUserProvider).value;
    final isCurrentUser = currentUserId == vote.userId;
    final voteTime = vote.createdAt ?? DateTime.now();
    final theme = Theme.of(context);
    final color = PollUtils.getColorFromOptionIndex(optionIndex);

    return GlassyContainer(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(12),
      borderOpacity: 0.08,
      child: Row(
        children: [
          StyledIconContainer(
            icon: Icons.person,
            iconSize: 20,
            size: 32,
            primaryColor: color,
            shadowOpacity: 0.05,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCurrentUser
                      ? L10n.of(context).you
                      : (ref.watch(getUserByIdProvider(vote.userId))?.name ??
                            vote.userId),
                  style: isCurrentUser
                      ? theme.textTheme.bodyMedium?.copyWith(
                          color: color,
                        )
                      : theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateTimeUtils.formatDateTime(voteTime),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}