import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/contents/text/data/text_content_list.dart';
import 'package:zoey/features/contents/text/models/text_content_model.dart';

// StateNotifier for managing the text content list
class TextContentListNotifier extends StateNotifier<List<TextContentModel>> {
  TextContentListNotifier() : super(textContentList);

  // Update a specific content item
  void updateContent(String id, {String? title, String? data}) {
    state = state.map((content) {
      if (content.id == id) {
        return content.copyWith(
          title: title ?? content.title,
          data: data ?? content.data,
        );
      }
      return content;
    }).toList();

    // Also update the original list to keep it in sync
    final index = textContentList.indexWhere((element) => element.id == id);
    if (index != -1) {
      textContentList[index] = state.firstWhere((element) => element.id == id);
    }
  }

  // Add new content
  void addContent(TextContentModel content) {
    state = [...state, content];
    textContentList.add(content);
  }

  // Remove content
  void removeContent(String id) {
    state = state.where((content) => content.id != id).toList();
    textContentList.removeWhere((element) => element.id == id);
  }
}

// StateNotifier provider for the text content list
final textContentListProvider =
    StateNotifierProvider<TextContentListNotifier, List<TextContentModel>>((
      ref,
    ) {
      return TextContentListNotifier();
    });
