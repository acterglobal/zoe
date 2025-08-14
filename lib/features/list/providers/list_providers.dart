import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/list/models/list_model.dart';
import 'package:zoe/features/list/providers/list_notifers.dart';

final listsrovider = StateNotifierProvider<ListNotifier, List<ListModel>>(
  (ref) => ListNotifier(),
);

final listItemProvider = Provider.family<ListModel?, String>((ref, listId) {
  final listList = ref.watch(listsrovider);
  return listList.where((l) => l.id == listId).firstOrNull;
});
