import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/firestore_error_handler.dart';
import 'package:zoe/features/bullets/model/bullet_model.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/constants/firestore_collection_constants.dart';
import 'package:zoe/constants/firestore_field_constants.dart';

part 'bullet_providers.g.dart';

/// Main bullet list notifier with all bullet management functionality
@Riverpod(keepAlive: true)
class BulletList extends _$BulletList {
  StreamSubscription? _subscription;

  CollectionReference<Map<String, dynamic>> get collection =>
      ref.read(firestoreProvider).collection(FirestoreCollections.bullets);

  @override
  List<BulletModel> build() {
    _subscription?.cancel();
    _subscription = null;

    _subscription = collection.snapshots().listen(
      (snapshot) {
        state = snapshot.docs
            .map((doc) => BulletModel.fromJson(doc.data()))
            .toList();
      },
      onError: (error, stackTrace) =>
          runFirestoreOperation(ref, () => throw error),
    );

    ref.onDispose(() => _subscription?.cancel());
    return [];
  }

  Future<void> addBullet({
    String title = '',
    required String parentId,
    required String sheetId,
    int? orderIndex,
  }) async {
    final userId = ref.read(loggedInUserProvider).value;
    if (userId == null) return;

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
      createdBy: userId,
    );

    // Persist to Firebase
    await runFirestoreOperation(ref, () async {
      // Add the new bullet
      await collection.doc(newBullet.id).set(newBullet.toJson());

      // Update orderIndex for affected bullets if needed
      if (bulletsToUpdate.isNotEmpty) {
        final batch = ref.read(firestoreProvider).batch();
        for (final entry in bulletsToUpdate.entries) {
          batch.update(collection.doc(entry.key), {
            FirestoreFieldConstants.orderIndex: entry.value.orderIndex,
            FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
          });
        }
        await batch.commit();
      }
      // Set the focus to the new bullet
      ref.read(bulletFocusProvider.notifier).state = newBullet.id;
    });
  }

  Future<void> deleteBullet(String bulletId) async {
    // Get the focus bullet id
    final focusBulletId = getFocusBulletId(bulletId);
    // Persist to Firebase
    await runFirestoreOperation(ref, () async {
      await collection.doc(bulletId).delete();
      // Set the focus to the focus bullet
      ref.read(bulletFocusProvider.notifier).state = focusBulletId;
    });
  }

  Future<void> updateBulletTitle(String bulletId, String title) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(bulletId).update({
        FirestoreFieldConstants.title: title,
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> updateBulletDescription(
    String bulletId,
    Description description,
  ) async {
    // Persist to Firebase
    await runFirestoreOperation(
      ref,
      () => collection.doc(bulletId).update({
        FirestoreFieldConstants.description: {
          FirestoreFieldConstants.plainText: description.plainText,
          FirestoreFieldConstants.htmlText: description.htmlText,
        },
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> updateBulletOrderIndex(String bulletId, int orderIndex) async {
    // Persist to Firebase
    await runFirestoreOperation(
      ref,
      () => collection.doc(bulletId).update({
        FirestoreFieldConstants.orderIndex: orderIndex,
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
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
