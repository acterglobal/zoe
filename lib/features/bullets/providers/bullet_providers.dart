import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/bullets/model/bullet_item_model.dart';
import 'package:zoey/features/bullets/providers/bullet_notifiers.dart';

final bulletListProvider =
    StateNotifierProvider<BulletNotifier, List<BulletItem>>(
      (ref) => BulletNotifier(),
    );

final bulletProvider = Provider.family<BulletItem?, String>((ref, bulletId) {
  final bulletList = ref.watch(bulletListProvider);
  return bulletList.where((b) => b.id == bulletId).firstOrNull;
});

final bulletListByListProvider = Provider.family<List<BulletItem>, String>((
  ref,
  listId,
) {
  final bulletList = ref.watch(bulletListProvider);
  return bulletList.where((b) => b.listId == listId).toList();
});
