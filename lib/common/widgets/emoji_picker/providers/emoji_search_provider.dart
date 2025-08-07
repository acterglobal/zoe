import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/widgets/emoji_picker/emoji_picker_config.dart';
import 'package:zoey/common/widgets/emoji_picker/notifiers/emoji_search_notifier.dart';

/// Provider for emoji search state
final emojiSearchProvider = StateNotifierProvider<EmojiSearchNotifier, EmojiSearchState>(
  (ref) => EmojiSearchNotifier(),
);
