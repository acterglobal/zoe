import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/contents/bullet-lists/data/bullets_content_list.dart';
import 'package:zoey/features/contents/bullet-lists/models/bullets_content_model.dart';
import 'package:zoey/features/contents/bullet-lists/providers/bullets_content_list_provider.dart';

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

// Provider for title controller
final bulletsContentTitleControllerProvider =
    Provider.family<TextEditingController, String>((ref, String id) {
      final bulletsContent = ref.watch(bulletsContentItemProvider(id));
      final controller = TextEditingController(text: bulletsContent.title);

      // Dispose controller when provider is disposed
      ref.onDispose(() {
        controller.dispose();
      });

      return controller;
    });

// Provider for bullet controllers (one per bullet item)
final bulletsContentBulletControllerProvider =
    Provider.family<TextEditingController, String>((ref, String key) {
      // key format: "contentId-bulletIndex"
      final parts = key.split('-');
      final contentId = parts.sublist(0, parts.length - 1).join('-');
      final bulletIndex = int.parse(parts.last);

      final bulletsContent = ref.watch(bulletsContentItemProvider(contentId));
      final bulletText = bulletIndex < bulletsContent.bullets.length
          ? bulletsContent.bullets[bulletIndex]
          : '';
      final controller = TextEditingController(text: bulletText);

      // Dispose controller when provider is disposed
      ref.onDispose(() {
        controller.dispose();
      });

      return controller;
    });

// Provider to update bullets content
final bulletsContentUpdateProvider =
    Provider<void Function(String, {String? title, List<String>? bullets})>((
      ref,
    ) {
      return (String id, {String? title, List<String>? bullets}) {
        final index = bulletsContentList.indexWhere(
          (element) => element.id == id,
        );
        if (index != -1) {
          final currentContent = bulletsContentList[index];
          final updatedContent = currentContent.copyWith(
            title: title,
            bullets: bullets,
          );
          bulletsContentList[index] = updatedContent;

          // Refresh the list provider to notify listeners
          ref.invalidate(bulletsContentListProvider);
          // Also invalidate the specific item provider to ensure UI updates
          ref.invalidate(bulletsContentItemProvider(id));
        }
      };
    });
