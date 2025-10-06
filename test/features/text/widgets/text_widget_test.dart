import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/toolkit/zoe_delete_button_widget.dart';
import 'package:zoe/common/widgets/emoji_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_html_inline_text_widget.dart';
import 'package:zoe/features/text/widgets/text_widget.dart';
import 'package:zoe/features/text/providers/text_providers.dart';
import 'package:zoe/features/text/models/text_model.dart';
import 'package:zoe/features/text/data/text_list.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('TextWidget', () {
    late ProviderContainer container;
    late TextModel testTextModel;

    setUp(() {
      // Use existing data from textList
      testTextModel = textList.first; // Uses 'Welcome to Zoe!' with 👋 emoji

      container = ProviderContainer.test(
        overrides: [
          textProvider('text-content-1').overrideWith((ref) => testTextModel),
        ],
      );
    });

    testWidgets('renders correctly with valid text content', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: TextWidget(textId: 'text-content-1'),
        container: container,
      );

      expect(find.byType(TextWidget), findsOneWidget);

      // Check that the expected widgets are present
      expect(find.byType(EmojiWidget), findsOneWidget);
      expect(find.byType(ZoeInlineTextEditWidget), findsOneWidget);
      expect(find.byType(ZoeHtmlTextEditWidget), findsOneWidget);

      // Wait for async initialization to complete
      await tester.pumpAndSettle();

      // Try to find text using more flexible approaches
      expect(find.text('Welcome to Zoe!'), findsOneWidget);
    });

    testWidgets('renders empty widget when text content is null', (
      tester,
    ) async {
      final containerWithNullText = ProviderContainer(
        overrides: [
          textProvider('non-existent-id').overrideWith((ref) => null),
        ],
      );

      await tester.pumpMaterialWidgetWithProviderScope(
        child: TextWidget(textId: 'non-existent-id'),
        container: containerWithNullText,
      );

      // Should render SizedBox.shrink() when text is null
      expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
      expect(find.text('Welcome to Zoe!'), findsNothing);
    });

    testWidgets('displays default emoji when no emoji is provided', (
      tester,
    ) async {
      // Create a TextModel with no emoji explicitly set
      final TextModel textWithoutEmoji = textList.first.copyWith(emoji: null);

      final containerNoEmoji = ProviderContainer.test(
        overrides: [
          textProvider(
            'text-content-1',
          ).overrideWith((ref) => textWithoutEmoji),
        ],
      );

      await tester.pumpMaterialWidgetWithProviderScope(
        child: TextWidget(textId: 'text-content-1'),
        container: containerNoEmoji,
      );

      // Wait for async initialization to complete
      await tester.pumpAndSettle();

      // Check that EmojiWidget is present and verify its content through widget properties
      expect(find.byType(EmojiWidget), findsOneWidget);
      final emojiWidget = tester.widget<EmojiWidget>(find.byType(EmojiWidget));
      expect(emojiWidget.emoji, '𝑻'); // Should display default emoji '𝑻'
    });

    testWidgets('displays empty description when no description provided', (
      tester,
    ) async {
      final textWithoutDescription = testTextModel.copyWith(description: null);
      final containerNoDescription = ProviderContainer(
        overrides: [
          textProvider(
            'text-content-1',
          ).overrideWith((ref) => textWithoutDescription),
        ],
      );

      await tester.pumpMaterialWidgetWithProviderScope(
        child: TextWidget(textId: 'text-content-1'),
        container: containerNoDescription,
      );

      expect(find.text('Welcome to Zoe!'), findsOneWidget);
      expect(
        find.text('Welcome to Zoe - your intelligent personal workspace!'),
        findsNothing,
      );
    });

    testWidgets('shows delete button when in editing mode', (tester) async {
      final editModeContainer = ProviderContainer(
        overrides: [
          textProvider('text-content-1').overrideWith((ref) => testTextModel),
          editContentIdProvider.overrideWith((ref) => 'text-content-1'),
        ],
      );

      await tester.pumpMaterialWidgetWithProviderScope(
        child: TextWidget(textId: 'text-content-1'),
        container: editModeContainer,
      );

      expect(find.byType(ZoeDeleteButtonWidget), findsOneWidget);
    });

    testWidgets('hides delete button when not in editing mode', (tester) async {
      final noEditContainer = ProviderContainer(
        overrides: [
          textProvider('text-content-1').overrideWith((ref) => testTextModel),
          editContentIdProvider.overrideWith((ref) => null),
        ],
      );

      await tester.pumpMaterialWidgetWithProviderScope(
        child: TextWidget(textId: 'text-content-1'),
        container: noEditContainer,
      );

      expect(find.byType(ZoeDeleteButtonWidget), findsNothing);
    });

    testWidgets('handles empty title gracefully', (tester) async {
      final emptyTitleText = testTextModel.copyWith(title: '');
      final emptyTitleContainer = ProviderContainer(
        overrides: [
          textProvider('text-content-1').overrideWith((ref) => emptyTitleText),
        ],
      );

      await tester.pumpMaterialWidgetWithProviderScope(
        child: TextWidget(textId: 'text-content-1'),
        container: emptyTitleContainer,
      );

      // Empty title should still render but not show text
      expect(find.byType(TextWidget), findsOneWidget);
    });
  });
}
