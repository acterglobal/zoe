import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

Widget addPollOptionWidget(
  BuildContext context,
  WidgetRef ref,
  PollModel poll,
) {
  final theme = Theme.of(context);
  return GestureDetector(
    onTap: () => ref.read(pollListProvider.notifier).addPollOption(poll.id, ''),
    child: Row(
      children: [
        Icon(
          Icons.add_circle,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          size: 24,
        ),
        const SizedBox(width: 4),
        Text(
          L10n.of(context).addOption,
          style: theme.textTheme.bodySmall,
        ),
      ],
    ),
  );
}

Widget startPollButtonWidget(
  BuildContext context,
  WidgetRef ref,
  PollModel poll,
) {
  final theme = Theme.of(context);
  return GestureDetector(
    onTap: () => ref.read(pollListProvider.notifier).startPoll(context, poll),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.play_circle_outline,
          size: 18,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          L10n.of(context).startPoll,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    ),
  );
}

Widget endPollButtonWidget(
  BuildContext context,
  WidgetRef ref,
  PollModel poll,
) {
  final theme = Theme.of(context);
  return GestureDetector(
    onTap: () => ref.read(pollListProvider.notifier).endPoll(poll.id),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.stop_circle, size: 18, color: theme.colorScheme.error),
        const SizedBox(width: 8),
        Text(
          L10n.of(context).endPoll,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.error,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

Widget choiceTypeSelectorWidget(
  BuildContext context,
  WidgetRef ref,
  PollModel poll,
) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Single Choice Option
      choiceOptionWidget(
        context: context,
        isSelected: !poll.isMultipleChoice,
        label: L10n.of(context).singleChoice,
        icon: Icons.radio_button_checked,
        ref: ref,
        poll: poll,
      ),

      // Multiple Choice Option
      choiceOptionWidget(
        context: context,
        isSelected: poll.isMultipleChoice,
        label: L10n.of(context).multipleChoice,
        icon: Icons.check_box,
        ref: ref,
        poll: poll,
      ),
    ],
  );
}

Widget choiceOptionWidget({
  required BuildContext context,
  required bool isSelected,
  required String label,
  required IconData icon,
  required WidgetRef ref,
  required PollModel poll,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  return GestureDetector(
    onTap: () =>
        ref.read(pollListProvider.notifier).togglePollMultipleChoice(poll.id),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? (colorScheme.primary.withValues(alpha: 0.15))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected
                ? (colorScheme.primary)
                : (colorScheme.onSurface.withValues(alpha: 0.7)),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isSelected
                  ? (colorScheme.primary)
                  : (colorScheme.onSurface.withValues(alpha: 0.7)),
              fontSize: 12,
            ),
          ),
        ],
      ),
    ),
  );
}
