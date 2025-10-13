import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/data/document_data.dart';
import 'package:zoe/features/documents/widgets/document_list_widget.dart';
import 'package:zoe/features/documents/widgets/document_widget.dart';
import '../../../test-utils/test_utils.dart';

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  group('DocumentListWidget Tests', () {
    late ProviderContainer container;
    late MockGoRouter mockGoRouter;
    late Provider<List<DocumentModel>> documentsProvider;

    setUp(() {
      container = ProviderContainer.test();
      mockGoRouter = MockGoRouter();
      
      // Create a test documents provider
      documentsProvider = Provider<List<DocumentModel>>((ref) => []);
    });

    testWidgets('renders empty state when documents list is empty', (tester) async {
      const customEmptyState = Text('No documents found');

      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentListWidget(
            documentsProvider: documentsProvider,
            isEditing: false,
            emptyState: customEmptyState,
          ),
        ),
        container: container,
        router: mockGoRouter,
      );

      expect(find.text('No documents found'), findsOneWidget);
    });

    testWidgets('renders documents when list is not empty', (tester) async {
      // Use existing documents from document_data.dart
      final testDocuments = documentList.take(2).toList();

      // Override the provider with test documents
      container = ProviderContainer.test(
        overrides: [
          documentsProvider.overrideWith((ref) => testDocuments),
        ],
      );

      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentListWidget(
            documentsProvider: documentsProvider,
            isEditing: false,
          ),
        ),
        container: container,
        router: mockGoRouter,
      );

      // Should render the document list
      expect(find.byType(DocumentListWidget), findsOneWidget);
    });

    testWidgets('shows section header when showSectionHeader is true', (tester) async {
      // Use existing documents from document_data.dart
      final testDocuments = documentList.take(1).toList();

      // Override the provider with test documents
      container = ProviderContainer.test(
        overrides: [
          documentsProvider.overrideWith((ref) => testDocuments),
        ],
      );

      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentListWidget(
            documentsProvider: documentsProvider,
            isEditing: false,
            showSectionHeader: true,
          ),
        ),
        container: container,
        router: mockGoRouter,
      );

      // Should show section header
      expect(find.byType(Column), findsAtLeastNWidgets(1));
    });

    testWidgets('limits documents when maxItems is specified', (tester) async {
      // Use existing documents from document_data.dart
      final testDocuments = documentList.take(5).toList();

      // Override the provider with test documents
      container = ProviderContainer.test(
        overrides: [
          documentsProvider.overrideWith((ref) => testDocuments),
        ],
      );

      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentListWidget(
            documentsProvider: documentsProvider,
            isEditing: false,
            maxItems: 3,
          ),
        ),
        container: container,
        router: mockGoRouter,
      );

      // Should render the document list with limited items
      expect(find.byType(DocumentListWidget), findsOneWidget);
      
      // Should render exactly 3 DocumentWidget instances (limited by maxItems)
      expect(find.byType(DocumentWidget), findsNWidgets(3));
    });

    testWidgets('renders vertical layout when isVertical is true', (tester) async {
      // Use existing documents from document_data.dart
      final testDocuments = documentList.take(1).toList();

      // Override the provider with test documents
      container = ProviderContainer.test(
        overrides: [
          documentsProvider.overrideWith((ref) => testDocuments),
        ],
      );

      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentListWidget(
            documentsProvider: documentsProvider,
            isEditing: false,
            isVertical: true,
          ),
        ),
        container: container,
        router: mockGoRouter,
      );

      // Should render SingleChildScrollView for vertical layout
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Wrap), findsOneWidget);
    });

    testWidgets('renders horizontal layout when isVertical is false', (tester) async {
      // Use existing documents from document_data.dart
      final testDocuments = documentList.take(1).toList();

      // Override the provider with test documents
      container = ProviderContainer.test(
        overrides: [
          documentsProvider.overrideWith((ref) => testDocuments),
        ],
      );

      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentListWidget(
            documentsProvider: documentsProvider,
            isEditing: false,
            isVertical: false,
          ),
        ),
        container: container,
        router: mockGoRouter,
      );

      // Should render Wrap without SingleChildScrollView
      expect(find.byType(SingleChildScrollView), findsNothing);
      expect(find.byType(Wrap), findsOneWidget);
    });

    testWidgets('passes isEditing parameter to DocumentWidget', (tester) async {
      // Use existing documents from document_data.dart
      final testDocuments = documentList.take(1).toList();

      // Override the provider with test documents
      container = ProviderContainer.test(
        overrides: [
          documentsProvider.overrideWith((ref) => testDocuments),
        ],
      );

      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentListWidget(
            documentsProvider: documentsProvider,
            isEditing: true,
          ),
        ),
        container: container,
        router: mockGoRouter,
      );

      // Should render the document list
      expect(find.byType(DocumentListWidget), findsOneWidget);
      
      // Should render DocumentWidget with isEditing: true
      final documentWidget = tester.widget<DocumentWidget>(find.byType(DocumentWidget));
      expect(documentWidget.isEditing, isTrue);
    });

    testWidgets('handles null maxItems', (tester) async {
      // Use existing documents from document_data.dart
      final testDocuments = documentList.take(3).toList(); // Use 3 documents

      // Override the provider with test documents
      container = ProviderContainer.test(
        overrides: [
          documentsProvider.overrideWith((ref) => testDocuments),
        ],
      );

      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentListWidget(
            documentsProvider: documentsProvider,
            isEditing: false,
            maxItems: null, // No limit
          ),
        ),
        container: container,
        router: mockGoRouter,
      );

      // Should render all documents when maxItems is null
      expect(find.byType(DocumentListWidget), findsOneWidget);
      
      // Should render all 3 DocumentWidget instances (no limit)
      expect(find.byType(DocumentWidget), findsNWidgets(3));
    });

    testWidgets('uses default empty state when not provided', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentListWidget(
            documentsProvider: documentsProvider,
            isEditing: false,
          ),
        ),
        container: container,
        router: mockGoRouter,
      );

      // Should render default empty state (SizedBox.shrink)
      expect(find.byType(SizedBox), findsWidgets);
    });
  });
}
