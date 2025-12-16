import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/link/data/link_list.dart';
import 'package:zoe/features/link/models/link_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

part 'link_providers.g.dart';

/// Main link list provider with all link management functionality
@Riverpod(keepAlive: true)
class LinkList extends _$LinkList {
  @override
  List<LinkModel> build() => linkList;

  void addLink(LinkModel link) {
    state = [...state, link];
  }

  void deleteLink(String linkId) {
    state = state.where((l) => l.id != linkId).toList();
  }

  void updateLinkTitle(String linkId, String title) {
    state = [
      for (final link in state)
        if (link.id == linkId) link.copyWith(title: title) else link,
    ];
  }

  void updateLinkUrl(String linkId, String url) {
    state = [
      for (final link in state)
        if (link.id == linkId) link.copyWith(url: url) else link,
    ];
  }

  void updateLinkEmoji(String linkId, String emoji) {
    state = [
      for (final link in state)
        if (link.id == linkId) link.copyWith(emoji: emoji) else link,
    ];
  }

  void updateLinkOrderIndex(String linkId, int orderIndex) {
    state = [
      for (final link in state)
        if (link.id == linkId) link.copyWith(orderIndex: orderIndex) else link,
    ];
  }
}

/// Provider for a single link by ID
@riverpod
LinkModel? link(Ref ref, String linkId) {
  final linkList = ref.watch(linkListProvider);
  return linkList.where((l) => l.id == linkId).firstOrNull;
}

/// Provider for links filtered by parent ID
@riverpod
List<LinkModel> linkByParent(Ref ref, String parentId) {
  final linkList = ref.watch(linkListProvider);
  return linkList.where((l) => l.parentId == parentId).toList();
}

/// Provider for searching links
@riverpod
List<LinkModel> linkListSearch(Ref ref) {
  final allLinks = ref.watch(linkListProvider);
  final searchValue = ref.watch(searchValueProvider);
  final currentUser = ref.watch(currentUserProvider);

  if (currentUser == null || currentUser.id.isEmpty) return [];

  final memberLinks = allLinks.where((l) {
    final sheet = ref.watch(sheetProvider(l.sheetId));
    return sheet?.users.contains(currentUser.id) == true;
  });

  if (searchValue.isEmpty) return memberLinks.toList();
  return memberLinks
      .where(
        (l) =>
            l.title.toLowerCase().contains(searchValue.toLowerCase()) ||
            l.url.toLowerCase().contains(searchValue.toLowerCase()),
      )
      .toList();
}
