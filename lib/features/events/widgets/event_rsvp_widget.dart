import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/events/models/events_model.dart';
import 'package:zoey/features/events/providers/events_proivder.dart';
import 'package:zoey/features/events/utils/event_utils.dart';
import 'package:zoey/features/events/widgets/event_rsvp_count_widget.dart';
import 'package:zoey/features/users/providers/user_providers.dart';
import 'package:zoey/l10n/generated/l10n.dart';

class EventRsvpWidget extends ConsumerWidget {
  final String eventId;

  const EventRsvpWidget({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRsvp = ref.watch(currentUserRsvpProvider(eventId));
    final currentUser = ref.watch(loggedInUserProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, currentRsvp.value),
        const SizedBox(height: 16),
        _buildRsvpButtons(context, ref, currentRsvp.value, currentUser.value ?? ''),
      ],
    );
  }

  // Header widget with status
  Widget _buildHeader(BuildContext context, RsvpStatus? currentRsvp) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    return Row(
      children: [
        // Status Icon
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.event_available_rounded,
            color: theme.colorScheme.primary,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        // Title + Count
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.willYouAttend,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  EventRsvpCountWidget(eventId: eventId),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // RSVP button row
  Widget _buildRsvpButtons(
    BuildContext context,
    WidgetRef ref,
    RsvpStatus? currentRsvp,
    String currentUser,
  ) {
    return Row(
      children: RsvpStatus.values
          .map(
            (status) => Expanded(
              child: _buildRsvpButton(
                context: context,
                ref: ref,
                status: status,
                isSelected: currentRsvp == status,
                currentUser: currentUser,
              ),
            ),
          )
          .toList(),
    );
  }

  // RSVP button item
  Widget _buildRsvpButton({
    required BuildContext context,
    required WidgetRef ref,
    required RsvpStatus status,
    required bool isSelected,
    required String currentUser,
  }) {
    final theme = Theme.of(context);
    final statusColor = EventUtils.getRsvpStatusColor(status);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          ref.read(eventListProvider.notifier).updateRsvpResponse(
                eventId,
                currentUser,
                status,
              );
        },
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? statusColor.withValues(alpha: 0.08)
                : theme.colorScheme.surface.withValues(alpha: 0.08),
            border: Border.all(
              color: isSelected
                  ? statusColor.withValues(alpha: 0.4)
                  : theme.dividerColor.withValues(alpha: 0.2),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                status == RsvpStatus.yes
                    ? Icons.check_circle_rounded
                    : status == RsvpStatus.no
                        ? Icons.cancel_rounded
                        : Icons.question_mark_rounded,
                size: 20,
                color: statusColor,
              ),
              const SizedBox(height: 4),
              Text(
                status.name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? statusColor
                      : theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
