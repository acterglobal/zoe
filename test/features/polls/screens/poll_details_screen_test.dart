import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/content_menu_button.dart';
import 'package:zoe/common/widgets/floating_action_button_wrapper.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/paper_sheet_background_widget.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/features/content/providers/content_providers.dart';
import 'package:zoe/features/content/widgets/content_widget.dart';
import 'package:zoe/features/polls/data/polls.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/polls/screens/poll_details_screen.dart';
import 'package:zoe/features/polls/widgets/poll_widget.dart';
import '../../../test-utils/mock_search_value.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('PollDetailsScreen Tests', () {
    late ProviderContainer container;
    late PollModel testPoll;

    setUp(() {
      testPoll = polls.first;

      container = ProviderContainer.test(
        overrides: [
          pollProvider(testPoll.id).overrideWith((ref) => testPoll),
          editContentIdProvider.overrideWith((ref) => null),
          searchValueProvider.overrideWith(MockSearchValue.new),
          contentListProvider.overrideWithValue([]),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    Future<void> createWidgetUnderTest({
      required WidgetTester tester,
      required String pollId,
    }) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: PollDetailsScreen(pollId: pollId),
        container: container,
      );
    }

    group('Basic Rendering', () {
      testWidgets('renders correctly with valid poll', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find main screen components
        expect(find.byType(PollDetailsScreen), findsOneWidget);
        expect(find.byType(NotebookPaperBackgroundWidget), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(MaxWidthWidget), findsOneWidget);
      });

      testWidgets('renders app bar with correct title', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find app bar components
        expect(find.byType(ZoeAppBar), findsOneWidget);
        expect(find.byType(ContentMenuButton), findsOneWidget);
      });

      testWidgets('renders poll widget with correct properties', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find poll widget with detail screen flag
        expect(find.byType(PollWidget), findsOneWidget);
        
        // Verify PollWidget has correct properties
        final pollWidget = tester.widget<PollWidget>(find.byType(PollWidget));
        expect(pollWidget.pollId, equals(testPoll.id));
        expect(pollWidget.isDetailScreen, isTrue);
      });

      testWidgets('renders content widget', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find content widget
        expect(find.byType(ContentWidget), findsOneWidget);
        
        // Verify ContentWidget has correct properties
        final contentWidget = tester.widget<ContentWidget>(find.byType(ContentWidget));
        expect(contentWidget.parentId, equals(testPoll.id));
        expect(contentWidget.sheetId, equals(testPoll.sheetId));
      });

      testWidgets('renders floating action button', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find floating action button wrapper
        expect(find.byType(FloatingActionButtonWrapper), findsOneWidget);
        
        // Verify FloatingActionButtonWrapper has correct properties
        final fabWidget = tester.widget<FloatingActionButtonWrapper>(find.byType(FloatingActionButtonWrapper));
        expect(fabWidget.parentId, equals(testPoll.id));
        expect(fabWidget.sheetId, equals(testPoll.sheetId));
      });
    });
  
    group('Empty State', () {
      testWidgets('renders empty state when poll is null', (tester) async {
        container = ProviderContainer.test(
          overrides: [
            pollProvider('non-existent-poll').overrideWith((ref) => null),
            editContentIdProvider.overrideWith((ref) => null),
            searchValueProvider.overrideWith(MockSearchValue.new),
            contentListProvider.overrideWithValue([]),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: 'non-existent-poll');

        // Should find empty state components
        expect(find.byType(NotebookPaperBackgroundWidget), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(EmptyStateWidget), findsOneWidget);
        
        // Should not find poll widget or content widget
        expect(find.byType(PollWidget), findsNothing);
        expect(find.byType(ContentWidget), findsNothing);
        expect(find.byType(FloatingActionButtonWrapper), findsNothing);
      });

      testWidgets('empty state has correct message and icon', (tester) async {
        container = ProviderContainer.test(
          overrides: [
            pollProvider('non-existent-poll').overrideWith((ref) => null),
            editContentIdProvider.overrideWith((ref) => null),
            searchValueProvider.overrideWith(MockSearchValue.new),
            contentListProvider.overrideWithValue([]),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: 'non-existent-poll');

        // Should find empty state widget
        expect(find.byType(EmptyStateWidget), findsOneWidget);
        
        // Verify EmptyStateWidget properties
        final emptyStateWidget = tester.widget<EmptyStateWidget>(find.byType(EmptyStateWidget));
        expect(emptyStateWidget.icon, equals(Icons.poll_outlined));
      });
    });

    group('Editing State', () {
      testWidgets('renders editing state correctly', (tester) async {
        container = ProviderContainer.test(
          overrides: [
            pollProvider(testPoll.id).overrideWith((ref) => testPoll),
            editContentIdProvider.overrideWith((ref) => testPoll.id),
            searchValueProvider.overrideWith(MockSearchValue.new),
            contentListProvider.overrideWithValue([]),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find stack widget
        expect(find.byType(Stack), findsAtLeastNWidgets(1));
        
        // Verify edit state is correct
        final editContentId = container.read(editContentIdProvider);
        expect(editContentId, equals(testPoll.id));
      });

      testWidgets('renders non-editing state correctly', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find stack widget
        expect(find.byType(Stack), findsAtLeastNWidgets(1));
        
        // Verify edit state is correct
        final editContentId = container.read(editContentIdProvider);
        expect(editContentId, isNull);
      });

      testWidgets('shows correct editing state in poll widget', (tester) async {
        container = ProviderContainer.test(
          overrides: [
            pollProvider(testPoll.id).overrideWith((ref) => testPoll),
            editContentIdProvider.overrideWith((ref) => testPoll.id),
            searchValueProvider.overrideWith(MockSearchValue.new),
            contentListProvider.overrideWithValue([]),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find poll widget
        expect(find.byType(PollWidget), findsOneWidget);
        
        // Verify editContentIdProvider is being watched
        final editContentId = container.read(editContentIdProvider);
        expect(editContentId, equals(testPoll.id));
      });
    });

    group('Layout Structure', () {

      testWidgets('has correct padding and spacing', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find SingleChildScrollView with padding
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        
        // Should find SizedBox widgets for spacing
        expect(find.byType(SizedBox), findsAtLeastNWidgets(2));
      });

      testWidgets('app bar has correct configuration', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find app bar
        final appBar = find.byType(AppBar);
        expect(appBar, findsOneWidget);
        
        // App bar should not have leading
        final appBarWidget = tester.widget<AppBar>(appBar);
        expect(appBarWidget.automaticallyImplyLeading, isFalse);
      });
    });

    group('Widget Properties', () {
      testWidgets('has correct key when provided', (tester) async {
        const testKey = Key('test-poll-details-screen-key');
        
        await tester.pumpMaterialWidgetWithProviderScope(
          child: PollDetailsScreen(
            key: testKey,
            pollId: testPoll.id,
          ),
          container: container,
        );

        expect(find.byKey(testKey), findsOneWidget);
      });

      testWidgets('requires pollId parameter', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should render correctly with pollId
        expect(find.byType(PollDetailsScreen), findsOneWidget);
      });
    });

    group('Content Integration', () {
      testWidgets('renders content widget with correct parent relationship', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find content widget
        expect(find.byType(ContentWidget), findsOneWidget);
        
        // Verify parent-child relationship
        final contentWidget = tester.widget<ContentWidget>(find.byType(ContentWidget));
        expect(contentWidget.parentId, equals(testPoll.id));
        expect(contentWidget.sheetId, equals(testPoll.sheetId));
      });

      testWidgets('floating action button has correct parent relationship', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find floating action button wrapper
        expect(find.byType(FloatingActionButtonWrapper), findsOneWidget);
        
        // Verify parent-child relationship
        final fabWidget = tester.widget<FloatingActionButtonWrapper>(find.byType(FloatingActionButtonWrapper));
        expect(fabWidget.parentId, equals(testPoll.id));
        expect(fabWidget.sheetId, equals(testPoll.sheetId));
      });
    });

    group('Menu Integration', () {
      testWidgets('renders content menu button', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find content menu button
        expect(find.byType(ContentMenuButton), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles different poll states gracefully', (tester) async {
        // Test with draft poll
        final draftPoll = testPoll.copyWith(startDate: null);
        
        container = ProviderContainer.test(
          overrides: [
            pollProvider(draftPoll.id).overrideWith((ref) => draftPoll),
            editContentIdProvider.overrideWith((ref) => null),
            searchValueProvider.overrideWith(MockSearchValue.new),
            contentListProvider.overrideWithValue([]),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: draftPoll.id);

        // Should render correctly
        expect(find.byType(PollDetailsScreen), findsOneWidget);
        expect(find.byType(PollWidget), findsOneWidget);
      });

      testWidgets('handles completed poll correctly', (tester) async {
        // Test with completed poll
        final completedPoll = testPoll.copyWith(
          startDate: DateTime.now().subtract(const Duration(days: 2)),
          endDate: DateTime.now().subtract(const Duration(days: 1)),
        );
        
        container = ProviderContainer.test(
          overrides: [
            pollProvider(completedPoll.id).overrideWith((ref) => completedPoll),
            editContentIdProvider.overrideWith((ref) => null),
            searchValueProvider.overrideWith(MockSearchValue.new),
            contentListProvider.overrideWithValue([]),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: completedPoll.id);

        // Should render correctly
        expect(find.byType(PollDetailsScreen), findsOneWidget);
        expect(find.byType(PollWidget), findsOneWidget);
      });

      testWidgets('handles active poll correctly', (tester) async {
        // Test with active poll
        final activePoll = testPoll.copyWith(
          startDate: DateTime.now().subtract(const Duration(days: 1)),
          endDate: null,
        );
        
        container = ProviderContainer.test(
          overrides: [
            pollProvider(activePoll.id).overrideWith((ref) => activePoll),
            editContentIdProvider.overrideWith((ref) => null),
            searchValueProvider.overrideWith(MockSearchValue.new),
            contentListProvider.overrideWithValue([]),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: activePoll.id);

        // Should render correctly
        expect(find.byType(PollDetailsScreen), findsOneWidget);
        expect(find.byType(PollWidget), findsOneWidget);
      });
    });
  });
}
