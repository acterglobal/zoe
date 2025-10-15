import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/events/data/event_list.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

void main() {
  group('Event Providers', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    EventModel buildEvent({
      required String id,
      required DateTime start,
      required DateTime end,
      String parentId = 'parent-1',
      String sheetId = 'sheet-1',
      String title = 'Event',
      Map<String, RsvpStatus> rsvp = const {},
      int orderIndex = 0,
    }) {
      return EventModel(
        id: id,
        parentId: parentId,
        sheetId: sheetId,
        title: title,
        description: (plainText: '', htmlText: ''),
        startDate: start,
        endDate: end,
        rsvpResponses: rsvp,
        orderIndex: orderIndex,
      );
    }

    group('EventList notifier', () {
      test('add, update, delete, order and RSVP updates', () {
        container = ProviderContainer(
          overrides: [eventListProvider.overrideWith(() => EventList())],
        );

        final now = DateTime.now();
        final e1 = buildEvent(
          id: 'e1',
          start: now,
          end: now.add(const Duration(hours: 1)),
          title: 'Title 1',
        );

        // seed empty then add
        container.read(eventListProvider.notifier).state = [];
        container.read(eventListProvider.notifier).addEvent(e1);
        expect(container.read(eventListProvider).length, 1);

        // update title
        container.read(eventListProvider.notifier).updateEventTitle('e1', 'Updated');
        expect(container.read(eventListProvider).single.title, 'Updated');

        // update description
        container
            .read(eventListProvider.notifier)
            .updateEventDescription('e1', (plainText: 'p', htmlText: '<p/>'));
        expect(
          container.read(eventListProvider).single.description?.plainText,
          'p',
        );

        // update start/end
        final newStart = now.add(const Duration(days: 1));
        final newEnd = now.add(const Duration(days: 1, hours: 2));
        container.read(eventListProvider.notifier).updateEventStartDate('e1', newStart);
        container.read(eventListProvider.notifier).updateEventEndDate('e1', newEnd);
        final updated = container.read(eventListProvider).single;
        expect(updated.startDate, newStart);
        expect(updated.endDate, newEnd);

        // update range
        final rangeStart = now.add(const Duration(days: 2));
        final rangeEnd = now.add(const Duration(days: 2, hours: 3));
        container
            .read(eventListProvider.notifier)
            .updateEventDateRange('e1', rangeStart, rangeEnd);
        final ranged = container.read(eventListProvider).single;
        expect(ranged.startDate, rangeStart);
        expect(ranged.endDate, rangeEnd);

        // order index
        container.read(eventListProvider.notifier).updateEventOrderIndex('e1', 5);
        expect(container.read(eventListProvider).single.orderIndex, 5);

        // RSVP update
        container
            .read(eventListProvider.notifier)
            .updateRsvpResponse('e1', 'user-1', RsvpStatus.yes);
        expect(
          container.read(eventListProvider).single.rsvpResponses['user-1'],
          RsvpStatus.yes,
        );

        // delete
        container.read(eventListProvider.notifier).deleteEvent('e1');
        expect(container.read(eventListProvider), isEmpty);
      });
    });

    group('Derived lists (today/upcoming/past/all)', () {
      test('classifies events correctly', () {
        final now = DateTime.now();
        final today = buildEvent(
          id: 'today',
          start: DateTime(now.year, now.month, now.day, 10),
          end: DateTime(now.year, now.month, now.day, 11),
          title: 'Today',
        );
        final upcoming = buildEvent(
          id: 'upcoming',
          start: now.add(const Duration(days: 1, hours: 9)),
          end: now.add(const Duration(days: 1, hours: 10)),
          title: 'Tomorrow',
        );
        final past = buildEvent(
          id: 'past',
          start: now.subtract(const Duration(days: 2)),
          end: now.subtract(const Duration(days: 2, hours: -1)),
          title: 'Past',
        );

        container = ProviderContainer(overrides: [
          eventListProvider.overrideWithValue([today, upcoming, past]),
        ]);

        final todays = container.read(todaysEventsProvider);
        final upcomings = container.read(upcomingEventsProvider);
        final pasts = container.read(pastEventsProvider);
        final all = container.read(allEventsProvider);

        expect(todays.map((e) => e.id), contains('today'));
        expect(upcomings.map((e) => e.id), contains('upcoming'));
        expect(pasts.map((e) => e.id), contains('past'));
        expect(all.length, 3);
      });
    });

    group('Search and lookups', () {
      test('eventListSearch filters by title using searchValueProvider', () {
        final now = DateTime.now();
        final e1 = buildEvent(id: 'e1', start: now, end: now, title: 'Meeting Alpha');
        final e2 = buildEvent(id: 'e2', start: now, end: now, title: 'Planning Beta');
        final e3 = buildEvent(id: 'e3', start: now, end: now, title: 'MEETING Gamma');

        container = ProviderContainer(overrides: [
          eventListProvider.overrideWithValue([e1, e2, e3]),
          searchValueProvider.overrideWithValue('meeting'),
        ]);

        final filtered = container.read(eventListSearchProvider);
        expect(filtered.map((e) => e.id).toSet(), {'e1', 'e3'});
      });

      test('event and eventByParent return expected items', () {
        final now = DateTime.now();
        final e1 = buildEvent(id: 'e1', start: now, end: now, parentId: 'p1');
        final e2 = buildEvent(id: 'e2', start: now, end: now, parentId: 'p2');
        final e3 = buildEvent(id: 'e3', start: now, end: now, parentId: 'p1');

        container = ProviderContainer(overrides: [
          eventListProvider.overrideWithValue([e1, e2, e3]),
        ]);

        expect(container.read(eventProvider('e2'))?.id, 'e2');
        final byParent = container.read(eventByParentProvider('p1'));
        expect(byParent.map((e) => e.id).toSet(), {'e1', 'e3'});
      });
    });

    group('RSVP derived providers', () {
      test('currentUserRsvp resolves from loggedInUserProvider', () async {
        final now = DateTime.now();
        final e1 = buildEvent(
          id: 'e1',
          start: now,
          end: now,
          rsvp: {'user-1': RsvpStatus.maybe},
        );

        container = ProviderContainer(overrides: [
          eventListProvider.overrideWithValue([e1]),
          loggedInUserProvider.overrideWith((ref) => Future.value('user-1')),
        ]);

        final status = await container.read(currentUserRsvpProvider('e1').future);
        expect(status, RsvpStatus.maybe);
      });

      test('counters and yes users', () {
        final now = DateTime.now();
        final e1 = buildEvent(
          id: 'e1',
          start: now,
          end: now,
          rsvp: {
            'a': RsvpStatus.yes,
            'b': RsvpStatus.no,
            'c': RsvpStatus.yes,
          },
        );

        container = ProviderContainer(overrides: [
          eventListProvider.overrideWithValue([e1]),
        ]);

        expect(container.read(eventRsvpYesCountProvider('e1')), 2);
        expect(container.read(eventTotalRsvpCountProvider('e1')), 3);
        expect(container.read(eventRsvpYesUsersProvider('e1')).toSet(), {'a', 'c'});
      });
    });

    group('Using bundled eventList dataset', () {
      test('allEvents matches bundled list length and search finds expected', () {

        container = ProviderContainer(overrides: [
          eventListProvider.overrideWithValue(eventList),
        ]);

        // allEvents should include all events (today/upcoming/past partitions are disjoint)
        final all = container.read(allEventsProvider);
        expect(all.length, eventList.length);

        // Pick first event and search a substring of its title
        final first = eventList.first;
        final title = first.title;
        final query = title.isNotEmpty
            ? title.substring(0, (title.length / 2).ceil()).toLowerCase()
            : '';

        final searchScoped = ProviderContainer(overrides: [
          eventListProvider.overrideWithValue(eventList),
          searchValueProvider.overrideWithValue(query),
        ]);
        final filtered = searchScoped.read(eventListSearchProvider);
        expect(filtered.any((e) => e.id == first.id), isTrue);
      });

      test('eventRsvpYesCount matches computed yes count for a sample event', () {
        if (eventList.isEmpty) return;
        container = ProviderContainer(overrides: [
          eventListProvider.overrideWithValue(eventList),
        ]);

        final sample = eventList.first;
        final expectedYes = sample.rsvpResponses.values
            .where((s) => s == RsvpStatus.yes)
            .length;

        expect(container.read(eventRsvpYesCountProvider(sample.id)), expectedYes);
      });

      test('eventByParent returns events sharing the same parentId', () {
        if (eventList.length < 2) return;
        container = ProviderContainer(overrides: [
          eventListProvider.overrideWithValue(eventList),
        ]);

        // Choose a parentId from the dataset
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


