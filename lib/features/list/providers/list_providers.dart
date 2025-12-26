import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/common/actions/firestore_actions.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/firebase_utils.dart';
import 'package:zoe/core/constants/firestore_constants.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/list/models/list_model.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';

part 'list_providers.g.dart';

/// Main list provider with all list management functionality
@Riverpod(keepAlive: true)
class Lists extends _$Lists {
  StreamSubscription? _subscription;

  CollectionReference<Map<String, dynamic>> get collection =>
      ref.read(firestoreProvider).collection(FirestoreCollections.lists);

  @override
  List<ListModel> build() {
    _subscription?.cancel();
    _subscription = null;

    final sheetIds = ref.watch(listOfSheetIdsProvider);
    Query<Map<String, dynamic>> query = collection;
    if (sheetIds.isNotEmpty) {
      query = query.where(
        whereInFilter(FirestoreFieldConstants.sheetId, sheetIds),
      );
    }

    _subscription = query.snapshots().listen(
      (snapshot) {
        state = snapshot.docs
            .map((doc) => ListModel.fromJson(doc.data()))
            .toList();
      },
      /*onError: (error, stackTrace) => runFirestoreOperation(
        ref,
        () => Error.throwWithStackTrace(error, stackTrace),
      ),*/
    );

    ref.onDispose(() => _subscription?.cancel());
    return [];
  }

  Future<void> addList(ListModel list) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(list.id).set(list.toJson()),
    );
  }

  Future<void> deleteList(ListModel list) async {
    await runFirestoreOperation(ref, () async {
      final listId = list.id;
      final listType = list.listType;

      String? collectionName;
      if (listType == ContentType.task) {
        collectionName = FirestoreCollections.tasks;
      } else if (listType == ContentType.bullet) {
        collectionName = FirestoreCollections.bullets;
      } else if (listType == ContentType.document) {
        collectionName = FirestoreCollections.documents;
      }

      if (collectionName != null) {
        // Delete all content related to the list
        await runFirestoreDeleteContentOperation(
          ref: ref,
          collectionName: collectionName,
          fieldName: FirestoreFieldConstants.parentId,
          isEqualTo: listId,
        );
      }

      await collection.doc(listId).delete();
    });
  }

  Future<void> updateListTitle(String listId, String title) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(listId).update({
        FirestoreFieldConstants.title: title,
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> updateListDescription(
    String listId,
    Description description,
  ) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(listId).update({
        FirestoreFieldConstants.description: {
          FirestoreFieldConstants.plainText: description.plainText,
          FirestoreFieldConstants.htmlText: description.htmlText,
        },
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> updateListEmoji(String listId, String emoji) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(listId).update({
        FirestoreFieldConstants.emoji: emoji,
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> updateListOrderIndex(String listId, int orderIndex) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(listId).update({
        FirestoreFieldConstants.orderIndex: orderIndex,
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }
}

/// Provider for a single list item by ID
@riverpod
ListModel? listItem(Ref ref, String listId) {
  final listList = ref.watch(listsProvider);
  return listList.where((l) => l.id == listId).firstOrNull;
}

/// Provider for lists filtered by parent ID
@riverpod
List<ListModel> listByParent(Ref ref, String parentId) {
  final listList = ref.watch(listsProvider);
  return listList.where((l) => l.parentId == parentId).toList();
}

/// Provider for searching lists
@riverpod
List<ListModel> listSearch(Ref ref, String searchTerm) {
  final listList = ref.watch(listsProvider);
  if (searchTerm.isEmpty) return listList;
  return listList
      .where((l) => l.title.toLowerCase().contains(searchTerm.toLowerCase()))
      .toList();
}
