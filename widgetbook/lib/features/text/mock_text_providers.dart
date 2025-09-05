import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/text/models/text_model.dart';
import 'package:zoe/features/text/providers/text_notifiers.dart';

class MockTextNotifier extends TextNotifier {
   MockTextNotifier(ref);

  void setTexts(List<TextModel> texts) {
    state = texts;
  }
}

final mockTextListProvider = StateNotifierProvider<TextNotifier, List<TextModel>>(
  (ref) => MockTextNotifier(ref),
);

final mockTextProvider = Provider.family<TextModel?, String>((ref, textId) {
  final textList = ref.watch(mockTextListProvider);
  return textList.where((t) => t.id == textId).firstOrNull;
}, dependencies: [mockTextListProvider]);

final mockTextByParentProvider = Provider.family<List<TextModel>, String>((
  ref,
  parentId,
) {
  final textList = ref.watch(mockTextListProvider);
  return textList.where((t) => t.parentId == parentId).toList();
}, dependencies: [mockTextListProvider]);

final mockTextListSearchProvider = Provider<List<TextModel>>((ref) {
  final textList = ref.watch(mockTextListProvider);
  final searchValue = ref.watch(searchValueProvider);
  if (searchValue.isEmpty) return textList;
  return textList
      .where((t) => t.title.toLowerCase().contains(searchValue.toLowerCase()))
      .toList();
}, dependencies: [mockTextListProvider, searchValueProvider]);
