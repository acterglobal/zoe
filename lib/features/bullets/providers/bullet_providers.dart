import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/features/bullets/data/bullets.dart';
import 'package:zoe/features/bullets/model/bullet_model.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';

part 'bullet_providers.g.dart';

/// Main bullet list notifier with all bullet management functionality
@Riverpod(keepAlive: true)
class BulletList extends _$BulletList {
  @override
  List<BulletModel> build() => bulletList;

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
    // Get the focus bullet id
    final focusBulletId = getFocusBulletId(bulletId);
    // Remove the bullet from the state
    state = state.where((b) => b.id != bulletId).toList();
    // Set the focus to the focus bullet
    ref.read(bulletFocusProvider.notifier).state = focusBulletId;
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

  String? getFocusBulletId(String bulletId) {
    // Get the bullet for the parent
    final bullet = state.where((b) => b.id == bulletId).firstOrNull;
    if (bullet == null) return null;
    final parentId = bullet.parentId;

    // Get the parent bullet list from current state
    final parentBullets = state.where((b) => b.parentId == parentId).toList()
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    // Get the current bullet index
    final currentBulletIndex = parentBullets.indexOf(bullet);
    // If the current bullet is the first bullet, try to return the next bullet
    if (currentBulletIndex <= 0) {
      // Check if there's a next bullet available
      if (currentBulletIndex < parentBullets.length - 1) {
        // Return the next bullet id
        return parentBullets[currentBulletIndex + 1].id;
      }
      return null;
    }
    // Return the previous bullet id
    return parentBullets[currentBulletIndex - 1].id;
  }
}

/// Provider for a single bullet by ID
@riverpod
BulletModel? bullet(Ref ref, String bulletId) {
  final bulletList = ref.watch(bulletListProvider);
  return bulletList.where((b) => b.id == bulletId).firstOrNull;
}

/// Provider for bullets filtered by parent ID
@riverpod
List<BulletModel> bulletListByParent(Ref ref, String parentId) {
  final bulletList = ref.watch(bulletListProvider);
  final filteredBullets = bulletList
      .where((b) => b.parentId == parentId)
      .toList();
  filteredBullets.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
  return filteredBullets;
}

/// Focus management for newly added bullets
@Riverpod(keepAlive: true)
class BulletFocus extends _$BulletFocus {
  @override
  String? build() => null;
}
