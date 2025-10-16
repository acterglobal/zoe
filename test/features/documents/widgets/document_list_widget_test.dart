import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/data/document_data.dart';
import 'package:zoe/features/documents/widgets/document_list_widget.dart';
import 'package:zoe/features/documents/widgets/document_widget.dart';

import '../../../test-utils/mock_gorouter.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('DocumentListWidget Tests', () {
    late ProviderContainer container;
    late MockGoRouter mockGoRouter;
    late Provider<List<DocumentModel>> documentsProvider;

    setUp(() {
      container = ProviderContainer.test();
      mockGoRouter = MockGoRouter();
      documentsProvider = Provider<List<DocumentModel>>((ref) => []);
    });

    Future<void> pumpDocumentListWidget(
      WidgetTester tester, {
      bool isEditing = false,
      bool isVertical = false,
      bool showSectionHeader = false,
      int? maxItems,
      Widget? emptyState,
      List<DocumentModel>? documents,
    }) async {
      final testContainer = documents != null
          ? ProviderContainer.test(
              overrides: [documentsProvider.overrideWith((ref) => documents)],
            )
          : container;

      await tester.pumpMaterialWidgetWithProviderScope(
        container: testContainer,
        router: mockGoRouter,
        child: Scaffold(
          body: DocumentListWidget(
            documentsProvider: documentsProvider,
            isEditing: isEditing,
            isVertical: isVertical,
            showSectionHeader: showSectionHeader,
            maxItems: maxItems,
            emptyState: emptyState ?? const SizedBox.shrink(),
          ),
        ),
      );
    }

    group('Empty State', () {
      testWidgets('renders custom empty state', (tester) async {
        const customEmptyState = Text('No documents found');

        await pumpDocumentListWidget(
          tester,
          emptyState: customEmptyState,
        );

        expect(find.text('No documents found'), findsOneWidget);
      });

      testWidgets('renders default empty state when not provided', (tester) async {
        await pumpDocumentListWidget(tester);
        expect(find.byType(SizedBox), findsWidgets);
      });
    });

    group('Document Rendering', () {
      testWidgets('renders documents when list is not empty', (tester) async {
        final docs = documentList.take(2).toList();

        await pumpDocumentListWidget(
          tester,
          documents: docs,
        );

        expect(find.byType(DocumentWidget), findsNWidgets(2));
      });

      testWidgets('limits documents when maxItems is specified', (tester) async {
        final docs = documentList.take(5).toList();

        await pumpDocumentListWidget(
          tester,
          documents: docs,
          maxItems: 3,
        );

        expect(find.byType(DocumentWidget), findsNWidgets(3));
      });

      testWidgets('renders all documents when maxItems is null', (tester) async {
        final docs = documentList.take(3).toList();

        await pumpDocumentListWidget(
          tester,
          documents: docs,
        );

        expect(find.byType(DocumentWidget), findsNWidgets(3));
      });
    });

    group('Layout Behavior', () {
      testWidgets('renders vertical layout when isVertical is true', (tester) async {
        final docs = documentList.take(1).toList();

        await pumpDocumentListWidget(
          tester,
          documents: docs,
          isVertical: true,
        );

        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(Wrap), findsOneWidget);
      });

      testWidgets('renders horizontal layout when isVertical is false', (tester) async {
        final docs = documentList.take(1).toList();

        await pumpDocumentListWidget(
          tester,
          documents: docs,
          isVertical: false,
        );

        expect(find.byType(SingleChildScrollView), findsNothing);
        expect(find.byType(Wrap), findsOneWidget);
      });

      testWidgets('shows section header when showSectionHeader is true', (tester) async {
        final docs = documentList.take(1).toList();

        await pumpDocumentListWidget(
          tester,
          documents: docs,
          showSectionHeader: true,
        );

        expect(find.byType(Column), findsWidgets);
      });
    });

    group('Editing Mode', () {
      testWidgets('passes isEditing = true to DocumentWidget', (tester) async {
        final docs = documentList.take(1).toList();

        await pumpDocumentListWidget(
          tester,
          documents: docs,
          isEditing: true,
        );

        final documentWidget = tester.widget<DocumentWidget>(find.byType(DocumentWidget));
        expect(documentWidget.isEditing, isTrue);
      });
    });
  });
}
