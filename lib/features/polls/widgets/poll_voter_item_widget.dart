import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/utils/date_time_utils.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_avatar_widget.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

class PollVoterItemWidget extends ConsumerWidget {
  final Vote vote;

  const PollVoterItemWidget({
    super.key,
    required this.vote,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(getUserByIdProvider(vote.userId));
    if (user == null) return const SizedBox.shrink();

    return GlassyContainer(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(12),
      borderOpacity: 0.08,
      child: Row(
        children: [
          ZoeUserAvatarWidget(user: user),
          const SizedBox(width: 12),
          _buildVoterUserInfo(context, ref, vote),
        ],
      ),
    );
  }

  Widget _buildVoterUserInfo(BuildContext context, WidgetRef ref, Vote vote) {
   
    final voteTime = vote.createdAt ?? DateTime.now();
    final theme = Theme.of(context);
    final userName = ref.watch(userDisplayNameProvider(vote.userId));

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userName,
            style: theme.textTheme.bodyMedium?.copyWith(
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
    );
  }
}
