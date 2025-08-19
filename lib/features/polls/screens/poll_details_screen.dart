import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/polls/utils/poll_utils.dart';
import 'package:zoe/features/polls/widgets/poll_voter_item_widget.dart';
import 'package:zoe/features/polls/widgets/poll_voted_members_widget.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import 'package:zoe/features/polls/widgets/poll_progress_widget.dart';

class PollDetailsScreen extends ConsumerStatefulWidget {
  final String pollId;

  const PollDetailsScreen({super.key, required this.pollId});

  @override
  ConsumerState<PollDetailsScreen> createState() => _PollDetailsScreenState();
}

class _PollDetailsScreenState extends ConsumerState<PollDetailsScreen> {
  bool _showVotingStatus = false;

  @override
  Widget build(BuildContext context) {
    final poll = ref.watch(pollProvider(widget.pollId));
    if (poll == null) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: ZoeAppBar(title: L10n.of(context).pollDetails),
      ),
      body: _buildBody(context, ref, poll),
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
    final totalVotes = ref.watch(pollTotalVotesBySheetIdProvider(poll.sheetId));
    final totalMembers = ref.watch(usersBySheetIdProvider(poll.sheetId)).length;
    final votingData = ref.watch(pollVotingDataProvider(poll.id));
    final theme = Theme.of(context);

    // Count how many members have voted
    final membersVoted = votingData['membersVoted'] as int;

    // Calculate participation rate based on members who voted
    final participationRate = votingData['participationRate'] as double;

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
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              setState(() {
                _showVotingStatus = !_showVotingStatus;
              });
            },
            child: Row(
              children: [
                Icon(
                  totalVotes == 1 ? Icons.person_outline : Icons.people_outline,
                  size: 18,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
                            L10n.of(
                              context,
                            ).membersVoted(membersVoted, totalMembers),
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                           Icon(
                                  _showVotingStatus
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  size: 20,
                                  color: _showVotingStatus
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                        ],
                      ),
                      Text(
                        L10n.of(context).participation('$participationRate%'),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      
          if (membersVoted > 0 && _showVotingStatus)
            PollVotedMembersWidget(
              memberVotingStatus: votingData['memberVotingStatus'],
            ),
        ],
      ),
    );
  }

  Widget _buildPollDetailsOptions(
    BuildContext context,
    WidgetRef ref,
    PollModel poll,
  ) {
    // Sort options by vote count (highest first)
    final sortedOptions = poll.options.asMap().entries.toList()
      ..sort((a, b) => b.value.votes.length.compareTo(a.value.votes.length));
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...sortedOptions.map(
          (pollOption) =>
              _buildPollOption(context, ref, poll, pollOption),
        ),
      ],
    );
  }

  Widget _buildPollOption(
    BuildContext context,
    WidgetRef ref,
    PollModel poll,
    MapEntry<int, PollOption> pollOption,
  ) {

    final pollOptionKey = pollOption.key;
    final pollOptionValue = pollOption.value;

    final theme = Theme.of(context);
    final totalVotes = poll.totalVotes;
    final percentage = totalVotes > 0
        ? (pollOptionValue.votes.length / totalVotes) * 100
        : 0.0;
    final color = PollUtils.getColorFromOptionIndex(pollOptionKey);

    // display the star if the option has the max votes
    final isMaxVotes =
        pollOptionValue.votes.length ==
        poll.options.map((o) => o.votes.length).reduce((a, b) => a > b ? a : b);

   

    return GlassyContainer(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  pollOptionValue.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                children: [
                  if (isMaxVotes)
                    Icon(Icons.star, size: 20, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text(
                    '${pollOptionValue.votes.length} vote${pollOptionValue.votes.length == 1 ? '' : 's'}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          PollProgressWidget(
            percentage: percentage,
            optionIndex: pollOptionKey,
          ),
          const SizedBox(height: 16),
          _buildUsersVotedList(context, ref, pollOptionValue),
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
        ...pollOption.votes.map((vote) => PollVoterItemWidget(vote: vote)),
      ],
    );
  }
}
