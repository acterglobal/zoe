import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/features/events/data/event_list.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

void main() {
  group('Event Providers', () {
    late ProviderContainer container;

    ProviderContainer createTestContainer({
      List<Override> overrides = const [],
    }) {
      return ProviderContainer(overrides: overrides);
    }

    setUp(() {
      container = createTestContainer();
    });

    group('EventListNotifier', () {
      test('add, update, delete, order, and RSVP updates', () {
        container = createTestContainer(
          overrides: [eventListProvider.overrideWith(() => EventList())],
        );

        final e1 = eventList.first;
        final originalStart = e1.startDate;
        final originalEnd = e1.endDate;

        // Seed empty and add event
        container.read(eventListProvider.notifier).state = [];
        container.read(eventListProvider.notifier).addEvent(e1);
        expect(container.read(eventListProvider).length, 1);

        // Update title
        container
            .read(eventListProvider.notifier)
            .updateEventTitle(e1.id, 'Updated');
        expect(container.read(eventListProvider).single.title, 'Updated');

        // Update description
        container.read(eventListProvider.notifier).updateEventDescription(
          e1.id,
          (plainText: 'p', htmlText: '<p/>'),
        );
        expect(
          container.read(eventListProvider).single.description?.plainText,
          'p',
        );

        // Update start and end date
        final newStart = originalStart.add(const Duration(days: 1));
        final newEnd = originalEnd.add(const Duration(days: 1, hours: 2));
        container
            .read(eventListProvider.notifier)
            .updateEventStartDate(e1.id, newStart);
        container
            .read(eventListProvider.notifier)
            .updateEventEndDate(e1.id, newEnd);

        final updated = container.read(eventListProvider).single;
        expect(updated.startDate, newStart);
        expect(updated.endDate, newEnd);

        // Update range
        final rangeStart = originalStart.add(const Duration(days: 2));
        final rangeEnd = originalEnd.add(const Duration(days: 2, hours: 3));
        container
            .read(eventListProvider.notifier)
            .updateEventDateRange(e1.id, rangeStart, rangeEnd);

        final ranged = container.read(eventListProvider).single;
        expect(ranged.startDate, rangeStart);
        expect(ranged.endDate, rangeEnd);

        // Update order index
        container
            .read(eventListProvider.notifier)
            .updateEventOrderIndex(e1.id, 5);
        expect(container.read(eventListProvider).single.orderIndex, 5);

        // Update RSVP
        container
            .read(eventListProvider.notifier)
            .updateRsvpResponse(e1.id, 'user-1', RsvpStatus.yes);
        expect(
          container.read(eventListProvider).single.rsvpResponses['user-1'],
          RsvpStatus.yes,
        );

        // Delete event
        container.read(eventListProvider.notifier).deleteEvent(e1.id);
        expect(container.read(eventListProvider), isEmpty);
      });
    });

    group('Derived lists (today/upcoming/past/all)', () {
      test('classifies events correctly', () {
        final events = eventList.take(3).toList();
        container = createTestContainer(
          overrides: [eventListProvider.overrideWithValue(events)],
        );

        final todays = container.read(todaysEventsProvider);
        final upcoming = container.read(upcomingEventsProvider);
        final past = container.read(pastEventsProvider);
        final all = container.read(allEventsProvider);

        expect(all.length, events.length);
        expect(
          todays.length + upcoming.length + past.length,
          equals(events.length),
        );

        final allIds = all.map((e) => e.id).toSet();
        final originalIds = events.map((e) => e.id).toSet();
        expect(allIds, equals(originalIds));
      });
    });
    group('Search and lookups', () {
      test('eventListSearch filters by title using searchValueProvider', () {
        final events = eventList.take(3).toList();
        final firstEvent = events.first;

        final searchQuery = firstEvent.title.isNotEmpty
            ? firstEvent.title
                  .substring(0, (firstEvent.title.length / 2).ceil())
                  .toLowerCase()
            : 'test';

        container = createTestContainer(
          overrides: [
            eventListProvider.overrideWithValue(events),
            searchValueProvider.overrideWithValue(searchQuery),
          ],
        );

        final filtered = container.read(eventListSearchProvider);
        expect(filtered.any((e) => e.id == firstEvent.id), isTrue);
      });

      test('event and eventByParent return expected items', () {
        final events = eventList.take(3).toList();
        final first = events.first;

        container = createTestContainer(
          overrides: [eventListProvider.overrideWithValue(events)],
        );

        // Single event lookup
        expect(container.read(eventProvider(first.id))?.id, first.id);

        // Events by parent ID
        final byParent = container.read(eventByParentProvider(first.parentId));
        final expected = events
            .where((e) => e.parentId == first.parentId)
            .toList();

        expect(byParent.length, expected.length);
        expect(
          byParent.map((e) => e.id).toSet(),
          expected.map((e) => e.id).toSet(),
        );
      });
    });

    group('RSVP derived providers', () {
      test('currentUserRsvp resolves from loggedInUserProvider', () async {
        final e1 = eventList.first;
        const testUserId = 'test-user-1';

        final eventWithRsvp = e1.copyWith(
          rsvpResponses: {...e1.rsvpResponses, testUserId: RsvpStatus.maybe},
        );

        container = createTestContainer(
          overrides: [
            eventListProvider.overrideWithValue([eventWithRsvp]),
            loggedInUserProvider.overrideWith(
              (ref) => Future.value(testUserId),
            ),
          ],
        );

        final status = await container.read(
          currentUserRsvpProvider(e1.id).future,
        );
        expect(status, RsvpStatus.maybe);
      });

      test('counters and yes users', () {
        final e1 = eventList.first;

        final baseYesCount = e1.rsvpResponses.values
            .where((s) => s == RsvpStatus.yes)
            .length;
        final baseTotalCount = e1.rsvpResponses.length;

        final eventWithRsvp = e1.copyWith(
          rsvpResponses: {
            ...e1.rsvpResponses,
            'a': RsvpStatus.yes,
            'b': RsvpStatus.no,
            'c': RsvpStatus.yes,
          },
        );

        container = createTestContainer(
          overrides: [
            eventListProvider.overrideWithValue([eventWithRsvp]),
          ],
        );

        final expectedYes = baseYesCount + 2;
        final expectedTotal = baseTotalCount + 3;

        expect(container.read(eventRsvpYesCountProvider(e1.id)), expectedYes);
        expect(
          container.read(eventTotalRsvpCountProvider(e1.id)),
          expectedTotal,
        );

        final allYesUsers = <String>[
          ...e1.rsvpResponses.entries
              .where((e) => e.value == RsvpStatus.yes)
              .map((e) => e.key),
          'a',
          'c',
        ];

        expect(
          container.read(eventRsvpYesUsersProvider(e1.id)).toSet(),
          allYesUsers.toSet(),
        );
      });
    });

    group('Bundled eventList dataset', () {
      test('allEvents matches dataset and search finds expected', () {
        container = createTestContainer(
          overrides: [eventListProvider.overrideWithValue(eventList)],
        );

        final all = container.read(allEventsProvider);
        expect(all.length, eventList.length);

        final first = eventList.first;
        final query = first.title.isNotEmpty
            ? first.title
                  .substring(0, (first.title.length / 2).ceil())
                  .toLowerCase()
            : '';

        final searchScoped = createTestContainer(
          overrides: [
            eventListProvider.overrideWithValue(eventList),
            searchValueProvider.overrideWithValue(query),
          ],
        );

        final filtered = searchScoped.read(eventListSearchProvider);
        expect(filtered.any((e) => e.id == first.id), isTrue);
      });

      test('eventRsvpYesCount matches computed yes count', () {
        if (eventList.isEmpty) return;

        container = createTestContainer(
          overrides: [eventListProvider.overrideWithValue(eventList)],
        );

        final sample = eventList.first;
        final expectedYes = sample.rsvpResponses.values
            .where((s) => s == RsvpStatus.yes)
            .length;

        expect(
          container.read(eventRsvpYesCountProvider(sample.id)),
          expectedYes,
        );
      });

      test('eventByParent returns events sharing parentId', () {
        if (eventList.length < 2) return;

        container = createTestContainer(
          overrides: [eventListProvider.overrideWithValue(eventList)],
        );

        final parentId = eventList.first.parentId;
        final expectedIds = eventList
            .where((e) => e.parentId == parentId)
            .map((e) => e.id)
            .toSet();

        final resultIds = container
            .read(eventByParentProvider(parentId))
            .map((e) => e.id)
            .toSet();

        expect(resultIds, expectedIds);
      });
    });
  });
}
