import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Zoe/features/bullets/model/bullet_model.dart';
import 'package:Zoe/features/bullets/providers/bullet_notifiers.dart';

final bulletListProvider =
    StateNotifierProvider<BulletNotifier, List<BulletModel>>(
      (ref) => BulletNotifier(ref),
    );

final bulletProvider = Provider.family<BulletModel?, String>((ref, bulletId) {
  final bulletList = ref.watch(bulletListProvider);
  return bulletList.where((b) => b.id == bulletId).firstOrNull;
});

final bulletListByParentProvider = Provider.family<List<BulletModel>, String>((
  ref,
  parentId,
) {
  final bulletList = ref.watch(bulletListProvider);
  final filteredBullets = bulletList
      .where((b) => b.parentId == parentId)
      .toList();
  filteredBullets.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
  return filteredBullets;
});

// Focus management for newly added bullets
final bulletFocusProvider = StateProvider<String?>((ref) => null);
