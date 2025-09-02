import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/widgets/event_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class EventListWidget extends ConsumerWidget {
  final ProviderBase<List<EventModel>> eventsProvider;
  final bool isEditing;
  final int? maxItems;
  final bool shrinkWrap;

  const EventListWidget({
    super.key,
    required this.eventsProvider,
    required this.isEditing,
    this.maxItems,
    this.shrinkWrap = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventsProvider);
    if (events.isEmpty) {
      return EmptyStateWidget(message: L10n.of(context).noEventsFound);
    }

    final itemCount = maxItems != null
        ? min(maxItems!, events.length)
        : events.length;

    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final event = events[index];
        return EventWidget(
            key: ValueKey(event.id),
            eventsId: event.id,
            isEditing: isEditing,
          );
      },
    );
  }
}
