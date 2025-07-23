import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/bullets/model/bullet_model.dart';
import 'package:zoey/features/bullets/providers/bullet_notifiers.dart';

final bulletListProvider =
    StateNotifierProvider<BulletNotifier, List<BulletModel>>(
      (ref) => BulletNotifier(),
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
  return bulletList.where((b) => b.parentId == parentId).toList();
});
