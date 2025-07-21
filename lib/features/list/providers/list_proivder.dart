import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/list/models/list_model.dart';
import 'package:zoey/features/list/providers/lists_provider.dart';

final listProvider = Provider.family<ListModel?, String>((ref, String listId) {
  final listBlocks = ref.watch(listsProvider);
  try {
    return listBlocks.firstWhere((list) => list.id == listId);
  } catch (e) {
    // Return null if no matching list block is found
    return null;
  }
});

final listTitleUpdateProvider = Provider<void Function(String, String)>((ref) {
  return (String blockId, String title) {
    ref.read(listsProvider.notifier).updateBlock(blockId, title: title);
  };
});

final listItemsUpdateProvider = Provider<void Function(String, List<String>)>((
  ref,
) {
  return (String blockId, List<String> bullets) {
    ref.read(listsProvider.notifier).updateBlock(blockId, bullets: bullets);
  };
});
