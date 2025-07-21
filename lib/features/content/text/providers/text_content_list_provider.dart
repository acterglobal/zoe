import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/text/data/text_content_list.dart';
import 'package:zoey/features/content/text/models/text_content_model.dart';

// StateNotifier provider for the text content list
final textContentListProvider =
    StateNotifierProvider<TextContentListNotifier, List<TextContentModel>>((
      ref,
    ) {
      return TextContentListNotifier();
    });

// StateNotifier for managing the text content list
class TextContentListNotifier extends StateNotifier<List<TextContentModel>> {
  TextContentListNotifier() : super(textContentList);

  // Update a specific text content item
  void updateTextContent(
    String textContentId, {
    String? title,
    String? plainTextDescription,
    String? htmlDescription,
  }) {
    state = state.map((textContent) {
      if (textContent.id == textContentId) {
        return textContent.copyWith(
          title: title ?? textContent.title,
          plainTextDescription:
              plainTextDescription ?? textContent.plainTextDescription,
          htmlDescription: htmlDescription ?? textContent.htmlDescription,
        );
      }
      return textContent;
    }).toList();

    // Also update the original list to keep it in sync
    final index = textContentList.indexWhere(
      (element) => element.id == textContentId,
    );
    if (index != -1) {
      textContentList[index] = state.firstWhere(
        (textContent) => textContent.id == textContentId,
      );
    }
  }

  // Add new text content
  void addTextContent(TextContentModel textContent) {
    state = [...state, textContent];
    textContentList.add(textContent);
  }

  // Remove text content
  void removeTextContent(String textContentId) {
    state = state
        .where((textContent) => textContent.id != textContentId)
        .toList();
    textContentList.removeWhere((element) => element.id == textContentId);
  }
}
