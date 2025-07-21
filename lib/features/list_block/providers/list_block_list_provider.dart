import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/list_block/data/list_block_list.dart';
import 'package:zoey/features/list_block/models/list_block_model.dart';

// StateNotifier for managing the bullets content list
class BulletsContentListNotifier extends StateNotifier<List<ListBlockModel>> {
  BulletsContentListNotifier() : super(bulletsContentList);

  // Update a specific content item
  void updateContent(String id, {String? title, List<ListItem>? listItems}) {
    state = state.map((content) {
      if (content.id == id) {
        return content.copyWith(
          title: title ?? content.title,
          listItems: listItems ?? content.listItems,
        );
      }
      return content;
    }).toList();

    // Also update the original list to keep it in sync
    final index = bulletsContentList.indexWhere((element) => element.id == id);
    if (index != -1) {
      bulletsContentList[index] = state.firstWhere(
        (element) => element.id == id,
      );
    }
  }

  // Add new content
  void addContent(ListBlockModel content) {
    state = [...state, content];
    bulletsContentList.add(content);
  }

  // Remove content
  void removeContent(String id) {
    state = state.where((content) => content.id != id).toList();
    bulletsContentList.removeWhere((element) => element.id == id);
  }
}

// StateNotifier provider for the bullets content list
final bulletsContentListProvider =
    StateNotifierProvider<BulletsContentListNotifier, List<ListBlockModel>>((
      ref,
    ) {
      return BulletsContentListNotifier();
    });
