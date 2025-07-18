import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/contents/todos/data/todos_content_list.dart';
import 'package:zoey/features/contents/todos/models/todos_content_model.dart';
import 'package:zoey/features/contents/todos/providers/todos_content_list_provider.dart';

final todosContentItemProvider = Provider.family<TodosContentModel, String>((
  ref,
  String id,
) {
  try {
    return ref
        .watch(todosContentListProvider)
        .firstWhere((element) => element.id == id);
  } catch (e) {
    // Return a default todos content if ID not found
    return TodosContentModel(
      parentId: 'default',
      id: id,
      title: 'Content not found',
      items: [
        TodoItem(
          title: 'Content not found',
          description: 'The content with ID "$id" could not be found.',
          isCompleted: false,
        ),
      ],
    );
  }
});

// Provider to update todos content
final todosContentUpdateProvider =
    Provider<void Function(String, {String? title, List<TodoItem>? items})>((
      ref,
    ) {
      return (String id, {String? title, List<TodoItem>? items}) {
        final index = todosContentList.indexWhere(
          (element) => element.id == id,
        );
        if (index != -1) {
          final currentContent = todosContentList[index];
          final updatedContent = currentContent.copyWith(
            title: title,
            items: items,
          );
          todosContentList[index] = updatedContent;

          // Refresh the list provider to notify listeners
          ref.invalidate(todosContentListProvider);
          // Also invalidate the specific item provider to ensure UI updates
          ref.invalidate(todosContentItemProvider(id));
        }
      };
    });
