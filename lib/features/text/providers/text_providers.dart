import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/features/text/data/text_list.dart';
import 'package:zoe/features/text/models/text_model.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';

part 'text_providers.g.dart';

/// Main text list provider with all text management functionality
@Riverpod(keepAlive: true)
class TextList extends _$TextList {
  @override
  List<TextModel> build() => textList;

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

/// Provider for a single text by ID
@riverpod
TextModel? text(Ref ref, String textId) {
  final textList = ref.watch(textListProvider);
  return textList.where((t) => t.id == textId).firstOrNull;
}

/// Provider for texts filtered by parent ID
@riverpod
List<TextModel> textByParent(Ref ref, String parentId) {
  final textList = ref.watch(textListProvider);
  final filteredTexts = textList.where((t) => t.parentId == parentId).toList();
  filteredTexts.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
  return filteredTexts;
}

/// Provider for searching texts
@riverpod
List<TextModel> textListSearch(Ref ref, String searchTerm) {
  final textList = ref.watch(textListProvider);
  if (searchTerm.isEmpty) return textList;
  return textList
      .where((t) => t.title.toLowerCase().contains(searchTerm.toLowerCase()))
      .toList();
}

/// Provider for sorted texts
@riverpod
List<TextModel> sortedTexts(Ref ref) {
  final texts = ref.watch(textListProvider);
  return [...texts]..sort((a, b) => a.title.compareTo(b.title));
}