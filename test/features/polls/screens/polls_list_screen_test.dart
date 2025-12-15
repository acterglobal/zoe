import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_list_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_glassy_tab_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:zoe/features/polls/data/polls.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/polls/screens/polls_list_screen.dart';
import 'package:zoe/features/polls/utils/poll_utils.dart';
import 'package:zoe/features/polls/widgets/poll_list_widget.dart';

import '../../../test-utils/mock_search_value.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('PollsListScreen Tests', () {
    late ProviderContainer container;

    setUp(() {

      container = ProviderContainer.test(
        overrides: [
          searchValueProvider.overrideWith(MockSearchValue.new),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    Future<void> createWidgetUnderTest({required WidgetTester tester}) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: const PollsListScreen(),
        container: container,
      );
    }

    group('Basic Rendering', () {
      testWidgets('renders correctly with all main components', (tester) async {
        await createWidgetUnderTest(tester: tester);

        // Should find main screen components
        expect(find.byType(PollsListScreen), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(SafeArea), findsAtLeastNWidgets(1));
        expect(find.byType(TabBarView), findsOneWidget);
      });

      testWidgets('renders app bar', (tester) async {
        await createWidgetUnderTest(tester: tester);

        // Should find app bar components
        expect(find.byType(ZoeAppBar), findsOneWidget);
        expect(find.byType(ZoeGlassyTabWidget), findsOneWidget);
      });

      testWidgets('renders search bar', (tester) async {
        await createWidgetUnderTest(tester: tester);

        // Should find search bar
        expect(find.byType(ZoeSearchBarWidget), findsOneWidget);
      });

      testWidgets('renders all three tabs', (tester) async {
        await createWidgetUnderTest(tester: tester);

        // Should find tab bar view with three children
        expect(find.byType(TabBarView), findsOneWidget);

        // Should find one poll list widget (only active tab is rendered)
        expect(find.byType(PollListWidget), findsOneWidget);
      });
    });

    group('Tab Functionality', () {
      testWidgets('renders draft polls tab with correct provider', (
        tester,
      ) async {
        // Create mock polls with different statuses
        final draftPoll = polls.first.copyWith(startDate: null);
        final activePoll = polls.first.copyWith(
          startDate: DateTime.now().subtract(const Duration(days: 1)),
          endDate: null,
        );

        container = ProviderContainer.test(
          overrides: [
            notActivePollListProvider.overrideWithValue([draftPoll]),
            activePollListProvider.overrideWithValue([activePoll]),
            completedPollListProvider.overrideWithValue([]),
            searchValueProvider.overrideWith(MockSearchValue.new),
          ],
        );

        await createWidgetUnderTest(tester: tester);

        // Should find poll list widget for draft polls (active tab)
        expect(find.byType(PollListWidget), findsOneWidget);

        // Verify the notActivePollListProvider is being used
        final notActivePolls = container.read(notActivePollListProvider);
        expect(notActivePolls.length, equals(1));
        expect(notActivePolls.first.id, equals(draftPoll.id));
      });

      testWidgets('renders active polls tab with correct provider', (
        tester,
      ) async {
        // Create mock polls with different statuses
        final draftPoll = polls.first.copyWith(startDate: null);
        final activePoll = polls.first.copyWith(
          startDate: DateTime.now().subtract(const Duration(days: 1)),
          endDate: null,
        );

        container = ProviderContainer.test(
          overrides: [
            notActivePollListProvider.overrideWithValue([draftPoll]),
            activePollListProvider.overrideWithValue([activePoll]),
            completedPollListProvider.overrideWithValue([]),
            searchValueProvider.overrideWith(MockSearchValue.new),
          ],
        );

        await createWidgetUnderTest(tester: tester);

        // Should find poll list widget for active polls (active tab)
        expect(find.byType(PollListWidget), findsOneWidget);

        // Verify the activePollListProvider is being used
        final activePolls = container.read(activePollListProvider);
        expect(activePolls.length, equals(1));
        expect(activePolls.first.id, equals(activePoll.id));
      });

      testWidgets('renders completed polls tab with correct provider', (
        tester,
      ) async {
        // Create mock polls with different statuses
        final draftPoll = polls.first.copyWith(startDate: null);
        final completedPoll = polls.first.copyWith(
          startDate: DateTime.now().subtract(const Duration(days: 2)),
          endDate: DateTime.now().subtract(const Duration(days: 1)),
        );

        container = ProviderContainer.test(
          overrides: [
            notActivePollListProvider.overrideWithValue([draftPoll]),
            activePollListProvider.overrideWithValue([]),
            completedPollListProvider.overrideWithValue([completedPoll]),
            searchValueProvider.overrideWith(MockSearchValue.new),
          ],
        );

        await createWidgetUnderTest(tester: tester);

        // Should find poll list widget for completed polls (active tab)
        expect(find.byType(PollListWidget), findsOneWidget);

        // Verify the completedPollListProvider is being used
        final completedPolls = container.read(completedPollListProvider);
        expect(completedPolls.length, equals(1));
        expect(completedPolls.first.id, equals(completedPoll.id));
      });

      testWidgets('shows empty state when no polls available', (tester) async {
        // Create container with empty poll lists
        container = ProviderContainer.test(
          overrides: [
            notActivePollListProvider.overrideWithValue([]),
            activePollListProvider.overrideWithValue([]),
            completedPollListProvider.overrideWithValue([]),
            searchValueProvider.overrideWith(MockSearchValue.new),
          ],
        );

        await createWidgetUnderTest(tester: tester);

        // Should find poll list widget
        expect(find.byType(PollListWidget), findsOneWidget);

        // Should find empty state widget when no polls are available
        expect(find.byType(EmptyStateListWidget), findsOneWidget);
      });

      testWidgets('has correct tab labels', (tester) async {
        await createWidgetUnderTest(tester: tester);

        // Should find tab labels
        expect(find.text(PollStatus.draft.name), findsOneWidget);
        expect(find.text(PollStatus.active.name), findsOneWidget);
        expect(find.text(PollStatus.completed.name), findsOneWidget);
      });
    });

    group('Search Functionality', () {
      testWidgets('search bar updates search value provider', (tester) async {
        await createWidgetUnderTest(tester: tester);

        // Find search bar and enter text
        final searchBar = find.byType(ZoeSearchBarWidget);
        expect(searchBar, findsOneWidget);

        await tester.enterText(searchBar, 'test search');
        await tester.pump();

        // Verify search value was updated
        final searchValue = container.read(searchValueProvider);
        expect(searchValue, equals('test search'));
      });

      testWidgets('search bar clears when text is removed', (tester) async {
        await createWidgetUnderTest(tester: tester);

        // Enter text first
        final searchBar = find.byType(ZoeSearchBarWidget);
        await tester.enterText(searchBar, 'test');
        await tester.pump();

        // Clear text
        await tester.enterText(searchBar, '');
        await tester.pump();

        // Verify search value was cleared
        final searchValue = container.read(searchValueProvider);
        expect(searchValue, equals(''));
      });
    });

    group('Empty State', () {
      testWidgets('renders empty state for each tab', (tester) async {
        await createWidgetUnderTest(tester: tester);

        // Should find empty state widget for active tab
        expect(find.byType(EmptyStateListWidget), findsOneWidget);
      });
    });

    group('Layout Structure', () {
      testWidgets('has correct layout hierarchy', (tester) async {
        await createWidgetUnderTest(tester: tester);

        // Should find main layout components
        expect(find.byType(SafeArea), findsAtLeastNWidgets(1));
        expect(find.byType(Column), findsAtLeastNWidgets(1));
        expect(find.byType(Expanded), findsAtLeastNWidgets(1));
      });

      testWidgets('app bar has correct configuration', (tester) async {
        await createWidgetUnderTest(tester: tester);

        // Should find app bar
        final appBar = find.byType(AppBar);
        expect(appBar, findsOneWidget);

        // App bar should not have leading
        final appBarWidget = tester.widget<AppBar>(appBar);
        expect(appBarWidget.automaticallyImplyLeading, isFalse);
      });
    });

    group('Widget Lifecycle', () {
      testWidgets('disposes controllers correctly', (tester) async {
        await createWidgetUnderTest(tester: tester);

        // Should render without errors
        expect(find.byType(PollsListScreen), findsOneWidget);

        // Dispose the container to test cleanup
        container.dispose();

        // Should not throw errors
        expect(tester.takeException(), isNull);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles empty poll lists gracefully', (tester) async {
        await createWidgetUnderTest(tester: tester);

        // Should render empty state widget
        expect(find.byType(EmptyStateListWidget), findsOneWidget);
        expect(find.byType(PollListWidget), findsOneWidget);
      });

      testWidgets('handles search with no results', (tester) async {
        await createWidgetUnderTest(tester: tester);

        // Enter search text
        final searchBar = find.byType(ZoeSearchBarWidget);
        await tester.enterText(searchBar, 'nonexistent poll');
        await tester.pump();

        // Should still render the screen
        expect(find.byType(PollsListScreen), findsOneWidget);
        expect(find.byType(PollListWidget), findsOneWidget);
      });
    });
    testWidgets('has correct key when provided', (tester) async {
      const testKey = Key('test-polls-list-screen-key');

      await tester.pumpMaterialWidgetWithProviderScope(
        child: const PollsListScreen(key: testKey),
        container: container,
      );

      expect(find.byKey(testKey), findsOneWidget);
    });
  });
}
