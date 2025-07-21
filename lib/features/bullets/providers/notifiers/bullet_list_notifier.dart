import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/bullets/data/bullets.dart';
import 'package:zoey/features/bullets/model/bullet_item_model.dart';

class BulletListNotifier extends StateNotifier<List<BulletItem>> {
  BulletListNotifier() : super(bulletList);

  // Update the title of a bullet item
  void updateBullet(String id, String title) {
    state = state.map((bullet) {
      if (bullet.id == id) {
        return bullet.copyWith(title: title);
      }
      return bullet;
    }).toList();
  }

  // Delete a bullet item
  void deleteBullet(String bulletId) {
    state = state.where((bullet) => bullet.id != bulletId).toList();
  }

  // Add a bullet item
  String addBullet(String title, String blockId) {
    final newBullet = BulletItem(title: title, blockId: blockId);
    state = [...state, newBullet];
    return newBullet.id;
  }
}
