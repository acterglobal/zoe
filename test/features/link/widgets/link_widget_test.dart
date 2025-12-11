import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/display_sheet_name_widget.dart';
import 'package:zoe/common/widgets/emoji_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_delete_button_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/features/link/models/link_model.dart';
import 'package:zoe/features/link/providers/link_providers.dart';
import 'package:zoe/features/link/widgets/link_widget.dart';
import '../../../test-utils/test_utils.dart';
import '../utils/link_utils.dart';

void main() {
  group('LinkWidget', () {
    late ProviderContainer container;
    late LinkModel testLink;
    late String testLinkId;

    setUp(() {
      container = ProviderContainer.test();
      testLink = getLinkByIndex(container);
      testLinkId = testLink.id;
    });

    Future<void> pumpLinkWidget(
      WidgetTester tester, {
      required String linkId,
      bool showSheetName = true,
    }) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: LinkWidget(linkId: linkId, showSheetName: showSheetName),
        container: container,
      );
    }

    group('Basic Rendering', () {
      testWidgets('renders correctly with valid link', (tester) async {
        await pumpLinkWidget(tester, linkId: testLinkId);

        expect(find.byType(LinkWidget), findsOneWidget);
        expect(find.byType(EmojiWidget), findsOneWidget);
        expect(find.byType(ZoeInlineTextEditWidget), findsAtLeastNWidgets(2));
      });

      testWidgets('renders empty widget when link is null', (tester) async {
        final containerWithNullLink = ProviderContainer(
          overrides: [
            linkProvider('non-existent-id').overrideWith((ref) => null),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          child: const LinkWidget(linkId: 'non-existent-id'),
          container: containerWithNullLink,
        );

        // Should render SizedBox.shrink() when link is null
        expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
      });

      testWidgets('displays link title correctly', (tester) async {
        await pumpLinkWidget(tester, linkId: testLinkId);
        await tester.pumpAndSettle();

        expect(find.text(testLink.title), findsOneWidget);
      });

      testWidgets('displays link URL correctly', (tester) async {
        await pumpLinkWidget(tester, linkId: testLinkId);
        await tester.pumpAndSettle();

        expect(find.text(testLink.url), findsOneWidget);
      });

      testWidgets('displays link emoji correctly', (tester) async {
        await pumpLinkWidget(tester, linkId: testLinkId);

        expect(find.byType(EmojiWidget), findsOneWidget);
        final emojiWidget = tester.widget<EmojiWidget>(
          find.byType(EmojiWidget),
        );
        expect(emojiWidget.emoji, equals(testLink.emoji ?? '🔗'));
      });
    });

    group('Edit Mode', () {
      testWidgets('shows delete button when in editing mode', (tester) async {
        final editModeContainer = ProviderContainer(
          overrides: [
            linkProvider(testLinkId).overrideWith((ref) => testLink),
            editContentIdProvider.overrideWith((ref) => testLinkId),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          child: LinkWidget(linkId: testLinkId),
          container: editModeContainer,
        );

        expect(find.byType(ZoeDeleteButtonWidget), findsOneWidget);
      });

      testWidgets('hides delete button when not in editing mode', (
        tester,
      ) async {
        final noEditContainer = ProviderContainer(
          overrides: [
            linkProvider(testLinkId).overrideWith((ref) => testLink),
            editContentIdProvider.overrideWith((ref) => null),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          child: LinkWidget(linkId: testLinkId),
          container: noEditContainer,
        );

        expect(find.byType(ZoeDeleteButtonWidget), findsNothing);
      });

      testWidgets('enables editing when link ID matches editContentId', (
        tester,
      ) async {
        final editModeContainer = ProviderContainer(
          overrides: [
            linkProvider(testLinkId).overrideWith((ref) => testLink),
            editContentIdProvider.overrideWith((ref) => testLinkId),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          child: LinkWidget(linkId: testLinkId),
          container: editModeContainer,
        );

        // Should have delete button when editing
        expect(find.byType(ZoeDeleteButtonWidget), findsOneWidget);
      });

      testWidgets(
        'disables editing when link ID does not match editContentId',
        (tester) async {
          final noEditContainer = ProviderContainer(
            overrides: [
              linkProvider(testLinkId).overrideWith((ref) => testLink),
              editContentIdProvider.overrideWith((ref) => 'different-id'),
            ],
          );

          await tester.pumpMaterialWidgetWithProviderScope(
            child: LinkWidget(linkId: testLinkId),
            container: noEditContainer,
          );

          expect(find.byType(ZoeDeleteButtonWidget), findsNothing);
        },
      );
    });

    group('Sheet Name Display', () {
      testWidgets('shows sheet name when showSheetName is true', (
        tester,
      ) async {
        await pumpLinkWidget(tester, linkId: testLinkId, showSheetName: true);

        expect(find.byType(DisplaySheetNameWidget), findsOneWidget);
      });

      testWidgets('hides sheet name when showSheetName is false', (
        tester,
      ) async {
        await pumpLinkWidget(tester, linkId: testLinkId, showSheetName: false);

        expect(find.byType(DisplaySheetNameWidget), findsNothing);
      });
    });

    group('Emoji Widget', () {
      testWidgets('displays default emoji when link emoji is null', (
        tester,
      ) async {
        // Create a link with no emoji
        final linkWithoutEmoji = LinkModel(
          id: 'link-no-emoji-test',
          sheetId: 'sheet-1',
          parentId: 'sheet-1',
          title: 'Test Link Without Emoji',
          url: 'https://test.com',
          emoji: null,
          orderIndex: 1000,
          createdBy: 'test-user',
        );

        // Add the link to the provider
        container.read(linkListProvider.notifier).addLink(linkWithoutEmoji);

        await tester.pumpMaterialWidgetWithProviderScope(
          child: const LinkWidget(linkId: 'link-no-emoji-test'),
          container: container,
        );

        await tester.pumpAndSettle();

        final emojiWidget = tester.widget<EmojiWidget>(
          find.byType(EmojiWidget),
        );
        expect(emojiWidget.emoji, equals('🔗'));
      });

      testWidgets('displays custom emoji when link emoji is provided', (
        tester,
      ) async {
        final linkWithCustomEmoji = testLink.copyWith(emoji: '🎉');
        container = ProviderContainer(
          overrides: [
            linkProvider(testLinkId).overrideWith((ref) => linkWithCustomEmoji),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          child: LinkWidget(linkId: testLinkId),
          container: container,
        );

        final emojiWidget = tester.widget<EmojiWidget>(
          find.byType(EmojiWidget),
        );
        expect(emojiWidget.emoji, equals('🎉'));
      });

      testWidgets('emoji widget has correct size', (tester) async {
        await pumpLinkWidget(tester, linkId: testLinkId);

        final emojiWidget = tester.widget<EmojiWidget>(
          find.byType(EmojiWidget),
        );
        expect(emojiWidget.size, equals(20));
      });
    });

    group('URL Display and Interaction', () {
      testWidgets('displays URL with inline text edit widget', (tester) async {
        await pumpLinkWidget(tester, linkId: testLinkId);
        await tester.pumpAndSettle();

        expect(find.text(testLink.url), findsOneWidget);
      });

      testWidgets('handles empty URL', (tester) async {
        final linkWithEmptyUrl = testLink.copyWith(url: '');
        final containerEmptyUrl = ProviderContainer(
          overrides: [
            linkProvider(testLinkId).overrideWith((ref) => linkWithEmptyUrl),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          child: LinkWidget(linkId: testLinkId),
          container: containerEmptyUrl,
        );

        // Should still render the URL widget
        expect(find.byType(ZoeInlineTextEditWidget), findsAtLeastNWidgets(2));
      });
    });

    group('Title Display and Editing', () {
      testWidgets('displays title with correct styling', (tester) async {
        await pumpLinkWidget(tester, linkId: testLinkId);
        await tester.pumpAndSettle();

        expect(find.text(testLink.title), findsOneWidget);
      });

      testWidgets('handles empty title', (tester) async {
        final linkWithEmptyTitle = testLink.copyWith(title: '');
        final containerEmptyTitle = ProviderContainer(
          overrides: [
            linkProvider(testLinkId).overrideWith((ref) => linkWithEmptyTitle),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          child: LinkWidget(linkId: testLinkId),
          container: containerEmptyTitle,
        );

        // Should still render the title widget
        expect(find.byType(ZoeInlineTextEditWidget), findsAtLeastNWidgets(2));
      });
    });

    group('Multiple Links', () {
      testWidgets('renders different links correctly', (tester) async {
        final link2 = getLinkByIndex(container, index: 1);
        final containerMultiple = ProviderContainer.test(
          overrides: [
            linkProvider(testLinkId).overrideWith((ref) => testLink),
            linkProvider(link2.id).overrideWith((ref) => link2),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          child: Column(
            children: [
              LinkWidget(linkId: testLinkId),
              LinkWidget(linkId: link2.id),
            ],
          ),
          container: containerMultiple,
        );

        expect(find.byType(LinkWidget), findsNWidgets(2));
        expect(find.text(testLink.title), findsOneWidget);
        expect(find.text(link2.title), findsOneWidget);
      });
    });
  });
}
