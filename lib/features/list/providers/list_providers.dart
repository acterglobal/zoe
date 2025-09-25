import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/list/data/lists.dart';
import 'package:zoe/features/list/models/list_model.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';

part 'list_providers.g.dart';

/// Main list provider with all list management functionality
@Riverpod(keepAlive: true)
class Lists extends _$Lists {
  @override
  List<ListModel> build() => lists;

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

  void updateListType(String listId, ContentType contentType) {
    state = [
      for (final list in state)
        if (list.id == listId) list.copyWith(listType: contentType) else list,
    ];
  }

  void updateListOrderIndex(String listId, int orderIndex) {
    state = [
      for (final list in state)
        if (list.id == listId) list.copyWith(orderIndex: orderIndex) else list,
    ];
  }
}

/// Provider for a single list item by ID
@riverpod
ListModel? listItem(Ref ref, String listId) {
  final listList = ref.watch(listsProvider);
  return listList.where((l) => l.id == listId).firstOrNull;
}

/// Provider for lists filtered by parent ID
@riverpod
List<ListModel> listByParent(Ref ref, String parentId) {
  final listList = ref.watch(listsProvider);
  return listList.where((l) => l.parentId == parentId).toList();
}

/// Provider for searching lists
@riverpod
List<ListModel> listSearch(Ref ref, String searchTerm) {
  final listList = ref.watch(listsProvider);
  if (searchTerm.isEmpty) return listList;
  return listList
      .where((l) => l.title.toLowerCase().contains(searchTerm.toLowerCase()))
      .toList();
}