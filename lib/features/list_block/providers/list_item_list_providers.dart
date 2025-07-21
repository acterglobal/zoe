import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/list_block/models/list_block_model.dart';
import 'package:zoey/features/list_block/providers/list_block_list_provider.dart';

final listItemListProvider = Provider.family<List<BulletItem>, String>((
  ref,
  String listBlockId,
) {
  final listBlocks = ref.watch(listBlockListProvider);

  try {
    return listBlocks
        .firstWhere((listBlock) => listBlock.id == listBlockId)
        .bullets;
  } catch (e) {
    return [];
  }
});
