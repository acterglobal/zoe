import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/list_block/models/list_block_model.dart';
import 'package:zoey/features/list_block/providers/list_block_list_provider.dart';

final bulletsContentItemProvider = Provider.family<ListBlockModel, String>((
  ref,
  String id,
) {
  try {
    return ref
        .watch(bulletsContentListProvider)
        .firstWhere((element) => element.id == id);
  } catch (e) {
    // Return a default bullets content if ID not found
    return ListBlockModel(
      parentId: 'default',
      id: id,
      title: 'Content not found',
      listItems: [
        ListItem(title: 'The content with ID "$id" could not be found.'),
      ],
    );
  }
});

// Provider to find a specific BulletItem by ID across all bullets content
final listItemProvider = Provider.family<ListItem?, String>((
  ref,
  String listItemId,
) {
  final allBulletsContent = ref.watch(bulletsContentListProvider);

  for (final content in allBulletsContent) {
    for (final listItem in content.listItems) {
      if (listItem.id == listItemId) {
        return listItem;
      }
    }
  }

  return null; // Return null if not found
});

// Provider to find the parent BulletsContentModel for a specific BulletItem
final listItemParentProvider = Provider.family<ListBlockModel?, String>((
  ref,
  String listItemId,
) {
  final allBulletsContent = ref.watch(bulletsContentListProvider);

  for (final content in allBulletsContent) {
    for (final listItem in content.listItems) {
      if (listItem.id == listItemId) {
        return content;
      }
    }
  }

  return null; // Return null if not found
});

// Direct update provider - saves immediately using StateNotifier
final bulletsContentUpdateProvider =
    Provider<void Function(String, {String? title, List<ListItem>? listItems})>(
      (ref) {
        return (String contentId, {String? title, List<ListItem>? listItems}) {
          // Update using the StateNotifier for immediate reactivity
          ref
              .read(bulletsContentListProvider.notifier)
              .updateContent(contentId, title: title, listItems: listItems);
        };
      },
    );
