import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/bullets/data/bullets.dart';
import 'package:zoey/features/bullets/model/bullet_model.dart';
import 'package:zoey/features/bullets/providers/bullet_providers.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';

class BulletNotifier extends StateNotifier<List<BulletModel>> {
  Ref ref;
  BulletNotifier(this.ref) : super(bulletList);

  void addBullet({
    String title = '',
    required String parentId,
    required String sheetId,
    int? orderIndex,
  }) {
    // Single pass optimization: collect parent bullets and determine new orderIndex
    int newOrderIndex;
    Map<String, BulletModel> bulletsToUpdate = {};

    if (orderIndex == null) {
      // Find max orderIndex for this parent in a single pass
      int maxOrderIndex = -1;
      for (final bullet in state) {
        if (bullet.parentId == parentId && bullet.orderIndex > maxOrderIndex) {
          maxOrderIndex = bullet.orderIndex;
        }
      }
      newOrderIndex = maxOrderIndex + 1;
    } else {
      // Collect bullets that need orderIndex updates in a single pass
      newOrderIndex = orderIndex;
      for (final bullet in state) {
        if (bullet.parentId == parentId && bullet.orderIndex >= orderIndex) {
          bulletsToUpdate[bullet.id] = bullet.copyWith(
            orderIndex: bullet.orderIndex + 1,
          );
        }
      }
    }

    // Create the new bullet
    final newBullet = BulletModel(
      parentId: parentId,
      title: title,
      sheetId: sheetId,
      orderIndex: newOrderIndex,
    );

    // Update state efficiently
    if (orderIndex == null) {
      // Simple append - no need to update existing bullets
      state = [...state, newBullet];
    } else {
      // Replace existing bullets with updated ones and add new bullet
      final updatedState = <BulletModel>[];

      // Single pass to build new state with O(1) lookup
      for (final bullet in state) {
        final updatedBullet = bulletsToUpdate[bullet.id];
        updatedState.add(updatedBullet ?? bullet);
      }
      updatedState.add(newBullet);
      state = updatedState;
      ref.read(bulletFocusProvider.notifier).state = newBullet.id;
    }
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
