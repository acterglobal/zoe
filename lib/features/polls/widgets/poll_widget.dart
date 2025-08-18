import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/polls/utils/poll_utils.dart';
import 'package:zoe/features/polls/widgets/poll_checkbox_widget.dart';
import 'package:zoe/features/polls/widgets/poll_settings_widget.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class PollWidget extends ConsumerWidget {
  final String pollId;
  final bool isEditing;

  const PollWidget({super.key, required this.pollId, required this.isEditing});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poll = ref.watch(pollProvider(pollId));

    if (poll == null) return const SizedBox.shrink();

    return _buildPollContent(context, ref, poll);
  }

  Widget _buildPollContent(
    BuildContext context,
    WidgetRef ref,
    PollModel poll,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        _buildPollQuestion(context, ref, poll),
        const SizedBox(height: 16),
        _buildPollOptionsList(context, ref, poll),
        const SizedBox(height: 12),
        _buildPollActions(context, ref, poll),
        if (PollUtils.isEnded(poll))
          _buildPollClosedMessage(context, ref, poll),
      ],
    );
  }

  Widget _buildPollQuestion(
    BuildContext context,
    WidgetRef ref,
    PollModel poll,
  ) {
    return Row(
      children: [
        Icon(
          Icons.poll_outlined,
          size: 20,
          color: AppColors.brightMagentaColor.withValues(alpha: 0.8),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ZoeInlineTextEditWidget(
            hintText: L10n.of(context).pollTitle,
            text: poll.question,
            isEditing: PollUtils.isNotStarted(poll) && isEditing,
            textInputAction: TextInputAction.next,
            textStyle: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            onTextChanged: (value) {
              ref
                  .read(pollListProvider.notifier)
                  .updatePollQuestion(pollId, value);
            },
          ),
        ),
        if (isEditing)
          GestureDetector(
            onTap: () {
              ref.read(pollListProvider.notifier).deletePoll(pollId);
            },
            child: Icon(
              Icons.delete,
              size: 16,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
      ],
    );
  }

  Widget _buildPollOptionsList(
    BuildContext context,
    WidgetRef ref,
    PollModel poll,
  ) {
    return Column(
      children: poll.options.map((option) {
        return _buildPollOptionWidget(context, ref, poll, option);
      }).toList(),
    );
  }

  Widget _buildPollOptionWidget(
    BuildContext context,
    WidgetRef ref,
    PollModel poll,
    PollOption option,
  ) {
    final totalVotes = poll.totalVotes;
    final percentage = totalVotes > 0
        ? (option.votes.length / totalVotes) * 100
        : 0.0;
    final currentUserId = ref.watch(loggedInUserProvider).value;
    final isVoted =
        currentUserId != null &&
        option.votes.any((vote) => vote.userId == currentUserId);
    final color = CommonUtils().getRandomColorFromName(option.title);
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: PollUtils.isStarted(poll)
              ? () {
                  final currentUserId = ref.read(loggedInUserProvider).value;
                  if (currentUserId != null) {
                    ref
                        .read(pollListProvider.notifier)
                        .voteOnPoll(pollId, option.id, currentUserId);
                  }
                }
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            margin: const EdgeInsets.only(bottom: 8),
            clipBehavior: Clip.none,
            decoration: BoxDecoration(
              color: isVoted
                  ? color.withValues(alpha: 0.08)
                  : theme.colorScheme.surface.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isVoted
                    ? color.withValues(alpha: 0.4)
                    : color.withValues(alpha: 0.1),
                width: isVoted ? 1 : 0.5,
              ),
            ),
            child: Row(
              children: [
                pollCheckboxWidget(context, poll, option, isVoted),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEditableOptionText(context, ref, poll, option),
                      const SizedBox(height: 2),
                      _buildVoteProgress(
                        context,
                        percentage,
                        option
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _buildVoteCount(context, option, isVoted),
              ],
            ),
          ),
        ),
        if (PollUtils.isNotStarted(poll) &&
            isEditing &&
            poll.options.length > 1)
          Positioned(
            top: -16,
            right: -16,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                ref
                    .read(pollListProvider.notifier)
                    .deletePollOption(pollId, option.id);
              },
              icon: Icon(
                Icons.cancel,
                size: 16,
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEditableOptionText(
    BuildContext context,
    WidgetRef ref,
    PollModel poll,
    PollOption option,
  ) {
    return ZoeInlineTextEditWidget(
      hintText: L10n.of(context).enterOptionText,
      text: option.title,
      isEditing: PollUtils.isNotStarted(poll) && isEditing,
      textStyle: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
      onTextChanged: (value) {
        ref
            .read(pollListProvider.notifier)
            .updatePollOptionText(pollId, option.id, value);
      },
    );
  }

  Widget _buildVoteProgress(
    BuildContext context,
    double percentage,
    PollOption option,
  ) {
    if (option.votes.isEmpty) return const SizedBox.shrink();
    final color = CommonUtils().getRandomColorFromName(option.title);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              height: 4,
              width:
                  (MediaQuery.of(context).size.width * 0.6 * (percentage / 100))
                      .clamp(0, MediaQuery.of(context).size.width * 0.6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),
        Text(
          '${percentage.toStringAsFixed(1)}%',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalVotesCountWidget(
    BuildContext context,
    WidgetRef ref,
    PollModel poll,
  ) {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          poll.totalVotes == 1 ? Icons.person_outline : Icons.people_outline,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          poll.totalVotes == 1
              ? l10n.vote(poll.totalVotes)
              : l10n.votes(poll.totalVotes),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildPollActions(
    BuildContext context,
    WidgetRef ref,
    PollModel poll,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (PollUtils.isNotStarted(poll) && isEditing)
              addPollOptionWidget(context, ref, poll),
            if (PollUtils.isNotStarted(poll)) ...[
              const Spacer(),
              startPollButtonWidget(context, ref, poll),
            ],
            if (PollUtils.isStarted(poll) && !isEditing) ...[
              const Spacer(),
              endPollButtonWidget(context, ref, poll),
            ],
          ],
        ),
        if (PollUtils.isNotStarted(poll) && isEditing) ...[
          const SizedBox(height: 12),
          choiceTypeSelectorWidget(context, ref, poll),
        ],
      ],
    );
  }

  Widget _buildPollClosedMessage(
    BuildContext context,
    WidgetRef ref,
    PollModel poll,
  ) {
    if (PollUtils.isStarted(poll)) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return GlassyContainer(
      padding: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.lock,
                size: 16,
                color: theme.colorScheme.errorContainer,
              ),
              const SizedBox(width: 8),
              Text(
                L10n.of(context).thisPollIsClosed,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.errorContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          _buildTotalVotesCountWidget(context, ref, poll),
        ],
      ),
    );
  }

  Widget _buildVoteCount(BuildContext context, PollOption option, bool isVoted) {
    final color = CommonUtils().getRandomColorFromName(option.title);
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isVoted
            ? color.withValues(alpha: 0.15)
            : theme.colorScheme.surface.withValues(alpha: 0.2),
        border: Border.all(
          color: isVoted
              ? color.withValues(alpha: 0.3)
              : theme.colorScheme.outline.withValues(alpha: 0.15),
          width: 1,
        ),
        shape: BoxShape.circle,
      ),
      child: Text(
        '${option.votes.length}',
        style: theme.textTheme.bodySmall?.copyWith(
          color: isVoted ? color : theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }
}
