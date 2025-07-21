import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/list/data/list.dart';
import 'package:zoey/features/content/list/models/list_model.dart';

// StateNotifier provider for the list block list
final listsProvider = StateNotifierProvider<ListNotifier, List<ListModel>>(
  (ref) => ListNotifier(),
);

// StateNotifier for managing the list block list
class ListNotifier extends StateNotifier<List<ListModel>> {
  ListNotifier() : super(lists);

  // Update a specific list block item
  void updateBlock(String id, {String? title, List<String>? bullets}) {
    state = state.map((listBlock) {
      if (listBlock.id == id) {
        return listBlock.copyWith(title: title ?? listBlock.title);
      }
      return listBlock;
    }).toList();

    // Also update the original list to keep it in sync
    final index = lists.indexWhere((element) => element.id == id);
    if (index != -1) {
      lists[index] = state.firstWhere((element) => element.id == id);
    }
  }

  // Add new list block
  void addList(ListModel list) {
    state = [...state, list];
    lists.add(list);
  }

  // Remove list block
  void removeBlock(String id) {
    state = state.where((listBlock) => listBlock.id != id).toList();
    lists.removeWhere((element) => element.id == id);
  }
}
