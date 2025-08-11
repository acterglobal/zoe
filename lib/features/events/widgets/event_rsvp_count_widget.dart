import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/events/providers/events_proivder.dart';
import 'package:zoey/features/users/widgets/user_list_widget.dart';
import 'package:zoey/l10n/generated/l10n.dart';

class EventRsvpCountWidget extends ConsumerWidget {
  final String eventId;

  const EventRsvpCountWidget({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventRSVPYesCount = ref.watch(eventRsvpYesCountProvider(eventId));
    final totalRsvpCount = ref.watch(eventTotalRsvpCountProvider(eventId));

    if (totalRsvpCount == 0) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => _showRsvpUsersBottomSheet(context),
      child: _buildRsvpCountText(context, eventRSVPYesCount),
    );
  }

  Widget _buildRsvpCountText(
    BuildContext context,
    int eventRSVPYesCount
  ) {
    final l10n = L10n.of(context);

    if (eventRSVPYesCount == 0) return const SizedBox.shrink();

    String countText = eventRSVPYesCount == 1 ? l10n.isGoing(eventRSVPYesCount) : l10n.areGoing(eventRSVPYesCount);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            eventRSVPYesCount == 1 ? Icons.person_rounded : Icons.people_rounded,
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

  void _showRsvpUsersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          return UserListWidget(
            userIdList: eventRsvpYesUsersProvider(eventId),
            title: L10n.of(context).membersGoingToEvent,
            onTapUser: (userId) {
              Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }
}
