import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/bullet-lists/models/bullets_content_model.dart';
import 'package:zoey/features/bullet-lists/providers/bullets_content_list_provider.dart';

final bulletsContentItemProvider = Provider.family<BulletsContentModel, String>(
  (ref, String id) {
    try {
      return ref
          .watch(bulletsContentListProvider)
          .firstWhere((element) => element.id == id);
    } catch (e) {
      // Return a default bullets content if ID not found
      return BulletsContentModel(
        parentId: 'default',
        id: id,
        title: 'Content not found',
        bullets: ['The content with ID "$id" could not be found.'],
      );
    }
  },
);

// Simple controller providers that create controllers once and keep them stable
final bulletsContentTitleControllerProvider = Provider.family
    .autoDispose<TextEditingController, String>((ref, String id) {
      final content = ref.read(bulletsContentItemProvider(id));
      final controller = TextEditingController(text: content.title);

      ref.onDispose(() {
        controller.dispose();
      });

      return controller;
    });

final bulletsContentBulletControllerProvider = Provider.family
    .autoDispose<TextEditingController, String>((ref, String key) {
      // key format: "contentId-bulletIndex"
      final parts = key.split('-');
      final contentId = parts.sublist(0, parts.length - 1).join('-');
      final bulletIndex = int.parse(parts.last);

      final content = ref.read(bulletsContentItemProvider(contentId));
      final bulletText = bulletIndex < content.bullets.length
          ? content.bullets[bulletIndex]
          : '';
      final controller = TextEditingController(text: bulletText);

      ref.onDispose(() {
        controller.dispose();
      });

      return controller;
    });

// Direct update provider - saves immediately using StateNotifier
final bulletsContentUpdateProvider =
    Provider<void Function(String, {String? title, List<String>? bullets})>((
      ref,
    ) {
      return (String contentId, {String? title, List<String>? bullets}) {
        // Update using the StateNotifier for immediate reactivity
        ref
            .read(bulletsContentListProvider.notifier)
            .updateContent(contentId, title: title, bullets: bullets);
      };
    });
