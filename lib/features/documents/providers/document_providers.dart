import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/firebase_utils.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/core/constants/firestore_constants.dart';

part 'document_providers.g.dart';

/// Main document list provider with all document management functionality
@Riverpod(keepAlive: true)
class DocumentList extends _$DocumentList {
  StreamSubscription? _subscription;

  CollectionReference<Map<String, dynamic>> get collection =>
      ref.read(firestoreProvider).collection(FirestoreCollections.documents);

  @override
  List<DocumentModel> build() {
    _subscription?.cancel();
    _subscription = null;

    final sheetIds = ref.watch(listOfSheetIdsProvider);
    Query<Map<String, dynamic>> query = collection;
    if (sheetIds.isNotEmpty) {
      query = query.where(
        whereInFilter(FirestoreFieldConstants.sheetId, sheetIds),
      );
    }

    _subscription = query.snapshots().listen((snapshot) {
      state = snapshot.docs
          .map((doc) => DocumentModel.fromJson(doc.data()))
          .toList();
    });

    ref.onDispose(() => _subscription?.cancel());
    return [];
  }

  Future<void> addDocument({
    required String title,
    required String parentId,
    required String sheetId,
    required String filePath,
    int? orderIndex,
  }) async {
    final userId = ref.read(currentUserProvider)?.id;
    if (userId == null) return;

    await runFirestoreOperation(ref, () async {
      // Extract filename without extension for title
      final extractedTitle = title.contains('.')
          ? title.substring(0, title.lastIndexOf('.'))
          : title;

      final uploadedFileUrl = await uploadFileToStorage(
        ref: ref,
        bucketName: FirestoreBucketNames.documents,
        file: XFile(filePath),
      );
      if (uploadedFileUrl == null) return;

      final newDocument = DocumentModel(
        parentId: parentId,
        title: extractedTitle,
        sheetId: sheetId,
        filePath: uploadedFileUrl,
        orderIndex: orderIndex ?? 0,
        createdBy: userId,
      );

      await collection.doc(newDocument.id).set(newDocument.toJson());
    });
  }

  Future<void> deleteDocument(DocumentModel document) async {
    await runFirestoreOperation(ref, () async {
      if (document.filePath.isNotEmpty) {
        await deleteFileFromStorage(ref: ref, fileUrl: document.filePath);
      }
      await collection.doc(document.id).delete();
    });
  }

  Future<void> updateDocumentOrderIndex(
    String documentId,
    int orderIndex,
  ) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(documentId).update({
        FirestoreFieldConstants.orderIndex: orderIndex,
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }
}

/// Provider for a single document by ID
@riverpod
DocumentModel? document(Ref ref, String documentId) {
  final documentList = ref.watch(documentListProvider);
  return documentList.where((d) => d.id == documentId).firstOrNull;
}

/// Provider for documents filtered by parent ID
@riverpod
List<DocumentModel> documentListByParent(Ref ref, String parentId) {
  final documentList = ref.watch(documentListProvider);
  return documentList.where((d) => d.parentId == parentId).toList();
}

/// Provider for searching documents
@riverpod
List<DocumentModel> documentListSearch(Ref ref) {
  final allDocuments = ref.watch(documentListProvider);
  final searchValue = ref.watch(searchValueProvider);
  final currentUser = ref.watch(currentUserProvider);

  if (currentUser == null || currentUser.id.isEmpty) return [];

  final memberDocs = allDocuments.where((d) {
    final sheet = ref.watch(sheetProvider(d.sheetId));
    return sheet?.users.contains(currentUser.id) == true;
  });

  if (searchValue.isEmpty) return memberDocs.toList();
  return memberDocs
      .where((d) => d.title.toLowerCase().contains(searchValue.toLowerCase()))
      .toList();
}
