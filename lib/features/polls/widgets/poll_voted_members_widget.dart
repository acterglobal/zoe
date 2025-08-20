import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class PollVotedMembersWidget extends ConsumerWidget {
  final String pollId;
  const PollVotedMembersWidget({super.key, required this.pollId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final votingData = ref.watch(pollVotingDataProvider(pollId));
    final memberVotingStatus = votingData['memberVotingStatus'];
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
            Text(
              l10n.membersWhoVoted,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 8),
            ...memberVotingStatus.map((entry) {
              final userId = entry.key;
              final votes = entry.value;
              final user = ref.watch(getUserByIdProvider(userId));

              if (user == null) return const SizedBox.shrink();

              return Container(
                margin: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: votes.isNotEmpty
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.3,
                              ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        user.name,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.8,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      votes.isNotEmpty ? l10n.voted : '',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: votes.isNotEmpty
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }),
      ],
    );
  }
}