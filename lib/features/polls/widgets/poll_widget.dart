import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/display_sheet_name_widget.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/content/providers/content_menu_providers.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/polls/utils/poll_utils.dart';
import 'package:zoe/features/polls/widgets/poll_checkbox_widget.dart';
import 'package:zoe/features/polls/widgets/poll_settings_widget.dart';

import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import 'package:zoe/features/polls/widgets/poll_progress_widget.dart';
import 'package:zoe/features/polls/screens/poll_details_screen.dart';

class PollWidget extends ConsumerWidget {
  final String pollId;
  final bool showSheetName;

  const PollWidget({
    super.key,
    required this.pollId,
    this.showSheetName = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poll = ref.watch(pollProvider(pollId));

    if (poll == null) return const SizedBox.shrink();

    return GestureDetector(
      onLongPress: () =>
          ref.read(editContentIdProvider.notifier).state = pollId,
      child: _buildPollContent(context, ref, poll),
    );
  }

  Widget _buildPollContent(
    BuildContext context,
    WidgetRef ref,
    PollModel poll,
  ) {
    final editContentId = ref.watch(editContentIdProvider);
    final isEditing = editContentId == pollId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        _buildPollQuestion(context, ref, poll, isEditing),
        const SizedBox(height: 2),
        if (showSheetName) ...[
          Row(
            children: [
              const SizedBox(width: 30),
              DisplaySheetNameWidget(sheetId: poll.sheetId),
            ],
          ),
        ],
        const SizedBox(height: 16),
        _buildPollOptionsList(context, ref, poll, isEditing),
        const SizedBox(height: 12),
        _buildPollActions(context, ref, poll, isEditing),
        if (PollUtils.isCompleted(poll))
          _buildPollClosedMessage(context, ref, poll, isEditing),
      ],
    );
  }

  Widget _buildPollQuestion(
    BuildContext context,
    WidgetRef ref,
    PollModel poll,
    bool isEditing,
  ) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        if (CommonUtils.findAncestorWidgetOfExactType<PollDetailsScreen>(
              context,
            ) ==
            null) {
          context.push(
            AppRoutes.pollDetails.route.replaceAll(':pollId', pollId),
          );
        }
      },
      child: Row(
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
              textStyle: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              onTextChanged: (value) {
                ref
                    .read(pollListProvider.notifier)
                    .updatePollQuestion(pollId, value);
              },
              onTapText: () {
                if (CommonUtils.findAncestorWidgetOfExactType<
                      PollDetailsScreen
                    >(context) ==
                    null) {
                  context.push(
                    AppRoutes.pollDetails.route.replaceAll(':pollId', pollId),
                  );
                }
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
                color: theme.colorScheme.error,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPollOptionsList(
    BuildContext context,
    WidgetRef ref,
    PollModel poll,
    bool isEditing,
  ) {
    return Column(
      children: poll.options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        return _buildPollOptionWidget(
          context,
          ref,
          poll,
          option,
          index,
          isEditing,
        );
      }).toList(),
    );
  }

  Widget _buildPollOptionWidget(
    BuildContext context,
    WidgetRef ref,
    PollModel poll,
    PollOption option,
    int optionIndex,
    bool isEditing,
  ) {
    final isVoted = PollUtils.isUserVoted(poll, option, ref);
    final color = PollUtils.getColorFromOptionId(option.id, poll);
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {
            if (PollUtils.isActive(poll)) {
              final currentUserId = ref.read(loggedInUserProvider).value;
              if (currentUserId != null) {
                // Get current state before voting
                final currentStateOfActivePollsWithPendingResponse = ref.read(
                  activePollsWithPendingResponseProvider,
                );

                ref
                    .read(pollListProvider.notifier)
                    .voteOnPoll(pollId, option.id, currentUserId);

                // added cause need to remain the state same for home screen poll list to show current user voted poll
                ref
                        .read(activePollsWithPendingResponseProvider.notifier)
                        .state =
                    currentStateOfActivePollsWithPendingResponse;
              }
            }
            if (PollUtils.isDraft(poll)) {
              CommonUtils.showSnackBar(
                context,
                L10n.of(context).thisPollIsNotYetStarted,
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            margin: const EdgeInsets.only(bottom: 8),
            clipBehavior: Clip.none,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withValues(alpha: 0.1),
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
                      _buildEditableOptionText(
                        context,
                        ref,
                        poll,
                        option,
                        isEditing,
                      ),
                      const SizedBox(height: 2),
                      PollProgressWidget(
                        option: option,
                        poll: poll,
                        color: color,
                        height: 4.0,
                        maxWidth: 0.6,
                        percentageStyle: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _buildVoteCount(context, poll, option, isVoted),
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
    bool isEditing,
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
        context.push(AppRoutes.pollResults.route.replaceAll(':pollId', pollId));
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
    bool isEditing,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (PollUtils.isDraft(poll) && isEditing)
              addPollOptionWidget(context, ref, poll),
            if (PollUtils.isDraft(poll)) ...[
              _buildPollClosedMessage(context, ref, poll, isEditing),
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
    bool isEditing,
  ) {
    if (PollUtils.isActive(poll) || (PollUtils.isDraft(poll) && isEditing)) {
      return const SizedBox.shrink();
    }
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
                color: PollUtils.isDraft(poll)
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.4)
                    : theme.colorScheme.errorContainer,
              ),
              const SizedBox(width: 8),
              Text(
                PollUtils.isDraft(poll)
                    ? L10n.of(context).thisPollIsNotYetStarted
                    : L10n.of(context).thisPollIsClosed,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: PollUtils.isDraft(poll)
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.4)
                      : theme.colorScheme.errorContainer,
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
    PollModel poll,
    PollOption option,
    bool isVoted,
  ) {
    final color = PollUtils.getColorFromOptionId(option.id, poll);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isVoted
            ? color.withValues(alpha: 0.15)
            : colorScheme.surface.withValues(alpha: 0.2),
        border: Border.all(
          color: isVoted
              ? color.withValues(alpha: 0.3)
              : colorScheme.outline.withValues(alpha: 0.15),
          width: 1,
        ),
        shape: BoxShape.circle,
      ),
      child: Text(
        '${option.votes.length}',
        style: textTheme.bodySmall?.copyWith(
          color: isVoted ? color : colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }
}
