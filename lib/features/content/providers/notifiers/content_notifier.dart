import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/models/content_model.dart';
import 'package:zoey/features/text/data/text_list.dart';
import 'package:zoey/features/events/data/event_list.dart';
import 'package:zoey/features/list/data/lists.dart';

class ContentNotifier extends StateNotifier<List<ContentModel>> {
  ContentNotifier() : super([]) {
    _loadAllContent();
  }

  void _loadAllContent() {
    final allContent = <ContentModel>[...textList, ...eventList, ...lists];
    state = allContent;
  }

  List<ContentModel> getContentByParentId(String parentId) {
    return state.where((content) => content.parentId == parentId).toList();
  }

  void addContent(ContentModel content) {
    state = [...state, content];
  }

  void updateContent(ContentModel updatedContent) {
    state = state.map((content) {
      return content.id == updatedContent.id ? updatedContent : content;
    }).toList();
  }

  void deleteContent(String contentId) {
    state = state.where((c) => c.id != contentId).toList();
  }

  void reorderContent(int oldIndex, int newIndex, String parentId) {
    final contentForParent = getContentByParentId(parentId);
    final otherContent = state.where((c) => c.parentId != parentId).toList();

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final item = contentForParent.removeAt(oldIndex);
    contentForParent.insert(newIndex, item);

    state = [...otherContent, ...contentForParent];
  }
}
