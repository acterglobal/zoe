import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Zoe/common/providers/common_providers.dart';
import 'package:Zoe/features/link/models/link_model.dart';
import 'package:Zoe/features/link/providers/link_notifiers.dart';

final linkListProvider = StateNotifierProvider<LinkNotifier, List<LinkModel>>(
  (ref) => LinkNotifier(),
);

final linkProvider = Provider.family<LinkModel?, String>((ref, linkId) {
  final linkList = ref.watch(linkListProvider);
  return linkList.where((l) => l.id == linkId).firstOrNull;
});

final linkByParentProvider = Provider.family<List<LinkModel>, String>((
  ref,
  parentId,
) {
  final linkList = ref.watch(linkListProvider);
  return linkList.where((l) => l.parentId == parentId).toList();
});

final linkListSearchProvider = Provider<List<LinkModel>>((ref) {
  final linkList = ref.watch(linkListProvider);
  final searchValue = ref.watch(searchValueProvider);
  if (searchValue.isEmpty) return linkList;
  return linkList
      .where((l) => l.title.toLowerCase().contains(searchValue.toLowerCase()) ||
                    l.url.toLowerCase().contains(searchValue.toLowerCase()))
      .toList();
});
