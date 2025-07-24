import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/bullets/data/bullets.dart';
import 'package:zoey/features/bullets/model/bullet_model.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';

class BulletNotifier extends StateNotifier<List<BulletModel>> {
  BulletNotifier() : super(bulletList);

  void addBullet(String title, String parentId, String sheetId) {
    final newBullet = BulletModel(
      parentId: parentId,
      title: title,
      sheetId: sheetId,
    );
    state = [...state, newBullet];
  }

  void deleteBullet(String bulletId) {
    state = state.where((b) => b.id != bulletId).toList();
  }

  void updateBulletTitle(String bulletId, String title) {
    state = [
      for (final bullet in state)
        if (bullet.id == bulletId) bullet.copyWith(title: title) else bullet,
    ];
  }

  void updateBulletDescription(String bulletId, Description description) {
    state = [
      for (final bullet in state)
        if (bullet.id == bulletId)
          bullet.copyWith(description: description)
        else
          bullet,
    ];
  }

  void updateBulletParentId(String bulletId, String parentId) {
    state = [
      for (final bullet in state)
        if (bullet.id == bulletId)
          bullet.copyWith(parentId: parentId)
        else
          bullet,
    ];
  }

  void updateBulletOrderIndex(String bulletId, int orderIndex) {
    state = [
      for (final bullet in state)
        if (bullet.id == bulletId)
          bullet.copyWith(orderIndex: orderIndex)
        else
          bullet,
    ];
  }
}
