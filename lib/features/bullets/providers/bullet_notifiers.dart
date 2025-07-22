import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/bullets/data/bullets.dart';
import 'package:zoey/features/bullets/model/bullet_item_model.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';

class BulletNotifier extends StateNotifier<List<BulletItem>> {
  BulletNotifier() : super(bulletList);

  void addBullet(String title, String listId, String sheetId) {
    final newBullet = BulletItem(
      listId: listId,
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

  void updateBulletListId(String bulletId, String listId) {
    state = [
      for (final bullet in state)
        if (bullet.id == bulletId) bullet.copyWith(listId: listId) else bullet,
    ];
  }
}
