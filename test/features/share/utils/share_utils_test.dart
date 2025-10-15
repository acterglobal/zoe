import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/text/models/text_model.dart';
import 'package:zoe/features/share/utils/share_utils.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/text/providers/text_providers.dart';
import '../../../test-utils/test_utils.dart';
import '../../sheet/utils/sheet_utils.dart';
import '../../text/utils/text_utils.dart';

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
  });
}
