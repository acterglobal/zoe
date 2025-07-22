import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/models/base_content_model.dart';
import 'package:zoey/features/content/providers/notifiers/content_notifier.dart';

final contentNotifierProvider =
    StateNotifierProvider<ContentNotifier, List<ContentModel>>((ref) {
      return ContentNotifier();
    });

final contentByParentIdProvider = Provider.family<List<ContentModel>, String>((
  ref,
  parentId,
) {
  return ref.watch(contentNotifierProvider).where((content) {
    return content.parentId == parentId;
  }).toList();
});
