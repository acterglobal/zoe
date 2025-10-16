import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/display_sheet_name_widget.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/data/document_data.dart';
import 'package:zoe/features/documents/widgets/document_widget.dart';
import '../../../test-utils/mock_gorouter.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('🧾 DocumentWidget Tests', () {
    late ProviderContainer container;
    late MockGoRouter mockGoRouter;
    late DocumentModel testDocument;

    setUp(() {
      container = ProviderContainer.test();
      mockGoRouter = MockGoRouter();
      testDocument = documentList.first;
    });

    tearDown(() => container.dispose());

    Future<void> pumpDocumentWidget(
      WidgetTester tester, {
      required String documentId,
      bool isEditing = false,
      bool isVertical = false,
      bool showSheetName = false,
    }) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentWidget(
            documentId: documentId,
            isEditing: isEditing,
            isVertical: isVertical,
            showSheetName: showSheetName,
          ),
        ),
        container: container,
        router: mockGoRouter,
      );
    }

    group('Basic Rendering', () {
      testWidgets('renders correctly with valid document', (tester) async {
        await pumpDocumentWidget(
          tester,
          documentId: testDocument.id,
          isEditing: false,
        );

        expect(find.byType(DocumentWidget), findsOneWidget);
        expect(find.byType(GlassyContainer), findsAtLeastNWidgets(1));
      });

      testWidgets('renders SizedBox.shrink when document is null', (tester) async {
        await pumpDocumentWidget(
          tester,
          documentId: 'invalid-id',
          isEditing: false,
        );

        expect(find.byType(SizedBox), findsWidgets);
      });
    });

    group('Layout Variants', () {
      testWidgets('renders thumbnail layout when isVertical = false', (tester) async {
        await pumpDocumentWidget(
          tester,
          documentId: testDocument.id,
          isEditing: false,
          isVertical: false,
        );

        expect(find.byType(Stack), findsAtLeastNWidgets(1));
        expect(find.byType(ListTile), findsNothing);

        final glassyContainers = tester.widgetList<GlassyContainer>(find.byType(GlassyContainer));
        final mainContainer = glassyContainers.firstWhere((c) => c.width == 80);
        expect(mainContainer.width, 80);
        expect(mainContainer.height, 100);
      });

      testWidgets('renders vertical layout when isVertical = true', (tester) async {
        await pumpDocumentWidget(
          tester,
          documentId: testDocument.id,
          isEditing: false,
          isVertical: true,
        );

        expect(find.byType(ListTile), findsOneWidget);
        expect(find.byType(StyledIconContainer), findsAtLeastNWidgets(1));
        expect(find.text(testDocument.title), findsOneWidget);
      });
    });

    group('Editing Mode', () {
      testWidgets('shows delete button when isEditing = true', (tester) async {
        await pumpDocumentWidget(
          tester,
          documentId: testDocument.id,
          isEditing: true,
          isVertical: false,
        );

        expect(find.byIcon(Icons.close_rounded), findsOneWidget);
        expect(find.byType(Positioned), findsAtLeastNWidgets(1));
      });

      testWidgets('hides delete button when isEditing = false', (tester) async {
        await pumpDocumentWidget(
          tester,
          documentId: testDocument.id,
          isEditing: false,
          isVertical: false,
        );

        expect(find.byIcon(Icons.close_rounded), findsNothing);
      });
    });

    group('sheet Name', () {
      testWidgets('shows sheet name when showSheetName = true', (tester) async {
        await pumpDocumentWidget(
          tester,
          documentId: testDocument.id,
          isEditing: false,
          isVertical: true,
          showSheetName: true,
        );

        expect(find.byType(DisplaySheetNameWidget), findsOneWidget);
      });

      testWidgets('hides sheet name when showSheetName = false', (tester) async {
        await pumpDocumentWidget(
          tester,
          documentId: testDocument.id,
          isEditing: false,
          isVertical: true,
          showSheetName: false,
        );

        expect(find.byType(DisplaySheetNameWidget), findsNothing);
      });
    });

    group(' Content & Styling', () {
      testWidgets('displays title correctly in vertical layout', (tester) async {
        await pumpDocumentWidget(
          tester,
          documentId: testDocument.id,
          isEditing: false,
          isVertical: true,
        );

        expect(find.text(testDocument.title), findsOneWidget);
        expect(find.byType(ListTile), findsOneWidget);
      });

      testWidgets('displays file type badge in thumbnail layout', (tester) async {
        await pumpDocumentWidget(
          tester,
          documentId: testDocument.id,
          isEditing: false,
          isVertical: false,
        );

        final fileType = testDocument.filePath.split('.').last.toUpperCase();
        expect(find.text(fileType), findsOneWidget);
        expect(find.byType(StyledIconContainer), findsOneWidget);
      });

      testWidgets('applies proper ListTile styling in vertical layout', (tester) async {
        await pumpDocumentWidget(
          tester,
          documentId: testDocument.id,
          isEditing: false,
          isVertical: true,
        );

        final tile = tester.widget<ListTile>(find.byType(ListTile));
        expect(tile.contentPadding, const EdgeInsets.symmetric(horizontal: 12, vertical: 2));

        final fileType = testDocument.filePath.split('.').last.toUpperCase();
        expect(find.textContaining(fileType), findsOneWidget);
        expect(find.textContaining('•'), findsOneWidget);
      });

      testWidgets('uses correct icon size, radius, and color', (tester) async {
        await pumpDocumentWidget(
          tester,
          documentId: testDocument.id,
          isEditing: false,
          isVertical: false,
        );

        final styledIcon = tester.widget<StyledIconContainer>(find.byType(StyledIconContainer));
        expect(styledIcon.size, 32);
        expect(styledIcon.iconSize, 16);
        expect(styledIcon.borderRadius, BorderRadius.circular(12));
      });
    });

    group('Multiple File Types', () {
      testWidgets('renders correctly for different document types', (tester) async {
        final docTypes = documentList
            .where((doc) => doc.filePath.endsWith('.pdf') || doc.filePath.endsWith('.docx') || doc.filePath.endsWith('.xlsx'))
            .toList();

        for (final doc in docTypes) {
          await pumpDocumentWidget(
            tester,
            documentId: doc.id,
            isEditing: false,
            isVertical: true,
          );

          expect(find.byType(DocumentWidget), findsOneWidget);
          expect(find.text(doc.title), findsOneWidget);
          expect(find.byType(ListTile), findsOneWidget);
        }
      });
    });
  });
}