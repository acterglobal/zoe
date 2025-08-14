import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Zoe/features/bullets/providers/bullet_providers.dart';
import 'package:Zoe/features/content/models/content_model.dart';
import 'package:Zoe/features/link/providers/link_providers.dart';
import 'package:Zoe/features/task/providers/task_providers.dart';
import 'package:Zoe/features/text/providers/text_providers.dart';
import 'package:Zoe/features/events/providers/events_proivder.dart';
import 'package:Zoe/features/list/providers/list_providers.dart';

// Computed provider that combines data from individual module providers
// Sorted by orderIndex within each parent, then by createdAt as fallback
final contentListProvider = Provider<List<ContentModel>>((ref) {
  final texts = ref.watch(textListProvider);
  final events = ref.watch(eventListProvider);
  final lists = ref.watch(listsrovider);
  final bullets = ref.watch(bulletListProvider);
  final tasks = ref.watch(taskListProvider);
  final links = ref.watch(linkListProvider);

  final allContent = [...texts, ...events, ...lists, ...bullets, ...tasks, ...links];
  // Sort by parentId first, then by orderIndex within parent, then by createdAt as fallback
  allContent.sort((a, b) {
    // First sort by parent
    final parentCompare = a.parentId.compareTo(b.parentId);
    if (parentCompare != 0) return parentCompare;

    // Within same parent, sort by orderIndex
    final orderCompare = a.orderIndex.compareTo(b.orderIndex);
    if (orderCompare != 0) return orderCompare;

    // If same orderIndex, sort by creation time as fallback
    return a.createdAt.compareTo(b.createdAt);
  });
  return allContent;
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
