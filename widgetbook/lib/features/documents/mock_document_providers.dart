import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/providers/document_notifiers.dart';

class MockDocumentNotifier extends DocumentNotifier {
  MockDocumentNotifier();

  void setDocuments(List<DocumentModel> documents) {
    state = documents;
  }

  @override
  void deleteDocument(String documentId) {
    state = state.where((doc) => doc.id != documentId).toList();
  }
}

final mockDocumentListProvider = StateNotifierProvider<DocumentNotifier, List<DocumentModel>>(
  (ref) => MockDocumentNotifier(),
);

final mockDocumentProvider = Provider.family<DocumentModel?, String>((ref, documentId) {
  final documentList = ref.watch(mockDocumentListProvider);
  return documentList.where((d) => d.id == documentId).firstOrNull;
}, dependencies: [mockDocumentListProvider]);

final mockDocumentListByParentProvider = Provider.family<List<DocumentModel>, String>((ref, parentId) {
  final documentList = ref.watch(mockDocumentListProvider);
  return documentList.where((d) => d.parentId == parentId).toList();
}, dependencies: [mockDocumentListProvider]);

final mockDocumentListBySheetIdProvider = Provider.family<List<DocumentModel>, String>((ref, sheetId) {
  final documentList = ref.watch(mockDocumentListProvider);
  return documentList.where((d) => d.sheetId == sheetId).toList();
}, dependencies: [mockDocumentListProvider]);

final mockDocumentListSearchProvider = Provider<List<DocumentModel>>((ref) {
  final documentList = ref.watch(mockDocumentListProvider);
  final searchValue = ref.watch(searchValueProvider);
  if (searchValue.isEmpty) return documentList;
  return documentList
      .where((d) => d.title.toLowerCase().contains(searchValue.toLowerCase()))
      .toList();
}, dependencies: [mockDocumentListProvider, searchValueProvider]);
