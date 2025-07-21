import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/list_block/models/list_block_model.dart';
import 'package:zoey/features/list_block/providers/list_block_list_provider.dart';

final listItemProvider = Provider.family<ListItem?, String>((
  ref,
  String listItemId,
) {
  final listBlocks = ref.watch(listBlockListProvider);

  // Find the list item across all list blocks
  for (final listBlock in listBlocks) {
    try {
      return listBlock.listItems.firstWhere(
        (listItem) => listItem.id == listItemId,
      );
    } catch (e) {
      // Continue searching in other list blocks
      continue;
    }
  }

  // Return null if no matching list item is found
  return null;
});
