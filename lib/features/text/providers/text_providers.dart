import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/text/models/text_model.dart';
import 'package:zoe/features/text/providers/text_notifiers.dart';

final textListProvider = StateNotifierProvider<TextNotifier, List<TextModel>>(
  (ref) => TextNotifier(),
);

final textProvider = Provider.family<TextModel?, String>((ref, textId) {
  final textList = ref.watch(textListProvider);
  return textList.where((t) => t.id == textId).firstOrNull;
});

final textByParentProvider = Provider.family<List<TextModel>, String>((
  ref,
  parentId,
) {
  final textList = ref.watch(textListProvider);
  return textList.where((t) => t.parentId == parentId).toList();
});
