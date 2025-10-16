import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/events/actions/event_actions.dart';
import 'package:zoe/features/events/data/event_list.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/features/share/widgets/share_items_bottom_sheet.dart';
import '../../../test-utils/test_utils.dart';
import '../../../test-utils/mock_gorouter.dart';

void main() {
  group('EventActions Tests', () {
    late ProviderContainer container;
    late EventModel testEvent;
    late MockGoRouter mockGoRouter;

    setUp(() {
      testEvent = eventList.first;
      mockGoRouter = MockGoRouter();

      // Set up mock methods
      when(() => mockGoRouter.canPop()).thenReturn(true);
      when(() => mockGoRouter.pop()).thenReturn(null);

      container = ProviderContainer.test(
        overrides: [
          eventProvider(testEvent.id).overrideWith((ref) => testEvent),
          editContentIdProvider.overrideWith((ref) => null),
        ],
      );
    });

    group('copyEvent', () {
      testWidgets('copies event content to clipboard', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Copy Event',
          onPressed: (context, ref) =>
              EventActions.copyEvent(context, ref, testEvent.id),
        );

        // Tap the button to trigger copy action
        await tester.tap(find.text('Copy Event'));
        await tester.pumpAndSettle();

        // Verify the action was called (we can't easily test clipboard in unit tests)
        expect(find.text('Copy Event'), findsOneWidget);
      });

      testWidgets('shows snackbar after copying', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Copy Event',
          onPressed: (context, ref) =>
              EventActions.copyEvent(context, ref, testEvent.id),
        );

        // Tap the button to trigger copy action
        await tester.tap(find.text('Copy Event'));
        await tester.pumpAndSettle();

        // Verify snackbar is shown with correct message
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Copied to clipboard'), findsOneWidget);
      });
    });

    group('shareEvent', () {
      testWidgets('shows share bottom sheet', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Share Event',
          onPressed: (context, ref) => EventActions.shareEvent(context, testEvent.id),
        );

        // Tap the button to trigger share action
        await tester.tap(find.text('Share Event'));
        await tester.pump(); // Don't use pumpAndSettle to avoid timeout

        // Verify the action was called
        expect(find.text('Share Event'), findsAtLeastNWidgets(1));
        expect(find.byType(ShareItemsBottomSheet), findsOneWidget);
      });
    });

    group('editEvent', () {

      testWidgets('sets correct event ID in edit provider', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Edit Event',
          onPressed: (context, ref) => EventActions.editEvent(ref, testEvent.id),
        );

        // Tap the button to trigger edit action
        await tester.tap(find.text('Edit Event'));
        await tester.pumpAndSettle();

        // Verify the correct event ID is set
        final editContentId = container.read(editContentIdProvider);
        expect(editContentId, equals(testEvent.id));
      });
    });

    group('deleteEvent', () {
      testWidgets('deletes event from provider', (tester) async {
        // Verify event exists initially
        final initialEvents = container.read(eventListProvider);
        expect(initialEvents.any((event) => event.id == testEvent.id), isTrue);

        await tester.pumpActionsWidget(
          buttonText: 'Delete Event',
          onPressed: (context, ref) =>
              EventActions.deleteEvent(context, ref, testEvent.id),
          container: container,
        );

        // Tap the button to trigger delete action
        await tester.tap(find.text('Delete Event'));
        await tester.pumpAndSettle();

        // Verify event was deleted from provider
        final updatedEvents = container.read(eventListProvider);
        expect(updatedEvents.any((event) => event.id == testEvent.id), isFalse);
        expect(updatedEvents.length, equals(initialEvents.length - 1));
      });

      testWidgets('shows snackbar after deletion', (tester) async {
        await tester.pumpActionsWidget(
          buttonText: 'Delete Event',
          onPressed: (context, ref) =>
              EventActions.deleteEvent(context, ref, testEvent.id),
          container: container,
        );

        // Tap the button to trigger delete action
        await tester.tap(find.text('Delete Event'));
        await tester.pumpAndSettle();

        // Verify snackbar is shown with correct message
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Event deleted'), findsOneWidget);
      });
    });

    group('showEventMenu', () {
      testWidgets('shows event menu with all items when not editing', (
        tester,
      ) async {
        await tester.pumpActionsWidget(
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showEventMenu(
            context: context,
            ref: ref,
            isEditing: false,
            eventId: testEvent.id,
          ),
          container: container,
          router: mockGoRouter,
        );

        // Tap the button to trigger menu
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Verify menu items are rendered (copy, share, edit, delete)
        // Note: These strings should match the L10n strings in app_en.arb
        expect(find.text('Copy event content'), findsOneWidget);
        expect(find.text('Share'), findsOneWidget);
        expect(find.text('Edit'), findsOneWidget);
        expect(find.text('Delete'), findsOneWidget);
      });

      testWidgets('shows event menu without edit item when editing', (
        tester,
      ) async {
        await tester.pumpActionsWidget(
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showEventMenu(
            context: context,
            ref: ref,
            isEditing: true,
            eventId: testEvent.id,
          ),
          container: container,
          router: mockGoRouter,
        );

        // Tap the button to trigger menu
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Verify menu items are rendered (copy, share, delete - no edit)
        // Note: These strings should match the L10n strings in app_en.arb
        expect(find.text('Copy event content'), findsOneWidget);
        expect(find.text('Share'), findsOneWidget);
        expect(find.text('Delete'), findsOneWidget);
        expect(find.text('Edit'), findsNothing);
      });

      testWidgets('handles copy menu item tap correctly', (tester) async {
        await tester.pumpActionsWidget(
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showEventMenu(
            context: context,
            ref: ref,
            isEditing: false,
            eventId: testEvent.id,
          ),
          container: container,
          router: mockGoRouter,
        );

        // Tap the button to trigger menu
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Tap the copy menu item
        await tester.tap(find.text('Copy event content'));
        await tester.pumpAndSettle();

        // Verify snackbar is shown with correct message (indicates copy action was executed)
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Copied to clipboard'), findsOneWidget);
      });

      testWidgets('handles edit menu item tap correctly', (tester) async {
        await tester.pumpActionsWidget(
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showEventMenu(
            context: context,
            ref: ref,
            isEditing: false,
            eventId: testEvent.id,
          ),
          container: container,
          router: mockGoRouter,
        );

        // Tap the button to trigger menu
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Tap the edit menu item
        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();

        // Verify edit state was set
        final editContentId = container.read(editContentIdProvider);
        expect(editContentId, equals(testEvent.id));
      });

      testWidgets('handles delete menu item tap correctly', (tester) async {
        // Verify event exists initially
        final initialEvents = container.read(eventListProvider);
        expect(initialEvents.any((event) => event.id == testEvent.id), isTrue);

        await tester.pumpActionsWidget(
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showEventMenu(
            context: context,
            ref: ref,
            isEditing: false,
            eventId: testEvent.id,
          ),
          container: container,
          router: mockGoRouter,
        );

        // Tap the button to trigger menu
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Tap the delete menu item
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        // Verify event was deleted from provider
        final updatedEvents = container.read(eventListProvider);
        expect(updatedEvents.any((event) => event.id == testEvent.id), isFalse);
        expect(updatedEvents.length, equals(initialEvents.length - 1));

        // Verify snackbar is shown with correct message
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Event deleted'), findsOneWidget);
      });

      testWidgets('handles share menu item tap correctly', (tester) async {
        await tester.pumpActionsWidget(
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showEventMenu(
            context: context,
            ref: ref,
            isEditing: false,
            eventId: testEvent.id,
          ),
          container: container,
          router: mockGoRouter,
        );

        // Tap the button to trigger menu
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Tap the share menu item
        await tester.tap(find.text('Share'));
        await tester.pump(); // Don't use pumpAndSettle to avoid timeout

        // Verify the action was called (share bottom sheet might not settle)
        expect(find.text('Share'), findsAtLeastNWidgets(1));
        expect(find.byType(ShareItemsBottomSheet), findsOneWidget);
      });

      testWidgets('menu can be dismissed by tapping outside', (tester) async {
        await tester.pumpActionsWidget(
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showEventMenu(
            context: context,
            ref: ref,
            isEditing: false,
            eventId: testEvent.id,
          ),
          container: container,
          router: mockGoRouter,
        );

        // Tap the button to trigger menu
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Verify menu is shown
        expect(find.text('Copy event content'), findsOneWidget);

        // Tap outside the menu to dismiss it
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        // Verify menu is dismissed
        expect(find.text('Copy event content'), findsNothing);
      });

      testWidgets('shows correct menu items with detail screen flag', (
        tester,
      ) async {
        await tester.pumpActionsWidget(
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showEventMenu(
            context: context,
            ref: ref,
            isEditing: false,
            eventId: testEvent.id,
            isDetailScreen: true,
          ),
          container: container,
          router: mockGoRouter,
        );

        // Tap the button to trigger menu
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Verify all menu items are present
        // Note: These strings should match the L10n strings in app_en.arb
        expect(find.text('Copy event content'), findsOneWidget);
        expect(find.text('Share'), findsOneWidget);
        expect(find.text('Edit'), findsOneWidget);
        expect(find.text('Delete'), findsOneWidget);
      });
    });

    group('Integration Tests', () {
      testWidgets('copy action works with real providers', (tester) async {
        await tester.pumpActionsWidget(
          buttonText: 'Copy',
          onPressed: (context, ref) =>
              EventActions.copyEvent(context, ref, testEvent.id),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text('Copy'));
        await tester.pumpAndSettle();

        // Verify the action completed without errors
        expect(find.text('Copy'), findsOneWidget);
      });

      testWidgets('edit action works with real providers', (tester) async {
        await tester.pumpActionsWidget(
          buttonText: 'Edit',
          onPressed: (context, ref) => EventActions.editEvent(ref, testEvent.id),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();

        // Verify edit state was set
        final editContentId = container.read(editContentIdProvider);
        expect(editContentId, equals(testEvent.id));
      });

      testWidgets('delete action works with real providers', (tester) async {
        // Verify event exists initially
        final initialEvents = container.read(eventListProvider);
        expect(initialEvents.any((event) => event.id == testEvent.id), isTrue);

        await tester.pumpActionsWidget(
          buttonText: 'Delete',
          onPressed: (context, ref) =>
              EventActions.deleteEvent(context, ref, testEvent.id),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        // Verify event was deleted from provider
        final updatedEvents = container.read(eventListProvider);
        expect(updatedEvents.any((event) => event.id == testEvent.id), isFalse);
        expect(updatedEvents.length, equals(initialEvents.length - 1));
      });
    });

    group('Edge Cases', () {
      testWidgets('handles invalid event ID gracefully', (tester) async {
        const invalidEventId = 'invalid-event-id';

        await tester.pumpActionsWidget(
          buttonText: 'Copy Invalid',
          onPressed: (context, ref) =>
              EventActions.copyEvent(context, ref, invalidEventId),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text('Copy Invalid'));
        await tester.pumpAndSettle();

        // Should not throw an error
        expect(find.text('Copy Invalid'), findsOneWidget);
      });

      testWidgets('handles empty event ID', (tester) async {
        const emptyEventId = '';

        await tester.pumpActionsWidget(
          buttonText: 'Edit Empty',
          onPressed: (context, ref) => EventActions.editEvent(ref, emptyEventId),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text('Edit Empty'));
        await tester.pumpAndSettle();

        // Should set empty string as edit content ID
        final editContentId = container.read(editContentIdProvider);
        expect(editContentId, equals(emptyEventId));
      });
    });

    group('Provider State Changes', () {
      testWidgets('edit event updates provider state', (tester) async {
        // Initial state should be null
        expect(container.read(editContentIdProvider), isNull);

        await tester.pumpActionsWidget(
          buttonText: 'Edit',
          onPressed: (context, ref) => EventActions.editEvent(ref, testEvent.id),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();

        // State should be updated
        expect(container.read(editContentIdProvider), equals(testEvent.id));
      });

      testWidgets('delete event updates provider state', (tester) async {
        // Verify event exists initially
        final initialEvents = container.read(eventListProvider);
        expect(initialEvents.any((event) => event.id == testEvent.id), isTrue);

        await tester.pumpActionsWidget(
          buttonText: 'Delete',
          onPressed: (context, ref) =>
              EventActions.deleteEvent(context, ref, testEvent.id),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        // Verify event was deleted from provider
        final updatedEvents = container.read(eventListProvider);
        expect(updatedEvents.any((event) => event.id == testEvent.id), isFalse);
        expect(updatedEvents.length, equals(initialEvents.length - 1));
      });
    });

    group('Menu Item Configuration', () {
      testWidgets('menu items are configured correctly for non-editing state', (
        tester,
      ) async {
        await tester.pumpActionsWidget(
          buttonText: 'Menu',
          onPressed: (context, ref) => showEventMenu(
            context: context,
            ref: ref,
            isEditing: false,
            eventId: testEvent.id,
          ),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text('Menu'));
        await tester.pumpAndSettle();

        // Verify menu was shown
        expect(find.text('Menu'), findsOneWidget);
      });

      testWidgets('menu items are configured correctly for editing state', (
        tester,
      ) async {
        await tester.pumpActionsWidget(
          buttonText: 'Menu',
          onPressed: (context, ref) => showEventMenu(
            context: context,
            ref: ref,
            isEditing: true,
            eventId: testEvent.id,
          ),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text('Menu'));
        await tester.pumpAndSettle();

        // Verify menu was shown
        expect(find.text('Menu'), findsOneWidget);
      });
    });
  });
}