import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Zoe/features/text/data/text_list.dart';
import 'package:Zoe/features/text/models/text_model.dart';
import 'package:Zoe/features/sheet/models/sheet_model.dart';

class TextNotifier extends StateNotifier<List<TextModel>> {
  TextNotifier() : super(textList);

  void addText(TextModel text) {
    state = [...state, text];
  }

  void deleteText(String textId) {
    state = state.where((t) => t.id != textId).toList();
  }

  void updateTextTitle(String textId, String title) {
    state = [
      for (final text in state)
        if (text.id == textId) text.copyWith(title: title) else text,
    ];
  }

  void updateTextDescription(String textId, Description description) {
    state = [
      for (final text in state)
        if (text.id == textId)
          text.copyWith(description: description)
        else
          text,
    ];
  }

  void updateTextEmoji(String textId, String emoji) {
    state = [
      for (final text in state)
        if (text.id == textId) text.copyWith(emoji: emoji) else text,
    ];
  }

  void updateTextOrderIndex(String textId, int orderIndex) {
    state = [
      for (final text in state)
        if (text.id == textId) text.copyWith(orderIndex: orderIndex) else text,
    ];
  }
}
