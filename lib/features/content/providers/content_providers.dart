import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/models/content_model.dart';
import 'package:zoey/features/text/providers/text_providers.dart';
import 'package:zoey/features/events/providers/events_proivder.dart';
import 'package:zoey/features/list/providers/list_providers.dart';

// Computed provider that combines data from individual module providers
final contentListProvider = Provider<List<ContentModel>>((ref) {
  final texts = ref.watch(textListProvider);
  final events = ref.watch(eventListProvider);
  final lists = ref.watch(listsrovider);
  return [...texts, ...events, ...lists];
});

final contentListByParentIdProvider =
    Provider.family<List<ContentModel>, String>((ref, parentId) {
      final contentList = ref.watch(contentListProvider);
      return contentList.where((content) {
        return content.parentId == parentId;
      }).toList();
    });

final contentProvider = Provider.family<ContentModel?, String>((
  ref,
  contentId,
) {
  final contentList = ref.watch(contentListProvider);
  return contentList.where((content) => content.id == contentId).firstOrNull;
});
