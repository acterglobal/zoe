import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/contents/text/models/text_content_model.dart';
import 'package:zoey/features/contents/text/providers/text_content_list_provider.dart';

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

// Simple controller providers that create controllers once and keep them stable
final textContentTitleControllerProvider = Provider.family
    .autoDispose<TextEditingController, String>((ref, String id) {
      final content = ref.read(textContentItemProvider(id));
      final controller = TextEditingController(text: content.title);

      ref.onDispose(() {
        controller.dispose();
      });

      return controller;
    });

final textContentDataControllerProvider = Provider.family
    .autoDispose<TextEditingController, String>((ref, String id) {
      final content = ref.read(textContentItemProvider(id));
      final controller = TextEditingController(text: content.data);

      ref.onDispose(() {
        controller.dispose();
      });

      return controller;
    });

// Direct update provider - saves immediately using StateNotifier
final textContentUpdateProvider =
    Provider<void Function(String, String, String)>((ref) {
      return (String contentId, String fieldType, String value) {
        // Update using the StateNotifier for immediate reactivity
        if (fieldType == 'title') {
          ref
              .read(textContentListProvider.notifier)
              .updateContent(contentId, title: value);
        } else {
          ref
              .read(textContentListProvider.notifier)
              .updateContent(contentId, data: value);
        }
      };
    });
