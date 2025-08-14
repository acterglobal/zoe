import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Zoe/features/link/data/link_list.dart';
import 'package:Zoe/features/link/models/link_model.dart';

class LinkNotifier extends StateNotifier<List<LinkModel>> {
  LinkNotifier() : super(linkList);

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
        if (link.id == linkId)
          link.copyWith(url: url)
        else
          link,
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
