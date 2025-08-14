import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Zoe/features/documents/data/document_data.dart';
import 'package:Zoe/features/documents/models/document_model.dart';

class DocumentNotifier extends StateNotifier<List<DocumentModel>> {
  DocumentNotifier() : super(documentList);

  void addDocument({
    required String title,
    required String parentId,
    required String sheetId,
    required String filePath,
    int? orderIndex,
  }) {

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
