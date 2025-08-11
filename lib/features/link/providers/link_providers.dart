import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/link/models/link_model.dart';
import 'package:zoey/features/link/providers/link_notifiers.dart';

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
