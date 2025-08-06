import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/events/models/rsvp_event_response_model.dart';
import 'package:zoey/features/events/providers/events_proivder.dart';
import 'package:zoey/l10n/generated/l10n.dart';

class EventRsvpCountWidget extends ConsumerWidget {
  final String eventId;

  const EventRsvpCountWidget({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rsvpCount = ref.watch(eventListProvider.notifier).getRsvpCount(eventId);
    final totalRsvpCount = ref.watch(eventListProvider.notifier).getTotalRsvpCount(eventId);

    if (totalRsvpCount == 0) return const SizedBox.shrink();

    final yesCount = rsvpCount[RsvpStatus.yes] ?? 0;

    return _buildRsvpCountText(context, yesCount);
  }

  Widget _buildRsvpCountText(
    BuildContext context,
    int yesCount
  ) {
    final l10n = L10n.of(context);

    if (yesCount == 0) return const SizedBox.shrink();

    String countText = yesCount == 1 ? l10n.isGoing(yesCount) : l10n.areGoing(yesCount);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            yesCount == 1 ? Icons.person_rounded : Icons.people_rounded,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            countText,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
