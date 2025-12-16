import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/display_sheet_name_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/features/polls/data/polls.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/polls/widgets/poll_progress_widget.dart';
import 'package:zoe/features/polls/widgets/poll_widget.dart';

import '../../../test-utils/test_utils.dart';

void main() {
  group('PollWidget Tests', () {
    late ProviderContainer container;
    late PollModel testPoll;

    setUp(() {
      testPoll = polls.first;

      container = ProviderContainer.test(
        overrides: [
          pollProvider(testPoll.id).overrideWith((ref) => testPoll),
          // currentUserProvider.overrideWithValue(AsyncValue.data('user_1')),
          editContentIdProvider.overrideWith((ref) => null),
        ],
      );
    });

    Future<void> createWidgetUnderTest({
      required WidgetTester tester,
      required String pollId,
      bool isDetailScreen = false,
      bool showSheetName = true,
    }) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: PollWidget(
          pollId: pollId,
          isDetailScreen: isDetailScreen,
          showSheetName: showSheetName,
        ),
        container: container,
      );
    }

    group('Basic Rendering', () {
      testWidgets('renders correctly with valid poll', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find main poll content
        expect(find.byType(PollWidget), findsOneWidget);

        // Should find poll question and option text editors
        expect(find.byType(ZoeInlineTextEditWidget), findsAtLeastNWidgets(1));

        // Should find poll icon
        expect(find.byIcon(Icons.poll_outlined), findsOneWidget);

        // Should find progress widgets for each option
        expect(find.byType(PollProgressWidget), findsNWidgets(testPoll.options.length));
      });

      testWidgets('returns SizedBox.shrink when poll is null', (tester) async {
        container = ProviderContainer.test(
          overrides: [
            pollProvider('non-existent-poll').overrideWith((ref) => null),
            // currentUserProvider.overrideWithValue(AsyncValue.data('user_1')),
            editContentIdProvider.overrideWith((ref) => null),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: 'non-existent-poll');

        // Should find SizedBox.shrink (which renders nothing)
        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.byType(PollWidget), findsOneWidget);
      });

      testWidgets('renders with showSheetName true', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id, showSheetName: true);

        // Should find DisplaySheetNameWidget
        expect(find.byType(DisplaySheetNameWidget), findsOneWidget);
      });

      testWidgets('renders with showSheetName false', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id, showSheetName: false);

        // Should not find DisplaySheetNameWidget
        expect(find.byType(DisplaySheetNameWidget), findsNothing);
      });
    });

    group('Poll Question', () {
      testWidgets('displays poll question correctly', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find poll icon
        expect(find.byIcon(Icons.poll_outlined), findsOneWidget);

        // Should find question text
        expect(find.text(testPoll.question), findsOneWidget);
      });

      testWidgets('shows delete button when editing', (tester) async {
        container = ProviderContainer.test(
          overrides: [
            pollProvider(testPoll.id).overrideWith((ref) => testPoll),
            // currentUserProvider.overrideWithValue(AsyncValue.data('user_1')),
            editContentIdProvider.overrideWith((ref) => testPoll.id),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find delete icon
        expect(find.byIcon(Icons.delete), findsOneWidget);
      });
    });

    group('Poll Options', () {
      testWidgets('renders all poll options', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find progress widgets for each option
        expect(find.byType(PollProgressWidget), findsNWidgets(testPoll.options.length));
      });
    });

    group('Poll Actions', () {
      testWidgets('renders poll actions for draft poll', (tester) async {
        final draftPoll = testPoll.copyWith(startDate: null);
        
        container = ProviderContainer.test(
          overrides: [
            pollProvider(draftPoll.id).overrideWith((ref) => draftPoll),
            // currentUserProvider.overrideWithValue(AsyncValue.data('user_1')),
            editContentIdProvider.overrideWith((ref) => null),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: draftPoll.id);

        // Should render poll widget with draft poll
        expect(find.byType(PollWidget), findsOneWidget);
        expect(find.text(draftPoll.question), findsOneWidget);
        expect(find.byType(PollProgressWidget), findsNWidgets(draftPoll.options.length));
      });

      testWidgets('renders poll actions for active poll', (tester) async {
        final activePoll = testPoll.copyWith(
          startDate: DateTime.now().subtract(const Duration(days: 1)),
          endDate: null,
        );
        
        container = ProviderContainer.test(
          overrides: [
            pollProvider(activePoll.id).overrideWith((ref) => activePoll),
            // currentUserProvider.overrideWithValue(AsyncValue.data('user_1')),
            editContentIdProvider.overrideWith((ref) => null),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: activePoll.id);

        // Should render poll widget with active poll
        expect(find.byType(PollWidget), findsOneWidget);
        expect(find.text(activePoll.question), findsOneWidget);
        expect(find.byType(PollProgressWidget), findsNWidgets(activePoll.options.length));
      });

      testWidgets('renders poll actions when editing', (tester) async {
        final draftPoll = testPoll.copyWith(startDate: null);
        
        container = ProviderContainer.test(
          overrides: [
            pollProvider(draftPoll.id).overrideWith((ref) => draftPoll),
            // currentUserProvider.overrideWithValue(AsyncValue.data('user_1')),
            editContentIdProvider.overrideWith((ref) => draftPoll.id),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: draftPoll.id);

        // Should render poll widget in editing mode
        expect(find.byType(PollWidget), findsOneWidget);
        expect(find.text(draftPoll.question), findsOneWidget);
        expect(find.byType(ZoeInlineTextEditWidget), findsAtLeastNWidgets(1));
      });
    });

    group('Voting Functionality', () {
      testWidgets('renders voting interface for active poll', (tester) async {
        final activePoll = testPoll.copyWith(
          startDate: DateTime.now().subtract(const Duration(days: 1)),
          endDate: null,
        );
        
        container = ProviderContainer.test(
          overrides: [
            pollProvider(activePoll.id).overrideWith((ref) => activePoll),
            // currentUserProvider.overrideWithValue(AsyncValue.data('user_1')),
            editContentIdProvider.overrideWith((ref) => null),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: activePoll.id);

        // Should render voting interface
        expect(find.byType(PollWidget), findsOneWidget);
        expect(find.text(activePoll.question), findsOneWidget);
        expect(find.byType(PollProgressWidget), findsNWidgets(activePoll.options.length));
      });

      testWidgets('renders voting interface for draft poll', (tester) async {
        final draftPoll = testPoll.copyWith(startDate: null);
        
        container = ProviderContainer.test(
          overrides: [
            pollProvider(draftPoll.id).overrideWith((ref) => draftPoll),
            // currentUserProvider.overrideWithValue(AsyncValue.data('user_1')),
            editContentIdProvider.overrideWith((ref) => null),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: draftPoll.id);

        // Should render voting interface for draft
        expect(find.byType(PollWidget), findsOneWidget);
        expect(find.text(draftPoll.question), findsOneWidget);
        expect(find.byType(PollProgressWidget), findsNWidgets(draftPoll.options.length));
      });

      testWidgets('displays vote counts correctly', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find vote count text for options with votes
        final optionsWithVotes = testPoll.options.where((option) => option.votes.isNotEmpty);
        for (final option in optionsWithVotes) {
          expect(find.text('${option.votes.length}'), findsOneWidget);
        }
      });
    });

    group('Poll States', () {
      testWidgets('renders completed poll correctly', (tester) async {
        final completedPoll = testPoll.copyWith(
          startDate: DateTime.now().subtract(const Duration(days: 2)),
          endDate: DateTime.now().subtract(const Duration(days: 1)),
        );
        
        container = ProviderContainer.test(
          overrides: [
            pollProvider(completedPoll.id).overrideWith((ref) => completedPoll),
            // currentUserProvider.overrideWithValue(AsyncValue.data('user_1')),
            editContentIdProvider.overrideWith((ref) => null),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: completedPoll.id);

        // Should render completed poll
        expect(find.byType(PollWidget), findsOneWidget);
        expect(find.text(completedPoll.question), findsOneWidget);
        expect(find.byType(PollProgressWidget), findsNWidgets(completedPoll.options.length));
      });

      testWidgets('renders draft poll correctly', (tester) async {
        final draftPoll = testPoll.copyWith(startDate: null);
        
        container = ProviderContainer.test(
          overrides: [
            pollProvider(draftPoll.id).overrideWith((ref) => draftPoll),
            // currentUserProvider.overrideWithValue(AsyncValue.data('user_1')),
            editContentIdProvider.overrideWith((ref) => null),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: draftPoll.id);

        // Should render draft poll
        expect(find.byType(PollWidget), findsOneWidget);
        expect(find.text(draftPoll.question), findsOneWidget);
        expect(find.byType(PollProgressWidget), findsNWidgets(draftPoll.options.length));
      });

      testWidgets('renders active poll correctly', (tester) async {
        final activePoll = testPoll.copyWith(
          startDate: DateTime.now().subtract(const Duration(days: 1)),
          endDate: null,
        );
        
        container = ProviderContainer.test(
          overrides: [
            pollProvider(activePoll.id).overrideWith((ref) => activePoll),
            // currentUserProvider.overrideWithValue(AsyncValue.data('user_1')),
            editContentIdProvider.overrideWith((ref) => null),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: activePoll.id);

        // Should render active poll
        expect(find.byType(PollWidget), findsOneWidget);
        expect(find.text(activePoll.question), findsOneWidget);
        expect(find.byType(PollProgressWidget), findsNWidgets(activePoll.options.length));
      });
    });

    group('Edge Cases', () {
      testWidgets('handles poll with no options', (tester) async {
        final pollWithNoOptions = testPoll.copyWith(options: []);
        
        container = ProviderContainer.test(
          overrides: [
            pollProvider(pollWithNoOptions.id).overrideWith((ref) => pollWithNoOptions),
            // currentUserProvider.overrideWithValue(AsyncValue.data('user_1')),
            editContentIdProvider.overrideWith((ref) => null),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: pollWithNoOptions.id);

        // Should still render the widget but with no progress widgets
        expect(find.byType(PollWidget), findsOneWidget);
        expect(find.byType(PollProgressWidget), findsNothing);
        expect(find.byIcon(Icons.poll_outlined), findsOneWidget);
      });

      testWidgets('handles poll with single option', (tester) async {
        final pollWithSingleOption = testPoll.copyWith(
          options: [testPoll.options.first],
        );
        
        container = ProviderContainer.test(
          overrides: [
            pollProvider(pollWithSingleOption.id).overrideWith((ref) => pollWithSingleOption),
            // currentUserProvider.overrideWithValue(AsyncValue.data('user_1')),
            editContentIdProvider.overrideWith((ref) => pollWithSingleOption.id),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: pollWithSingleOption.id);

        // Should render correctly with single progress widget
        expect(find.byType(PollWidget), findsOneWidget);
        expect(find.byType(PollProgressWidget), findsOneWidget);
        expect(find.text(pollWithSingleOption.options.first.title), findsOneWidget);
      });

      testWidgets('handles different poll types', (tester) async {
        final multipleChoicePoll = testPoll.copyWith(isMultipleChoice: true);
        
        container = ProviderContainer.test(
          overrides: [
            pollProvider(multipleChoicePoll.id).overrideWith((ref) => multipleChoicePoll),
            // currentUserProvider.overrideWithValue(AsyncValue.data('user_1')),
            editContentIdProvider.overrideWith((ref) => null),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: multipleChoicePoll.id);

        // Should render correctly with all options
        expect(find.byType(PollWidget), findsOneWidget);
        expect(find.byType(PollProgressWidget), findsNWidgets(multipleChoicePoll.options.length));
        expect(find.text(multipleChoicePoll.question), findsOneWidget);
      });
    });

    group('Widget Properties', () {
      testWidgets('has correct key when provided', (tester) async {
        const testKey = Key('test-poll-widget-key');
        
        await tester.pumpMaterialWidgetWithProviderScope(
          child: PollWidget(
            key: testKey,
            pollId: testPoll.id,
          ),
          container: container,
        );

        expect(find.byKey(testKey), findsOneWidget);
      });

      testWidgets('handles isDetailScreen parameter', (tester) async {
        await createWidgetUnderTest(
          tester: tester, 
          pollId: testPoll.id, 
          isDetailScreen: true,
        );

        // Should render correctly with all expected elements
        expect(find.byType(PollWidget), findsOneWidget);
        expect(find.byIcon(Icons.poll_outlined), findsOneWidget);
        expect(find.text(testPoll.question), findsOneWidget);
        expect(find.byType(PollProgressWidget), findsNWidgets(testPoll.options.length));
      });
    });
  });
}
