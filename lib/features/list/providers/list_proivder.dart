import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/providers/content_providers.dart';
import 'package:zoey/features/list/models/list_model.dart';
import 'package:zoey/features/list/providers/lists_provider.dart';

final listProvider = Provider.family<ListModel?, String>((ref, String listId) {
  try {
    return ref.watch(listsProvider).firstWhere((list) => list.id == listId);
  } catch (e) {
    return null;
  }
});

final listTitleUpdateProvider = Provider<void Function(String, String)>((ref) {
  return (String blockId, String title) {
    ref.read(contentListProvider.notifier).updateContentTitle(blockId, title);
  };
});

final deleteListProvider = Provider<void Function(String)>((ref) {
  return (String blockId) {
    ref.read(contentListProvider.notifier).deleteContent(blockId);
  };
});
