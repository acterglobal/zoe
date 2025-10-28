import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/features/events/widgets/event_widget.dart';
import 'package:zoe/features/home/widgets/section_header/section_header_widget.dart';
import 'package:zoe/features/home/widgets/today_focus/todays_focus_widget.dart';
import 'package:zoe/features/home/widgets/today_focus/todays_item_widget.dart';
import 'package:zoe/features/polls/data/polls.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/polls/widgets/poll_widget.dart';
import 'package:zoe/features/task/data/tasks.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/task/widgets/task_item_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../../test-utils/test_utils.dart';
import '../../../events/utils/event_utils.dart';
import '../../../polls/utils/poll_utils.dart';
import '../../../task/utils/task_utils.dart';

void main() {
  group('TodaysFocusWidget', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
    });

    Future<void> pumpTodaysFocusWidget(WidgetTester tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: SingleChildScrollView(
          child: SizedBox(
            height: 1200,
            width: 800,
            child: const TodaysFocusWidget(),
          ),
        ),
      );
      // Allow the test screen to be taller
      tester.view.physicalSize = const Size(800, 1200);
      addTearDown(tester.view.resetPhysicalSize);
    }

    L10n getL10n(WidgetTester tester) =>
        L10n.of(tester.element(find.byType(TodaysFocusWidget)));

    group('Empty State', () {
      testWidgets('renders nothing when all providers are empty', (
        tester,
      ) async {
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue(<EventModel>[]),
            todaysTasksProvider.overrideWithValue(<TaskModel>[]),
            activePollsWithPendingResponseProvider.overrideWithValue(
              <PollModel>[],
            ),
          ],
        );

        await pumpTodaysFocusWidget(tester);

        // Find the shrink-sized SizedBox from the empty state
        final sizedBoxes = find.byType(SizedBox);
        final shrinkBox = sizedBoxes.at(1); // The second one is the shrink
        expect(shrinkBox, findsOneWidget);
        final sizedBox = tester.widget<SizedBox>(shrinkBox);
        expect(sizedBox.width, equals(0));
        expect(sizedBox.height, equals(0));
      });
    });

    group('Widget Rendering', () {
      testWidgets('renders with proper structure when data exists', (
        tester,
      ) async {
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue([getEventByIndex(container)]),
            todaysTasksProvider.overrideWithValue(<TaskModel>[]),
            activePollsWithPendingResponseProvider.overrideWithValue(
              <PollModel>[],
            ),
          ],
        );

        await pumpTodaysFocusWidget(tester);

        expect(find.byType(Column), findsAtLeastNWidgets(1));
        expect(find.byType(SectionHeaderWidget), findsOneWidget);
        expect(find.byType(TodaysItemWidget), findsOneWidget);
      });

      testWidgets('renders section header correctly', (tester) async {
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue([getEventByIndex(container)]),
            todaysTasksProvider.overrideWithValue(<TaskModel>[]),
            activePollsWithPendingResponseProvider.overrideWithValue(
              <PollModel>[],
            ),
          ],
        );

        await pumpTodaysFocusWidget(tester);

        final sectionHeader = tester.widget<SectionHeaderWidget>(
          find.byType(SectionHeaderWidget),
        );
        expect(sectionHeader.title, equals(getL10n(tester).todaysFocus));
        expect(sectionHeader.icon, equals(Icons.rocket_launch_rounded));
      });
    });

    group('Events Section', () {
      testWidgets('renders events section when events exist', (tester) async {
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue([getEventByIndex(container),getEventByIndex(container, index: 1)]),
            todaysTasksProvider.overrideWithValue(<TaskModel>[]),
            activePollsWithPendingResponseProvider.overrideWithValue(
              <PollModel>[],
            ),
          ],
        );

        await pumpTodaysFocusWidget(tester);

        expect(find.byType(TodaysItemWidget), findsOneWidget);
        expect(find.byType(EventWidget), findsNWidgets(2));
      });

      testWidgets('renders events section with correct properties', (
        tester,
      ) async {
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue([getEventByIndex(container)]),
            todaysTasksProvider.overrideWithValue(<TaskModel>[]),
            activePollsWithPendingResponseProvider.overrideWithValue(
              <PollModel>[],
            ),
          ],
        );

        await pumpTodaysFocusWidget(tester);

        final todaysItem = tester.widget<TodaysItemWidget>(
          find.byType(TodaysItemWidget),
        );
        expect(todaysItem.title, equals(getL10n(tester).upcomingEvents));
        expect(todaysItem.icon, equals(Icons.event_rounded));
        expect(todaysItem.color, equals(AppColors.secondaryColor));
        expect(todaysItem.count, equals(1));
      });

      testWidgets('renders event widgets with correct properties', (
        tester,
      ) async {
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue([getEventByIndex(container)]),
            todaysTasksProvider.overrideWithValue(<TaskModel>[]),
            activePollsWithPendingResponseProvider.overrideWithValue(
              <PollModel>[],
            ),
          ],
        );

        await pumpTodaysFocusWidget(tester);

        final eventWidget = tester.widget<EventWidget>(
          find.byType(EventWidget),
        );
        expect(eventWidget.eventId, equals(getEventByIndex(container).id));
        expect(
          eventWidget.margin,
          equals(const EdgeInsets.only(top: 3, bottom: 3)),
        );
      });
    });

    group('Tasks Section', () {
      testWidgets('renders tasks section when tasks exist', (tester) async {
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue(<EventModel>[]),
            todaysTasksProvider.overrideWithValue([getTaskByIndex(container), getTaskByIndex(container, index: 1)]),
            activePollsWithPendingResponseProvider.overrideWithValue(
              <PollModel>[],
            ),
          ],
        );

        await pumpTodaysFocusWidget(tester);

        expect(find.byType(TodaysItemWidget), findsOneWidget);
        expect(find.byType(TaskWidget), findsNWidgets(2));
      });

      testWidgets('renders tasks section with correct properties', (
        tester,
      ) async {
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue(<EventModel>[]),
            todaysTasksProvider.overrideWithValue([tasks.first]),
            activePollsWithPendingResponseProvider.overrideWithValue(
              <PollModel>[],
            ),
          ],
        );

        await pumpTodaysFocusWidget(tester);

        final todaysItem = tester.widget<TodaysItemWidget>(
          find.byType(TodaysItemWidget),
        );
        expect(todaysItem.title, equals(getL10n(tester).activeTasks));
        expect(todaysItem.icon, equals(Icons.task_alt_rounded));
        expect(todaysItem.color, equals(AppColors.successColor));
        expect(todaysItem.count, equals(1));
      });

      testWidgets('renders task widgets with correct properties', (
        tester,
      ) async {
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue(<EventModel>[]),
            todaysTasksProvider.overrideWithValue([tasks.first]),
            activePollsWithPendingResponseProvider.overrideWithValue(
              <PollModel>[],
            ),
          ],
        );

        await pumpTodaysFocusWidget(tester);

        final taskWidget = tester.widget<TaskWidget>(find.byType(TaskWidget));
        expect(taskWidget.taskId, equals(getTaskByIndex(container).id));
        expect(taskWidget.isEditing, equals(false));
      });
    });

    group('Polls Section', () {
      testWidgets('renders polls section when polls exist', (tester) async {
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue(<EventModel>[]),
            todaysTasksProvider.overrideWithValue(<TaskModel>[]),
            activePollsWithPendingResponseProvider.overrideWithValue([
              polls.first,
              polls[1],
            ]),
          ],
        );

        await pumpTodaysFocusWidget(tester);

        expect(find.byType(TodaysItemWidget), findsOneWidget);
        expect(find.byType(PollWidget), findsNWidgets(2));
      });

      testWidgets('renders polls section with correct properties', (
        tester,
      ) async {
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue(<EventModel>[]),
            todaysTasksProvider.overrideWithValue(<TaskModel>[]),
            activePollsWithPendingResponseProvider.overrideWithValue([
              polls.first,
            ]),
          ],
        );

        await pumpTodaysFocusWidget(tester);

        final todaysItem = tester.widget<TodaysItemWidget>(
          find.byType(TodaysItemWidget),
        );
        expect(todaysItem.title, equals(getL10n(tester).activePolls));
        expect(todaysItem.icon, equals(Icons.poll_rounded));
        expect(todaysItem.color, equals(AppColors.brightMagentaColor));
        expect(todaysItem.count, equals(1));
      });

      testWidgets('renders poll widgets with correct properties', (
        tester,
      ) async {
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue(<EventModel>[]),
            todaysTasksProvider.overrideWithValue(<TaskModel>[]),
            activePollsWithPendingResponseProvider.overrideWithValue([
              getPollByIndex(container),
            ]),
          ],
        );

        await pumpTodaysFocusWidget(tester);

        final pollWidget = tester.widget<PollWidget>(find.byType(PollWidget));
        expect(pollWidget.pollId, equals(getPollByIndex(container).id));
      });
    });

    group('Multiple Sections', () {
      testWidgets('renders all sections when all data exists', (tester) async {
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue([getEventByIndex(container)]),
            todaysTasksProvider.overrideWithValue([getTaskByIndex(container)]),
            activePollsWithPendingResponseProvider.overrideWithValue([
              polls.first,
            ]),
          ],
        );

        await pumpTodaysFocusWidget(tester);

        expect(find.byType(TodaysItemWidget), findsNWidgets(3));
        expect(find.byType(EventWidget), findsOneWidget);
        expect(find.byType(TaskWidget), findsOneWidget);
        expect(find.byType(PollWidget), findsOneWidget);
      });

      testWidgets('renders correct spacing between sections', (tester) async {
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue([getEventByIndex(container)]),
            todaysTasksProvider.overrideWithValue([getTaskByIndex(container)]),
            activePollsWithPendingResponseProvider.overrideWithValue(
              <PollModel>[],
            ),
          ],
        );

        await pumpTodaysFocusWidget(tester);

        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        final heightSpacing = sizedBoxes.where((s) => s.height == 16).toList();
        expect(heightSpacing.length, equals(3)); // Between sections
      });
    });

    group('Localization', () {
      testWidgets('displays localized titles correctly', (tester) async {
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue([getEventByIndex(container)]),
            todaysTasksProvider.overrideWithValue([getTaskByIndex(container)]),
            activePollsWithPendingResponseProvider.overrideWithValue([
              polls.first,
            ]),
          ],
        );

        await pumpTodaysFocusWidget(tester);

        final l10n = getL10n(tester);
        expect(find.text(l10n.todaysFocus), findsOneWidget);
        expect(find.text(l10n.upcomingEvents), findsOneWidget);
        expect(find.text(l10n.activeTasks), findsOneWidget);
        expect(find.text(l10n.activePolls), findsOneWidget);
      });
    });

    group('Color Scheme', () {
      testWidgets('uses correct colors for each section', (tester) async {
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue([getEventByIndex(container)]),
            todaysTasksProvider.overrideWithValue([getTaskByIndex(container)]),
            activePollsWithPendingResponseProvider.overrideWithValue([
              polls.first,
            ]),
          ],
        );

        await pumpTodaysFocusWidget(tester);

        final todaysItems = tester.widgetList<TodaysItemWidget>(
          find.byType(TodaysItemWidget),
        );
        final colors = todaysItems.map((item) => item.color).toList();

        expect(colors, contains(AppColors.secondaryColor)); // Events
        expect(colors, contains(AppColors.successColor)); // Tasks
        expect(colors, contains(AppColors.brightMagentaColor)); // Polls
      });
    });

    group('Accessibility', () {
      testWidgets('has proper semantic structure', (tester) async {
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue([getEventByIndex(container)]),
            todaysTasksProvider.overrideWithValue(<TaskModel>[]),
            activePollsWithPendingResponseProvider.overrideWithValue(
              <PollModel>[],
            ),
          ],
        );

        await pumpTodaysFocusWidget(tester);

        expect(find.byType(Column), findsAtLeastNWidgets(1));
        expect(find.byType(SectionHeaderWidget), findsOneWidget);
        expect(find.byType(TodaysItemWidget), findsOneWidget);
        expect(find.byType(EventWidget), findsOneWidget);
      });

      testWidgets('text is properly rendered', (tester) async {
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue([getEventByIndex(container)]),
            todaysTasksProvider.overrideWithValue(<TaskModel>[]),
            activePollsWithPendingResponseProvider.overrideWithValue(
              <PollModel>[],
            ),
          ],
        );

        await pumpTodaysFocusWidget(tester);

        final l10n = getL10n(tester);
        expect(find.text(l10n.todaysFocus), findsOneWidget);
        expect(find.text(l10n.upcomingEvents), findsOneWidget);
      });
    });
  });
}

