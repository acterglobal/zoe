import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/list/models/list_model.dart';
import 'package:zoe/features/list/providers/list_notifers.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';

class MockListNotifier extends ListNotifier {
  MockListNotifier(this.ref);

  final Ref ref;

  void setLists(List<ListModel> lists) {
    state = lists;
  }

  @override
  void addList(ListModel list) {
    state = [...state, list];
  }

  @override
  void deleteList(String listId) {
    state = state.where((l) => l.id != listId).toList();
  }

  @override
  void updateListTitle(String listId, String title) {
    state = [
      for (final list in state)
        if (list.id == listId) list.copyWith(title: title) else list,
    ];
  }

  @override
  void updateListDescription(String listId, Description description) {
    state = [
      for (final list in state)
        if (list.id == listId)
          list.copyWith(description: description)
        else
          list,
    ];
  }

  @override
  void updateListEmoji(String listId, String emoji) {
    state = [
      for (final list in state)
        if (list.id == listId) list.copyWith(emoji: emoji) else list,
    ];
  }

  @override
  void updateListType(String listId, ContentType contentType) {
    state = [
      for (final list in state)
        if (list.id == listId) list.copyWith(listType: contentType) else list,
    ];
  }

  @override
  void updateListOrderIndex(String listId, int orderIndex) {
    state = [
      for (final list in state)
        if (list.id == listId) list.copyWith(orderIndex: orderIndex) else list,
    ];
  }
}

final mockListsProvider = StateNotifierProvider<ListNotifier, List<ListModel>>(
  (ref) => MockListNotifier(ref),
);

final mockListItemProvider = Provider.family<ListModel?, String>((ref, listId) {
  final listList = ref.watch(mockListsProvider);
  return listList.where((l) => l.id == listId).firstOrNull;
}, dependencies: [mockListsProvider]);
