import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/list_block/models/list_block_model.dart';
import 'package:zoey/features/list_block/providers/list_block_proivder.dart';

final bulletListProvider = Provider.family<List<BulletItem>?, String>((
  ref,
  String listBlockId,
) {
  final listBlock = ref.watch(listBlockProvider(listBlockId));
  return listBlock?.bullets;
});
