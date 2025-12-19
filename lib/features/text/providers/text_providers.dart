import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/firebase_utils.dart';
import 'package:zoe/core/constants/firestore_constants.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/text/models/text_model.dart';

import '../../sheet/models/sheet_model.dart';

part 'text_providers.g.dart';

@Riverpod(keepAlive: true)
class TextList extends _$TextList {
  CollectionReference<Map<String, dynamic>> get collection =>
      ref.read(firestoreProvider).collection(FirestoreCollections.texts);

  StreamSubscription? _subscription;

  @override
  List<TextModel> build() {
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
            .map((doc) => TextModel.fromJson(doc.data()))
            .toList();
      },
      /*onError: (error, stackTrace) => runFirestoreOperation(
        ref,
        () => Error.throwWithStackTrace(error, stackTrace),
      ),*/
    );

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return [];
  }

  Future<void> addText(TextModel text) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(text.id).set(text.toJson()),
    );
  }

  Future<void> deleteText(String textId) async {
    await runFirestoreOperation(ref, () => collection.doc(textId).delete());
  }

  Future<void> updateTextTitle(String textId, String title) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(textId).update({
        FirestoreFieldConstants.title: title,
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> updateTextEmoji(String textId, String? emoji) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(textId).update({
        FirestoreFieldConstants.emoji: emoji,
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> updateTextDescription(String textId, Description desc) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(textId).update({
        FirestoreFieldConstants.description: {
          FirestoreFieldConstants.plainText: desc.plainText,
          FirestoreFieldConstants.htmlText: desc.htmlText,
        },
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> updateTextOrderIndex(String textId, int orderIndex) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(textId).update({
        FirestoreFieldConstants.orderIndex: orderIndex,
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }
}

/// Provider for a single text by ID
@riverpod
TextModel? text(Ref ref, String textId) {
  final textList = ref.watch(textListProvider);
  return textList.where((t) => t.id == textId).firstOrNull;
}

/// Provider for texts filtered by parent ID
@riverpod
List<TextModel> textByParent(Ref ref, String parentId) {
  final textList = ref.watch(textListProvider);
  final filteredTexts = textList.where((t) => t.parentId == parentId).toList();
  filteredTexts.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
  return filteredTexts;
}

/// Provider for searching texts
@riverpod
List<TextModel> textListSearch(Ref ref, String searchTerm) {
  final textList = ref.watch(textListProvider);
  if (searchTerm.isEmpty) return textList;
  return textList
      .where((t) => t.title.toLowerCase().contains(searchTerm.toLowerCase()))
      .toList();
}

/// Provider for sorted texts
@riverpod
List<TextModel> sortedTexts(Ref ref) {
  final texts = ref.watch(textListProvider);
  return [...texts]..sort((a, b) => a.title.compareTo(b.title));
}
