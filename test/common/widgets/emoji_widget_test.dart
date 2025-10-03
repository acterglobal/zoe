import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/emoji_widget.dart';

import '../../test-utils/test_utils.dart';

/// Test utilities for EmojiWidget tests
class EmojiWidgetTestUtils {
  /// Creates a test wrapper for the EmojiWidget
  static EmojiWidget createTestWidget({
    required String emoji,
    double? size,
    required bool isEditing,
    required Function(String) onTap,
  }) {
    return EmojiWidget(
      emoji: emoji,
      size: size,
      isEditing: isEditing,
      onTap: onTap,
    );
  }
}

void main() {
  group('EmojiWidget Tests -', () {
    testWidgets('renders with required properties', (tester) async {
      await tester.pumpMaterialWidget(
        child: EmojiWidgetTestUtils.createTestWidget(
          emoji: '😀',
          isEditing: false,
          onTap: (emoji) {},
        ),
      );

      // Verify widget is rendered
      expect(find.byType(EmojiWidget), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byType(Padding), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('displays emoji correctly', (tester) async {
      const testEmoji = '🎉';

      await tester.pumpMaterialWidget(
        child: EmojiWidgetTestUtils.createTestWidget(
          emoji: testEmoji,
          isEditing: false,
          onTap: (emoji) {},
        ),
      );

      // Verify emoji is displayed
      expect(find.text(testEmoji), findsOneWidget);
    });

    testWidgets('applies default size when size is null', (tester) async {
      await tester.pumpMaterialWidget(
        child: EmojiWidgetTestUtils.createTestWidget(
          emoji: '😀',
          size: null,
          isEditing: false,
          onTap: (emoji) {},
        ),
      );

      // Verify default size is applied
      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontSize, 14);
    });

    testWidgets('applies custom size', (tester) async {
      const customSize = 20.0;

      await tester.pumpMaterialWidget(
        child: EmojiWidgetTestUtils.createTestWidget(
          emoji: '😀',
          size: customSize,
          isEditing: false,
          onTap: (emoji) {},
        ),
      );

      // Verify custom size is applied
      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontSize, customSize);
    });

    testWidgets('applies correct padding', (tester) async {
      await tester.pumpMaterialWidget(
        child: EmojiWidgetTestUtils.createTestWidget(
          emoji: '😀',
          isEditing: false,
          onTap: (emoji) {},
        ),
      );

      // Verify padding is applied
      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, const EdgeInsets.only(top: 3, right: 6));
    });

    testWidgets('calls onTap when isEditing is true and tapped', (
      tester,
    ) async {
      String? tappedEmoji;
      const testEmoji = '🎯';

      await tester.pumpMaterialWidget(
        child: EmojiWidgetTestUtils.createTestWidget(
          emoji: testEmoji,
          isEditing: true,
          onTap: (emoji) => tappedEmoji = emoji,
        ),
      );

      // Tap the widget
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      // Verify onTap was called with correct emoji
      expect(tappedEmoji, testEmoji);
    });

    testWidgets('does not call onTap when isEditing is false', (tester) async {
      String? tappedEmoji;
      const testEmoji = '🎯';

      await tester.pumpMaterialWidget(
        child: EmojiWidgetTestUtils.createTestWidget(
          emoji: testEmoji,
          isEditing: false,
          onTap: (emoji) => tappedEmoji = emoji,
        ),
      );

      // Tap the widget
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      // Verify onTap was not called
      expect(tappedEmoji, isNull);
    });

    testWidgets('handles different emoji types', (tester) async {
      final emojis = ['😀', '🎉', '🚀', '💡', '🔥', '⭐', '🎯', '📱'];

      for (final emoji in emojis) {
        await tester.pumpMaterialWidget(
          child: EmojiWidgetTestUtils.createTestWidget(
            emoji: emoji,
            isEditing: false,
            onTap: (e) {},
          ),
        );

        // Verify emoji is displayed
        expect(find.text(emoji), findsOneWidget);
      }
    });
  });
}
