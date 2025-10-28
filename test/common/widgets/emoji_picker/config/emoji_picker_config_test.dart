import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/emoji_picker/emoji_picker_config.dart';
import '../../../../test-utils/test_utils.dart';

void main() {
  group('EmojiSearchState', () {
    test('initializes with empty query and results', () {
      const state = EmojiSearchState();
      expect(state.query, equals(''));
      expect(state.searchResults, isEmpty);
    });

    test('initializes with custom query', () {
      const state = EmojiSearchState(query: 'smile');
      expect(state.query, equals('smile'));
      expect(state.searchResults, isEmpty);
    });

    test('initializes with custom search results', () {
      final state = EmojiSearchState(
        searchResults: [
          Emoji.fromJson({'emoji': '😀', 'name': 'grinning'}),
          Emoji.fromJson({'emoji': '😊', 'name': 'smiling'}),
        ],
      );
      expect(state.query, isEmpty);
      expect(state.searchResults.length, equals(2));
    });

    test('initializes with both query and results', () {
      final state = EmojiSearchState(
        query: 'happy',
        searchResults: [
          Emoji.fromJson({'emoji': '😀', 'name': 'grinning'}),
        ],
      );
      expect(state.query, equals('happy'));
      expect(state.searchResults.length, equals(1));
    });

    group('copyWith', () {
      test('returns new instance without changes', () {
        final initialState = EmojiSearchState(
          query: 'test',
          searchResults: [
            Emoji.fromJson({'emoji': '😀', 'name': 'grinning'}),
          ],
        );
        final newState = initialState.copyWith();
        expect(newState.query, equals('test'));
        expect(newState.searchResults.length, equals(1));
      });

      test('updates only query', () {
        final initialState = EmojiSearchState(
          query: 'old',
          searchResults: [
            Emoji.fromJson({'emoji': '😀', 'name': 'grinning'}),
          ],
        );
        final newState = initialState.copyWith(query: 'new');
        expect(newState.query, equals('new'));
        expect(newState.searchResults.length, equals(1));
      });

      test('updates only searchResults', () {
        final initialState = EmojiSearchState(
          query: 'test',
          searchResults: [
            Emoji.fromJson({'emoji': '😀', 'name': 'grinning'}),
          ],
        );
        final newResults = [
          Emoji.fromJson({'emoji': '😊', 'name': 'smiling'}),
          Emoji.fromJson({'emoji': '😍', 'name': 'heart_eyes'}),
        ];
        final newState = initialState.copyWith(searchResults: newResults);
        expect(newState.query, equals('test'));
        expect(newState.searchResults.length, equals(2));
      });

      test('updates both query and searchResults', () {
        final initialState = EmojiSearchState(
          query: 'old',
          searchResults: [
            Emoji.fromJson({'emoji': '😀', 'name': 'grinning'}),
          ],
        );
        final newResults = [
          Emoji.fromJson({'emoji': '😊', 'name': 'smiling'}),
        ];
        final newState = initialState.copyWith(
          query: 'new',
          searchResults: newResults,
        );
        expect(newState.query, equals('new'));
        expect(newState.searchResults.length, equals(1));
      });

      test('keeps original values when parameters are null', () {
        final initialState = EmojiSearchState(
          query: 'test',
          searchResults: [
            Emoji.fromJson({'emoji': '😀', 'name': 'grinning'}),
          ],
        );
        final newState = initialState.copyWith();
        expect(newState.query, equals('test'));
        expect(newState.searchResults.length, equals(1));
      });
    });
  });

  group('EmojiPickerConfigBuilder', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('buildConfig creates valid Config', (tester) async {
      await tester.pumpMaterialWidget(child: const SizedBox());

      await tester.pumpAndSettle();

      final context = tester.element(find.byType(SizedBox));

      final config = EmojiPickerConfigBuilder.buildConfig(
        context,
        controller,
        (_) {},
      );

      expect(config.height, equals(250.0));
      expect(config.emojiTextStyle, isNotNull);
      expect(config.emojiViewConfig, isNotNull);
      expect(config.categoryViewConfig, isNotNull);
      expect(config.bottomActionBarConfig.enabled, isFalse);
    });

    testWidgets('buildConfig emoji text style has correct fontSize', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(child: const SizedBox());

      await tester.pumpAndSettle();

      final context = tester.element(find.byType(SizedBox));

      final config = EmojiPickerConfigBuilder.buildConfig(
        context,
        controller,
        (_) {},
      );

      expect(config.emojiTextStyle?.fontSize, equals(28.0));
      expect(config.emojiTextStyle?.shadows, isNotEmpty);
    });

    testWidgets('buildConfig emoji view has correct dimensions', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(child: const SizedBox());

      await tester.pumpAndSettle();

      final context = tester.element(find.byType(SizedBox));

      final config = EmojiPickerConfigBuilder.buildConfig(
        context,
        controller,
        (_) {},
      );

      expect(config.emojiViewConfig.columns, equals(8));
      expect(config.emojiViewConfig.emojiSizeMax, equals(44.0));
      expect(config.emojiViewConfig.verticalSpacing, equals(8.0));
      expect(config.emojiViewConfig.horizontalSpacing, equals(8.0));
      expect(
        config.emojiViewConfig.gridPadding,
        equals(const EdgeInsets.all(16.0)),
      );
      expect(config.emojiViewConfig.buttonMode, equals(ButtonMode.MATERIAL));
    });

    testWidgets('buildConfig category view has correct configuration', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(child: const SizedBox());

      await tester.pumpAndSettle();

      final context = tester.element(find.byType(SizedBox));

      final config = EmojiPickerConfigBuilder.buildConfig(
        context,
        controller,
        (_) {},
      );

      expect(config.categoryViewConfig.tabBarHeight, equals(40.0));
      expect(
        config.categoryViewConfig.indicatorColor,
        equals(Colors.transparent),
      );
      expect(
        config.categoryViewConfig.dividerColor,
        equals(Colors.transparent),
      );
    });

    testWidgets('buildConfig applies theme colors to category view', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(theme: ThemeData.light(), home: const SizedBox()),
      );

      await tester.pumpAndSettle();

      final context = tester.element(find.byType(SizedBox));

      final config = EmojiPickerConfigBuilder.buildConfig(
        context,
        controller,
        (_) {},
      );

      expect(config.categoryViewConfig.backgroundColor, isNotNull);
      expect(config.categoryViewConfig.iconColor, isNotNull);
      expect(config.categoryViewConfig.iconColorSelected, isNotNull);
      expect(config.categoryViewConfig.backspaceColor, isNotNull);
    });

    testWidgets(
      'buildConfig creates valid configs with different controllers',
      (tester) async {
        await tester.pumpMaterialWidget(
          child: const SizedBox(),
          theme: ThemeData.light(),
        );

        await tester.pumpAndSettle();

        final context = tester.element(find.byType(SizedBox));
        final controller2 = TextEditingController();

        final config1 = EmojiPickerConfigBuilder.buildConfig(
          context,
          controller,
          (_) {},
        );
        final config2 = EmojiPickerConfigBuilder.buildConfig(
          context,
          controller2,
          (_) {},
        );

        // Verify both configs have the same properties
        expect(config1.height, equals(config2.height));
        expect(config1.height, equals(250.0));
        expect(config2.height, equals(250.0));
        expect(
          config1.emojiViewConfig.columns,
          equals(config2.emojiViewConfig.columns),
        );
        expect(config1.emojiViewConfig.columns, equals(8));
        expect(
          config1.categoryViewConfig.tabBarHeight,
          equals(config2.categoryViewConfig.tabBarHeight),
        );
        expect(config1.categoryViewConfig.tabBarHeight, equals(40.0));

        controller2.dispose();
      },
    );
  });
}
