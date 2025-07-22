import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/list/data/lists.dart';
import 'package:zoey/features/list/models/list_model.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';

class ListNotifier extends StateNotifier<List<ListModel>> {
  ListNotifier() : super(lists);

  void addList(ListModel list) {
    state = [...state, list];
  }

  void deleteList(String listId) {
    state = state.where((l) => l.id != listId).toList();
  }

  void updateListTitle(String listId, String title) {
    state = [
      for (final list in state)
        if (list.id == listId) list.copyWith(title: title) else list,
    ];
  }

  void updateListDescription(String listId, Description description) {
    state = [
      for (final list in state)
        if (list.id == listId)
          list.copyWith(description: description)
        else
          list,
    ];
  }

  void updateListEmoji(String listId, String emoji) {
    state = [
      for (final list in state)
        if (list.id == listId) list.copyWith(emoji: emoji) else list,
    ];
  }

  void updateListType(String listId, ListType listType) {
    state = [
      for (final list in state)
        if (list.id == listId) list.copyWith(listType: listType) else list,
    ];
  }
}
