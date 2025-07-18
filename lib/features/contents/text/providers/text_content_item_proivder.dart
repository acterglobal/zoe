import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/contents/text/models/text_content_model.dart';
import 'package:zoey/features/contents/text/providers/text_content_list_provider.dart';
import 'package:zoey/features/contents/text/data/text_content_list.dart';

final textContentItemProvider = Provider.family<TextContentModel, String>((
  ref,
  String id,
) {
  try {
    return ref
        .watch(textContentListProvider)
        .firstWhere((element) => element.id == id);
  } catch (e) {
    // Return a default text content if ID not found
    return TextContentModel(
      parentId: 'default',
      id: id,
      title: 'Content not found',
      data: 'The content with ID "$id" could not be found.',
    );
  }
});

// Provider for title controller
final textContentTitleControllerProvider =
    Provider.family<TextEditingController, String>((ref, String id) {
      final textContent = ref.watch(textContentItemProvider(id));
      final controller = TextEditingController(text: textContent.title);

      // Dispose controller when provider is disposed
      ref.onDispose(() {
        controller.dispose();
      });

      return controller;
    });

// Provider for data controller
final textContentDataControllerProvider =
    Provider.family<TextEditingController, String>((ref, String id) {
      final textContent = ref.watch(textContentItemProvider(id));
      final controller = TextEditingController(text: textContent.data);

      // Dispose controller when provider is disposed
      ref.onDispose(() {
        controller.dispose();
      });

      return controller;
    });

// Provider to update text content
final textContentUpdateProvider =
    Provider<void Function(String, {String? title, String? data})>((ref) {
      return (String id, {String? title, String? data}) {
        final index = textContentList.indexWhere((element) => element.id == id);
        if (index != -1) {
          final currentContent = textContentList[index];
          final updatedContent = currentContent.copyWith(
            title: title,
            data: data,
          );
          textContentList[index] = updatedContent;

          // Refresh the list provider to notify listeners
          ref.invalidate(textContentListProvider);
          // Also invalidate the specific item provider to ensure UI updates
          ref.invalidate(textContentItemProvider(id));
        }
      };
    });
