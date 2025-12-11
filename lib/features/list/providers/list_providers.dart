import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/constants/firestore_collection_constants.dart';
import 'package:zoe/constants/firestore_field_constants.dart';
import 'package:zoe/features/list/models/list_model.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

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

    _subscription = collection.snapshots().listen((snapshot) {
      state = snapshot.docs
          .map((doc) => ListModel.fromJson(doc.data()))
          .toList();
    });

    ref.onDispose(() => _subscription?.cancel());
    return [];
  }

  Future<void> addList(ListModel list) async {
    final userId = ref.read(loggedInUserProvider).value;
    if (userId == null) return;
    await collection
        .doc(list.id)
        .set(list.copyWith(createdBy: userId).toJson());
  }

  Future<void> deleteList(String listId) async {
    await collection.doc(listId).delete();
  }

  Future<void> updateListTitle(String listId, String title) async {
    await collection.doc(listId).update({
      FirestoreFieldConstants.title: title,
      FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateListDescription(
    String listId,
    Description description,
  ) async {
    await collection.doc(listId).update({
      FirestoreFieldConstants.description: {
        'plainText': description.plainText,
        'htmlText': description.htmlText,
      },
      FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateListEmoji(String listId, String emoji) async {
    await collection.doc(listId).update({
      FirestoreFieldConstants.emoji: emoji,
      FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateListOrderIndex(String listId, int orderIndex) async {
    await collection.doc(listId).update({
      FirestoreFieldConstants.orderIndex: orderIndex,
      FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
    });
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
