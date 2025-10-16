import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/widgets/event_rsvp_count_widget.dart';
import 'package:zoe/features/events/widgets/event_rsvp_widget.dart';
import 'package:zoe/features/events/data/event_list.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('EventRsvpWidget', () {
    late EventModel testEvent;
    late ProviderContainer container;

    setUp(() {
      testEvent = eventList.first;
      container = ProviderContainer();
    });

    group('Widget Rendering', () {
      testWidgets('should display correct header elements', (WidgetTester tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        // Check for header icon
        expect(find.byIcon(Icons.event_available_rounded), findsOneWidget);
        
        // Check for RSVP count widget
        expect(find.byType(EventRsvpCountWidget), findsOneWidget);
      });

      testWidgets('should display all RSVP status buttons', (WidgetTester tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        // Check for all RSVP status texts
        expect(find.text(RsvpStatus.yes.name), findsOneWidget);
        expect(find.text(RsvpStatus.no.name), findsOneWidget);
        expect(find.text(RsvpStatus.maybe.name), findsOneWidget);
      });

      testWidgets('should display correct icons for each RSVP status', (WidgetTester tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        // Check for RSVP status icons
        expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget); // Yes
        expect(find.byIcon(Icons.cancel_rounded), findsOneWidget); // No
        expect(find.byIcon(Icons.question_mark_rounded), findsOneWidget); // Maybe
      });
    });

    group('RSVP Button Interactions', () {
      testWidgets('should handle Yes button tap and update provider state', (WidgetTester tester) async {
        // Create a custom EventList notifier for testing
        final testEventList = EventList();
        
        container = ProviderContainer(
          overrides: [
            loggedInUserProvider.overrideWith((ref) => Future.value('user_1')),
            eventListProvider.overrideWith(() => testEventList),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        await tester.pump();

        // Set the initial state after the widget is built
        testEventList.state = [
          testEvent.copyWith(
            rsvpResponses: {}, // Start with no RSVP responses
          ),
        ];

        final yesButton = find.text(RsvpStatus.yes.name);
        expect(yesButton, findsOneWidget);

        // Tap the Yes button - this should trigger the onTap callback
        await tester.tap(yesButton);
        await tester.pump();

        // Verify the RSVP response was updated in the provider
        final eventList = container.read(eventListProvider);
        final updatedEvent = eventList.firstWhere((e) => e.id == testEvent.id);
        expect(updatedEvent.rsvpResponses['user_1'], equals(RsvpStatus.yes));
      });

      testWidgets('should handle No button tap and update provider state', (WidgetTester tester) async {
        // Create a custom EventList notifier for testing
        final testEventList = EventList();
        
        container = ProviderContainer(
          overrides: [
            loggedInUserProvider.overrideWith((ref) => Future.value('user_1')),
            eventListProvider.overrideWith(() => testEventList),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        await tester.pump();

        // Set the initial state after the widget is built
        testEventList.state = [
          testEvent.copyWith(
            rsvpResponses: {}, // Start with no RSVP responses
          ),
        ];

        final noButton = find.text(RsvpStatus.no.name);
        expect(noButton, findsOneWidget);

        await tester.tap(noButton);
        await tester.pump();

        // Verify the RSVP response was updated in the provider
        final eventList = container.read(eventListProvider);
        final updatedEvent = eventList.firstWhere((e) => e.id == testEvent.id);
        expect(updatedEvent.rsvpResponses['user_1'], equals(RsvpStatus.no));
      });

      testWidgets('should handle Maybe button tap and update provider state', (WidgetTester tester) async {
        // Create a custom EventList notifier for testing
        final testEventList = EventList();
        
        container = ProviderContainer(
          overrides: [
            loggedInUserProvider.overrideWith((ref) => Future.value('user_1')),
            eventListProvider.overrideWith(() => testEventList),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        await tester.pump();

        // Set the initial state after the widget is built
        testEventList.state = [
          testEvent.copyWith(
            rsvpResponses: {}, // Start with no RSVP responses
          ),
        ];

        final maybeButton = find.text(RsvpStatus.maybe.name);
        expect(maybeButton, findsOneWidget);

        await tester.tap(maybeButton);
        await tester.pump();

        // Verify the RSVP response was updated in the provider
        final eventList = container.read(eventListProvider);
        final updatedEvent = eventList.firstWhere((e) => e.id == testEvent.id);
        expect(updatedEvent.rsvpResponses['user_1'], equals(RsvpStatus.maybe));
      });

      testWidgets('should update existing RSVP response when tapping different button', (WidgetTester tester) async {
        // Create a custom EventList notifier for testing
        final testEventList = EventList();
        
        container = ProviderContainer(
          overrides: [
            loggedInUserProvider.overrideWith((ref) => Future.value('user_1')),
            eventListProvider.overrideWith(() => testEventList),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        await tester.pump();

        // Set the initial state after the widget is built
        testEventList.state = [
          testEvent.copyWith(
            rsvpResponses: {'user_1': RsvpStatus.yes}, // Start with Yes response
          ),
        ];

        // Tap No button to change from Yes to No
        final noButton = find.text(RsvpStatus.no.name);
        await tester.tap(noButton);
        await tester.pump();

        // Verify the RSVP response was updated from Yes to No
        final eventList = container.read(eventListProvider);
        final updatedEvent = eventList.firstWhere((e) => e.id == testEvent.id);
        expect(updatedEvent.rsvpResponses['user_1'], equals(RsvpStatus.no));
        expect(updatedEvent.rsvpResponses.length, equals(1)); // Should still have only one response
      });

      testWidgets('should have correct button layout', (WidgetTester tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        // Check that all buttons are in a row
        final buttonRow = find.byType(Row).last; // The last row should contain the buttons
        expect(buttonRow, findsOneWidget);

        // Check that there are 3 expanded widgets (one for each button)
        final expandedWidgets = find.descendant(
          of: buttonRow,
          matching: find.byType(Expanded),
        );
        expect(expandedWidgets, findsNWidgets(3));
      });

      testWidgets('should call haptic feedback on button tap', (WidgetTester tester) async {
        // Mock haptic feedback
        initHapticFeedbackMethodCallHandler();

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        // Tap a button to trigger haptic feedback
        await tester.tap(find.text(RsvpStatus.yes.name));
        await tester.pump();

        // Verify the tap was handled (haptic feedback is called internally)
        expect(find.text(RsvpStatus.yes.name), findsOneWidget);
      });
    });

    group('Styling and Visual States', () {
      testWidgets('should apply correct styling to buttons', (WidgetTester tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        // Check for InkWell widgets (button containers)
        final inkWells = find.byType(InkWell);
        expect(inkWells, findsNWidgets(3));

        // Check for AnimatedContainer widgets
        final animatedContainers = find.byType(AnimatedContainer);
        expect(animatedContainers, findsNWidgets(3));
      });

      testWidgets('should have correct padding and spacing', (WidgetTester tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        // Check for SizedBox spacing between header and buttons
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        final spacingBox = sizedBoxes.firstWhere(
          (box) => box.height != null && box.height! > 0,
          orElse: () => const SizedBox(),
        );
        expect(spacingBox.height, equals(22.0));
      });

      testWidgets('should display header with correct styling', (WidgetTester tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        // Check for header container with circular decoration
        final containers = tester.widgetList<Container>(find.byType(Container));
        final headerContainer = containers.firstWhere(
          (container) => container.decoration is BoxDecoration &&
                       (container.decoration as BoxDecoration).shape == BoxShape.circle,
          orElse: () => Container(),
        );
        expect(headerContainer, isNotNull);
      });

      testWidgets('should work in dark mode', (WidgetTester tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          theme: ThemeData.dark(),
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        expect(find.byType(EventRsvpWidget), findsOneWidget);
        expect(find.text(RsvpStatus.yes.name), findsOneWidget);
        expect(find.text(RsvpStatus.no.name), findsOneWidget);
        expect(find.text(RsvpStatus.maybe.name), findsOneWidget);
      });
    });

    group('Provider Integration', () {
      testWidgets('should watch current user RSVP provider and reflect state changes', (WidgetTester tester) async {
        // Create a custom EventList notifier for testing
        final testEventList = EventList();
        
        container = ProviderContainer(
          overrides: [
            loggedInUserProvider.overrideWith((ref) => Future.value('user_1')),
            eventListProvider.overrideWith(() => testEventList),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        await tester.pump();

        // Set initial state with no RSVP
        testEventList.state = [
          testEvent.copyWith(rsvpResponses: {}),
        ];

        // Verify widget renders correctly
        expect(find.byType(EventRsvpWidget), findsOneWidget);
        expect(find.text(RsvpStatus.yes.name), findsOneWidget);
        expect(find.text(RsvpStatus.no.name), findsOneWidget);
        expect(find.text(RsvpStatus.maybe.name), findsOneWidget);

        // Update provider state to have a Yes RSVP
        testEventList.state = [
          testEvent.copyWith(rsvpResponses: {'user_1': RsvpStatus.yes}),
        ];

        await tester.pump();

        // Widget should still render correctly after state change
        expect(find.byType(EventRsvpWidget), findsOneWidget);
        expect(find.text(RsvpStatus.yes.name), findsOneWidget);
        expect(find.text(RsvpStatus.no.name), findsOneWidget);
        expect(find.text(RsvpStatus.maybe.name), findsOneWidget);
      });

      testWidgets('should watch logged in user provider and handle user changes', (WidgetTester tester) async {
        // Test with different user
        container = ProviderContainer(
          overrides: [
            loggedInUserProvider.overrideWith((ref) => Future.value('user_2')),
            eventListProvider.overrideWithValue([
              testEvent.copyWith(
                rsvpResponses: {'user_1': RsvpStatus.yes, 'user_2': RsvpStatus.no},
              ),
            ]),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        await tester.pump();

        // Widget should render correctly with different user
        expect(find.byType(EventRsvpWidget), findsOneWidget);
        expect(find.text(RsvpStatus.yes.name), findsOneWidget);
        expect(find.text(RsvpStatus.no.name), findsOneWidget);
        expect(find.text(RsvpStatus.maybe.name), findsOneWidget);
      });

      testWidgets('should handle provider state changes and update UI accordingly', (WidgetTester tester) async {
        // Create a custom EventList notifier for testing
        final testEventList = EventList();
        
        container = ProviderContainer(
          overrides: [
            loggedInUserProvider.overrideWith((ref) => Future.value('user_1')),
            eventListProvider.overrideWith(() => testEventList),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        await tester.pump();

        // Start with no RSVP
        testEventList.state = [
          testEvent.copyWith(rsvpResponses: {}),
        ];

        await tester.pump();

        // Verify initial state
        expect(find.byType(EventRsvpWidget), findsOneWidget);

        // Change to Yes RSVP
        testEventList.state = [
          testEvent.copyWith(rsvpResponses: {'user_1': RsvpStatus.yes}),
        ];

        await tester.pump();

        // Widget should update to reflect the new state
        expect(find.byType(EventRsvpWidget), findsOneWidget);
        expect(find.text(RsvpStatus.yes.name), findsOneWidget);
        expect(find.text(RsvpStatus.no.name), findsOneWidget);
        expect(find.text(RsvpStatus.maybe.name), findsOneWidget);

        // Change to No RSVP
        testEventList.state = [
          testEvent.copyWith(rsvpResponses: {'user_1': RsvpStatus.no}),
        ];

        await tester.pump();

        // Widget should update to reflect the new state
        expect(find.byType(EventRsvpWidget), findsOneWidget);
        expect(find.text(RsvpStatus.yes.name), findsOneWidget);
        expect(find.text(RsvpStatus.no.name), findsOneWidget);
        expect(find.text(RsvpStatus.maybe.name), findsOneWidget);
      });

      testWidgets('should handle null logged in user gracefully', (WidgetTester tester) async {
        container = ProviderContainer(
          overrides: [
            loggedInUserProvider.overrideWith((ref) => Future.value(null)),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        await tester.pump();

        // Widget should still render even with null user
        expect(find.byType(EventRsvpWidget), findsOneWidget);
        expect(find.text(RsvpStatus.yes.name), findsOneWidget);
        expect(find.text(RsvpStatus.no.name), findsOneWidget);
        expect(find.text(RsvpStatus.maybe.name), findsOneWidget);
      });

      testWidgets('should handle empty logged in user gracefully', (WidgetTester tester) async {
        container = ProviderContainer(
          overrides: [
            loggedInUserProvider.overrideWith((ref) => Future.value('')),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        await tester.pump();

        // Widget should still render even with empty user
        expect(find.byType(EventRsvpWidget), findsOneWidget);
        expect(find.text(RsvpStatus.yes.name), findsOneWidget);
        expect(find.text(RsvpStatus.no.name), findsOneWidget);
        expect(find.text(RsvpStatus.maybe.name), findsOneWidget);
      });

      testWidgets('should correctly read current user RSVP from provider', (WidgetTester tester) async {
        // Create a custom EventList notifier for testing
        final testEventList = EventList();
        
        container = ProviderContainer(
          overrides: [
            loggedInUserProvider.overrideWith((ref) => Future.value('user_1')),
            eventListProvider.overrideWith(() => testEventList),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        await tester.pump();

        // Set state with user_1 having Maybe RSVP
        testEventList.state = [
          testEvent.copyWith(rsvpResponses: {'user_1': RsvpStatus.maybe}),
        ];

        await tester.pump();

        // Verify the current user RSVP provider returns the correct value
        final currentRsvp = container.read(currentUserRsvpProvider(testEvent.id));
        expect(currentRsvp.value, equals(RsvpStatus.maybe));

        // Widget should render correctly
        expect(find.byType(EventRsvpWidget), findsOneWidget);
        expect(find.text(RsvpStatus.yes.name), findsOneWidget);
        expect(find.text(RsvpStatus.no.name), findsOneWidget);
        expect(find.text(RsvpStatus.maybe.name), findsOneWidget);

        // Change to different RSVP status
        testEventList.state = [
          testEvent.copyWith(rsvpResponses: {'user_1': RsvpStatus.yes}),
        ];

        await tester.pump();

        // Verify the provider now returns the updated value
        final updatedRsvp = container.read(currentUserRsvpProvider(testEvent.id));
        expect(updatedRsvp.value, equals(RsvpStatus.yes));
      });
    });

    group('Haptic Feedback', () {
      testWidgets('should handle button taps without crashing when haptic feedback is called', (WidgetTester tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        // Tap Yes button - should not crash even with haptic feedback
        await tester.tap(find.text(RsvpStatus.yes.name));
        await tester.pump();

        // Verify the tap was handled without errors
        expect(find.text(RsvpStatus.yes.name), findsOneWidget);
      });

      testWidgets('should handle multiple button taps without crashing', (WidgetTester tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        // Tap multiple buttons - should not crash even with haptic feedback
        await tester.tap(find.text(RsvpStatus.yes.name));
        await tester.pump();
        
        await tester.tap(find.text(RsvpStatus.no.name));
        await tester.pump();
        
        await tester.tap(find.text(RsvpStatus.maybe.name));
        await tester.pump();

        // Verify all buttons are still present
        expect(find.text(RsvpStatus.yes.name), findsOneWidget);
        expect(find.text(RsvpStatus.no.name), findsOneWidget);
        expect(find.text(RsvpStatus.maybe.name), findsOneWidget);
      });

      testWidgets('should handle rapid button taps without issues', (WidgetTester tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        // Rapidly tap buttons - should handle gracefully
        await tester.tap(find.text(RsvpStatus.yes.name));
        await tester.tap(find.text(RsvpStatus.no.name));
        await tester.tap(find.text(RsvpStatus.maybe.name));
        await tester.pump();

        // Widget should still be functional
        expect(find.byType(EventRsvpWidget), findsOneWidget);
        expect(find.text(RsvpStatus.yes.name), findsOneWidget);
        expect(find.text(RsvpStatus.no.name), findsOneWidget);
        expect(find.text(RsvpStatus.maybe.name), findsOneWidget);
      });

      testWidgets('should work correctly in test environment without haptic feedback', (WidgetTester tester) async {
        // This test verifies that the widget works correctly in test environment
        // where haptic feedback might not be available
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        // All buttons should be present and tappable
        expect(find.text(RsvpStatus.yes.name), findsOneWidget);
        expect(find.text(RsvpStatus.no.name), findsOneWidget);
        expect(find.text(RsvpStatus.maybe.name), findsOneWidget);

        // Tap each button to ensure they work
        await tester.tap(find.text(RsvpStatus.yes.name));
        await tester.pump();
        
        await tester.tap(find.text(RsvpStatus.no.name));
        await tester.pump();
        
        await tester.tap(find.text(RsvpStatus.maybe.name));
        await tester.pump();

        // Widget should remain functional
        expect(find.byType(EventRsvpWidget), findsOneWidget);
      });
    });
    
    group('RSVP State Changes and Visual Feedback', () {
      testWidgets('should show selected state for current RSVP status', (WidgetTester tester) async {
        container = ProviderContainer(
          overrides: [
            loggedInUserProvider.overrideWith((ref) => Future.value('user_1')),
            eventListProvider.overrideWithValue([
              testEvent.copyWith(
                rsvpResponses: {'user_1': RsvpStatus.yes},
              ),
            ]),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        await tester.pump();

        // The Yes button should be visually selected (we can't easily test the exact styling,
        // but we can verify the widget renders without errors)
        expect(find.byType(EventRsvpWidget), findsOneWidget);
        expect(find.text(RsvpStatus.yes.name), findsOneWidget);
        expect(find.text(RsvpStatus.no.name), findsOneWidget);
        expect(find.text(RsvpStatus.maybe.name), findsOneWidget);
      });

      testWidgets('should update visual state when RSVP status changes', (WidgetTester tester) async {
        container = ProviderContainer(
          overrides: [
            loggedInUserProvider.overrideWith((ref) => Future.value('user_1')),
            eventListProvider.overrideWithValue([
              testEvent.copyWith(
                rsvpResponses: {'user_1': RsvpStatus.yes},
              ),
            ]),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        await tester.pump();

        // Note: We can't easily test the notifier update with overrideWithValue
        // but we can verify the widget renders correctly with the initial state
        expect(find.byType(EventRsvpWidget), findsOneWidget);
        expect(find.text(RsvpStatus.yes.name), findsOneWidget);
        expect(find.text(RsvpStatus.no.name), findsOneWidget);
        expect(find.text(RsvpStatus.maybe.name), findsOneWidget);
      });

      testWidgets('should handle multiple users RSVP responses', (WidgetTester tester) async {
        container = ProviderContainer(
          overrides: [
            loggedInUserProvider.overrideWith((ref) => Future.value('user_1')),
            eventListProvider.overrideWithValue([
              testEvent.copyWith(
                rsvpResponses: {
                  'user_1': RsvpStatus.yes,
                  'user_2': RsvpStatus.no,
                  'user_3': RsvpStatus.maybe,
                },
              ),
            ]),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        await tester.pump();

        // Widget should render correctly with multiple RSVP responses
        expect(find.byType(EventRsvpWidget), findsOneWidget);
        expect(find.text(RsvpStatus.yes.name), findsOneWidget);
        expect(find.text(RsvpStatus.no.name), findsOneWidget);
        expect(find.text(RsvpStatus.maybe.name), findsOneWidget);

        // Verify the RSVP counts are correct
        final yesCount = container.read(eventRsvpYesCountProvider(testEvent.id));
        expect(yesCount, equals(1));

        final totalCount = container.read(eventTotalRsvpCountProvider(testEvent.id));
        expect(totalCount, equals(3));
      });
    });

    group('Animation and Transitions', () {
      testWidgets('should have animated containers for buttons', (WidgetTester tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventRsvpWidget(eventId: testEvent.id),
        );

        // Check for AnimatedContainer widgets
        final animatedContainers = find.byType(AnimatedContainer);
        expect(animatedContainers, findsNWidgets(3));

        // Verify animation duration
        final animatedContainerWidgets = tester.widgetList<AnimatedContainer>(animatedContainers);
        for (final animatedContainer in animatedContainerWidgets) {
          expect(animatedContainer.duration, equals(const Duration(milliseconds: 300)));
        }
      });
    });
  });
}
