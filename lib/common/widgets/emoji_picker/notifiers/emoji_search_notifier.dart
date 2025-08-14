import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Zoe/common/widgets/emoji_picker/emoji_picker_config.dart';

class EmojiSearchNotifier extends StateNotifier<EmojiSearchState> {
  EmojiSearchNotifier() : super(const EmojiSearchState());

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
      state = state.copyWith(searchResults: []);
    }
  }

  void resetEmojiSearch() {
    state = const EmojiSearchState();
  }
}
