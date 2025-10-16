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
  group('🧾 DocumentListWidget Tests', () {
    late ProviderContainer container;
    late MockGoRouter mockGoRouter;
    late Provider<List<DocumentModel>> documentsProvider;

    setUp(() {
      container = ProviderContainer.test();
      mockGoRouter = MockGoRouter();
      documentsProvider = Provider<List<DocumentModel>>((ref) => []);
    });

    Future<void> pumpWidget(
      WidgetTester tester, {
      required Widget child,
      ProviderContainer? testContainer,
    }) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(body: child),
        container: testContainer ?? container,
        router: mockGoRouter,
      );
    }

    ProviderContainer createContainerWithDocs(List<DocumentModel> docs) {
      return ProviderContainer.test(
        overrides: [documentsProvider.overrideWith((ref) => docs)],
      );
    }

    group('📄 Empty State', () {
      testWidgets('renders custom empty state', (tester) async {
        const customEmptyState = Text('No documents found');

        await pumpWidget(
          tester,
          child: DocumentListWidget(
            documentsProvider: documentsProvider,
            isEditing: false,
            emptyState: customEmptyState,
          ),
        );

        expect(find.text('No documents found'), findsOneWidget);
      });

      testWidgets('renders default empty state when not provided', (tester) async {
        await pumpWidget(
          tester,
          child: DocumentListWidget(
            documentsProvider: documentsProvider,
            isEditing: false,
          ),
        );

        expect(find.byType(SizedBox), findsWidgets);
      });
    });

    group('📂 Document Rendering', () {
      testWidgets('renders documents when list is not empty', (tester) async {
        final docs = documentList.take(2).toList();
        final testContainer = createContainerWithDocs(docs);

        await pumpWidget(
          tester,
          child: DocumentListWidget(
            documentsProvider: documentsProvider,
            isEditing: false,
          ),
          testContainer: testContainer,
        );

        expect(find.byType(DocumentWidget), findsNWidgets(2));
      });

      testWidgets('limits documents when maxItems is specified', (tester) async {
        final docs = documentList.take(5).toList();
        final testContainer = createContainerWithDocs(docs);

        await pumpWidget(
          tester,
          child: DocumentListWidget(
            documentsProvider: documentsProvider,
            isEditing: false,
            maxItems: 3,
          ),
          testContainer: testContainer,
        );

        expect(find.byType(DocumentWidget), findsNWidgets(3));
      });

      testWidgets('renders all documents when maxItems is null', (tester) async {
        final docs = documentList.take(3).toList();
        final testContainer = createContainerWithDocs(docs);

        await pumpWidget(
          tester,
          child: DocumentListWidget(
            documentsProvider: documentsProvider,
            isEditing: false,
            maxItems: null,
          ),
          testContainer: testContainer,
        );

        expect(find.byType(DocumentWidget), findsNWidgets(3));
      });
    });

    group('Layout Behavior', () {
      testWidgets('renders vertical layout when isVertical is true', (tester) async {
        final docs = documentList.take(1).toList();
        final testContainer = createContainerWithDocs(docs);

        await pumpWidget(
          tester,
          child: DocumentListWidget(
            documentsProvider: documentsProvider,
            isEditing: false,
            isVertical: true,
          ),
          testContainer: testContainer,
        );

        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(Wrap), findsOneWidget);
      });

      testWidgets('renders horizontal layout when isVertical is false', (tester) async {
        final docs = documentList.take(1).toList();
        final testContainer = createContainerWithDocs(docs);

        await pumpWidget(
          tester,
          child: DocumentListWidget(
            documentsProvider: documentsProvider,
            isEditing: false,
            isVertical: false,
          ),
          testContainer: testContainer,
        );

        expect(find.byType(SingleChildScrollView), findsNothing);
        expect(find.byType(Wrap), findsOneWidget);
      });

      testWidgets('shows section header when showSectionHeader is true', (tester) async {
        final docs = documentList.take(1).toList();
        final testContainer = createContainerWithDocs(docs);

        await pumpWidget(
          tester,
          child: DocumentListWidget(
            documentsProvider: documentsProvider,
            isEditing: false,
            showSectionHeader: true,
          ),
          testContainer: testContainer,
        );

        expect(find.byType(Column), findsWidgets);
      });
    });

    group(' Editing Mode', () {
      testWidgets('passes isEditing = true to DocumentWidget', (tester) async {
        final docs = documentList.take(1).toList();
        final testContainer = createContainerWithDocs(docs);

        await pumpWidget(
          tester,
          child: DocumentListWidget(
            documentsProvider: documentsProvider,
            isEditing: true,
          ),
          testContainer: testContainer,
        );

        final documentWidget = tester.widget<DocumentWidget>(find.byType(DocumentWidget));
        expect(documentWidget.isEditing, isTrue);
      });
    });
  });
}
