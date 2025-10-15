import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/text/models/text_model.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/list/models/list_model.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/share/utils/share_utils.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/text/providers/text_providers.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/features/list/providers/list_providers.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/common/utils/date_time_utils.dart';
import '../../../test-utils/test_utils.dart';
import '../../bullets/utils/bullets_utils.dart';
import '../../sheet/utils/sheet_utils.dart';
import '../../text/utils/text_utils.dart';
import '../../events/utils/event_utils.dart';
import '../../list/utils/list_utils.dart';
import '../../task/utils/task_utils.dart';

void main() {
  late ProviderContainer container;

  setUp(() async {
    // Create the container
    container = ProviderContainer.test();
  });

  group('Share Utils', () {
    group('Link Generation', () {
      test('getLinkPrefixUrl returns correct format', () {
        const endpoint = 'test-endpoint';
        final result = ShareUtils.getLinkPrefixUrl(endpoint);
        expect(result, equals('🔗 ${ShareUtils.linkPrefixUrl}/$endpoint'));
      });

      test('getLinkPrefixUrl handles different endpoints', () {
        const endpoints = [
          'sheet/test-id',
          'text-block/test-id',
          'task/test-id',
          'event/test-id',
          'list/test-id',
          'bullet/test-id',
          'poll/test-id',
        ];

        for (final endpoint in endpoints) {
          final result = ShareUtils.getLinkPrefixUrl(endpoint);
          expect(result, equals('🔗 ${ShareUtils.linkPrefixUrl}/$endpoint'));
        }
      });

      test('getLinkPrefixUrl handles empty endpoint', () {
        const endpoint = '';
        final result = ShareUtils.getLinkPrefixUrl(endpoint);
        expect(result, equals('🔗 ${ShareUtils.linkPrefixUrl}/'));
      });

      test('getLinkPrefixUrl handles special characters in endpoint', () {
        const endpoint = 'test-endpoint/with-special-chars';
        final result = ShareUtils.getLinkPrefixUrl(endpoint);
        expect(result, equals('🔗 ${ShareUtils.linkPrefixUrl}/$endpoint'));
      });
    });

    group('Sheet Share Message', () {
      late SheetModel testSheetModel;

      setUp(() {
        testSheetModel = getSheetByIndex(container);
      });

      Future<void> pumpSheetShareUtilsWidget(
        WidgetTester tester, {
        String? parentId,
      }) async {
        await tester.pumpConsumerWidget(
          container: container,
          builder: (_, ref, _) => Text(
            ShareUtils.getSheetShareMessage(
              ref: ref,
              parentId: parentId ?? testSheetModel.id,
            ),
          ),
        );
      }

      String getSheetShareLink({String? parentId}) {
        return '🔗 ${ShareUtils.linkPrefixUrl}/sheet/${parentId ?? testSheetModel.id}';
      }

      testWidgets('generates correct share message for sheet with all fields', (
        tester,
      ) async {
        await pumpSheetShareUtilsWidget(tester);

        // Verify the message contains all expected elements
        expect(find.textContaining(testSheetModel.emoji), findsOneWidget);
        expect(find.textContaining(testSheetModel.title), findsOneWidget);
        if (testSheetModel.description?.plainText != null) {
          expect(
            find.textContaining(testSheetModel.description!.plainText!),
            findsOneWidget,
          );
        }
        expect(find.textContaining(getSheetShareLink()), findsOneWidget);
      });

      testWidgets('returns empty string for non-existent sheet', (
        tester,
      ) async {
        await pumpSheetShareUtilsWidget(tester, parentId: 'non-existent-id');

        // Verify empty message
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, isEmpty);
      });

      testWidgets('includes emoji and title in correct format', (tester) async {
        await pumpSheetShareUtilsWidget(tester);

        // Verify the message starts with emoji and title
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(
          textWidget.data,
          startsWith('${testSheetModel.emoji} ${testSheetModel.title}'),
        );
      });

      testWidgets('includes description when present', (tester) async {
        if (testSheetModel.description?.plainText != null) {
          await pumpSheetShareUtilsWidget(tester);

          // Verify the message contains description with proper spacing
          final textWidget = tester.widget<Text>(find.byType(Text));
          expect(
            textWidget.data,
            contains('\n\n${testSheetModel.description!.plainText}'),
          );
        }
      });

      testWidgets('includes link at the end', (tester) async {
        await pumpSheetShareUtilsWidget(tester);

        // Verify the message ends with the link
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, endsWith(getSheetShareLink()));
      });

      testWidgets('maintains correct message structure', (tester) async {
        await pumpSheetShareUtilsWidget(tester);

        // Verify the message structure
        final textWidget = tester.widget<Text>(find.byType(Text));
        final lines = textWidget.data!.split('\n');
        expect(
          lines.length,
          greaterThanOrEqualTo(2),
        ); // At least emoji+title and link

        // First line should be emoji + title
        expect(
          lines.first,
          equals('${testSheetModel.emoji} ${testSheetModel.title}'),
        );

        // Last line should be the link
        expect(lines.last, equals(getSheetShareLink()));
      });

      testWidgets('handles special characters in sheet data', (tester) async {
        final specialSheetId = 'special-sheet-id';
        final specialSheetTitle = 'Special Sheet';
        final specialSheetEmoji = '🧪';
        final specialSheetDescription = (
          plainText: 'Line 1\nLine 2\tTabbed',
          htmlText: null,
        );

        // Create a new sheet with special characters
        final specialSheet = testSheetModel.copyWith(
          id: specialSheetId,
          title: specialSheetTitle,
          emoji: specialSheetEmoji,
          description: specialSheetDescription,
        );

        // Add the special sheet to the container
        container.read(sheetListProvider.notifier).state = [specialSheet];

        // Pump the widget
        await pumpSheetShareUtilsWidget(tester, parentId: specialSheet.id);

        // Verify special characters are handled correctly
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains(specialSheetEmoji));
        expect(textWidget.data, contains(specialSheetTitle));
        expect(textWidget.data, contains(specialSheetDescription.plainText));
        expect(
          textWidget.data,
          contains(getSheetShareLink(parentId: specialSheet.id)),
        );
      });
    });

    group('Text Content Share Message', () {
      late TextModel testTextModel;

      setUp(() {
        testTextModel = getTextByIndex(container);
      });

      Future<void> pumpTextShareUtilsWidget(
        WidgetTester tester, {
        String? parentId,
      }) async {
        await tester.pumpConsumerWidget(
          container: container,
          builder: (_, ref, _) => Text(
            ShareUtils.getTextContentShareMessage(
              ref: ref,
              parentId: parentId ?? testTextModel.id,
            ),
          ),
        );
      }

      String getTextContentLink({String? parentId}) {
        return '🔗 ${ShareUtils.linkPrefixUrl}/text-block/${parentId ?? testTextModel.id}';
      }

      testWidgets('generates correct share message for text with all fields', (
        tester,
      ) async {
        await pumpTextShareUtilsWidget(tester);

        // Verify the message contains all expected elements
        if (testTextModel.emoji != null) {
          expect(find.textContaining(testTextModel.emoji!), findsOneWidget);
        }
        expect(find.textContaining(testTextModel.title), findsOneWidget);
        if (testTextModel.description?.plainText != null) {
          expect(
            find.textContaining(testTextModel.description!.plainText!),
            findsOneWidget,
          );
        }
        expect(find.textContaining(getTextContentLink()), findsOneWidget);
      });

      testWidgets('returns empty string for non-existent text', (tester) async {
        await pumpTextShareUtilsWidget(tester, parentId: 'non-existent-id');

        // Verify empty message
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, isEmpty);
      });

      testWidgets('includes emoji and title in correct format', (tester) async {
        await pumpTextShareUtilsWidget(tester);

        // Verify the message starts with emoji and title (if emoji exists)
        final textWidget = tester.widget<Text>(find.byType(Text));
        String expectedTitle = testTextModel.title;
        if (testTextModel.emoji != null) {
          expectedTitle = '${testTextModel.emoji} ${testTextModel.title}';
        }
        expect(textWidget.data, startsWith(expectedTitle));
      });

      testWidgets('includes description when present', (tester) async {
        if (testTextModel.description?.plainText != null) {
          await pumpTextShareUtilsWidget(tester);

          // Verify the message contains description with proper spacing
          final textWidget = tester.widget<Text>(find.byType(Text));
          expect(
            textWidget.data,
            contains('\n\n${testTextModel.description!.plainText}'),
          );
        }
      });

      testWidgets('includes link at the end', (tester) async {
        await pumpTextShareUtilsWidget(tester);

        // Verify the message ends with the link
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, endsWith(getTextContentLink()));
      });

      testWidgets('maintains correct message structure', (tester) async {
        await pumpTextShareUtilsWidget(tester);

        // Verify the message structure
        final textWidget = tester.widget<Text>(find.byType(Text));
        final lines = textWidget.data!.split('\n');
        expect(
          lines.length,
          greaterThanOrEqualTo(2),
        ); // At least title and link

        // First line should be emoji + title (if emoji exists) or just title
        String firstLine = testTextModel.title;
        if (testTextModel.emoji != null) {
          firstLine = '${testTextModel.emoji} ${testTextModel.title}';
        }
        expect(lines.first, equals(firstLine));

        // Last line should be the link
        expect(lines.last, equals(getTextContentLink()));
      });

      testWidgets('handles special characters in text data', (tester) async {
        final specialTextId = 'special-text-id';
        final specialTextTitle = 'Special Text';
        final specialTextEmoji = '🧪';
        final specialTextDescription = (
          plainText: 'Line 1\nLine 2\tTabbed',
          htmlText: null,
        );

        // Create a new text with special characters
        final specialText = testTextModel.copyWith(
          id: specialTextId,
          title: specialTextTitle,
          emoji: specialTextEmoji,
          description: specialTextDescription,
        );

        // Add the special text to the container
        container.read(textListProvider.notifier).state = [specialText];

        // Pump the widget
        await pumpTextShareUtilsWidget(tester, parentId: specialText.id);

        // Verify special characters are handled correctly
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains(specialTextTitle));
        expect(textWidget.data, contains(specialTextDescription.plainText));
        expect(
          textWidget.data,
          contains(getTextContentLink(parentId: specialText.id)),
        );
      });

      testWidgets('handles text without emoji', (tester) async {
        final textWithoutEmojiId = 'no-emoji-text-id';
        final textWithoutEmojiTitle = 'Text Without Emoji';

        // Create a text without emoji
        final textWithoutEmoji = testTextModel.copyWith(
          id: textWithoutEmojiId,
          emoji: null,
          title: textWithoutEmojiTitle,
        );

        // Add the text to the container
        container.read(textListProvider.notifier).state = [textWithoutEmoji];

        // Pump the widget
        await pumpTextShareUtilsWidget(tester, parentId: textWithoutEmoji.id);

        // Verify the message starts with title only (no emoji)
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, startsWith(textWithoutEmojiTitle));
        expect(
          textWidget.data,
          contains(textWithoutEmoji.description?.plainText),
        );
        expect(
          textWidget.data,
          contains(getTextContentLink(parentId: textWithoutEmoji.id)),
        );
      });
    });

    group('Event Content Share Message', () {
      late EventModel testEventModel;

      setUp(() {
        testEventModel = getEventByIndex(container);
      });

      Future<void> pumpEventShareUtilsWidget(
        WidgetTester tester, {
        String? parentId,
      }) async {
        await tester.pumpConsumerWidget(
          container: container,
          builder: (_, ref, _) => Text(
            ShareUtils.getEventContentShareMessage(
              ref: ref,
              parentId: parentId ?? testEventModel.id,
            ),
          ),
        );
      }

      String getEventContentLink({String? parentId}) {
        return '🔗 ${ShareUtils.linkPrefixUrl}/event/${parentId ?? testEventModel.id}';
      }

      testWidgets('generates correct share message for event with all fields', (
        tester,
      ) async {
        await pumpEventShareUtilsWidget(tester);

        // Verify the message contains all expected elements
        if (testEventModel.emoji != null) {
          expect(find.textContaining(testEventModel.emoji!), findsOneWidget);
        }
        expect(find.textContaining(testEventModel.title), findsOneWidget);
        if (testEventModel.description?.plainText != null) {
          expect(
            find.textContaining(testEventModel.description!.plainText!),
            findsOneWidget,
          );
        }
        expect(find.textContaining('🕓 Start'), findsOneWidget);
        expect(find.textContaining('🕓 End'), findsOneWidget);
        expect(find.textContaining(getEventContentLink()), findsOneWidget);
      });

      testWidgets('returns empty string for non-existent event', (
        tester,
      ) async {
        await pumpEventShareUtilsWidget(tester, parentId: 'non-existent-id');

        // Verify empty message
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, isEmpty);
      });

      testWidgets('includes emoji and title in correct format', (tester) async {
        await pumpEventShareUtilsWidget(tester);

        // Verify the message starts with emoji and title (if emoji exists)
        final textWidget = tester.widget<Text>(find.byType(Text));
        String expectedTitle = testEventModel.title;
        if (testEventModel.emoji != null) {
          expectedTitle = '${testEventModel.emoji} ${testEventModel.title}';
        }
        expect(textWidget.data, startsWith(expectedTitle));
      });

      testWidgets('includes description when present', (tester) async {
        if (testEventModel.description?.plainText != null) {
          await pumpEventShareUtilsWidget(tester);

          // Verify the message contains description with proper spacing
          final textWidget = tester.widget<Text>(find.byType(Text));
          expect(
            textWidget.data,
            contains('\n\n${testEventModel.description!.plainText}'),
          );
        }
      });

      testWidgets('includes start and end dates', (tester) async {
        await pumpEventShareUtilsWidget(tester);

        // Verify the message contains formatted dates
        final textWidget = tester.widget<Text>(find.byType(Text));
        final startDateString = DateTimeUtils.formatDateTime(
          testEventModel.startDate,
        );
        final endDateString = DateTimeUtils.formatDateTime(
          testEventModel.endDate,
        );

        expect(textWidget.data, contains('🕓 Start\n$startDateString'));
        expect(textWidget.data, contains('🕓 End\n$endDateString'));
      });

      testWidgets('includes link at the end', (tester) async {
        await pumpEventShareUtilsWidget(tester);

        // Verify the message ends with the link
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, endsWith(getEventContentLink()));
      });

      testWidgets('maintains correct message structure', (tester) async {
        await pumpEventShareUtilsWidget(tester);

        // Verify the message structure
        final textWidget = tester.widget<Text>(find.byType(Text));
        final lines = textWidget.data!.split('\n');
        expect(
          lines.length,
          greaterThanOrEqualTo(4),
        ); // At least title, start date, end date, and link

        // First line should be emoji + title (if emoji exists) or just title
        String firstLine = testEventModel.title;
        if (testEventModel.emoji != null) {
          firstLine = '${testEventModel.emoji} ${testEventModel.title}';
        }
        expect(lines.first, equals(firstLine));

        // Last line should be the link
        expect(lines.last, equals(getEventContentLink()));
      });

      testWidgets('handles special characters in event data', (tester) async {
        final specialEventId = 'special-event-id';
        final specialEventTitle = 'Special Event';
        final specialEventDescription = (
          plainText: 'Line 1\nLine 2\tTabbed',
          htmlText: null,
        );

        // Create a new event with special characters
        final specialEvent = testEventModel.copyWith(
          id: specialEventId,
          title: specialEventTitle,
          description: specialEventDescription,
        );

        // Add the special event to the container
        container.read(eventListProvider.notifier).state = [specialEvent];

        // Pump the widget
        await pumpEventShareUtilsWidget(tester, parentId: specialEvent.id);

        // Verify special characters are handled correctly
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains(specialEventTitle));
        expect(textWidget.data, contains(specialEventDescription.plainText));
        expect(
          textWidget.data,
          contains(getEventContentLink(parentId: specialEvent.id)),
        );
      });

      testWidgets('handles event without description', (tester) async {
        final eventWithoutDescriptionId = 'no-description-event-id';
        final eventWithoutDescriptionTitle = 'Event Without Description';

        // Create an event without description
        final eventWithoutDescription = testEventModel.copyWith(
          id: eventWithoutDescriptionId,
          title: eventWithoutDescriptionTitle,
          description: null,
        );

        // Add the event to the container
        container.read(eventListProvider.notifier).state = [
          eventWithoutDescription,
        ];

        // Pump the widget
        await pumpEventShareUtilsWidget(
          tester,
          parentId: eventWithoutDescription.id,
        );

        // Verify the message doesn't contain description
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains(eventWithoutDescriptionTitle));
        expect(textWidget.data, contains('🕓 Start'));
        expect(textWidget.data, contains('🕓 End'));
        expect(
          textWidget.data,
          contains(getEventContentLink(parentId: eventWithoutDescription.id)),
        );
      });

      testWidgets('formats dates correctly', (tester) async {
        final now = DateTime.now();
        final yesterday = now.subtract(const Duration(days: 1));
        final tomorrow = now.add(const Duration(days: 1));

        // Create an event with specific dates
        final eventWithSpecificDates = testEventModel.copyWith(
          startDate: yesterday,
          endDate: tomorrow,
        );

        // Add the event to the container
        container.read(eventListProvider.notifier).state = [
          eventWithSpecificDates,
        ];

        // Pump the widget
        await pumpEventShareUtilsWidget(
          tester,
          parentId: eventWithSpecificDates.id,
        );

        // Verify the dates are formatted correctly
        final textWidget = tester.widget<Text>(find.byType(Text));
        final formattedStartDate = DateTimeUtils.formatDateTime(yesterday);
        final formattedEndDate = DateTimeUtils.formatDateTime(tomorrow);

        expect(textWidget.data, contains(formattedStartDate));
        expect(textWidget.data, contains(formattedEndDate));
      });
    });

    group('List Content Share Message', () {
      late ListModel testListModel;

      setUp(() {
        testListModel = getListByIndex(container);
      });

      Future<void> pumpListShareUtilsWidget(
        WidgetTester tester, {
        String? parentId,
      }) async {
        await tester.pumpConsumerWidget(
          container: container,
          builder: (_, ref, _) => Text(
            ShareUtils.getListContentShareMessage(
              ref: ref,
              parentId: parentId ?? testListModel.id,
            ),
          ),
        );
      }

      String getListContentLink({String? parentId}) {
        return '🔗 ${ShareUtils.linkPrefixUrl}/list/${parentId ?? testListModel.id}';
      }

      testWidgets('generates correct share message for list with all fields', (
        tester,
      ) async {
        await pumpListShareUtilsWidget(tester);

        // Verify the message contains all expected elements
        if (testListModel.emoji != null) {
          expect(find.textContaining(testListModel.emoji!), findsOneWidget);
        }
        expect(find.textContaining(testListModel.title), findsOneWidget);
        if (testListModel.description?.plainText != null) {
          expect(
            find.textContaining(testListModel.description!.plainText!),
            findsOneWidget,
          );
        }
        expect(find.textContaining(getListContentLink()), findsOneWidget);
      });

      testWidgets('returns empty string for non-existent list', (tester) async {
        await pumpListShareUtilsWidget(tester, parentId: 'non-existent-id');

        // Verify empty message
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, isEmpty);
      });

      testWidgets('includes emoji and title in correct format', (tester) async {
        await pumpListShareUtilsWidget(tester);

        // Verify the message starts with emoji and title (if emoji exists)
        final textWidget = tester.widget<Text>(find.byType(Text));
        String expectedTitle = testListModel.title;
        if (testListModel.emoji != null) {
          expectedTitle = '${testListModel.emoji} ${testListModel.title}';
        }
        expect(textWidget.data, startsWith(expectedTitle));
      });

      testWidgets('includes description when present', (tester) async {
        if (testListModel.description?.plainText != null) {
          await pumpListShareUtilsWidget(tester);

          // Verify the message contains description with proper spacing
          final textWidget = tester.widget<Text>(find.byType(Text));
          expect(
            textWidget.data,
            contains('\n\n${testListModel.description!.plainText}'),
          );
        }
      });

      testWidgets('includes link at the end', (tester) async {
        await pumpListShareUtilsWidget(tester);

        // Verify the message ends with the link
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, endsWith(getListContentLink()));
      });

      testWidgets('maintains correct message structure', (tester) async {
        await pumpListShareUtilsWidget(tester);

        // Verify the message structure
        final textWidget = tester.widget<Text>(find.byType(Text));
        final lines = textWidget.data!.split('\n');
        expect(
          lines.length,
          greaterThanOrEqualTo(2),
        ); // At least title and link

        // First line should be emoji + title (if emoji exists) or just title
        String firstLine = testListModel.title;
        if (testListModel.emoji != null) {
          firstLine = '${testListModel.emoji} ${testListModel.title}';
        }
        expect(lines.first, equals(firstLine));

        // Last line should be the link
        expect(lines.last, equals(getListContentLink()));
      });

      testWidgets('handles special characters in list data', (tester) async {
        final specialListId = 'special-list-id';
        final specialListTitle = 'Special List';
        final specialListEmoji = '📝';
        final specialListDescription = (
          plainText: 'Line 1\nLine 2\tTabbed',
          htmlText: null,
        );

        // Create a new list with special characters
        final specialList = testListModel.copyWith(
          id: specialListId,
          title: specialListTitle,
          emoji: specialListEmoji,
          description: specialListDescription,
        );

        // Add the special list to the container
        container.read(listsProvider.notifier).state = [specialList];

        // Pump the widget
        await pumpListShareUtilsWidget(tester, parentId: specialList.id);

        // Verify special characters are handled correctly
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains(specialListTitle));
        expect(textWidget.data, contains(specialListDescription.plainText));
        expect(
          textWidget.data,
          contains(getListContentLink(parentId: specialList.id)),
        );
      });

      testWidgets('handles list without description', (tester) async {
        final listWithoutDescId = 'no-desc-list-id';
        final listWithoutDescTitle = 'List Without Description';

        // Create a list without description
        final listWithoutDesc = testListModel.copyWith(
          id: listWithoutDescId,
          description: null,
          title: listWithoutDescTitle,
        );

        // Add the list to the container
        container.read(listsProvider.notifier).state = [listWithoutDesc];

        // Pump the widget
        await pumpListShareUtilsWidget(tester, parentId: listWithoutDesc.id);

        // Verify the message doesn't contain description
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains(listWithoutDescTitle));
        expect(
          textWidget.data,
          contains(getListContentLink(parentId: listWithoutDesc.id)),
        );
      });

      testWidgets('includes tasks when list type is task', (tester) async {
        final taskListId = 'task-list-id';
        final taskListTitle = 'Task List';
        final task1Id = 'task-1-id';
        final task1Title = 'Task 1';
        final task2Id = 'task-2-id';
        final task2Title = 'Task 2';

        // Create a task list
        final taskList = testListModel.copyWith(
          id: taskListId,
          title: taskListTitle,
          listType: ContentType.task,
        );

        // Create tasks for the list
        final taskContent = getTaskByIndex(container);
        final task1 = taskContent.copyWith(
          id: task1Id,
          title: task1Title,
          parentId: taskList.id,
        );
        final task2 = taskContent.copyWith(
          id: task2Id,
          title: task2Title,
          parentId: taskList.id,
        );

        // Add the list and tasks to the container
        container.read(listsProvider.notifier).state = [taskList];
        container.read(taskListProvider.notifier).state = [task1, task2];

        // Pump the widget
        await pumpListShareUtilsWidget(tester, parentId: taskList.id);

        // Verify tasks are included in the message
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains('☑️ $task1Title'));
        expect(textWidget.data, contains('☑️ $task2Title'));
        expect(
          textWidget.data,
          contains(getListContentLink(parentId: taskList.id)),
        );
      });

      testWidgets('handles task list with empty tasks', (tester) async {
        final emptyTaskListId = 'empty-task-list-id';
        final emptyTaskListTitle = 'Empty Task List';

        // Create a task list with no tasks
        final emptyTaskList = testListModel.copyWith(
          id: emptyTaskListId,
          title: emptyTaskListTitle,
          listType: ContentType.task,
        );

        // Add the list to the container (no tasks added)
        container.read(listsProvider.notifier).state = [emptyTaskList];
        container.read(taskListProvider.notifier).state = [];

        // Pump the widget
        await pumpListShareUtilsWidget(tester, parentId: emptyTaskList.id);

        // Verify the message doesn't contain task items
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains(emptyTaskListTitle));
        expect(textWidget.data, isNot(contains('☑️')));
        expect(
          textWidget.data,
          contains(getListContentLink(parentId: emptyTaskList.id)),
        );
      });

      testWidgets('handles list with description and tasks', (tester) async {
        final taskListWithDescId = 'task-list-with-desc-id';
        final taskListWithDescTitle = 'Task List With Description';
        final taskListWithDescDescription = (
          plainText: 'This is a task list with description',
          htmlText: null,
        );

        final task1Id = 'task-desc-1';
        final task1Title = 'Task with Description';

        // Create a task list with description
        final taskListWithDesc = testListModel.copyWith(
          id: taskListWithDescId,
          title: taskListWithDescTitle,
          listType: ContentType.task,
          description: taskListWithDescDescription,
        );

        // Create a task
        final task = getTaskByIndex(container).copyWith(
          id: task1Id,
          title: task1Title,
          parentId: taskListWithDesc.id,
        );

        // Add the list and task to the container
        container.read(listsProvider.notifier).state = [taskListWithDesc];
        container.read(taskListProvider.notifier).state = [task];

        // Pump the widget
        await pumpListShareUtilsWidget(tester, parentId: taskListWithDesc.id);

        // Verify description and tasks are both included
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(
          textWidget.data,
          contains(taskListWithDescDescription.plainText),
        );
        expect(textWidget.data, contains('☑️ $task1Title'));
        expect(
          textWidget.data,
          contains(getListContentLink(parentId: taskListWithDesc.id)),
        );
      });

      testWidgets('includes bullets when list type is bullet', (tester) async {
        final bulletListId = 'bullet-list-id';
        final bulletListTitle = 'Bullet List';
        final bullet1Id = 'bullet-1-id';
        final bullet1Title = 'Bullet 1';
        final bullet2Id = 'bullet-2-id';
        final bullet2Title = 'Bullet 2';

        // Create a bullet list
        final bulletList = testListModel.copyWith(
          id: bulletListId,
          title: bulletListTitle,
          listType: ContentType.bullet,
        );

        // Create bullets for the list
        final bulletContent = getBulletByIndex(container);
        final bullet1 = bulletContent.copyWith(
          id: bullet1Id,
          title: bullet1Title,
          parentId: bulletList.id,
        );
        final bullet2 = bulletContent.copyWith(
          id: bullet2Id,
          title: bullet2Title,
          parentId: bulletList.id,
        );

        // Add the list to the container
        container.read(listsProvider.notifier).state = [bulletList];
        container.read(bulletListProvider.notifier).state = [bullet1, bullet2];

        // Pump the widget
        await pumpListShareUtilsWidget(tester, parentId: bulletList.id);

        // Verify the message is generated
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains(bulletListTitle));
        expect(textWidget.data, contains('🔹 $bullet1Title'));
        expect(textWidget.data, contains('🔹 $bullet2Title'));
        expect(
          textWidget.data,
          contains(getListContentLink(parentId: bulletList.id)),
        );
      });

      testWidgets('handles bullet list with empty bullets', (tester) async {
        final emptyBulletListId = 'empty-bullet-list-id';
        final emptyBulletListTitle = 'Empty Bullet List';

        // Create a bullet list with no bullets
        final emptyBulletList = testListModel.copyWith(
          id: emptyBulletListId,
          title: emptyBulletListTitle,
          listType: ContentType.bullet,
        );

        // Add the list to the container (no bullets added)
        container.read(listsProvider.notifier).state = [emptyBulletList];
        container.read(bulletListProvider.notifier).state = [];

        // Pump the widget
        await pumpListShareUtilsWidget(tester, parentId: emptyBulletList.id);

        // Verify the message doesn't contain bullet items
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains(emptyBulletListTitle));
        expect(textWidget.data, isNot(contains('🔹')));
        expect(
          textWidget.data,
          contains(getListContentLink(parentId: emptyBulletList.id)),
        );
      });

      testWidgets('handles list with description and bullets', (tester) async {
        final bulletListWithDescId = 'bullet-list-with-desc-id';
        final bulletListWithDescTitle = 'Bullet List With Description';
        final bulletListWithDescDescription = (
          plainText: 'This is a bullet list with description',
          htmlText: null,
        );

        final bullet1Id = 'bullet-desc-1';
        final bullet1Title = 'Bullet with Description';

        // Create a bullet list with description
        final bulletListWithDesc = testListModel.copyWith(
          id: bulletListWithDescId,
          title: bulletListWithDescTitle,
          listType: ContentType.bullet,
          description: bulletListWithDescDescription,
        );

        // Create a bullet
        final bullet = getBulletByIndex(container).copyWith(
          id: bullet1Id,
          title: bullet1Title,
          parentId: bulletListWithDesc.id,
        );

        // Add the list and bullet to the container
        container.read(listsProvider.notifier).state = [bulletListWithDesc];
        container.read(bulletListProvider.notifier).state = [bullet];

        // Pump the widget
        await pumpListShareUtilsWidget(tester, parentId: bulletListWithDesc.id);

        // Verify description and bullets are both included
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(
          textWidget.data,
          contains(bulletListWithDescDescription.plainText),
        );
        expect(textWidget.data, contains('🔹 $bullet1Title'));
        expect(
          textWidget.data,
          contains(getListContentLink(parentId: bulletListWithDesc.id)),
        );
      });
    });
  });
}
