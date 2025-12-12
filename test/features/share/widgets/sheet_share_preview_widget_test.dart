import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/animated_textfield_widget.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/share/widgets/sheet_share_preview_widget.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import '../../../test-utils/test_utils.dart';
import '../../documents/utils/document_utils.dart';
import '../../events/utils/event_utils.dart';
import '../../polls/utils/poll_utils.dart';
import '../../sheet/utils/sheet_utils.dart';
import '../../task/utils/task_utils.dart';

void main() {
  late ProviderContainer container;
  late SheetModel testSheet;
  late String testSheetId;
  const String testContentText = 'Test Sheet Content';

  setUp(() {
    container = ProviderContainer.test();

    // Get test sheet from container
    testSheet = getSheetByIndex(container);
    testSheetId = testSheet.id;
  });

  Future<void> pumpSheetSharePreviewWidget(
    WidgetTester tester, {
    required String parentId,
    required String contentText,
    ProviderContainer? testContainer,
    ValueChanged<String>? onMessageChanged,
  }) async {
    await tester.pumpMaterialWidgetWithProviderScope(
      container: testContainer ?? container,
      child: SheetSharePreviewWidget(
        parentId: parentId,
        contentText: contentText,
        onMessageChanged: (message) {},
      ),
    );
  }

  group('Sheet Share Preview Widget', () {
    group('Basic Rendering', () {
      testWidgets('renders correctly with valid sheet', (tester) async {
        await pumpSheetSharePreviewWidget(
          tester,
          parentId: testSheetId,
          contentText: testContentText,
        );

        // Verify GlassyContainer is present
        expect(find.byType(GlassyContainer), findsOneWidget);

        // Verify AnimatedTextField is present
        expect(find.byType(AnimatedTextField), findsOneWidget);
      });

      testWidgets('returns SizedBox.shrink when sheet is null', (tester) async {
        // Override with empty sheet list and null sheet provider
        final emptyContainer = ProviderContainer.test(
          overrides: [
            sheetListProvider.overrideWith(() => SheetList()..state = []),
            sheetProvider('non-existent-sheet').overrideWith((ref) => null),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: emptyContainer,
          child: SheetSharePreviewWidget(
            parentId: 'non-existent-sheet',
            contentText: testContentText,
            onMessageChanged: (message) {},
          ),
        );

        // Verify widget is not displayed (SizedBox.shrink)
        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.byType(GlassyContainer), findsNothing);
        expect(find.text(testContentText), findsNothing);
      });
    });

    group('Message Input Field', () {
      testWidgets('displays AnimatedTextField with correct properties', (
        tester,
      ) async {
        await pumpSheetSharePreviewWidget(
          tester,
          parentId: testSheetId,
          contentText: testContentText,
        );

        // Verify AnimatedTextField is present
        expect(find.byType(AnimatedTextField), findsOneWidget);

        // Verify TextField properties
        final animatedTextField = tester.widget<AnimatedTextField>(
          find.byType(AnimatedTextField),
        );
        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: SheetSharePreviewWidget,
        );
        expect(animatedTextField.hintText, equals(l10n.addAMessage));
        expect(animatedTextField.maxLines, equals(3));
        expect(animatedTextField.keyboardType, equals(TextInputType.multiline));
        expect(animatedTextField.autofocus, isFalse);
      });

      testWidgets('updates controller text when user types', (tester) async {
        await pumpSheetSharePreviewWidget(
          tester,
          parentId: testSheetId,
          contentText: testContentText,
          onMessageChanged: (message) {},
        );

        const testMessage = 'User typed message';
        await tester.enterText(find.byType(AnimatedTextField), testMessage);
        await tester.pump();

        // Verify controller text is updated
        final animatedTextField = tester.widget<AnimatedTextField>(
          find.byType(AnimatedTextField),
        );
        expect(animatedTextField.controller.text, equals(testMessage));
      });

      testWidgets('clears text field when user clears input', (tester) async {
        await pumpSheetSharePreviewWidget(
          tester,
          parentId: testSheetId,
          contentText: testContentText,
        );

        // Enter text
        const testMessage = 'Test message';
        await tester.enterText(find.byType(AnimatedTextField), testMessage);
        await tester.pump();

        // Clear text
        await tester.enterText(find.byType(AnimatedTextField), '');
        await tester.pump();

        // Verify controller text is empty
        final animatedTextField = tester.widget<AnimatedTextField>(
          find.byType(AnimatedTextField),
        );
        expect(animatedTextField.controller.text, isEmpty);
      });
    });

    group('Stat Cards', () {
      testWidgets('displays events stat card with correct count', (
        tester,
      ) async {
        final event1 = getEventByIndex(container);

        final event2 = getEventByIndex(container, index: 1);

        final testContainer = ProviderContainer.test(
          overrides: [
            sheetListProvider.overrideWith(
              () => SheetList()..state = [testSheet],
            ),
            sheetProvider(testSheetId).overrideWith((ref) => testSheet),
            eventListProvider.overrideWithValue([event1, event2]),
            taskListProvider.overrideWithValue(<TaskModel>[]),
            documentListProvider.overrideWithValue(<DocumentModel>[]),
            pollListProvider.overrideWithValue(<PollModel>[]),
          ],
        );

        await pumpSheetSharePreviewWidget(
          tester,
          parentId: testSheetId,
          contentText: testContentText,
          testContainer: testContainer,
        );

        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: SheetSharePreviewWidget,
        );

        expect(find.text(l10n.events), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
      });

      testWidgets('displays tasks stat card with correct count', (
        tester,
      ) async {
        final task1 = getTaskByIndex(container);

        final task2 = getTaskByIndex(container, index: 1);

        final testContainer = ProviderContainer.test(
          overrides: [
            sheetListProvider.overrideWith(
              () => SheetList()..state = [testSheet],
            ),
            sheetProvider(testSheetId).overrideWith((ref) => testSheet),
            eventListProvider.overrideWithValue(<EventModel>[]),
            taskListProvider.overrideWithValue([task1, task2]),
            documentListProvider.overrideWithValue(<DocumentModel>[]),
            pollListProvider.overrideWithValue(<PollModel>[]),
          ],
        );

        await pumpSheetSharePreviewWidget(
          tester,
          parentId: testSheetId,
          contentText: testContentText,
          testContainer: testContainer,
        );

        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: SheetSharePreviewWidget,
        );

        expect(find.text(l10n.tasks), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
      });

      testWidgets('displays documents stat card with correct count', (
        tester,
      ) async {
        final doc1 = getDocumentByIndex(container);

        final doc2 = getDocumentByIndex(container, index: 1);

        final doc3 = getDocumentByIndex(container, index: 2);

        final testContainer = ProviderContainer.test(
          overrides: [
            sheetListProvider.overrideWith(
              () => SheetList()..state = [testSheet],
            ),
            sheetProvider(testSheetId).overrideWith((ref) => testSheet),
            eventListProvider.overrideWithValue(<EventModel>[]),
            taskListProvider.overrideWithValue(<TaskModel>[]),
            documentListProvider.overrideWithValue([doc1, doc2, doc3]),
            pollListProvider.overrideWithValue(<PollModel>[]),
          ],
        );

        await pumpSheetSharePreviewWidget(
          tester,
          parentId: testSheetId,
          contentText: testContentText,
          testContainer: testContainer,
        );

        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: SheetSharePreviewWidget,
        );

        expect(find.text(l10n.documents), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
      });

      testWidgets('displays polls stat card with correct count', (
        tester,
      ) async {
        final poll1 = getPollByIndex(container);

        final poll2 = getPollByIndex(container, index: 1);

        final testContainer = ProviderContainer.test(
          overrides: [
            sheetListProvider.overrideWith(
              () => SheetList()..state = [testSheet],
            ),
            sheetProvider(testSheetId).overrideWith((ref) => testSheet),
            eventListProvider.overrideWithValue(<EventModel>[]),
            taskListProvider.overrideWithValue(<TaskModel>[]),
            documentListProvider.overrideWithValue(<DocumentModel>[]),
            pollListProvider.overrideWithValue([poll1, poll2]),
          ],
        );

        await pumpSheetSharePreviewWidget(
          tester,
          parentId: testSheetId,
          contentText: testContentText,
          testContainer: testContainer,
        );

        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: SheetSharePreviewWidget,
        );

        expect(find.text(l10n.polls), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
      });

      testWidgets('displays all stat cards when all types have items', (
        tester,
      ) async {
        final event = getEventByIndex(container);

        final task = getTaskByIndex(container);

        final document = getDocumentByIndex(container);

        final poll = getPollByIndex(container);

        final testContainer = ProviderContainer.test(
          overrides: [
            sheetListProvider.overrideWith(
              () => SheetList()..state = [testSheet],
            ),
            sheetProvider(testSheetId).overrideWith((ref) => testSheet),
            eventListProvider.overrideWithValue([event]),
            taskListProvider.overrideWithValue([task]),
            documentListProvider.overrideWithValue([document]),
            pollListProvider.overrideWithValue([poll]),
          ],
        );

        await pumpSheetSharePreviewWidget(
          tester,
          parentId: testSheetId,
          contentText: testContentText,
          testContainer: testContainer,
        );

        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: SheetSharePreviewWidget,
        );

        // Verify all stat cards are displayed
        expect(find.text(l10n.events), findsOneWidget);
        expect(find.text(l10n.tasks), findsOneWidget);
        expect(find.text(l10n.documents), findsOneWidget);
        expect(find.text(l10n.polls), findsOneWidget);

        // Verify all counts are displayed
        expect(find.text('1'), findsNWidgets(4)); // One for each type
      });
    });

    group('Stat Card Icons and Colors', () {
      testWidgets('displays all stat cards with correct icons and colors', (
        tester,
      ) async {
        final event = getEventByIndex(container);
        final task = getTaskByIndex(container);
        final document = getDocumentByIndex(container);
        final poll = getPollByIndex(container);

        final testContainer = ProviderContainer.test(
          overrides: [
            sheetListProvider.overrideWith(
              () => SheetList()..state = [testSheet],
            ),
            sheetProvider(testSheetId).overrideWith((ref) => testSheet),
            eventListProvider.overrideWithValue([event]),
            taskListProvider.overrideWithValue([task]),
            documentListProvider.overrideWithValue([document]),
            pollListProvider.overrideWithValue([poll]),
          ],
        );

        await pumpSheetSharePreviewWidget(
          tester,
          parentId: testSheetId,
          contentText: testContentText,
          testContainer: testContainer,
        );

        // Find all StyledIconContainer widgets
        final iconContainers = tester
            .widgetList<StyledIconContainer>(find.byType(StyledIconContainer))
            .toList();

        // Verify we have 4 icon containers (one for each type)
        expect(iconContainers.length, equals(4));

        // Verify icons and colors in order: events, tasks, documents, polls
        expect(iconContainers[0].icon, equals(Icons.event_rounded));
        expect(
          iconContainers[0].primaryColor,
          equals(AppColors.secondaryColor),
        );

        expect(iconContainers[1].icon, equals(Icons.task_alt_rounded));
        expect(iconContainers[1].primaryColor, equals(AppColors.successColor));

        expect(iconContainers[2].icon, equals(Icons.insert_drive_file_rounded));
        expect(
          iconContainers[2].primaryColor,
          equals(AppColors.brightOrangeColor),
        );

        expect(iconContainers[3].icon, equals(Icons.poll_rounded));
        expect(
          iconContainers[3].primaryColor,
          equals(AppColors.brightMagentaColor),
        );
      });
    });

    group('Today\'s Events and Tasks Subtitles', () {
      testWidgets('shows today events subtitle when there are today events', (
        tester,
      ) async {
        // Create event with today's date
        final baseEvent = getEventByIndex(container);
        final todayEvent = baseEvent.copyWith(
          sheetId: testSheetId,
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(hours: 1)),
        );

        // Create event with future date
        final futureEvent = baseEvent.copyWith(
          id: 'event-2',
          sheetId: testSheetId,
          startDate: DateTime.now().add(const Duration(days: 1)),
          endDate: DateTime.now().add(const Duration(days: 1, hours: 1)),
        );

        final testContainer = ProviderContainer.test(
          overrides: [
            sheetListProvider.overrideWith(
              () => SheetList()..state = [testSheet],
            ),
            sheetProvider(testSheetId).overrideWith((ref) => testSheet),
            eventListProvider.overrideWithValue([todayEvent, futureEvent]),
            taskListProvider.overrideWithValue(<TaskModel>[]),
            documentListProvider.overrideWithValue(<DocumentModel>[]),
            pollListProvider.overrideWithValue(<PollModel>[]),
          ],
        );

        await pumpSheetSharePreviewWidget(
          tester,
          parentId: testSheetId,
          contentText: testContentText,
          testContainer: testContainer,
        );

        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: SheetSharePreviewWidget,
        );

        // Verify today's events subtitle is shown
        expect(find.textContaining(l10n.today), findsOneWidget);
        expect(find.textContaining('1'), findsWidgets); // Should show "1 Today"
      });

      testWidgets(
        'does not show today events subtitle when there are no today events',
        (tester) async {
          // Create event with future date (not today)
          final baseEvent = getEventByIndex(container);
          final futureEvent = baseEvent.copyWith(
            sheetId: testSheetId,
            startDate: DateTime.now().add(const Duration(days: 1)),
            endDate: DateTime.now().add(const Duration(days: 1, hours: 1)),
          );

          final testContainer = ProviderContainer.test(
            overrides: [
              sheetListProvider.overrideWith(
                () => SheetList()..state = [testSheet],
              ),
              sheetProvider(testSheetId).overrideWith((ref) => testSheet),
              eventListProvider.overrideWithValue([futureEvent]),
              taskListProvider.overrideWithValue(<TaskModel>[]),
              documentListProvider.overrideWithValue(<DocumentModel>[]),
              pollListProvider.overrideWithValue(<PollModel>[]),
            ],
          );

          await pumpSheetSharePreviewWidget(
            tester,
            parentId: testSheetId,
            contentText: testContentText,
            testContainer: testContainer,
          );

          final l10n = WidgetTesterExtension.getL10n(
            tester,
            byType: SheetSharePreviewWidget,
          );

          // Verify today's events subtitle is NOT shown
          expect(find.textContaining(l10n.today), findsNothing);
        },
      );

      testWidgets('shows today tasks subtitle when there are today tasks', (
        tester,
      ) async {
        // Create task with today's date
        final baseTask = getTaskByIndex(container);
        final todayTask = baseTask.copyWith(
          sheetId: testSheetId,
          dueDate: DateTime.now(),
        );

        // Create task with future date
        final futureTask = baseTask.copyWith(
          id: 'task-2',
          sheetId: testSheetId,
          dueDate: DateTime.now().add(const Duration(days: 1)),
        );

        final testContainer = ProviderContainer.test(
          overrides: [
            sheetListProvider.overrideWith(
              () => SheetList()..state = [testSheet],
            ),
            sheetProvider(testSheetId).overrideWith((ref) => testSheet),
            eventListProvider.overrideWithValue(<EventModel>[]),
            taskListProvider.overrideWithValue([todayTask, futureTask]),
            documentListProvider.overrideWithValue(<DocumentModel>[]),
            pollListProvider.overrideWithValue(<PollModel>[]),
          ],
        );

        await pumpSheetSharePreviewWidget(
          tester,
          parentId: testSheetId,
          contentText: testContentText,
          testContainer: testContainer,
        );

        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: SheetSharePreviewWidget,
        );

        // Verify today's tasks subtitle is shown
        expect(find.textContaining(l10n.dueToday), findsOneWidget);
        expect(
          find.textContaining('1'),
          findsWidgets,
        ); // Should show "1 Due Today"
      });

      testWidgets(
        'does not show today tasks subtitle when there are no today tasks',
        (tester) async {
          // Create task with future date (not today)
          final baseTask = getTaskByIndex(container);
          final futureTask = baseTask.copyWith(
            sheetId: testSheetId,
            dueDate: DateTime.now().add(const Duration(days: 1)),
          );

          final testContainer = ProviderContainer.test(
            overrides: [
              sheetListProvider.overrideWith(
                () => SheetList()..state = [testSheet],
              ),
              sheetProvider(testSheetId).overrideWith((ref) => testSheet),
              eventListProvider.overrideWithValue(<EventModel>[]),
              taskListProvider.overrideWithValue([futureTask]),
              documentListProvider.overrideWithValue(<DocumentModel>[]),
              pollListProvider.overrideWithValue(<PollModel>[]),
            ],
          );

          await pumpSheetSharePreviewWidget(
            tester,
            parentId: testSheetId,
            contentText: testContentText,
            testContainer: testContainer,
          );

          final l10n = WidgetTesterExtension.getL10n(
            tester,
            byType: SheetSharePreviewWidget,
          );

          // Verify today's tasks subtitle is NOT shown
          expect(find.textContaining(l10n.dueToday), findsNothing);
        },
      );
    });

    group('Edge Cases', () {
      testWidgets('handles empty content text', (tester) async {
        await pumpSheetSharePreviewWidget(
          tester,
          parentId: testSheetId,
          contentText: '',
        );

        // Widget should still render but with empty text
        expect(find.byType(GlassyContainer), findsOneWidget);
      });

      testWidgets('handles mixed empty and non-empty lists', (tester) async {
        final event = getEventByIndex(container);

        final testContainer = ProviderContainer.test(
          overrides: [
            sheetListProvider.overrideWith(
              () => SheetList()..state = [testSheet],
            ),
            sheetProvider(testSheetId).overrideWith((ref) => testSheet),
            eventListProvider.overrideWithValue([event]),
            taskListProvider.overrideWithValue(<TaskModel>[]),
            documentListProvider.overrideWithValue(<DocumentModel>[]),
            pollListProvider.overrideWithValue(<PollModel>[]),
          ],
        );

        await pumpSheetSharePreviewWidget(
          tester,
          parentId: testSheetId,
          contentText: testContentText,
          testContainer: testContainer,
        );

        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: SheetSharePreviewWidget,
        );

        // All stat cards are shown when at least one type has items
        // Events stat card should be shown with count > 0
        expect(find.text(l10n.events), findsOneWidget);
        expect(find.text('1'), findsWidgets); // Event count

        // Tasks, documents, and polls stat cards are also shown (with count 0)
        expect(find.text(l10n.tasks), findsOneWidget);
        expect(find.text(l10n.documents), findsOneWidget);
        expect(find.text(l10n.polls), findsOneWidget);
      });
    });
  });
}
