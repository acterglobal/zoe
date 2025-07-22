import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/data/content_list.dart';
import 'package:zoey/features/content/models/base_content_model.dart';
import 'package:zoey/features/text/models/text_content_model.dart';
import 'package:zoey/features/events/models/events_model.dart';
import 'package:zoey/features/list/models/list_model.dart';

class ContentNotifier extends StateNotifier<List<ContentModel>> {
  ContentNotifier() : super(List.from(contentList));

  // Generic update method
  void updateContent<T extends ContentModel>(
    String contentId,
    T Function(T current) updateFunction,
  ) {
    state = state.map((content) {
      if (content.id == contentId && content is T) {
        final updated = updateFunction(content);
        // Update the original content list to keep it in sync
        _updateContentList(contentId, updated);
        return updated;
      }
      return content;
    }).toList();
  }

  // Generic add method
  void addContent<T extends ContentModel>(T content) {
    state = [...state, content];
    contentList.add(content);
  }

  // Generic remove method
  void removeContent(String contentId) {
    state = state.where((content) => content.id != contentId).toList();
    contentList.removeWhere((element) => element.id == contentId);
  }

  // Generic get methods
  List<T> getContentsByType<T extends ContentModel>() {
    return state.whereType<T>().toList();
  }

  List<ContentModel> getContentsByContentType(ContentType type) {
    return state.where((content) => content.type == type).toList();
  }

  T? getContentById<T extends ContentModel>(String contentId) {
    try {
      return state.firstWhere((content) => content.id == contentId) as T;
    } catch (e) {
      return null;
    }
  }

  // Filter methods
  List<ContentModel> getContentsBySheetId(String sheetId) {
    return state.where((content) => content.sheetId == sheetId).toList();
  }

  List<T> getContentsBySheetIdAndType<T extends ContentModel>(String sheetId) {
    return state
        .where((content) => content.sheetId == sheetId)
        .whereType<T>()
        .toList();
  }

  // Bulk operations
  void addMultipleContent(List<ContentModel> contents) {
    state = [...state, ...contents];
    contentList.addAll(contents);
  }

  void removeMultipleContent(List<String> contentIds) {
    state = state.where((content) => !contentIds.contains(content.id)).toList();
    contentList.removeWhere((element) => contentIds.contains(element.id));
  }

  void replaceAllContent(List<ContentModel> newContent) {
    state = List.from(newContent);
    contentList.clear();
    contentList.addAll(newContent);
  }

  // Helper method to update the original content list
  void _updateContentList(String contentId, ContentModel updatedContent) {
    final index = contentList.indexWhere((element) => element.id == contentId);
    if (index != -1) {
      contentList[index] = updatedContent;
    }
  }

  // Convenience methods for common update patterns
  void updateContentTitle(String contentId, String newTitle) {
    final content = state.firstWhere((c) => c.id == contentId);

    if (content is TextModel) {
      updateContent<TextModel>(
        contentId,
        (c) => c.copyWith(title: newTitle, updatedAt: DateTime.now()),
      );
    } else if (content is EventModel) {
      updateContent<EventModel>(
        contentId,
        (c) => c.copyWith(title: newTitle, updatedAt: DateTime.now()),
      );
    } else if (content is ListModel) {
      updateContent<ListModel>(
        contentId,
        (c) => c.copyWith(title: newTitle, updatedAt: DateTime.now()),
      );
    }
  }

  void updateContentDescription(String contentId, String newDescription) {
    final content = state.firstWhere((c) => c.id == contentId);
    if (content is TextModel) {
      updateContent<TextModel>(
        contentId,
        (c) => c.copyWith(
          plainTextDescription: newDescription,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }
}
