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
        bullets: [
          BulletItem(title: 'The content with ID "$id" could not be found.'),
        ],
      );
    }
  },
);

// Provider to find a specific BulletItem by ID across all bullets content
final bulletItemProvider = Provider.family<BulletItem?, String>((
  ref,
  String bulletId,
) {
  final allBulletsContent = ref.watch(bulletsContentListProvider);

  for (final content in allBulletsContent) {
    for (final bullet in content.bullets) {
      if (bullet.id == bulletId) {
        return bullet;
      }
    }
  }

  return null; // Return null if not found
});

// Provider to find the parent BulletsContentModel for a specific BulletItem
final bulletItemParentProvider = Provider.family<BulletsContentModel?, String>((
  ref,
  String bulletId,
) {
  final allBulletsContent = ref.watch(bulletsContentListProvider);

  for (final content in allBulletsContent) {
    for (final bullet in content.bullets) {
      if (bullet.id == bulletId) {
        return content;
      }
    }
  }

  return null; // Return null if not found
});

// Direct update provider - saves immediately using StateNotifier
final bulletsContentUpdateProvider =
    Provider<void Function(String, {String? title, List<BulletItem>? bullets})>(
      (ref) {
        return (String contentId, {String? title, List<BulletItem>? bullets}) {
          // Update using the StateNotifier for immediate reactivity
          ref
              .read(bulletsContentListProvider.notifier)
              .updateContent(contentId, title: title, bullets: bullets);
        };
      },
    );
