import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/events/data/event_list.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/features/events/widgets/event_rsvp_count_widget.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('EventRsvpCountWidget', () {
    late EventModel testEvent;
    late ProviderContainer container;

    setUp(() {
      testEvent = eventList.first;
      container = ProviderContainer();
    });

    Future<void> pumpWidget(
      WidgetTester tester, {
      required EventModel event,
      ThemeData? theme,
    }) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        theme: theme,
        child: EventRsvpCountWidget(eventId: event.id),
      );
      await tester.pump();
    }

    void setEventResponses(Map<String, RsvpStatus> responses) {
      container = ProviderContainer(
        overrides: [
          eventListProvider.overrideWithValue([
            testEvent.copyWith(rsvpResponses: responses),
          ]),
        ],
      );
    }

    String findText(BuildContext context, int count) {
      final l10n = L10n.of(context);
      return count == 1 ? l10n.isGoing(1) : l10n.areGoing(count);
    }

    group('Widget Rendering', () {
      testWidgets('shows correct text for single person', (tester) async {
        setEventResponses({'user_1': RsvpStatus.yes});
        await pumpWidget(tester, event: testEvent);

        final context = tester.element(find.byType(EventRsvpCountWidget));
        expect(find.textContaining(findText(context, 1)), findsOneWidget);
        expect(find.byIcon(Icons.person_rounded), findsOneWidget);
      });

      testWidgets('shows correct text for multiple people', (tester) async {
        setEventResponses({
          'user_1': RsvpStatus.yes,
          'user_2': RsvpStatus.yes,
          'user_3': RsvpStatus.yes,
        });
        await pumpWidget(tester, event: testEvent);

        final context = tester.element(find.byType(EventRsvpCountWidget));
        expect(find.textContaining(findText(context, 3)), findsOneWidget);
        expect(find.byIcon(Icons.people_rounded), findsOneWidget);
      });

      testWidgets('hides when no RSVP responses', (tester) async {
        setEventResponses({});
        await pumpWidget(tester, event: testEvent);

        final context = tester.element(find.byType(EventRsvpCountWidget));
        expect(find.textContaining(findText(context, 1)), findsNothing);
      });

      testWidgets('shows correct icon for single person', (tester) async {
        setEventResponses({'user_1': RsvpStatus.yes});
        await pumpWidget(tester, event: testEvent);

        expect(find.byIcon(Icons.person_rounded), findsOneWidget);
        expect(find.byIcon(Icons.people_rounded), findsNothing);
      });

      testWidgets('shows correct icon for multiple people', (tester) async {
        setEventResponses({'user_1': RsvpStatus.yes, 'user_2': RsvpStatus.yes});
        await pumpWidget(tester, event: testEvent);

        expect(find.byIcon(Icons.people_rounded), findsOneWidget);
      });
    });

    group('Provider Integration', () {
      testWidgets('watches eventRsvpYesCountProvider', (tester) async {
        setEventResponses({'user_1': RsvpStatus.yes, 'user_2': RsvpStatus.yes});
        await pumpWidget(tester, event: testEvent);

        expect(container.read(eventRsvpYesCountProvider(testEvent.id)), 2);
        final context = tester.element(find.byType(EventRsvpCountWidget));
        expect(find.textContaining(findText(context, 2)), findsOneWidget);
      });

      testWidgets('handles provider state updates', (tester) async {
        final eventListNotifier = EventList();
        container = ProviderContainer(overrides: [
          eventListProvider.overrideWith(() => eventListNotifier),
        ]);

        await pumpWidget(tester, event: testEvent);

        // Initially empty
        eventListNotifier.state = [testEvent.copyWith(rsvpResponses: {})];
        await tester.pump();
        expect(find.textContaining('is going'), findsNothing);

        // Update to 2 going
        eventListNotifier.state = [
          testEvent.copyWith(rsvpResponses: {
            'user_1': RsvpStatus.yes,
            'user_2': RsvpStatus.yes,
          }),
        ];
        await tester.pump();
        expect(find.textContaining('2 are going'), findsOneWidget);
      });
    });

    group('User Interaction', () {
      testWidgets('is tappable when count shown', (tester) async {
        setEventResponses({'user_1': RsvpStatus.yes});
        await pumpWidget(tester, event: testEvent);

        await tester.tap(find.byType(EventRsvpCountWidget));
        await tester.pump();
        expect(find.byType(EventRsvpCountWidget), findsOneWidget);
      });

      testWidgets('not tappable when count not shown', (tester) async {
        setEventResponses({});
        await pumpWidget(tester, event: testEvent);
        expect(find.byType(GestureDetector), findsNothing);
      });
    });

    group('Styling and Visual States', () {
      const expectedPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      const expectedFontSize = 13.0;
      const expectedIconSize = 16.0;
      const expectedSpacing = 6.0;

      testWidgets('applies correct text style', (tester) async {
        setEventResponses({'user_1': RsvpStatus.yes});
        await pumpWidget(tester, event: testEvent);

        final context = tester.element(find.byType(EventRsvpCountWidget));
        final text = tester.widget<Text>(
          find.textContaining(findText(context, 1)),
        );

        expect(text.style?.fontSize, expectedFontSize);
        expect(text.style?.fontWeight, FontWeight.w500);
      });

      testWidgets('applies correct padding', (tester) async {
        setEventResponses({'user_1': RsvpStatus.yes});
        await pumpWidget(tester, event: testEvent);

        final containerWidget = tester.widget<Container>(
          find.descendant(of: find.byType(EventRsvpCountWidget), matching: find.byType(Container)),
        );
        expect(containerWidget.padding, expectedPadding);
      });

      testWidgets('applies correct icon size and spacing', (tester) async {
        setEventResponses({'user_1': RsvpStatus.yes});
        await pumpWidget(tester, event: testEvent);

        final icon = tester.widget<Icon>(find.byIcon(Icons.person_rounded));
        expect(icon.size, expectedIconSize);

        final sizedBoxes = tester.widgetList<SizedBox>(
          find.descendant(of: find.byType(Row), matching: find.byType(SizedBox)),
        );
        expect(sizedBoxes.any((b) => b.width == expectedSpacing), isTrue);
      });

      testWidgets('renders correctly in dark mode', (tester) async {
        setEventResponses({'user_1': RsvpStatus.yes});
        await pumpWidget(tester, event: testEvent, theme: ThemeData.dark());

        final context = tester.element(find.byType(EventRsvpCountWidget));
        expect(find.textContaining(findText(context, 1)), findsOneWidget);
      });
    });

    group('Bottom Sheet Integration', () {
      testWidgets('shows bottom sheet on tap', (tester) async {
        container = ProviderContainer(
          overrides: [
            eventListProvider.overrideWithValue([
              testEvent.copyWith(rsvpResponses: {'user_1': RsvpStatus.yes}),
            ]),
            loggedInUserProvider.overrideWith((ref) => Future.value('user_1')),
          ],
        );

        await pumpWidget(tester, event: testEvent);
        await tester.tap(find.byType(EventRsvpCountWidget));
        await tester.pumpAndSettle();

        expect(find.byType(BottomSheet), findsOneWidget);
      });
    });
  });
}
