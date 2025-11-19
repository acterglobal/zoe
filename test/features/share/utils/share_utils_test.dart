import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/bullets/model/bullet_model.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/text/models/text_model.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/list/models/list_model.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/share/utils/share_utils.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/text/providers/text_providers.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/features/list/providers/list_providers.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/common/utils/date_time_utils.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import '../../../test-utils/test_utils.dart';
import '../../bullets/utils/bullets_utils.dart';
import '../../sheet/utils/sheet_utils.dart';
import '../../text/utils/text_utils.dart';
import '../../events/utils/event_utils.dart';
import '../../list/utils/list_utils.dart';
import '../../task/utils/task_utils.dart';
import '../../polls/utils/poll_utils.dart';
import '../../users/utils/users_utils.dart';

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

      test('getLinkPrefixUrl includes query parameters when provided', () {
        const endpoint = 'sheet/test-id';
        final queryParams = {'sharedBy': 'John Doe', 'message': 'Check this out'};
        final result = ShareUtils.getLinkPrefixUrl(endpoint, queryParams: queryParams);
        
        expect(result, contains('sharedBy=John+Doe'));
        expect(result, contains('message=Check+this+out'));
        expect(result, contains(endpoint));
      });

      test('getLinkPrefixUrl handles empty query params map', () {
        const endpoint = 'sheet/test-id';
        final result = ShareUtils.getLinkPrefixUrl(endpoint, queryParams: {});
        
        // Should return link without query parameters
        expect(result, equals('🔗 ${ShareUtils.linkPrefixUrl}/$endpoint'));
      });

      test('getLinkPrefixUrl handles null query params', () {
        const endpoint = 'sheet/test-id';
        final result = ShareUtils.getLinkPrefixUrl(endpoint, queryParams: null);
        
        // Should return link without query parameters
        expect(result, equals('🔗 ${ShareUtils.linkPrefixUrl}/$endpoint'));
      });

      test('getLinkPrefixUrl encodes query parameters correctly', () {
        const endpoint = 'sheet/test-id';
        final queryParams = {
          'sharedBy': 'John Doe',
          'message': 'Hello & Welcome!',
        };
        final result = ShareUtils.getLinkPrefixUrl(endpoint, queryParams: queryParams);
        
        // Verify URL encoding
        expect(result, contains('sharedBy=John+Doe'));
        expect(result, contains('message=Hello+%26+Welcome%21'));
      });

      test('getLinkPrefixUrl handles multiple query parameters', () {
        const endpoint = 'sheet/test-id';
        final queryParams = {
          'param1': 'value1',
          'param2': 'value2',
          'param3': 'value3',
        };
        final result = ShareUtils.getLinkPrefixUrl(endpoint, queryParams: queryParams);
        
        expect(result, contains('param1=value1'));
        expect(result, contains('param2=value2'));
        expect(result, contains('param3=value3'));
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
        String? userName,
        String? userMessage,
      }) async {
        await tester.pumpConsumerWidget(
          container: container,
          builder: (_, ref, _) => Text(
            ShareUtils.getSheetShareMessage(
              ref: ref,
              parentId: parentId ?? testSheetModel.id,
              userName: userName,
              userMessage: userMessage,
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
        expect(textWidget.data, startsWith(testSheetModel.title));
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
        expect(lines.first, equals(testSheetModel.title));

        // Last line should be the link
        expect(lines.last, equals(getSheetShareLink()));
      });

      testWidgets('handles special in sheet data', (tester) async {
        final specialSheetId = 'special-sheet-id';
        final specialSheetTitle = 'Special Sheet';
        final specialSheetDescription = (
          plainText: 'Line 1\nLine 2\tTabbed',
          htmlText: null,
        );

        // Create a new sheet with special characters
        final specialSheet = testSheetModel.copyWith(
          id: specialSheetId,
          title: specialSheetTitle,
          description: specialSheetDescription,
        );

        // Add the special sheet to the container
        container.read(sheetListProvider.notifier).state = [specialSheet];

        // Pump the widget
        await pumpSheetShareUtilsWidget(tester, parentId: specialSheet.id);

        // Verify special characters are handled correctly
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains(specialSheetTitle));
        expect(textWidget.data, contains(specialSheetDescription.plainText));
        expect(
          textWidget.data,
          contains(getSheetShareLink(parentId: specialSheet.id)),
        );
      });

      testWidgets('includes userName and userMessage as query parameters in link', (
        tester,
      ) async {
        const userName = 'John Doe';
        const userMessage = 'Check out this amazing sheet!';

        await pumpSheetShareUtilsWidget(
          tester,
          userName: userName,
          userMessage: userMessage,
        );

        // Verify userName and userMessage are included as query parameters in the link
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains('sharedBy=John+Doe'));
        expect(textWidget.data, contains('message=Check+out+this+amazing+sheet%21'));
      });

      testWidgets('includes only userName query parameter when userMessage is null', (
        tester,
      ) async {
        const userName = 'Jane Smith';

        await pumpSheetShareUtilsWidget(
          tester,
          userName: userName,
          userMessage: null,
        );

        // Verify userName is in link but userMessage is not
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains('sharedBy=Jane+Smith'));
        expect(textWidget.data, isNot(contains('message=')));
      });

      testWidgets('includes only userMessage query parameter when userName is null', (
        tester,
      ) async {
        const userMessage = 'This is a great sheet!';

        await pumpSheetShareUtilsWidget(
          tester,
          userName: null,
          userMessage: userMessage,
        );

        // Verify userMessage is in link but userName is not
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains('message=This+is+a+great+sheet%21'));
        expect(textWidget.data, isNot(contains('sharedBy=')));
      });


      testWidgets('trims userMessage whitespace before adding to link', (
        tester,
      ) async {
        const userName = 'John Doe';
        const userMessage = '  Message with whitespace  ';

        await pumpSheetShareUtilsWidget(
          tester,
          userName: userName,
          userMessage: userMessage,
        );

        // Verify trimmed message is in the link (not the original with whitespace)
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains('message=Message+with+whitespace'));
        expect(textWidget.data, isNot(contains('message=++Message+with+whitespace++')));
      });

      testWidgets('does not include query parameters when both are empty', (
        tester,
      ) async {
        await pumpSheetShareUtilsWidget(
          tester,
          userName: null,
          userMessage: null,
        );

        // Verify link does not contain query parameters
        final textWidget = tester.widget<Text>(find.byType(Text));
        final link = getSheetShareLink();
        expect(textWidget.data, contains(link));
        expect(textWidget.data, isNot(contains('?')));
      });

      testWidgets('does not include query parameters when userName is empty string', (
        tester,
      ) async {
        await pumpSheetShareUtilsWidget(
          tester,
          userName: '',
          userMessage: null,
        );

        // Verify link does not contain sharedBy parameter
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, isNot(contains('sharedBy=')));
      });

      testWidgets('does not include query parameters when userMessage is empty string', (
        tester,
      ) async {
        await pumpSheetShareUtilsWidget(
          tester,
          userName: null,
          userMessage: '',
        );

        // Verify link does not contain message parameter
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, isNot(contains('message=')));
      });

      testWidgets('does not include query parameters when userMessage is only whitespace', (
        tester,
      ) async {
        await pumpSheetShareUtilsWidget(
          tester,
          userName: null,
          userMessage: '   ',
        );

        // Verify link does not contain message parameter
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, isNot(contains('message=')));
      });

      testWidgets('maintains correct message structure with userName and userMessage', (
        tester,
      ) async {
        const userName = 'John Doe';
        const userMessage = 'Check this out!';

        await pumpSheetShareUtilsWidget(
          tester,
          userName: userName,
          userMessage: userMessage,
        );

        // Verify message structure: title, description (if any), link with query params
        final textWidget = tester.widget<Text>(find.byType(Text));
        final lines = textWidget.data!.split('\n');
        
        // Should have at least: title, link
        expect(lines.length, greaterThanOrEqualTo(2));
        
        // Verify link contains query parameters
        expect(textWidget.data, contains('sharedBy=John+Doe'));
        expect(textWidget.data, contains('message=Check+this+out%21'));
        
        // Verify link is at the end
        expect(textWidget.data, contains('🔗'));
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

      testWidgets('handles special emoji in text data', (tester) async {
        final specialTextEmoji = '🧪';

        // Create a new text with special characters
        final specialText = testTextModel.copyWith(emoji: specialTextEmoji);

        // Add the special text to the container
        container.read(textListProvider.notifier).state = [specialText];

        // Pump the widget
        await pumpTextShareUtilsWidget(tester, parentId: specialText.id);

        // Verify special characters are handled correctly
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains(specialTextEmoji));
        expect(textWidget.data, contains(testTextModel.title));
        expect(
          textWidget.data,
          contains(getTextContentLink(parentId: specialText.id)),
        );
      });

      testWidgets('handles text without emoji', (tester) async {
        // Create a text without emoji
        final textWithoutEmoji = testTextModel.copyWith(emoji: null);

        // Add the text to the container
        container.read(textListProvider.notifier).state = [textWithoutEmoji];

        // Pump the widget
        await pumpTextShareUtilsWidget(tester, parentId: textWithoutEmoji.id);

        // Verify the message starts with title only (no emoji)
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, startsWith(testTextModel.title));
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

      testWidgets('handles special dates in event data', (tester) async {
        final now = DateTime.now();
        final yesterday = now.subtract(const Duration(days: 1));
        final tomorrow = now.add(const Duration(days: 1));
        final specialEvent = testEventModel.copyWith(
          startDate: yesterday,
          endDate: tomorrow,
        );

        // Add the special event to the container
        container.read(eventListProvider.notifier).state = [specialEvent];

        // Pump the widget
        await pumpEventShareUtilsWidget(tester, parentId: specialEvent.id);

        // Verify special characters are handled correctly
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains(specialEvent.title));
        expect(textWidget.data, contains('🕓 Start'));
        expect(
          textWidget.data,
          contains(DateTimeUtils.formatDateTime(specialEvent.startDate)),
        );
        expect(textWidget.data, contains('🕓 End'));
        expect(
          textWidget.data,
          contains(DateTimeUtils.formatDateTime(specialEvent.endDate)),
        );
        expect(
          textWidget.data,
          contains(getEventContentLink(parentId: specialEvent.id)),
        );
      });

      testWidgets('handles event without description', (tester) async {
        // Create an event without description
        final eventWithoutDescription = testEventModel.copyWith(
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
        expect(textWidget.data, contains(testEventModel.title));
        expect(textWidget.data, contains('🕓 Start'));
        expect(textWidget.data, contains('🕓 End'));
        expect(
          textWidget.data,
          contains(getEventContentLink(parentId: eventWithoutDescription.id)),
        );
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

      testWidgets('handles special emoji in list data', (tester) async {
        final specialListEmoji = '📝';

        // Create a new list with special characters
        final specialList = testListModel.copyWith(emoji: specialListEmoji);

        // Add the special list to the container
        container.read(listsProvider.notifier).state = [specialList];

        // Pump the widget
        await pumpListShareUtilsWidget(tester, parentId: specialList.id);

        // Verify special characters are handled correctly
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains(specialListEmoji));
        expect(textWidget.data, contains(testListModel.title));
        expect(
          textWidget.data,
          contains(getListContentLink(parentId: specialList.id)),
        );
      });

      testWidgets('handles list without description', (tester) async {
        // Create a list without description
        final listWithoutDesc = testListModel.copyWith(description: null);

        // Add the list to the container
        container.read(listsProvider.notifier).state = [listWithoutDesc];

        // Pump the widget
        await pumpListShareUtilsWidget(tester, parentId: listWithoutDesc.id);

        // Verify the message doesn't contain description
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains(testListModel.title));
        expect(
          textWidget.data,
          contains(getListContentLink(parentId: listWithoutDesc.id)),
        );
      });

      testWidgets('includes tasks when list type is task', (tester) async {
        // Create a task list
        final taskList = testListModel.copyWith(listType: ContentType.task);

        // Create tasks for the list
        final taskContent1 = getTaskByIndex(container);
        final task1 = taskContent1.copyWith(parentId: taskList.id);
        final taskContent2 = getTaskByIndex(container, index: 1);
        final task2 = taskContent2.copyWith(parentId: taskList.id);

        // Add the list and tasks to the container
        container.read(listsProvider.notifier).state = [taskList];
        container.read(taskListProvider.notifier).state = [task1, task2];

        // Pump the widget
        await pumpListShareUtilsWidget(tester, parentId: taskList.id);

        // Verify tasks are included in the message
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains('☑️ ${task1.title}'));
        expect(textWidget.data, contains('☑️ ${task2.title}'));
        expect(
          textWidget.data,
          contains(getListContentLink(parentId: taskList.id)),
        );
      });

      testWidgets('handles task list with empty tasks', (tester) async {
        // Create a task list with no tasks
        final emptyTaskList = testListModel.copyWith(
          listType: ContentType.task,
        );

        // Add the list to the container (no tasks added)
        container.read(listsProvider.notifier).state = [emptyTaskList];
        container.read(taskListProvider.notifier).state = [];

        // Pump the widget
        await pumpListShareUtilsWidget(tester, parentId: emptyTaskList.id);

        // Verify the message doesn't contain task items
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains(testListModel.title));
        expect(textWidget.data, isNot(contains('☑️')));
        expect(
          textWidget.data,
          contains(getListContentLink(parentId: emptyTaskList.id)),
        );
      });

      testWidgets('handles list with description and tasks', (tester) async {
        final taskListWithDescDescription = (
          plainText: 'This is a task list with description',
          htmlText: null,
        );

        // Create a task list with description
        final taskListWithDesc = testListModel.copyWith(
          listType: ContentType.task,
          description: taskListWithDescDescription,
        );

        // Create a task
        final taskContent = getTaskByIndex(container);
        final task = taskContent.copyWith(parentId: taskListWithDesc.id);

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
        expect(textWidget.data, contains('☑️ ${task.title}'));
        expect(
          textWidget.data,
          contains(getListContentLink(parentId: taskListWithDesc.id)),
        );
      });

      testWidgets('includes bullets when list type is bullet', (tester) async {
        // Create a bullet list
        final bulletList = testListModel.copyWith(listType: ContentType.bullet);

        // Create bullets for the list
        final bulletContent1 = getBulletByIndex(container);
        final bullet1 = bulletContent1.copyWith(parentId: bulletList.id);
        final bulletContent2 = getBulletByIndex(container, index: 1);
        final bullet2 = bulletContent2.copyWith(parentId: bulletList.id);

        // Add the list to the container
        container.read(listsProvider.notifier).state = [bulletList];
        container.read(bulletListProvider.notifier).state = [bullet1, bullet2];

        // Pump the widget
        await pumpListShareUtilsWidget(tester, parentId: bulletList.id);

        // Verify the message is generated
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains(testListModel.title));
        expect(textWidget.data, contains('🔹 ${bullet1.title}'));
        expect(textWidget.data, contains('🔹 ${bullet2.title}'));
        expect(
          textWidget.data,
          contains(getListContentLink(parentId: bulletList.id)),
        );
      });

      testWidgets('handles bullet list with empty bullets', (tester) async {
        // Create a bullet list with no bullets
        final emptyBulletList = testListModel.copyWith(
          listType: ContentType.bullet,
        );

        // Add the list to the container (no bullets added)
        container.read(listsProvider.notifier).state = [emptyBulletList];
        container.read(bulletListProvider.notifier).state = [];

        // Pump the widget
        await pumpListShareUtilsWidget(tester, parentId: emptyBulletList.id);

        // Verify the message doesn't contain bullet items
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains(testListModel.title));
        expect(textWidget.data, isNot(contains('🔹')));
        expect(
          textWidget.data,
          contains(getListContentLink(parentId: emptyBulletList.id)),
        );
      });

      testWidgets('handles list with description and bullets', (tester) async {
        final bulletListWithDescDescription = (
          plainText: 'This is a bullet list with description',
          htmlText: null,
        );

        // Create a bullet list with description
        final bulletListWithDesc = testListModel.copyWith(
          listType: ContentType.bullet,
          description: bulletListWithDescDescription,
        );

        // Create a bullet
        final bulletContent = getBulletByIndex(container);
        final bullet = bulletContent.copyWith(parentId: bulletListWithDesc.id);

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
        expect(textWidget.data, contains('🔹 ${bullet.title}'));
        expect(
          textWidget.data,
          contains(getListContentLink(parentId: bulletListWithDesc.id)),
        );
      });
    });

    group('Task Content Share Message', () {
      late TaskModel testTaskModel;

      setUp(() {
        testTaskModel = getTaskByIndex(container);
      });

      Future<void> pumpTaskShareUtilsWidget(
        WidgetTester tester, {
        String? parentId,
      }) async {
        await tester.pumpConsumerWidget(
          container: container,
          builder: (_, ref, _) => Text(
            ShareUtils.getTaskContentShareMessage(
              ref: ref,
              parentId: parentId ?? testTaskModel.id,
            ),
          ),
        );
      }

      String getTaskContentLink({String? parentId}) {
        return '🔗 ${ShareUtils.linkPrefixUrl}/task/${parentId ?? testTaskModel.id}';
      }

      testWidgets('generates correct share message for task with all fields', (
        tester,
      ) async {
        await pumpTaskShareUtilsWidget(tester);

        // Verify the message contains all expected elements
        expect(find.textContaining(testTaskModel.title), findsOneWidget);
        if (testTaskModel.description?.plainText != null) {
          expect(
            find.textContaining(testTaskModel.description!.plainText!),
            findsOneWidget,
          );
        }
        expect(find.textContaining('🕒 Due:'), findsOneWidget);
        expect(find.textContaining(getTaskContentLink()), findsOneWidget);
      });

      testWidgets('returns empty string for non-existent task', (tester) async {
        await pumpTaskShareUtilsWidget(tester, parentId: 'non-existent-id');

        // Verify empty message
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, isEmpty);
      });

      testWidgets('includes emoji and title in correct format', (tester) async {
        await pumpTaskShareUtilsWidget(tester);

        // Verify the message starts with emoji and title
        final textWidget = tester.widget<Text>(find.byType(Text));
        final emoji = testTaskModel.emoji ?? '💻';
        expect(textWidget.data, startsWith('$emoji ${testTaskModel.title}'));
      });

      testWidgets('includes description when present', (tester) async {
        if (testTaskModel.description?.plainText != null) {
          await pumpTaskShareUtilsWidget(tester);

          // Verify the message contains description with proper spacing
          final textWidget = tester.widget<Text>(find.byType(Text));
          expect(
            textWidget.data,
            contains('\n\n${testTaskModel.description!.plainText}'),
          );
        }
      });

      testWidgets('includes due date', (tester) async {
        await pumpTaskShareUtilsWidget(tester);

        // Verify the message contains formatted due date
        final textWidget = tester.widget<Text>(find.byType(Text));
        final dueDateString = DateTimeUtils.formatDate(testTaskModel.dueDate);
        expect(textWidget.data, contains('🕒 Due: $dueDateString'));
      });

      testWidgets('includes assigned users when present', (tester) async {
        if (testTaskModel.assignedUsers.isNotEmpty) {
          await pumpTaskShareUtilsWidget(tester);

          // Verify the message contains assigned users
          final textWidget = tester.widget<Text>(find.byType(Text));
          expect(textWidget.data, contains('👥 Assigned:'));
        }
      });

      testWidgets('includes link at the end', (tester) async {
        await pumpTaskShareUtilsWidget(tester);

        // Verify the message ends with the link
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, endsWith(getTaskContentLink()));
      });

      testWidgets('maintains correct message structure', (tester) async {
        await pumpTaskShareUtilsWidget(tester);

        // Verify the message structure
        final textWidget = tester.widget<Text>(find.byType(Text));
        final lines = textWidget.data!.split('\n');
        expect(
          lines.length,
          greaterThanOrEqualTo(3),
        ); // At least title, due date, and link

        // First line should be emoji + title
        final emoji = testTaskModel.emoji ?? '💻';
        expect(lines.first, equals('$emoji ${testTaskModel.title}'));

        // Last line should be the link
        expect(lines.last, equals(getTaskContentLink()));
      });

      testWidgets('handles special due date in task data', (tester) async {
        final specialDueDate = DateTime.now().add(const Duration(days: 1));
        final specialTask = testTaskModel.copyWith(dueDate: specialDueDate);

        // Add the special task to the container
        container.read(taskListProvider.notifier).state = [specialTask];
        // Pump the widget
        await pumpTaskShareUtilsWidget(tester, parentId: specialTask.id);
        // Verify special characters are handled correctly
        final textWidget = tester.widget<Text>(find.byType(Text));
        final formattedDueDate = DateTimeUtils.formatDate(specialDueDate);
        expect(textWidget.data, contains('🕒 Due: $formattedDueDate'));
      });

      testWidgets('handles task without description', (tester) async {
        // Create a task without description
        final taskWithoutDescription = testTaskModel.copyWith(
          description: null,
        );

        // Add the task to the container
        container.read(taskListProvider.notifier).state = [
          taskWithoutDescription,
        ];

        // Pump the widget
        await pumpTaskShareUtilsWidget(
          tester,
          parentId: taskWithoutDescription.id,
        );

        // Verify the message doesn't contain description
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains(testTaskModel.title));
        expect(textWidget.data, contains('🕒 Due:'));
        expect(textWidget.data, contains(getTaskContentLink()));
      });

      testWidgets('includes single assigned user', (tester) async {
        final user = getUserByIndex(container);

        // Create a task with one assigned user
        final taskWithUser = testTaskModel.copyWith(assignedUsers: [user.id]);

        // Add the task to the container
        container.read(taskListProvider.notifier).state = [taskWithUser];

        // Pump the widget
        await pumpTaskShareUtilsWidget(tester, parentId: taskWithUser.id);

        // Verify assigned user is included
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains('👥 Assigned:'));
        final userData = container.read(getUserByIdProvider(user.id));
        expect(textWidget.data, contains(userData?.name ?? ''));
        expect(
          textWidget.data,
          contains(getTaskContentLink(parentId: taskWithUser.id)),
        );
      });

      testWidgets('includes multiple assigned users', (tester) async {
        final user1 = getUserByIndex(container);
        final user2 = getUserByIndex(container, index: 1);
        final user3 = getUserByIndex(container, index: 2);
        final assignedUsers = [user1.id, user2.id, user3.id];

        // Create a task with multiple assigned users
        final taskWithUsers = testTaskModel.copyWith(
          assignedUsers: assignedUsers,
        );

        // Add the task to the container
        container.read(taskListProvider.notifier).state = [taskWithUsers];

        // Pump the widget
        await pumpTaskShareUtilsWidget(tester, parentId: taskWithUsers.id);

        // Verify assigned users are included
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains('👥 Assigned:'));
        for (final userId in assignedUsers) {
          final user = container.read(getUserByIdProvider(userId));
          expect(textWidget.data, contains(user?.name ?? ''));
        }
        expect(
          textWidget.data,
          contains(getTaskContentLink(parentId: taskWithUsers.id)),
        );
      });

      testWidgets('handles task without assigned users', (tester) async {
        // Create a task without assigned users
        final taskWithoutUsers = testTaskModel.copyWith(assignedUsers: []);

        // Add the task to the container
        container.read(taskListProvider.notifier).state = [taskWithoutUsers];

        // Pump the widget
        await pumpTaskShareUtilsWidget(tester, parentId: taskWithoutUsers.id);

        // Verify assigned users section is not included
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, isNot(contains('👥 Assigned:')));
        expect(
          textWidget.data,
          contains(getTaskContentLink(parentId: taskWithoutUsers.id)),
        );
      });

      testWidgets('handles task with description and assigned users', (
        tester,
      ) async {
        final taskWithAllFieldsDescription = (
          plainText: 'This task has all fields',
          htmlText: null,
        );
        final user1 = getUserByIndex(container);
        final user2 = getUserByIndex(container, index: 1);
        final assignedUsers = [user1.id, user2.id];

        // Create a task with description and assigned users
        final taskWithAllFields = testTaskModel.copyWith(
          description: taskWithAllFieldsDescription,
          assignedUsers: assignedUsers,
        );

        // Add the task to the container
        container.read(taskListProvider.notifier).state = [taskWithAllFields];

        // Pump the widget
        await pumpTaskShareUtilsWidget(tester, parentId: taskWithAllFields.id);

        // Verify all fields are included
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(
          textWidget.data,
          contains(taskWithAllFieldsDescription.plainText),
        );
        expect(textWidget.data, contains('🕒 Due:'));
        expect(textWidget.data, contains('👥 Assigned:'));
        for (final userId in assignedUsers) {
          final userData = container.read(getUserByIdProvider(userId));
          expect(textWidget.data, contains(userData?.name ?? ''));
        }
        expect(
          textWidget.data,
          contains(getTaskContentLink(parentId: taskWithAllFields.id)),
        );
      });
    });

    group('Bullet Content Share Message', () {
      late BulletModel testBulletModel;

      setUp(() {
        testBulletModel = getBulletByIndex(container);
      });

      Future<void> pumpBulletShareUtilsWidget(
        WidgetTester tester, {
        String? parentId,
      }) async {
        await tester.pumpConsumerWidget(
          container: container,
          builder: (_, ref, _) => Text(
            ShareUtils.getBulletContentShareMessage(
              ref: ref,
              parentId: parentId ?? testBulletModel.id,
            ),
          ),
        );
      }

      String getBulletContentLink({String? parentId}) {
        return '🔗 ${ShareUtils.linkPrefixUrl}/bullet/${parentId ?? testBulletModel.id}';
      }

      testWidgets(
        'generates correct share message for bullet with all fields',
        (tester) async {
          await pumpBulletShareUtilsWidget(tester);

          // Verify the message contains all expected elements
          expect(find.textContaining(testBulletModel.title), findsOneWidget);
          if (testBulletModel.description?.plainText != null) {
            expect(
              find.textContaining(testBulletModel.description!.plainText!),
              findsOneWidget,
            );
          }
          expect(find.textContaining(getBulletContentLink()), findsOneWidget);
        },
      );

      testWidgets('returns empty string for non-existent bullet', (
        tester,
      ) async {
        await pumpBulletShareUtilsWidget(tester, parentId: 'non-existent-id');

        // Verify empty message
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, isEmpty);
      });

      testWidgets('includes emoji and title in correct format', (tester) async {
        await pumpBulletShareUtilsWidget(tester);

        // Verify the message starts with emoji and title
        final textWidget = tester.widget<Text>(find.byType(Text));
        final emoji = testBulletModel.emoji ?? '🔹';
        expect(textWidget.data, startsWith('$emoji ${testBulletModel.title}'));
      });

      testWidgets('includes description when present', (tester) async {
        if (testBulletModel.description?.plainText != null) {
          await pumpBulletShareUtilsWidget(tester);

          // Verify the message contains description with proper spacing
          final textWidget = tester.widget<Text>(find.byType(Text));
          expect(
            textWidget.data,
            contains('\n\n${testBulletModel.description!.plainText}'),
          );
        }
      });

      testWidgets('includes link at the end', (tester) async {
        await pumpBulletShareUtilsWidget(tester);

        // Verify the message ends with the link
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, endsWith(getBulletContentLink()));
      });

      testWidgets('maintains correct message structure', (tester) async {
        await pumpBulletShareUtilsWidget(tester);

        // Verify the message structure
        final textWidget = tester.widget<Text>(find.byType(Text));
        final lines = textWidget.data!.split('\n');
        expect(
          lines.length,
          greaterThanOrEqualTo(2),
        ); // At least title and link

        // First line should be emoji + title
        final emoji = testBulletModel.emoji ?? '🔹';
        expect(lines.first, equals('$emoji ${testBulletModel.title}'));

        // Last line should be the link
        expect(lines.last, equals(getBulletContentLink()));
      });

      testWidgets('handles bullet without description', (tester) async {
        // Create a bullet without description
        final bulletWithoutDescription = testBulletModel.copyWith(
          description: null,
        );

        // Add the bullet to the container
        container.read(bulletListProvider.notifier).state = [
          bulletWithoutDescription,
        ];

        // Pump the widget
        await pumpBulletShareUtilsWidget(
          tester,
          parentId: bulletWithoutDescription.id,
        );

        // Verify the message doesn't contain description
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains(testBulletModel.title));
        expect(
          textWidget.data,
          contains(getBulletContentLink(parentId: bulletWithoutDescription.id)),
        );
      });

      testWidgets('handles bullet with long description', (tester) async {
        final bulletLongDescDescription = (
          plainText:
              'This is a very long description that spans multiple lines and contains a lot of text. '
              'It should be properly formatted in the share message. '
              'The description can include various details and information about the bullet point.',
          htmlText: null,
        );

        // Create a bullet with long description
        final bulletLongDesc = testBulletModel.copyWith(
          description: bulletLongDescDescription,
        );

        // Add the bullet to the container
        container.read(bulletListProvider.notifier).state = [bulletLongDesc];

        // Pump the widget
        await pumpBulletShareUtilsWidget(tester, parentId: bulletLongDesc.id);

        // Verify the long description is included
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains(testBulletModel.title));
        expect(textWidget.data, contains(bulletLongDescDescription.plainText));
        expect(
          textWidget.data,
          contains(getBulletContentLink(parentId: bulletLongDesc.id)),
        );
      });
    });

    group('Poll Content Share Message', () {
      late PollModel testPollModel;

      setUp(() {
        testPollModel = getPollByIndex(container);
      });

      Future<void> pumpPollShareUtilsWidget(
        WidgetTester tester, {
        String? parentId,
      }) async {
        await tester.pumpConsumerWidget(
          container: container,
          builder: (_, ref, _) => Text(
            ShareUtils.getPollContentShareMessage(
              ref: ref,
              parentId: parentId ?? testPollModel.id,
            ),
          ),
        );
      }

      String getPollContentLink({String? parentId}) {
        return '🔗 ${ShareUtils.linkPrefixUrl}/poll/${parentId ?? testPollModel.id}';
      }

      testWidgets('generates correct share message for poll with all fields', (
        tester,
      ) async {
        await pumpPollShareUtilsWidget(tester);

        // Verify the message contains all expected elements
        expect(find.textContaining(testPollModel.title), findsOneWidget);
        if (testPollModel.emoji != null) {
          expect(find.textContaining(testPollModel.emoji!), findsOneWidget);
        }
        expect(find.textContaining('🔘'), findsWidgets);
        expect(find.textContaining(getPollContentLink()), findsOneWidget);
      });

      testWidgets('returns empty string for non-existent poll', (tester) async {
        await pumpPollShareUtilsWidget(tester, parentId: 'non-existent-id');

        // Verify empty message
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, isEmpty);
      });

      testWidgets('includes emoji and title in correct format', (tester) async {
        await pumpPollShareUtilsWidget(tester);

        // Verify the message starts with emoji and title (if emoji exists)
        final textWidget = tester.widget<Text>(find.byType(Text));
        final expectedTitle = testPollModel.emoji != null
            ? '${testPollModel.emoji} ${testPollModel.title}'
            : testPollModel.title;
        expect(textWidget.data, startsWith(expectedTitle));
      });

      testWidgets('includes poll options', (tester) async {
        await pumpPollShareUtilsWidget(tester);

        // Verify all options are included with 🔘 emoji
        final textWidget = tester.widget<Text>(find.byType(Text));
        for (final option in testPollModel.options) {
          expect(textWidget.data, contains('🔘 ${option.title}'));
        }
      });

      testWidgets('includes link at the end', (tester) async {
        await pumpPollShareUtilsWidget(tester);

        // Verify the message ends with the link
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, endsWith(getPollContentLink()));
      });

      testWidgets('maintains correct message structure', (tester) async {
        await pumpPollShareUtilsWidget(tester);

        // Verify the message structure
        final textWidget = tester.widget<Text>(find.byType(Text));
        final lines = textWidget.data!.split('\n');
        expect(
          lines.length,
          greaterThanOrEqualTo(3),
        ); // At least title, option, and link

        // First line should be emoji + title (if emoji exists) or just title
        final firstLine = testPollModel.emoji != null
            ? '${testPollModel.emoji} ${testPollModel.title}'
            : testPollModel.title;
        expect(lines.first, equals(firstLine));

        // Last line should be the link
        expect(lines.last, equals(getPollContentLink()));
      });

      testWidgets('handles special options in poll data', (tester) async {
        final specialOptions = [
          PollOption(id: 'opt-1', title: 'Option & Special "Characters"'),
          PollOption(id: 'opt-2', title: 'Option with\ttab'),
        ];

        // Create a new poll with special characters
        final specialPoll = testPollModel.copyWith(options: specialOptions);

        // Add the special poll to the container
        container.read(pollListProvider.notifier).state = [specialPoll];

        // Pump the widget
        await pumpPollShareUtilsWidget(tester, parentId: specialPoll.id);

        // Verify special characters are handled correctly
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains(testPollModel.title));
        for (final option in specialOptions) {
          expect(textWidget.data, contains(option.title));
        }
        expect(
          textWidget.data,
          contains(getPollContentLink(parentId: specialPoll.id)),
        );
      });

      testWidgets('handles poll with single option', (tester) async {
        final optionTitle = 'Only Option';
        final singleOption = [PollOption(id: 'single-opt', title: optionTitle)];

        // Create a poll with single option
        final singleOptionPoll = testPollModel.copyWith(options: singleOption);

        // Add the poll to the container
        container.read(pollListProvider.notifier).state = [singleOptionPoll];

        // Pump the widget
        await pumpPollShareUtilsWidget(tester, parentId: singleOptionPoll.id);

        // Verify the single option is included
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains(testPollModel.title));
        expect(textWidget.data, contains('🔘 $optionTitle'));
        expect(
          textWidget.data,
          contains(getPollContentLink(parentId: singleOptionPoll.id)),
        );
      });

      testWidgets('handles poll with multiple options', (tester) async {
        final multiOptions = List.generate(
          5,
          (index) => PollOption(id: 'opt-$index', title: 'Option ${index + 1}'),
        );

        // Create a poll with multiple options
        final multiOptionPoll = testPollModel.copyWith(options: multiOptions);

        // Add the poll to the container
        container.read(pollListProvider.notifier).state = [multiOptionPoll];

        // Pump the widget
        await pumpPollShareUtilsWidget(tester, parentId: multiOptionPoll.id);

        // Verify all options are included
        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.data, contains(testPollModel.title));
        for (int i = 1; i <= 5; i++) {
          expect(textWidget.data, contains('🔘 Option $i'));
        }
        expect(
          textWidget.data,
          contains(getPollContentLink(parentId: multiOptionPoll.id)),
        );
      });
    });
  });
}
