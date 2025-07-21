import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/list_block/models/list_block_model.dart';
import 'package:zoey/features/list_block/providers/bullet_list_providers.dart';

final bulletItemProvider = Provider.family<BulletItem?, String>((
  ref,
  String bulletItemId,
) {
  final bulletList = ref.watch(bulletListProvider(bulletItemId));
  if (bulletList == null) return null;

  try {
    return bulletList.firstWhere((bullet) => bullet.id == bulletItemId);
  } catch (e) {
    // Return null if no matching bullet item is found
    return null;
  }
});
