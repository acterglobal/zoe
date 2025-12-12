import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/features/home/widgets/stats_section/stats_section_widget.dart';
import 'package:zoe/features/home/widgets/stats_section/stats_widget.dart';
import 'package:zoe/features/link/data/link_list.dart';
import 'package:zoe/features/link/models/link_model.dart';
import 'package:zoe/features/link/providers/link_providers.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../../test-utils/mock_gorouter.dart';
import '../../../../test-utils/test_utils.dart';
import '../../../documents/utils/document_utils.dart';
import '../../../events/utils/event_utils.dart';
import '../../../polls/utils/poll_utils.dart';
import '../../../sheet/utils/sheet_utils.dart';
import '../../../task/utils/task_utils.dart';

void main() {
  group('StatsSectionWidget', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
    });

    Future<void> pumpStatsSectionWidget(WidgetTester tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: const StatsSectionWidget(),
      );
    }

    Future<void> pumpStatsSectionWidgetWithRouter(
      WidgetTester tester,
      MockGoRouter mockGoRouter,
    ) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        router: mockGoRouter,
        child: const StatsSectionWidget(),
      );
    }

    L10n getL10n(WidgetTester tester) =>
        L10n.of(tester.element(find.byType(StatsSectionWidget)));

    group('Widget Rendering', () {
      testWidgets('renders with proper structure', (tester) async {
        await pumpStatsSectionWidget(tester);

        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Row), findsAtLeastNWidgets(3));
        expect(find.byType(StatsWidget), findsAtLeastNWidgets(6));
        expect(find.byType(SizedBox), findsAtLeastNWidgets(2));
      });
    });

    group('Layout Structure', () {
      testWidgets('has correct layout for first row', (tester) async {
        await pumpStatsSectionWidget(tester);
        final firstRow = tester.widgetList<Row>(find.byType(Row)).first;
        expect(firstRow.children.length, equals(3));
      });

      testWidgets('has correct layout for second row', (tester) async {
        await pumpStatsSectionWidget(tester);
        final secondRow = tester.widgetList<Row>(find.byType(Row)).toList()[1];
        expect(secondRow.children.length, equals(3));
      });

      testWidgets('has correct layout for third row', (tester) async {
        await pumpStatsSectionWidget(tester);
        final thirdRow = tester.widgetList<Row>(find.byType(Row)).toList()[2];
        expect(thirdRow.children.length, equals(3));
      });

      testWidgets('uses correct spacing between rows', (tester) async {
        await pumpStatsSectionWidget(tester);
        final heightSpacing = tester
            .widgetList<SizedBox>(find.byType(SizedBox))
            .firstWhere((s) => s.height == 12);
        expect(heightSpacing.height, equals(12));
      });

      testWidgets('uses correct spacing between stats widgets', (tester) async {
        await pumpStatsSectionWidget(tester);
        final widthSpacing = tester
            .widgetList<SizedBox>(find.byType(SizedBox))
            .firstWhere((s) => s.width == 12);
        expect(widthSpacing.width, equals(12));
      });
    });

    group('Stats Widgets Content', () {
      testWidgets('renders sheets stats widget correctly', (tester) async {
        await pumpStatsSectionWidget(tester);
        final widgetFinder = find.byIcon(Icons.article_rounded);
        expect(widgetFinder, findsOneWidget);

        final widget = tester.widget<StatsWidget>(
          find.ancestor(of: widgetFinder, matching: find.byType(StatsWidget)),
        );
        expect(widget.icon, Icons.article_rounded);
        expect(widget.color, AppColors.primaryColor);
      });

      testWidgets('renders events stats widget correctly', (tester) async {
        await pumpStatsSectionWidget(tester);
        final widgetFinder = find.byIcon(Icons.event_rounded);
        final widget = tester.widget<StatsWidget>(
          find.ancestor(of: widgetFinder, matching: find.byType(StatsWidget)),
        );
        expect(widget.icon, Icons.event_rounded);
        expect(widget.color, AppColors.secondaryColor);
      });

      testWidgets('renders tasks stats widget correctly', (tester) async {
        await pumpStatsSectionWidget(tester);
        final widgetFinder = find.byIcon(Icons.task_alt_rounded);
        final widget = tester.widget<StatsWidget>(
          find.ancestor(of: widgetFinder, matching: find.byType(StatsWidget)),
        );
        expect(widget.icon, Icons.task_alt_rounded);
        expect(widget.color, AppColors.successColor);
      });

      testWidgets('renders links stats widget correctly', (tester) async {
        await pumpStatsSectionWidget(tester);
        final widgetFinder = find.byIcon(Icons.link_rounded);
        final widget = tester.widget<StatsWidget>(
          find.ancestor(of: widgetFinder, matching: find.byType(StatsWidget)),
        );
        expect(widget.icon, Icons.link_rounded);
        expect(widget.color, Colors.blueAccent);
      });

      testWidgets('renders documents stats widget correctly', (tester) async {
        await pumpStatsSectionWidget(tester);
        final widgetFinder = find.byIcon(Icons.insert_drive_file_rounded);
        final widget = tester.widget<StatsWidget>(
          find.ancestor(of: widgetFinder, matching: find.byType(StatsWidget)),
        );
        expect(widget.icon, Icons.insert_drive_file_rounded);
        expect(widget.color, AppColors.brightOrangeColor);
      });

      testWidgets('renders polls stats widget correctly', (tester) async {
        await pumpStatsSectionWidget(tester);
        final widgetFinder = find.byIcon(Icons.poll_rounded);
        final widget = tester.widget<StatsWidget>(
          find.ancestor(of: widgetFinder, matching: find.byType(StatsWidget)),
        );
        expect(widget.icon, Icons.poll_rounded);
        expect(widget.color, AppColors.brightMagentaColor);
      });
    });

    group('Localization', () {
      testWidgets('displays localized titles correctly', (tester) async {
        await pumpStatsSectionWidget(tester);
        final l10n = getL10n(tester);

        expect(find.text(l10n.sheets), findsOneWidget);
        expect(find.text(l10n.events), findsOneWidget);
        expect(find.text(l10n.tasks), findsOneWidget);
        expect(find.text(l10n.links), findsOneWidget);
        expect(find.text(l10n.documents), findsOneWidget);
        expect(find.text(l10n.polls), findsOneWidget);
      });
    });

    group('Provider Integration', () {
      testWidgets('displays correct counts from providers', (tester) async {
        container = ProviderContainer.test(
          overrides: [
            sheetListProvider.overrideWithValue(<SheetModel>[]),
            eventListProvider.overrideWithValue(<EventModel>[]),
            taskListProvider.overrideWithValue(<TaskModel>[]),
            linkListProvider.overrideWithValue(<LinkModel>[]),
            documentListProvider.overrideWithValue(<DocumentModel>[]),
            pollListProvider.overrideWithValue(<PollModel>[]),
          ],
        );

        await pumpStatsSectionWidget(tester);

        for (final widget in tester.widgetList<StatsWidget>(
          find.byType(StatsWidget),
        )) {
          expect(widget.count, equals('0'));
        }
      });

      testWidgets('updates counts when provider data changes', (tester) async {
        // Create a temporary container to get all data
        final tempContainer = ProviderContainer.test();
        final sheet1 = getSheetByIndex(tempContainer);
        final sheet2 = getSheetByIndex(tempContainer, index: 1);
        final event1 = getEventByIndex(tempContainer);
        final task1 = getTaskByIndex(tempContainer);
        final task2 = getTaskByIndex(tempContainer, index: 1);
        final task3 = getTaskByIndex(tempContainer, index: 2);
        final doc1 = getDocumentByIndex(tempContainer);
        final doc2 = getDocumentByIndex(tempContainer, index: 1);
        final poll1 = getPollByIndex(tempContainer);
        final poll2 = getPollByIndex(tempContainer, index: 1);
        final poll3 = getPollByIndex(tempContainer, index: 2);
        final poll4 = getPollByIndex(tempContainer, index: 3);

        container = ProviderContainer.test(
          overrides: [
            sheetListProvider.overrideWithValue([sheet1, sheet2]),
            eventListProvider.overrideWithValue([event1]),
            taskListProvider.overrideWithValue([task1, task2, task3]),
            linkListProvider.overrideWithValue([linkList.first]),
            documentListProvider.overrideWithValue([doc1, doc2]),
            pollListProvider.overrideWithValue([poll1, poll2, poll3, poll4]),
          ],
        );

        await pumpStatsSectionWidget(tester);

        final statsWidgets = tester.widgetList<StatsWidget>(
          find.byType(StatsWidget),
        );

        // Get counts in the order they appear in the widget tree
        final counts = statsWidgets.map((w) => w.count).toList();

        expect(counts.length, equals(6));
        expect(counts[0], equals('2'));
        expect(counts[1], equals('1'));
        expect(counts[2], equals('3'));
        expect(counts[3], equals('1'));
        expect(counts[4], equals('2'));
        expect(counts[5], equals('4'));
      });
    });

    group('Navigation', () {
      final routes = {
        Icons.article_rounded: AppRoutes.sheetsList.route,
        Icons.event_rounded: AppRoutes.eventsList.route,
        Icons.task_alt_rounded: AppRoutes.tasksList.route,
        Icons.link_rounded: AppRoutes.linksList.route,
        Icons.insert_drive_file_rounded: AppRoutes.documentsList.route,
        Icons.poll_rounded: AppRoutes.pollsList.route,
      };

      for (final entry in routes.entries) {
        testWidgets('navigates to ${entry.value} when tapped', (tester) async {
          final mockGoRouter = MockGoRouter();
          when(() => mockGoRouter.push(any())).thenAnswer((_) async => true);

          await pumpStatsSectionWidgetWithRouter(tester, mockGoRouter);
          await tester.tap(
            find.ancestor(
              of: find.byIcon(entry.key),
              matching: find.byType(StatsWidget),
            ),
          );
          await tester.pumpAndSettle();

          verify(() => mockGoRouter.push(entry.value)).called(1);
        });
      }
    });

    group('Color Scheme', () {
      testWidgets('uses correct color scheme for all stats', (tester) async {
        await pumpStatsSectionWidget(tester);

        final colors = tester
            .widgetList<StatsWidget>(find.byType(StatsWidget))
            .map((w) => w.color)
            .toList();

        expect(
          colors,
          containsAll([
            AppColors.primaryColor,
            AppColors.secondaryColor,
            AppColors.successColor,
            Colors.blueAccent,
            AppColors.brightOrangeColor,
            AppColors.brightMagentaColor,
          ]),
        );
      });

      testWidgets('has unique colors for each stats widget', (tester) async {
        await pumpStatsSectionWidget(tester);
        final colors = tester
            .widgetList<StatsWidget>(find.byType(StatsWidget))
            .map((w) => w.color)
            .toList();
        expect(colors.toSet().length, equals(colors.length));
      });
    });

    group('Edge Cases', () {
      testWidgets('handles empty provider data gracefully', (tester) async {
        container = ProviderContainer.test(
          overrides: [
            sheetListProvider.overrideWithValue(<SheetModel>[]),
            eventListProvider.overrideWithValue(<EventModel>[]),
            taskListProvider.overrideWithValue(<TaskModel>[]),
            linkListProvider.overrideWithValue(<LinkModel>[]),
            documentListProvider.overrideWithValue(<DocumentModel>[]),
            pollListProvider.overrideWithValue(<PollModel>[]),
          ],
        );

        await pumpStatsSectionWidget(tester);

        expect(find.byType(StatsSectionWidget), findsOneWidget);
        expect(find.byType(StatsWidget), findsNWidgets(6));
      });
    });
  });
}
