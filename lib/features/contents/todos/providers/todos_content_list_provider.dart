import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/contents/todos/data/todos_content_list.dart';
import 'package:zoey/features/contents/todos/models/todos_content_model.dart';

// StateNotifier for managing the todos content list
class TodosContentListNotifier extends StateNotifier<List<TodosContentModel>> {
  TodosContentListNotifier() : super(todosContentList);

  // Update a specific content item
  void updateContent(String id, {String? title, List<TodoItem>? items}) {
    state = state.map((content) {
      if (content.id == id) {
        return content.copyWith(
          title: title ?? content.title,
          items: items ?? content.items,
        );
      }
      return content;
    }).toList();

    // Also update the original list to keep it in sync
    final index = todosContentList.indexWhere((element) => element.id == id);
    if (index != -1) {
      todosContentList[index] = state.firstWhere((element) => element.id == id);
    }
  }

  // Add new content
  void addContent(TodosContentModel content) {
    state = [...state, content];
    todosContentList.add(content);
  }

  // Remove content
  void removeContent(String id) {
    state = state.where((content) => content.id != id).toList();
    todosContentList.removeWhere((element) => element.id == id);
  }
}

// StateNotifier provider for the todos content list
final todosContentListProvider =
    StateNotifierProvider<TodosContentListNotifier, List<TodosContentModel>>((
      ref,
    ) {
      return TodosContentListNotifier();
    });
