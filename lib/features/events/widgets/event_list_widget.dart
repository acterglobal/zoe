import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/events/providers/events_proivder.dart';
import 'package:zoey/features/events/widgets/event_widget.dart';

class EventListWidget extends ConsumerWidget {
  final String parentId;

  const EventListWidget({super.key, required this.parentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventByParentProvider(parentId));
    if (events.isEmpty) return const SizedBox.shrink();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return EventWidget(key: ValueKey(event.id), eventsId: event.id);
      },
    );
  }
}
