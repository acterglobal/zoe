import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/list_block/models/list_block_model.dart';
import 'package:zoey/features/list_block/providers/list_block_list_provider.dart';

final bulletItemProvider = Provider.family<BulletItem?, String>((
  ref,
  String bulletItemId,
) {
  final listBlocks = ref.watch(listBlockListProvider);

  // Search through all list blocks to find the bullet item with the given ID
  for (final listBlock in listBlocks) {
    try {
      final bulletItem = listBlock.bullets.firstWhere(
        (bullet) => bullet.id == bulletItemId,
      );
      return bulletItem;
    } catch (e) {
      // Continue searching in other list blocks
      continue;
    }
  }

  // Return null if no matching bullet item is found in any list block
  return null;
});
