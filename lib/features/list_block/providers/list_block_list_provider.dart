import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/list_block/data/list_blocks.dart';
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
  void updateBlock(String id, {String? title, List<String>? bullets}) {
    state = state.map((listBlock) {
      if (listBlock.id == id) {
        return listBlock.copyWith(title: title ?? listBlock.title);
      }
      return listBlock;
    }).toList();

    // Also update the original list to keep it in sync
    final index = listBlockList.indexWhere((element) => element.id == id);
    if (index != -1) {
      listBlockList[index] = state.firstWhere((element) => element.id == id);
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
