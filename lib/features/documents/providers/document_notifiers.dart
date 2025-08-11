import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/documents/data/document_data.dart';
import 'package:zoey/features/documents/models/document_model.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';

class DocumentNotifier extends StateNotifier<List<DocumentModel>> {
  DocumentNotifier() : super(documentList);

  void addDocument({
    String title = '',
    required String parentId,
    required String sheetId,
    int? orderIndex,
  }) {
    final newDocument = DocumentModel(
      parentId: parentId,
      title: title,
      sheetId: sheetId,
      fileName: '',
      fileType: '',
      filePath: '',
      orderIndex: 0,
    );
    state = [...state, newDocument];
  }

  void updateDocumentFile(
    String documentId,
    String fileName,
    String fileType,
    String filePath,
  ) {
    state = [
      for (final document in state)
        if (document.id == documentId)
          document.copyWith(
            fileName: fileName,
            fileType: fileType,
            filePath: filePath,
            title: fileName, // Set title to filename by default
          )
        else
          document,
    ];
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

  void updateDocumentParentId(String documentId, String parentId) {
    state = [
      for (final document in state)
        if (document.id == documentId)
          document.copyWith(parentId: parentId)
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
