import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/features/link/providers/link_providers.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/text/providers/text_providers.dart';
import 'package:zoe/features/list/providers/list_providers.dart';

part 'content_providers.g.dart';

/// Computed provider that combines data from individual module providers
/// Sorted by orderIndex within each parent, then by createdAt as fallback
@riverpod
List<ContentModel> contentList(Ref ref) {
  final texts = ref.watch(textListProvider);
  final events = ref.watch(eventsListProvider);
  final lists = ref.watch(listsProvider);
  final bullets = ref.watch(bulletListProvider);
  final tasks = ref.watch(tasksListProvider);
  final links = ref.watch(linkListProvider);
  final polls = ref.watch(pollListProvider);
  final documents = ref.watch(documentListProvider);

  // Create a mutable list to allow sorting
  final allContent = <ContentModel>[
    ...texts,
    ...events,
    ...lists,
    ...bullets,
    ...tasks,
    ...links,
    ...polls,
    ...documents,
  ];

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
}

/// Provider for content filtered by parent ID
@riverpod
List<ContentModel> contentListByParentId(Ref ref, String parentId) {
  final contentList = ref.watch(contentListProvider);
  return contentList.where((content) => content.parentId == parentId).toList();
}

/// Provider for a single content by ID
@riverpod
ContentModel? content(Ref ref, String contentId) {
  final contentList = ref.watch(contentListProvider);
  return contentList.where((content) => content.id == contentId).firstOrNull;
}
