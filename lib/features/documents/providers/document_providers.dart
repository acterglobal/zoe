import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/documents/models/document_model.dart';
import 'package:zoey/features/documents/providers/document_notifiers.dart';

final documentListProvider =
    StateNotifierProvider<DocumentNotifier, List<DocumentModel>>(
      (ref) => DocumentNotifier(),
    );

final documentProvider = Provider.family<DocumentModel?, String>((ref, documentId) {
  final documentList = ref.watch(documentListProvider);
  return documentList.where((d) => d.id == documentId).firstOrNull;
});

final documentListByParentProvider = Provider.family<List<DocumentModel>, String>((
  ref,
  parentId,
) {
  final documentList = ref.watch(documentListProvider);
  return documentList.where((d) => d.parentId == parentId).toList();
});
