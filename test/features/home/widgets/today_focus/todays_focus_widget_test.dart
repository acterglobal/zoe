import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/features/events/widgets/event_widget.dart';
import 'package:zoe/features/home/widgets/section_header/section_header_widget.dart';
import 'package:zoe/features/home/widgets/today_focus/todays_focus_widget.dart';
import 'package:zoe/features/home/widgets/today_focus/todays_item_widget.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/polls/widgets/poll_widget.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/task/widgets/task_item_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../../test-utils/mock_models.dart';
import '../../../../test-utils/test_utils.dart';

void main() {
  group('TodaysFocusWidget', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
    });

    Future<void> pumpTodaysFocusWidget(WidgetTester tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: const TodaysFocusWidget(),
      );
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

        expect(find.byType(SizedBox), findsOneWidget);
        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
        expect(sizedBox.width, equals(0));
        expect(sizedBox.height, equals(0));
      });
    });

    group('Widget Rendering', () {
      testWidgets('renders with proper structure when data exists', (
        tester,
      ) async {
        final mockEvent = MockEventModel();
        when(() => mockEvent.id).thenReturn('event1');
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue([mockEvent]),
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
        final mockEvent = MockEventModel();
        when(() => mockEvent.id).thenReturn('event1');
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue([mockEvent]),
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
        final mockEvent1 = MockEventModel();
        final mockEvent2 = MockEventModel();
        when(() => mockEvent1.id).thenReturn('event1');
        when(() => mockEvent2.id).thenReturn('event2');
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue([mockEvent1, mockEvent2]),
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
        final mockEvent = MockEventModel();
        when(() => mockEvent.id).thenReturn('event1');
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue([mockEvent]),
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
        final mockEvent = MockEventModel();
        when(() => mockEvent.id).thenReturn('event1');
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue([mockEvent]),
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
        expect(eventWidget.eventId, equals('event1'));
        expect(
          eventWidget.margin,
          equals(const EdgeInsets.only(top: 3, bottom: 3)),
        );
      });
    });

    group('Tasks Section', () {
      testWidgets('renders tasks section when tasks exist', (tester) async {
        final mockTask1 = MockTaskModel();
        final mockTask2 = MockTaskModel();
        when(() => mockTask1.id).thenReturn('task1');
        when(() => mockTask2.id).thenReturn('task2');
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue(<EventModel>[]),
            todaysTasksProvider.overrideWithValue([mockTask1, mockTask2]),
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
        final mockTask = MockTaskModel();
        when(() => mockTask.id).thenReturn('task1');
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue(<EventModel>[]),
            todaysTasksProvider.overrideWithValue([mockTask]),
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
        final mockTask = MockTaskModel();
        when(() => mockTask.id).thenReturn('task1');
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue(<EventModel>[]),
            todaysTasksProvider.overrideWithValue([mockTask]),
            activePollsWithPendingResponseProvider.overrideWithValue(
              <PollModel>[],
            ),
          ],
        );

        await pumpTodaysFocusWidget(tester);

        final taskWidget = tester.widget<TaskWidget>(find.byType(TaskWidget));
        expect(taskWidget.taskId, equals('task1'));
        expect(taskWidget.isEditing, equals(false));
      });
    });

    group('Polls Section', () {
      testWidgets('renders polls section when polls exist', (tester) async {
        final mockPoll1 = MockPollModel();
        final mockPoll2 = MockPollModel();
        when(() => mockPoll1.id).thenReturn('poll1');
        when(() => mockPoll2.id).thenReturn('poll2');
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue(<EventModel>[]),
            todaysTasksProvider.overrideWithValue(<TaskModel>[]),
            activePollsWithPendingResponseProvider.overrideWithValue([
              mockPoll1,
              mockPoll2,
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
        final mockPoll = MockPollModel();
        when(() => mockPoll.id).thenReturn('poll1');
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue(<EventModel>[]),
            todaysTasksProvider.overrideWithValue(<TaskModel>[]),
            activePollsWithPendingResponseProvider.overrideWithValue([
              mockPoll,
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
        final mockPoll = MockPollModel();
        when(() => mockPoll.id).thenReturn('poll1');
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue(<EventModel>[]),
            todaysTasksProvider.overrideWithValue(<TaskModel>[]),
            activePollsWithPendingResponseProvider.overrideWithValue([
              mockPoll,
            ]),
          ],
        );

        await pumpTodaysFocusWidget(tester);

        final pollWidget = tester.widget<PollWidget>(find.byType(PollWidget));
        expect(pollWidget.pollId, equals('poll1'));
      });
    });

    group('Multiple Sections', () {
      testWidgets('renders all sections when all data exists', (tester) async {
        final mockEvent = MockEventModel();
        final mockTask = MockTaskModel();
        final mockPoll = MockPollModel();
        when(() => mockEvent.id).thenReturn('event1');
        when(() => mockTask.id).thenReturn('task1');
        when(() => mockPoll.id).thenReturn('poll1');
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue([mockEvent]),
            todaysTasksProvider.overrideWithValue([mockTask]),
            activePollsWithPendingResponseProvider.overrideWithValue([
              mockPoll,
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
        final mockEvent = MockEventModel();
        final mockTask = MockTaskModel();
        when(() => mockEvent.id).thenReturn('event1');
        when(() => mockTask.id).thenReturn('task1');
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue([mockEvent]),
            todaysTasksProvider.overrideWithValue([mockTask]),
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
        final mockEvent = MockEventModel();
        final mockTask = MockTaskModel();
        final mockPoll = MockPollModel();
        when(() => mockEvent.id).thenReturn('event1');
        when(() => mockTask.id).thenReturn('task1');
        when(() => mockPoll.id).thenReturn('poll1');
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue([mockEvent]),
            todaysTasksProvider.overrideWithValue([mockTask]),
            activePollsWithPendingResponseProvider.overrideWithValue([
              mockPoll,
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
        final mockEvent = MockEventModel();
        final mockTask = MockTaskModel();
        final mockPoll = MockPollModel();
        when(() => mockEvent.id).thenReturn('event1');
        when(() => mockTask.id).thenReturn('task1');
        when(() => mockPoll.id).thenReturn('poll1');
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue([mockEvent]),
            todaysTasksProvider.overrideWithValue([mockTask]),
            activePollsWithPendingResponseProvider.overrideWithValue([
              mockPoll,
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
        final mockEvent = MockEventModel();
        when(() => mockEvent.id).thenReturn('event1');
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue([mockEvent]),
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
        final mockEvent = MockEventModel();
        when(() => mockEvent.id).thenReturn('event1');
        container = ProviderContainer.test(
          overrides: [
            todaysEventsProvider.overrideWithValue([mockEvent]),
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
