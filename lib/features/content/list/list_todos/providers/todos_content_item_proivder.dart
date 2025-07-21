import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/list/list_todos/models/todos_content_model.dart';
import 'package:zoey/features/content/list/list_todos/providers/todos_content_list_provider.dart';

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
      sheetId: 'default',
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

// Direct update provider - saves immediately using StateNotifier
final todosContentUpdateProvider =
    Provider<void Function(String, {String? title, List<TodoItem>? items})>((
      ref,
    ) {
      return (String contentId, {String? title, List<TodoItem>? items}) {
        // Update using the StateNotifier for immediate reactivity
        ref
            .read(todosContentListProvider.notifier)
            .updateContent(contentId, title: title, items: items);
      };
    });
