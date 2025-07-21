import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/list_block/data/list_block_list.dart';
import 'package:zoey/features/list_block/models/list_block_model.dart';

// StateNotifier provider for the list block list
final listBlockListProvider =
    StateNotifierProvider<ListBlockListNotifier, List<ListBlockModel>>((ref) {
      return ListBlockListNotifier();
    });

// StateNotifier for managing the list block list
class ListBlockListNotifier extends StateNotifier<List<ListBlockModel>> {
  ListBlockListNotifier() : super(listBlockList);

  // Update a specific list block item
  void updateBlock(String id, {String? title, List<BulletItem>? bullets}) {
    state = state.map((listBlock) {
      if (listBlock.id == id) {
        return listBlock.copyWith(
          title: title ?? listBlock.title,
          bullets: bullets ?? listBlock.bullets,
        );
      }
      return listBlock;
    }).toList();

    // Also update the original list to keep it in sync
    final index = listBlockList.indexWhere((element) => element.id == id);
    if (index != -1) {
      try {
        listBlockList[index] = state.firstWhere((element) => element.id == id);
      } catch (e) {
        // Handle case where element might not be found
        print(
          'Warning: Could not find list block with id $id to update in original list',
        );
      }
    }
  }

  // Add new list block
  void addBlock(ListBlockModel listBlock) {
    state = [...state, listBlock];
    listBlockList.add(listBlock);
  }

  // Remove list block
  void removeBlock(String id) {
    state = state.where((listBlock) => listBlock.id != id).toList();
    listBlockList.removeWhere((element) => element.id == id);
  }
}
