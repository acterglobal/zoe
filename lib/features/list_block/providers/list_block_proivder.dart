import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/list_block/models/list_block_model.dart';
import 'package:zoey/features/list_block/providers/list_block_list_provider.dart';

final listBlockProvider = Provider.family<ListBlockModel?, String>((
  ref,
  String listBlockId,
) {
  final listBlocks = ref.watch(listBlockListProvider);
  try {
    return listBlocks.firstWhere((listBlock) => listBlock.id == listBlockId);
  } catch (e) {
    // Return null if no matching list block is found
    return null;
  }
});

final listBlockTitleUpdateProvider = Provider<void Function(String, String)>((
  ref,
) {
  return (String blockId, String title) {
    ref.read(listBlockListProvider.notifier).updateBlock(blockId, title: title);
  };
});

final listBlockBulletsUpdateProvider =
    Provider<void Function(String, List<BulletItem>)>((ref) {
      return (String blockId, List<BulletItem> bullets) {
        ref
            .read(listBlockListProvider.notifier)
            .updateBlock(blockId, bullets: bullets);
      };
    });
