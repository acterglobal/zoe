import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/documents/data/document_data.dart';
import 'package:zoe/common/providers/common_providers.dart';
import '../../../test-utils/mock_searchValue.dart';

void main() {
  group('Document Providers Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test(
        overrides: [
          searchValueProvider.overrideWith(MockSearchValue.new),
        ],
      );
    });

    group('DocumentList Provider', () {
      test('initial state contains all documents', () {
        final documents = container.read(documentListProvider);
        
        expect(documents, isNotEmpty);
        expect(documents.length, equals(documentList.length));
      });

      test('addDocument adds new document to list', () {
        const title = 'Test Document.pdf';
        const parentId = 'parent-1';
        const sheetId = 'sheet-1';
        const filePath = '/path/to/test.pdf';
        const orderIndex = 5;

        container.read(documentListProvider.notifier).addDocument(
          title: title,
          parentId: parentId,
          sheetId: sheetId,
          filePath: filePath,      
          orderIndex: orderIndex,
        );

        final documents = container.read(documentListProvider);
        final addedDocument = documents.last;

        expect(documents.length, equals(documentList.length + 1));
        expect(addedDocument.title, equals('Test Document'));
        expect(addedDocument.parentId, equals(parentId));
        expect(addedDocument.sheetId, equals(sheetId));
        expect(addedDocument.filePath, equals(filePath));
        expect(addedDocument.orderIndex, equals(orderIndex));
      });

      test('deleteDocument removes document from list', () {
        final initialDocuments = container.read(documentListProvider);
        final documentToDelete = initialDocuments.first;

        container.read(documentListProvider.notifier).deleteDocument(documentToDelete.id);

        final updatedDocuments = container.read(documentListProvider);
        
        expect(updatedDocuments.length, equals(initialDocuments.length - 1));
        expect(updatedDocuments.any((d) => d.id == documentToDelete.id), isFalse);
      });

      test('updateDocumentTitle updates document title', () {
        final initialDocuments = container.read(documentListProvider);
        final documentToUpdate = initialDocuments.first;
        const newTitle = 'Updated Title';

        container.read(documentListProvider.notifier).updateDocumentTitle(
          documentToUpdate.id,
          newTitle,
        );

        final updatedDocuments = container.read(documentListProvider);
        final updatedDocument = updatedDocuments.firstWhere(
          (d) => d.id == documentToUpdate.id,
        );

        expect(updatedDocument.title, equals(newTitle));
        expect(updatedDocuments.length, equals(initialDocuments.length));
      });

      test('updateDocumentDescription updates document description', () {
        final initialDocuments = container.read(documentListProvider);
        final documentToUpdate = initialDocuments.first;
        const newDescription = (plainText: 'Updated description', htmlText: null);

        container.read(documentListProvider.notifier).updateDocumentDescription(
          documentToUpdate.id,
          newDescription,
        );

        final updatedDocuments = container.read(documentListProvider);
        final updatedDocument = updatedDocuments.firstWhere(
          (d) => d.id == documentToUpdate.id,
        );

        expect(updatedDocument.description, equals(newDescription));
        expect(updatedDocuments.length, equals(initialDocuments.length));
      });

      test('updateDocumentOrderIndex updates document order index', () {
        final initialDocuments = container.read(documentListProvider);
        final documentToUpdate = initialDocuments.first;
        const newOrderIndex = 99;

        container.read(documentListProvider.notifier).updateDocumentOrderIndex(
          documentToUpdate.id,
          newOrderIndex,
        );

        final updatedDocuments = container.read(documentListProvider);
        final updatedDocument = updatedDocuments.firstWhere(
          (d) => d.id == documentToUpdate.id,
        );

        expect(updatedDocument.orderIndex, equals(newOrderIndex));
        expect(updatedDocuments.length, equals(initialDocuments.length));
      });
    });

    group('Document Provider', () {
      test('document provider returns correct document by ID', () {
        final documents = container.read(documentListProvider);
        final targetDocument = documents.first;

        final result = container.read(documentProvider(targetDocument.id));

        expect(result, equals(targetDocument));
      });

      test('document provider returns null for non-existent ID', () {
        const nonExistentId = 'non-existent-id';

        final result = container.read(documentProvider(nonExistentId));

        expect(result, isNull);
      });
    });

    group('Document List By Parent', () {
      test('documentListByParent returns documents for specific parent', () {
        final allDocuments = container.read(documentListProvider);
        final targetParentId = allDocuments.first.parentId;

        final filteredDocuments = container.read(documentListByParentProvider(targetParentId));

        expect(filteredDocuments, isNotEmpty);
        expect(filteredDocuments.every((d) => d.parentId == targetParentId), isTrue);
      });

      test('documentListByParent returns empty list for non-existent parent', () {
        const nonExistentParentId = 'non-existent-parent';

        final filteredDocuments = container.read(documentListByParentProvider(nonExistentParentId));

        expect(filteredDocuments, isEmpty);
      });
    });

    group('Document List Search', () {
      test('documentListSearch returns all documents when search is empty', () {
        final allDocuments = container.read(documentListProvider);

        final searchResults = container.read(documentListSearchProvider);

        expect(searchResults.length, equals(allDocuments.length));
      });

      test('documentListSearch filters documents by title', () {
        final allDocuments = container.read(documentListProvider);
        final targetDocument = allDocuments.first;
        final searchTerm = targetDocument.title.substring(0, 3);

        // Update search value
        container.read(searchValueProvider.notifier).update(searchTerm);

        final searchResults = container.read(documentListSearchProvider);

        expect(searchResults, isNotEmpty);
        expect(searchResults.any((d) => d.id == targetDocument.id), isTrue);
      });

      test('documentListSearch returns empty list for non-matching search', () {
        const nonMatchingSearch = 'xyz123nonexistent';

        // Update search value
        container.read(searchValueProvider.notifier).update(nonMatchingSearch);

        final searchResults = container.read(documentListSearchProvider);

        expect(searchResults, isEmpty);
      });
    });
  });
}
