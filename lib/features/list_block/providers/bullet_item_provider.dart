import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/list_block/models/list_block_model.dart';
import 'package:zoey/features/list_block/providers/list_block_list_provider.dart';

final bulletItemProvider = Provider.family<BulletItem?, String>((
  ref,
  String bulletItemId,
) {
  final listBlocks = ref.watch(listBlockListProvider);

  return listBlocks
      .firstWhere((listBlock) => listBlock.id == bulletItemId)
      .bullets
      .firstWhere((bullet) => bullet.id == bulletItemId);
});
