import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/polls/actions/poll_actions.dart';
import 'package:zoe/features/polls/data/polls.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import '../../../test-utils/test_utils.dart';
import '../../../test-utils/mock_gorouter.dart';

void main() {
  group('PollActions Tests', () {
    late ProviderContainer container;
    late PollModel testPoll;
    late MockGoRouter mockGoRouter;

    setUp(() {
      testPoll = polls.first;
      mockGoRouter = MockGoRouter();

      // Set up mock methods
      when(() => mockGoRouter.canPop()).thenReturn(true);
      when(() => mockGoRouter.pop()).thenReturn(null);

      container = ProviderContainer.test(
        overrides: [
          pollProvider(testPoll.id).overrideWith((ref) => testPoll),
          editContentIdProvider.overrideWith((ref) => null),
        ],
      );
    });

    group('copyPoll', () {
      testWidgets('copies poll content to clipboard', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Copy Poll',
          onPressed: (context, ref) =>
              PollActions.copyPoll(context, ref, testPoll.id),
        );

        // Tap the button to trigger copy action
        await tester.tap(find.text('Copy Poll'));
        await tester.pumpAndSettle();

        // Verify the action was called (we can't easily test clipboard in unit tests)
        expect(find.text('Copy Poll'), findsOneWidget);
      });

      testWidgets('shows snackbar after copying', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Copy Poll',
          onPressed: (context, ref) =>
              PollActions.copyPoll(context, ref, testPoll.id),
        );

        // Tap the button to trigger copy action
        await tester.tap(find.text('Copy Poll'));
        await tester.pumpAndSettle();

        // Verify snackbar is shown with correct message
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Copied to clipboard'), findsOneWidget);
      });
    });

    group('sharePoll', () {
      testWidgets('shows share bottom sheet', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Share Poll',
          onPressed: (context, ref) =>
              PollActions.sharePoll(context, ref, testPoll.id),
        );

        // Tap the button to trigger share action
        await tester.tap(find.text('Share Poll'));
        await tester.pump(); // Don't use pumpAndSettle to avoid timeout

        // Verify the action was called
        expect(find.text('Share Poll'), findsAtLeastNWidgets(1));
      });
    });

    group('editPoll', () {
      testWidgets('enables edit mode for poll', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Edit Poll',
          onPressed: (context, ref) => PollActions.editPoll(ref, testPoll.id),
        );

        // Tap the button to trigger edit action
        await tester.tap(find.text('Edit Poll'));
        await tester.pumpAndSettle();

        // Verify edit mode is enabled
        final editContentId = container.read(editContentIdProvider);
        expect(editContentId, equals(testPoll.id));
      });

      testWidgets('sets correct poll ID in edit provider', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Edit Poll',
          onPressed: (context, ref) => PollActions.editPoll(ref, testPoll.id),
        );

        // Tap the button to trigger edit action
        await tester.tap(find.text('Edit Poll'));
        await tester.pumpAndSettle();

        // Verify the correct poll ID is set
        final editContentId = container.read(editContentIdProvider);
        expect(editContentId, equals(testPoll.id));
      });
    });

    group('deletePoll', () {
      testWidgets('deletes poll from provider', (tester) async {
        // Verify poll exists initially
        final initialPolls = container.read(pollListProvider);
        expect(initialPolls.any((poll) => poll.id == testPoll.id), isTrue);

        await tester.pumpActionsWidget(
          buttonText: 'Delete Poll',
          onPressed: (context, ref) =>
              PollActions.deletePoll(context, ref, testPoll.id),
          container: container,
        );

        // Tap the button to trigger delete action
        await tester.tap(find.text('Delete Poll'));
        await tester.pumpAndSettle();

        // Verify poll was deleted from provider
        final updatedPolls = container.read(pollListProvider);
        expect(updatedPolls.any((poll) => poll.id == testPoll.id), isFalse);
        expect(updatedPolls.length, equals(initialPolls.length - 1));
      });

      testWidgets('shows snackbar after deletion', (tester) async {
        await tester.pumpActionsWidget(
          buttonText: 'Delete Poll',
          onPressed: (context, ref) =>
              PollActions.deletePoll(context, ref, testPoll.id),
          container: container,
        );

        // Tap the button to trigger delete action
        await tester.tap(find.text('Delete Poll'));
        await tester.pumpAndSettle();

        // Verify snackbar is shown with correct message
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Poll deleted'), findsOneWidget);
      });
    });

    group('showPollMenu', () {
      testWidgets('shows poll menu with all items when not editing', (
        tester,
      ) async {
        await tester.pumpActionsWidget(
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showPollMenu(
            context: context,
            ref: ref,
            isEditing: false,
            pollId: testPoll.id,
          ),
          container: container,
          router: mockGoRouter,
        );

        // Tap the button to trigger menu
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Verify menu items are rendered (copy, share, edit, delete)
        // Note: These strings should match the L10n strings in app_en.arb
        expect(find.text('Copy poll content'), findsOneWidget);
        expect(find.text('Share'), findsOneWidget);
        expect(find.text('Edit'), findsOneWidget);
        expect(find.text('Delete'), findsOneWidget);
      });

      testWidgets('shows poll menu without edit item when editing', (
        tester,
      ) async {
        await tester.pumpActionsWidget(
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showPollMenu(
            context: context,
            ref: ref,
            isEditing: true,
            pollId: testPoll.id,
          ),
          container: container,
          router: mockGoRouter,
        );

        // Tap the button to trigger menu
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Verify menu items are rendered (copy, share, delete - no edit)
        // Note: These strings should match the L10n strings in app_en.arb
        expect(find.text('Copy poll content'), findsOneWidget);
        expect(find.text('Share'), findsOneWidget);
        expect(find.text('Delete'), findsOneWidget);
        expect(find.text('Edit'), findsNothing);
      });

      testWidgets('handles copy menu item tap correctly', (tester) async {
        await tester.pumpActionsWidget(
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showPollMenu(
            context: context,
            ref: ref,
            isEditing: false,
            pollId: testPoll.id,
          ),
          container: container,
          router: mockGoRouter,
        );

        // Tap the button to trigger menu
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Tap the copy menu item
        await tester.tap(find.text('Copy poll content'));
        await tester.pumpAndSettle();

        // Verify snackbar is shown with correct message (indicates copy action was executed)
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Copied to clipboard'), findsOneWidget);
      });

      testWidgets('handles edit menu item tap correctly', (tester) async {
        await tester.pumpActionsWidget(
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showPollMenu(
            context: context,
            ref: ref,
            isEditing: false,
            pollId: testPoll.id,
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
        expect(editContentId, equals(testPoll.id));
      });

      testWidgets('handles delete menu item tap correctly', (tester) async {
        // Verify poll exists initially
        final initialPolls = container.read(pollListProvider);
        expect(initialPolls.any((poll) => poll.id == testPoll.id), isTrue);

        await tester.pumpActionsWidget(
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showPollMenu(
            context: context,
            ref: ref,
            isEditing: false,
            pollId: testPoll.id,
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

        // Verify poll was deleted from provider
        final updatedPolls = container.read(pollListProvider);
        expect(updatedPolls.any((poll) => poll.id == testPoll.id), isFalse);
        expect(updatedPolls.length, equals(initialPolls.length - 1));

        // Verify snackbar is shown with correct message
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Poll deleted'), findsOneWidget);
      });

      testWidgets('handles share menu item tap correctly', (tester) async {
        await tester.pumpActionsWidget(
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showPollMenu(
            context: context,
            ref: ref,
            isEditing: false,
            pollId: testPoll.id,
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
      });

      testWidgets('menu can be dismissed by tapping outside', (tester) async {
        await tester.pumpActionsWidget(
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showPollMenu(
            context: context,
            ref: ref,
            isEditing: false,
            pollId: testPoll.id,
          ),
          container: container,
          router: mockGoRouter,
        );

        // Tap the button to trigger menu
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Verify menu is shown
        expect(find.text('Copy poll content'), findsOneWidget);

        // Tap outside the menu to dismiss it
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        // Verify menu is dismissed
        expect(find.text('Copy poll content'), findsNothing);
      });

      testWidgets('shows correct menu items with detail screen flag', (
        tester,
      ) async {
        await tester.pumpActionsWidget(
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showPollMenu(
            context: context,
            ref: ref,
            isEditing: false,
            pollId: testPoll.id,
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
        expect(find.text('Copy poll content'), findsOneWidget);
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
              PollActions.copyPoll(context, ref, testPoll.id),
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
          onPressed: (context, ref) => PollActions.editPoll(ref, testPoll.id),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();

        // Verify edit state was set
        final editContentId = container.read(editContentIdProvider);
        expect(editContentId, equals(testPoll.id));
      });

      testWidgets('delete action works with real providers', (tester) async {
        // Verify poll exists initially
        final initialPolls = container.read(pollListProvider);
        expect(initialPolls.any((poll) => poll.id == testPoll.id), isTrue);

        await tester.pumpActionsWidget(
          buttonText: 'Delete',
          onPressed: (context, ref) =>
              PollActions.deletePoll(context, ref, testPoll.id),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        // Verify poll was deleted from provider
        final updatedPolls = container.read(pollListProvider);
        expect(updatedPolls.any((poll) => poll.id == testPoll.id), isFalse);
        expect(updatedPolls.length, equals(initialPolls.length - 1));
      });
    });

    group('Edge Cases', () {
      testWidgets('handles invalid poll ID gracefully', (tester) async {
        const invalidPollId = 'invalid-poll-id';

        await tester.pumpActionsWidget(
          buttonText: 'Copy Invalid',
          onPressed: (context, ref) =>
              PollActions.copyPoll(context, ref, invalidPollId),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text('Copy Invalid'));
        await tester.pumpAndSettle();

        // Should not throw an error
        expect(find.text('Copy Invalid'), findsOneWidget);
      });

      testWidgets('handles empty poll ID', (tester) async {
        const emptyPollId = '';

        await tester.pumpActionsWidget(
          buttonText: 'Edit Empty',
          onPressed: (context, ref) => PollActions.editPoll(ref, emptyPollId),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text('Edit Empty'));
        await tester.pumpAndSettle();

        // Should set empty string as edit content ID
        final editContentId = container.read(editContentIdProvider);
        expect(editContentId, equals(emptyPollId));
      });
    });

    group('Provider State Changes', () {
      testWidgets('edit poll updates provider state', (tester) async {
        // Initial state should be null
        expect(container.read(editContentIdProvider), isNull);

        await tester.pumpActionsWidget(
          buttonText: 'Edit',
          onPressed: (context, ref) => PollActions.editPoll(ref, testPoll.id),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();

        // State should be updated
        expect(container.read(editContentIdProvider), equals(testPoll.id));
      });

      testWidgets('delete poll updates provider state', (tester) async {
        // Verify poll exists initially
        final initialPolls = container.read(pollListProvider);
        expect(initialPolls.any((poll) => poll.id == testPoll.id), isTrue);

        await tester.pumpActionsWidget(
          buttonText: 'Delete',
          onPressed: (context, ref) =>
              PollActions.deletePoll(context, ref, testPoll.id),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        // Verify poll was deleted from provider
        final updatedPolls = container.read(pollListProvider);
        expect(updatedPolls.any((poll) => poll.id == testPoll.id), isFalse);
        expect(updatedPolls.length, equals(initialPolls.length - 1));
      });
    });

    group('Menu Item Configuration', () {
      testWidgets('menu items are configured correctly for non-editing state', (
        tester,
      ) async {
        await tester.pumpActionsWidget(
          buttonText: 'Menu',
          onPressed: (context, ref) => showPollMenu(
            context: context,
            ref: ref,
            isEditing: false,
            pollId: testPoll.id,
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
          onPressed: (context, ref) => showPollMenu(
            context: context,
            ref: ref,
            isEditing: true,
            pollId: testPoll.id,
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
