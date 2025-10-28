import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';


DocumentModel getDocumentByIndex(ProviderContainer container, {int index = 0}) {
  final documentList = container.read(documentListProvider);
  if (documentList.isEmpty) fail('Document list is empty');
  if (index < 0 || index >= documentList.length) {
    fail('Document index is out of bounds');
  }
  return documentList[index];
}
