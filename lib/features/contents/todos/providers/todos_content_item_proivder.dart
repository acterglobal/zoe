import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

// Simple controller providers that create controllers once and keep them stable
final todosContentTitleControllerProvider = Provider.family
    .autoDispose<TextEditingController, String>((ref, String id) {
      final content = ref.read(todosContentItemProvider(id));
      final controller = TextEditingController(text: content.title);

      ref.onDispose(() {
        controller.dispose();
      });

      return controller;
    });

final todosContentItemTitleControllerProvider = Provider.family
    .autoDispose<TextEditingController, String>((ref, String key) {
      // key format: "contentId-itemIndex"
      final parts = key.split('-');
      final contentId = parts.sublist(0, parts.length - 1).join('-');
      final itemIndex = int.parse(parts.last);

      final content = ref.read(todosContentItemProvider(contentId));
      final itemTitle = itemIndex < content.items.length
          ? content.items[itemIndex].title
          : '';
      final controller = TextEditingController(text: itemTitle);

      ref.onDispose(() {
        controller.dispose();
      });

      return controller;
    });

final todosContentItemDescriptionControllerProvider = Provider.family
    .autoDispose<TextEditingController, String>((ref, String key) {
      // key format: "contentId-itemIndex"
      final parts = key.split('-');
      final contentId = parts.sublist(0, parts.length - 1).join('-');
      final itemIndex = int.parse(parts.last);

      final content = ref.read(todosContentItemProvider(contentId));
      final itemDescription = itemIndex < content.items.length
          ? (content.items[itemIndex].description ?? '')
          : '';
      final controller = TextEditingController(text: itemDescription);

      ref.onDispose(() {
        controller.dispose();
      });

      return controller;
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
