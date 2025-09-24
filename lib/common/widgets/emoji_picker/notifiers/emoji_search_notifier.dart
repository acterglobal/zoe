import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/common/widgets/emoji_picker/emoji_picker_config.dart';

part 'emoji_search_notifier.g.dart';

Logger log = Logger('EmojiSearchNotifier');
/// Notifier for handling emoji search functionality
@riverpod
class EmojiSearch extends _$EmojiSearch {
  @override
  EmojiSearchState build() => const EmojiSearchState();

  /// Search for emojis based on query
  Future<void> searchEmoji(String query) async {
    if (query.isEmpty) {
      state = const EmojiSearchState();
      return;
    }

    state = state.copyWith(query: query);

    try {
      final results = await EmojiPickerUtils().searchEmoji(
        query,
        defaultEmojiSet,
      );
      state = state.copyWith(searchResults: results);
    } catch (e) {
      log.severe('Error searching emoji: $e');
      state = state.copyWith(searchResults: []);
    }
  }

  /// Reset the emoji search state
  void resetEmojiSearch() {
    state = const EmojiSearchState();
  }
}