import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/core/theme/colors/app_colors.dart';
import 'package:zoey/features/events/models/rsvp_event_response_model.dart';
import 'package:zoey/features/events/providers/events_proivder.dart';
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
        _buildRsvpHeader(context, ref, currentRsvp),
        const SizedBox(height: 16),
        Row(
          children: RsvpStatus.values
              .where((s) => s != RsvpStatus.pending)
              .map(
                (status) => Expanded(
                  child: _buildRsvpButton(
                    context,
                    ref,
                    status,
                    currentRsvp?.status == status,
                    currentUser.value ?? '',
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildRsvpHeader(
    BuildContext context,
    WidgetRef ref,
    RsvpResponse? currentRsvp,
  ) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: currentRsvp != null
                ? _getStatusColor(currentRsvp.status).withValues(alpha: 0.1)
                : theme.colorScheme.primary.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(
            currentRsvp != null
                ? Icons.check_circle_rounded
                : Icons.event_available_rounded,
            color: currentRsvp != null
                ? _getStatusColor(currentRsvp.status)
                : theme.colorScheme.primary,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.willYouAttend,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (currentRsvp != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        currentRsvp.status,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(currentRsvp.status.emoji),
                        const SizedBox(width: 6),
                        Text(
                          currentRsvp.status.label,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(currentRsvp.status),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRsvpButton(
    BuildContext context,
    WidgetRef ref,
    RsvpStatus status,
    bool isSelected,
    String currentUser,
  ) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(status);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          ref
              .read(eventListProvider.notifier)
              .updateRsvpResponse(
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
              Text(status.emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 4),
              Text(
                status.label,
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

  Color _getStatusColor(RsvpStatus status) {
    switch (status) {
      case RsvpStatus.yes:
        return AppColors.successColor;
      case RsvpStatus.no:
        return AppColors.errorColor;
      case RsvpStatus.maybe:
        return AppColors.warningColor;
      case RsvpStatus.pending:
        return AppColors.accentColor;
    }
  }
}
