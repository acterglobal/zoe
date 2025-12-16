import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/documents/data/document_data.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

part 'document_providers.g.dart';

/// Main document list provider with all document management functionality
@Riverpod(keepAlive: true)
class DocumentList extends _$DocumentList {
  @override
  List<DocumentModel> build() => documentList;

  void addDocument({
    required String title,
    required String parentId,
    required String sheetId,
    required String filePath,
    int? orderIndex,
  }) {
    final userId = ref.read(currentUserProvider)?.id;
    if (userId == null) return;

    // Extract filename without extension for title
    final extractedTitle = title.contains('.')
        ? title.substring(0, title.lastIndexOf('.'))
        : title;

    final newDocument = DocumentModel(
      parentId: parentId,
      title: extractedTitle,
      sheetId: sheetId,
      filePath: filePath,
      orderIndex: orderIndex ?? 0,
      createdBy: userId,
    );
    state = [...state, newDocument];
  }

  void deleteDocument(String documentId) {
    state = state.where((d) => d.id != documentId).toList();
  }

  void updateDocumentTitle(String documentId, String title) {
    state = [
      for (final document in state)
        if (document.id == documentId)
          document.copyWith(title: title)
        else
          document,
    ];
  }

  void updateDocumentDescription(String documentId, Description description) {
    state = [
      for (final document in state)
        if (document.id == documentId)
          document.copyWith(description: description)
        else
          document,
    ];
  }

  void updateDocumentOrderIndex(String documentId, int orderIndex) {
    state = [
      for (final document in state)
        if (document.id == documentId)
          document.copyWith(orderIndex: orderIndex)
        else
          document,
    ];
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
