import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/zoe_circle_widget.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/polls/utils/poll_utils.dart';
import 'package:zoe/features/polls/widgets/poll_voter_item_widget.dart';
import 'package:zoe/features/users/widgets/user_list_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import 'package:zoe/features/polls/widgets/poll_progress_widget.dart';

class PollDetailsScreen extends ConsumerStatefulWidget {
  final String pollId;

  const PollDetailsScreen({super.key, required this.pollId});

  @override
  ConsumerState<PollDetailsScreen> createState() => _PollDetailsScreenState();
}

class _PollDetailsScreenState extends ConsumerState<PollDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    final poll = ref.watch(pollProvider(widget.pollId));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: ZoeAppBar(title: L10n.of(context).pollDetails),
      ),
      body: poll != null
          ? _buildBody(context, ref, poll)
          : Center(
              child: EmptyStateWidget(
                message: L10n.of(context).pollDetailsNotFound,
              ),
            ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, PollModel poll) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPollDetailsHeader(context, poll, ref),
            const SizedBox(height: 24),
            _buildPollDetailsOptions(context, ref, poll),
          ],
        ),
      ),
    );
  }

  Widget _buildPollDetailsHeader(
    BuildContext context,
    PollModel poll,
    WidgetRef ref,
  ) {
    return GlassyContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.poll_outlined,
                size: 24,
                color: AppColors.brightMagentaColor.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  poll.question,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildPollVotingStatus(context, ref, poll),
        ],
      ),
    );
  }

  Widget _buildPollVotingStatus(BuildContext context, WidgetRef ref, PollModel poll) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final totalMembers = ref.watch(pollSheetMembersProvider(poll.id)).length;
    final membersVoted = ref.watch(pollVotedMembersProvider(poll.id)).length;
    final participationRate = (membersVoted / totalMembers) * 100;

    return Row(
        children: [
          Icon(
            Icons.people_outline,
            size: 18,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      L10n.of(context).membersVoted(membersVoted, totalMembers),
                      style: textTheme.titleSmall,
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) =>
                              _buildPollParticipantsBottomSheet(
                                context,
                                ref,
                                poll,
                              ),
                        );
                      },
                      icon: Icon(
                        Icons.visibility,
                        size: 20,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Text(
                  L10n.of(context).participation('$participationRate%'),
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
    );
  }

  Widget _buildPollDetailsOptions(
    BuildContext context,
    WidgetRef ref,
    PollModel poll,
  ) {
    // Sort options by vote count (highest first)
    final sortedOptions = List<PollOption>.from(poll.options)
      ..sort((a, b) => b.votes.length.compareTo(a.votes.length));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedOptions.length,
      itemBuilder: (context, index) {
        final pollOption = sortedOptions[index];
        return _buildPollOption(context, ref, poll, pollOption);
      },
    );
  }

  Widget _buildPollOption(
    BuildContext context,
    WidgetRef ref,
    PollModel poll,
    PollOption pollOption,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final color = PollUtils.getColorFromOptionId(pollOption.id, poll);
    final voteCount = '${pollOption.votes.length} vote${pollOption.votes.length == 1 ? '' : 's'}';

    return GlassyContainer(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ZoeCircleWidget(size: 12, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  pollOption.title,
                  style: textTheme.titleMedium,
                ),
              ),
              Row(
                children: [
                  if (PollUtils.hasMaxVotes(pollOption, poll))
                    Icon(Icons.star, size: 20, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text(
                    voteCount,
                    style: textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          PollProgressWidget(
            poll: poll,
            option: pollOption,
            color: color,
          ),
          const SizedBox(height: 16),
          _buildUsersVotedList(context, ref, pollOption),
        ],
      ),
    );
  }

  Widget _buildUsersVotedList(
    BuildContext context,
    WidgetRef ref,
    PollOption pollOption,
  ) {
    final theme = Theme.of(context);
    if (pollOption.votes.isEmpty) {
      return Text(
        L10n.of(context).noVotesYet,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${L10n.of(context).voters}:',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: pollOption.votes.length,
          itemBuilder: (context, index) {
            final vote = pollOption.votes[index];
            return PollVoterItemWidget(vote: vote);
          },
        ),
      ],
    );
  }

  Widget _buildPollParticipantsBottomSheet(
    BuildContext context,
    WidgetRef ref,
    PollModel poll,
  ) {
    return UserListWidget(
      userIdList: pollSheetMemberIdsProvider(poll.id),
      title: L10n.of(context).pollParticipants,
      actionWidget: (userId) {
        final votedMemberIds = ref.read(pollVotedMemberIdsProvider(poll.id));
        final hasVoted = votedMemberIds.contains(userId);
        return hasVoted
            ? Text(
                L10n.of(context).voted,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }
}
