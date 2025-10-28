import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/emoji_picker/emoji_picker_config.dart';
import 'package:zoe/common/widgets/emoji_picker/notifiers/emoji_search_notifier.dart';

void main() {
  group('EmojiSearch', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
    });

    group('EmojiSearchState', () {
      test('has correct default values', () {
        const state = EmojiSearchState();
        expect(state.query, equals(''));
        expect(state.searchResults, isEmpty);
      });

      test('copyWith updates query', () {
        const initialState = EmojiSearchState();
        final updatedState = initialState.copyWith(query: 'smile');
        expect(updatedState.query, equals('smile'));
        expect(updatedState.searchResults, isEmpty);
      });

      test('copyWith updates searchResults', () {
        final emojis = [
          Emoji.fromJson({'emoji': '😀', 'name': 'grinning'}),
          Emoji.fromJson({'emoji': '😊', 'name': 'smiling'}),
        ];

        const initialState = EmojiSearchState();
        final updatedState = initialState.copyWith(searchResults: emojis);
        expect(updatedState.searchResults, equals(emojis));
        expect(updatedState.query, isEmpty);
      });

      test('copyWith updates both fields', () {
        final emojis = [
          Emoji.fromJson({'emoji': '😀', 'name': 'grinning'}),
        ];

        const initialState = EmojiSearchState();
        final updatedState = initialState.copyWith(
          query: 'grinning',
          searchResults: emojis,
        );
        expect(updatedState.query, equals('grinning'));
        expect(updatedState.searchResults, equals(emojis));
      });

      test('copyWith keeps original values when null', () {
        final emojis = [
          Emoji.fromJson({'emoji': '😀', 'name': 'grinning'}),
        ];

        final initialState = EmojiSearchState(
          query: 'test',
          searchResults: emojis,
        );
        final updatedState = initialState.copyWith();
        expect(updatedState.query, equals('test'));
        expect(updatedState.searchResults, equals(emojis));
      });
    });

    group('searchEmoji method', () {
      test('updates query in state', () async {
        await container.read(emojiSearchProvider.notifier).searchEmoji('smile');

        final state = container.read(emojiSearchProvider);
        expect(state.query, equals('smile'));
      });

      test('handles search with results', () async {
        await container
            .read(emojiSearchProvider.notifier)
            .searchEmoji('grinning');

        final state = container.read(emojiSearchProvider);
        expect(state.query, equals('grinning'));
        // Results depend on EmojiPickerUtils.searchEmoji implementation
        expect(state.searchResults, isA<List<Emoji>>());
      });
    });

    group('resetEmojiSearch method', () {
      test('resets state to initial values', () {
        // Set some state first
        container.read(emojiSearchProvider.notifier).state = EmojiSearchState(
          query: 'smile',
          searchResults: [
            Emoji.fromJson({'emoji': '😀', 'name': 'grinning'}),
          ],
        );

        container.read(emojiSearchProvider.notifier).resetEmojiSearch();

        final state = container.read(emojiSearchProvider);
        expect(state.query, isEmpty);
        expect(state.searchResults, isEmpty);
      });

      test('resets state with existing results', () {
        // Set state with results
        container.read(emojiSearchProvider.notifier).state = EmojiSearchState(
          query: 'happy',
          searchResults: [
            Emoji.fromJson({'emoji': '😀', 'name': 'grinning'}),
            Emoji.fromJson({'emoji': '😊', 'name': 'smiling'}),
          ],
        );

        container.read(emojiSearchProvider.notifier).resetEmojiSearch();

        final state = container.read(emojiSearchProvider);
        expect(state.query, isEmpty);
        expect(state.searchResults, isEmpty);
      });
    });
  });
}
