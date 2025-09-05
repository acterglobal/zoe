import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/link/models/link_model.dart';
import 'package:zoe/features/link/providers/link_notifiers.dart';

class MockLinkNotifier extends LinkNotifier {
  MockLinkNotifier();

  void setLinks(List<LinkModel> links) {
    state = links;
  }

  @override
  void deleteLink(String linkId) {
    state = state.where((link) => link.id != linkId).toList();
  }
}

final mockLinkListProvider = StateNotifierProvider<LinkNotifier, List<LinkModel>>(
  (ref) => MockLinkNotifier(),
);

final mockLinkProvider = Provider.family<LinkModel?, String>((ref, linkId) {
  final linkList = ref.watch(mockLinkListProvider);
  return linkList.where((l) => l.id == linkId).firstOrNull;
}, dependencies: [mockLinkListProvider]);

final mockLinkListByParentProvider = Provider.family<List<LinkModel>, String>((
  ref,
  parentId,
) {
  final linkList = ref.watch(mockLinkListProvider);
  return linkList.where((l) => l.parentId == parentId).toList();
}, dependencies: [mockLinkListProvider]);

final mockLinkListSearchProvider = Provider<List<LinkModel>>((ref) {
  final linkList = ref.watch(mockLinkListProvider);
  final searchValue = ref.watch(searchValueProvider);
  if (searchValue.isEmpty) return linkList;
  return linkList
      .where((l) => l.title.toLowerCase().contains(searchValue.toLowerCase()))
      .toList();
}, dependencies: [mockLinkListProvider, searchValueProvider]);
