import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:zoe/features/content/providers/content_menu_providers.dart';
import 'package:zoe/features/content/providers/content_providers.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/providers/events_proivder.dart';
import 'package:zoe/features/events/screens/event_detail_screen.dart';
import 'package:zoe/features/events/screens/events_list_screen.dart';
import 'package:zoe/features/events/widgets/event_list_widget.dart';
import 'package:zoe/features/events/widgets/event_widget.dart';
import 'package:widgetbook_workspace/features/events/mock_event_providers.dart';
import 'package:widgetbook_workspace/features/home/zoe_preview_widget.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

@widgetbook.UseCase(name: 'Event List Widget', type: EventListWidget)
Widget buildEventListWidgetUseCase(BuildContext context) {
  final isEditing = context.knobs.boolean(
    label: 'Is Editing',
    description: 'Toggle edit mode',
    initialValue: false,
  );

  final shrinkWrap = context.knobs.boolean(
    label: 'Shrink Wrap',
    description: 'Whether to shrink wrap the list',
    initialValue: true,
  );

  final maxItems = context.knobs.int.input(
    label: 'Max Items',
    description: 'Maximum number of items to display',
    initialValue: 3,
  );

  final currentUserRsvp = context.knobs.object.dropdown(
    label: 'Current User RSVP',
    options: RsvpStatus.values,
    initialOption: RsvpStatus.yes,
    labelBuilder: (status) => status.name,
  );

  final rsvpYesCount = context.knobs.int.input(
    label: 'RSVP Yes Count',
    initialValue: 1,
    description: 'Number of users who RSVP\'d yes',
  );

  final totalRsvpCount = context.knobs.int.input(
    label: 'Total RSVP Count',
    initialValue: 3,
    description: 'Total number of RSVPs',
  );

  return Consumer(
    builder: (context, ref, _) {
      final eventCount = context.knobs.int.input(
        label: 'Event Count',
        initialValue: 3,
      );

      final events = List.generate(eventCount, (index) {
        final startDate = DateTime.now().add(Duration(days: index));
        return EventModel(
          id: 'event-$index',
          title: context.knobs.string(
            label: 'Event $index Title',
            initialValue: 'Event $index',
          ),
          startDate: startDate,
          endDate: startDate.add(const Duration(hours: 2)),
          parentId: 'list-1',
          orderIndex: index,
          rsvpResponses: {'user_1': RsvpStatus.yes},
          sheetId: 'mock-sheet-1',
        );
      });

      return ProviderScope(
        overrides: [
          eventListProvider.overrideWith(
            (ref) => MockEventNotifier()..setEvents(events),
          ),
          eventProvider.overrideWith((ref, eventId) {
            final eventList = ref.watch(eventListProvider);
            return eventList.where((e) => e.id == eventId).firstOrNull;
          }),
          todaysEventsProvider.overrideWith(
            (ref) => ref.watch(mockTodaysEventsProvider),
          ),
          upcomingEventsProvider.overrideWith(
            (ref) => ref.watch(mockUpcomingEventsProvider),
          ),
          pastEventsProvider.overrideWith(
            (ref) => ref.watch(mockPastEventsProvider),
          ),
          contentListProvider.overrideWith((ref) => []),
          contentProvider.overrideWith((ref, id) => null),
          contentListByParentIdProvider.overrideWith((ref, id) => []),
          isEditValueProvider.overrideWith((ref, id) => false),
          loggedInUserProvider.overrideWith(
            (ref) => Future.value('mock-user-id'),
          ),
          eventRsvpYesCountProvider.overrideWith((ref, id) => rsvpYesCount),
          eventTotalRsvpCountProvider.overrideWith((ref, id) => totalRsvpCount),
          eventRsvpYesUsersProvider.overrideWith(
            (ref, id) => ['mock-user-id', 'user_1'],
          ),
          currentUserRsvpProvider.overrideWith(
            (ref, id) => Future.value(currentUserRsvp),
          ),
        ],
        child: ZoePreview(
          child: EventListWidget(
            eventsProvider: eventListProvider,
            isEditing: isEditing,
            shrinkWrap: shrinkWrap,
            maxItems: maxItems,
          ),
        ),
      );
    },
  );
}

@widgetbook.UseCase(name: 'Event Widget', type: EventWidget)
Widget buildEventWidgetUseCase(BuildContext context) {
  final eventId = context.knobs.string(
    label: 'Event ID',
    initialValue: 'event-1',
  );

  return ZoePreview(child: EventWidget(eventsId: eventId, isEditing: false));
}

@widgetbook.UseCase(name: 'Event List Screen', type: EventsListScreen)
Widget buildEventsListScreenUseCase(BuildContext context) {
  return ZoePreview(child: EventsListScreen());
}

@widgetbook.UseCase(name: 'Event Detail Screen', type: EventDetailScreen)
Widget buildEventDetailScreenUseCase(BuildContext context) {
  final eventId = context.knobs.string(
    label: 'Event ID',
    initialValue: 'event-1',
  );

  final currentUserRsvp = context.knobs.object.dropdown(
    label: 'Current User RSVP',
    options: RsvpStatus.values,
    initialOption: RsvpStatus.yes,
    labelBuilder: (status) => status.name,
  );

  final rsvpYesCount = context.knobs.int.input(
    label: 'RSVP Yes Count',
    initialValue: 1,
    description: 'Number of users who RSVP\'d yes',
  );

  final totalRsvpCount = context.knobs.int.input(
    label: 'Total RSVP Count',
    initialValue: 3,
    description: 'Total number of RSVPs',
  );

  final event = EventModel(
    id: eventId,
    title: context.knobs.string(
      label: 'Event Title',
      initialValue: 'Sample Event',
    ),
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(hours: 2)),
    parentId: 'list-1',
    orderIndex: 0,
    sheetId: 'mock-sheet-1',
    rsvpResponses: {
      'mock-user-id': currentUserRsvp,
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.no,
      'user_3': RsvpStatus.maybe,
    },
  );

  return Consumer(
    builder: (context, ref, _) {
      return ProviderScope(
        overrides: [
          eventListProvider.overrideWith(
            (ref) => MockEventNotifier()..setEvents([event]),
          ),
          eventProvider.overrideWith((ref, id) => id == eventId ? event : null),
          contentProvider.overrideWith((ref, id) => null),
          contentListProvider.overrideWith((ref) => const []),
          contentListByParentIdProvider.overrideWith((ref, id) => []),
          isEditValueProvider.overrideWith((ref, id) => false),
          loggedInUserProvider.overrideWith(
            (ref) => Future.value('mock-user-id'),
          ),
          eventRsvpYesCountProvider.overrideWith((ref, id) => rsvpYesCount),
          eventTotalRsvpCountProvider.overrideWith((ref, id) => totalRsvpCount),
          eventRsvpYesUsersProvider.overrideWith(
            (ref, id) => ['mock-user-id', 'user_1'],
          ),
          currentUserRsvpProvider.overrideWith(
            (ref, id) => Future.value(currentUserRsvp),
          ),
        ],
        child: ZoePreview(child: EventDetailScreen(eventId: eventId)),
      );
    },
  );
}
