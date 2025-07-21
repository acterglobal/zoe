import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/list_block/data/bullets.dart';
import 'package:zoey/features/list_block/models/bullet_item_model.dart';

final bulletListProvider =
    StateNotifierProvider<BulletListNotifier, List<BulletItem>>((ref) {
      return BulletListNotifier();
    });

final bulletListBySectionProvider = Provider.family<List<BulletItem>, String>((
  ref,
  String sectionId,
) {
  final bulletList = ref.watch(bulletListProvider);
  return bulletList
      .where((bullet) => bullet.sectionBlockId == sectionId)
      .toList();
});

class BulletListNotifier extends StateNotifier<List<BulletItem>> {
  BulletListNotifier() : super(bulletList);

  void updateBullet(String id, String title) {
    state = state.map((bullet) {
      if (bullet.id == id) {
        return bullet.copyWith(title: title);
      }
      return bullet;
    }).toList();
  }

  void deleteBullet(String id) {
    state = state.where((bullet) => bullet.id != id).toList();
  }

  void addBullet(String title, String sectionId) {
    state = [...state, BulletItem(title: title, sectionBlockId: sectionId)];
  }
}
