import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/polls/screens/poll_details_screen.dart';
import 'package:zoe/features/polls/utils/poll_utils.dart';
import 'package:zoe/features/polls/widgets/poll_checkbox_widget.dart';
import 'package:zoe/features/polls/widgets/poll_settings_widget.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import 'package:zoe/features/polls/widgets/poll_progress_widget.dart';

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
        if (PollUtils.isCompleted(poll))
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
            isEditing: PollUtils.isDraft(poll) && isEditing,
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
      children: poll.options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        return _buildPollOptionWidget(context, ref, poll, option, index);
      }).toList(),
    );
  }

  Widget _buildPollOptionWidget(
    BuildContext context,
    WidgetRef ref,
    PollModel poll,
    PollOption option,
    int optionIndex,
  ) {
    final totalVotes = poll.totalVotes;
    final percentage = totalVotes > 0
        ? (option.votes.length / totalVotes) * 100
        : 0.0;
    final currentUserId = ref.watch(loggedInUserProvider).value;
    final isVoted =
        currentUserId != null &&
        option.votes.any((vote) => vote.userId == currentUserId);
    final color = PollUtils.getColorFromOptionIndex(optionIndex);
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: PollUtils.isActive(poll)
              ? () {
                  final currentUserId = ref.read(loggedInUserProvider).value;
                  if (currentUserId != null) {
                    ref
                        .read(pollListProvider.notifier)
                        .voteOnPoll(pollId, option.id, currentUserId);
                  }
                }
              : (){
                if(PollUtils.isDraft(poll)) {
                  CommonUtils.showSnackBar(context, L10n.of(context).thisPollIsNotYetStarted);
                }
              },
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
                pollCheckboxWidget(context, poll, option, isVoted, optionIndex),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEditableOptionText(context, ref, poll, option),
                      const SizedBox(height: 2),
                      PollProgressWidget(
                        percentage: percentage,
                        option: option,
                        optionIndex: optionIndex,
                        height: 4.0,
                        maxWidth: 0.6,
                        showPercentage: true,
                        percentageStyle: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _buildVoteCount(context, option, isVoted, optionIndex),
              ],
            ),
          ),
        ),
        if (PollUtils.isDraft(poll) && isEditing && poll.options.length > 1)
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
      isEditing: PollUtils.isDraft(poll) && isEditing,
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

  Widget _buildViewVotesDetailsButton(
    BuildContext context,
    WidgetRef ref,
    PollModel poll,
  ) {

    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PollDetailsScreen(pollId: pollId),
          ),
        );
      },
      child: Row(
        children: [
          Icon(
            Icons.visibility,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            L10n.of(context).viewVotes,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
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
            if (PollUtils.isDraft(poll) && isEditing)
              addPollOptionWidget(context, ref, poll),
            if (PollUtils.isDraft(poll)) ...[
              _buildPollClosedMessage(context, ref, poll),
              startPollButtonWidget(context, ref, poll),
            ],
            if (PollUtils.isActive(poll) && !isEditing) ...[
              const Spacer(),
              endPollButtonWidget(context, ref, poll),
            ],
          ],
        ),
        if (PollUtils.isDraft(poll) && isEditing) ...[
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
    if (PollUtils.isActive(poll)) return const SizedBox.shrink();
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
                PollUtils.isDraft(poll)
                ? L10n.of(context).thisPollIsNotYetStarted : L10n.of(context).thisPollIsClosed,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.errorContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (!PollUtils.isDraft(poll))
            _buildViewVotesDetailsButton(context, ref, poll),
        ],
      ),
    );
  }

  Widget _buildVoteCount(
    BuildContext context,
    PollOption option,
    bool isVoted,
    int optionIndex,
  ) {
    final color = PollUtils.getColorFromOptionIndex(optionIndex);
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
