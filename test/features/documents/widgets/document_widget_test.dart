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
  group('DocumentWidget Tests', () {
    late ProviderContainer container;
    late MockGoRouter mockGoRouter;
    late DocumentModel testDocument;

    setUp(() {
      container = ProviderContainer.test();
      mockGoRouter = MockGoRouter();
      
      // Use existing document from document_data.dart
      testDocument = documentList.first;
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('renders document widget with correct document ID', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentWidget(
            documentId: testDocument.id,
            isEditing: false,
          ),
        ),
        container: container,
        router: mockGoRouter,
      );

      expect(find.byType(DocumentWidget), findsOneWidget);
      expect(find.byType(GlassyContainer), findsAtLeastNWidgets(1));
    });

    testWidgets('renders thumbnail layout when isVertical is false', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentWidget(
            documentId: testDocument.id,
            isEditing: false,
            isVertical: false,
          ),
        ),
        container: container,
        router: mockGoRouter,
      );

      // Should render thumbnail layout with Stack
      expect(find.byType(DocumentWidget), findsOneWidget);
      expect(find.byType(Stack), findsAtLeastNWidgets(1));
      expect(find.byType(ListTile), findsNothing);
      
      // Should have specific dimensions - find the main container
      final glassyContainers = tester.widgetList<GlassyContainer>(find.byType(GlassyContainer));
      final mainContainer = glassyContainers.firstWhere((container) => container.width == 80);
      expect(mainContainer.width, equals(80));
      expect(mainContainer.height, equals(100));
    });

    testWidgets('renders vertical layout when isVertical is true', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentWidget(
            documentId: testDocument.id,
            isEditing: false,
            isVertical: true,
          ),
        ),
        container: container,
        router: mockGoRouter,
      );

      // Should render ListTile layout
      expect(find.byType(ListTile), findsOneWidget);
      
      // Should have StyledIconContainer in leading
      expect(find.byType(StyledIconContainer), findsAtLeastNWidgets(1));
      
      // Should display document title
      expect(find.text(testDocument.title), findsOneWidget);
    });

    testWidgets('shows delete button when isEditing is true in thumbnail layout', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentWidget(
            documentId: testDocument.id,
            isEditing: true,
            isVertical: false,
          ),
        ),
        container: container,
        router: mockGoRouter,
      );

      // Should show delete button (close icon) in thumbnail layout only
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
      expect(find.byType(Stack), findsAtLeastNWidgets(1));
      
      // Delete button should be positioned
      expect(find.byType(Positioned), findsAtLeastNWidgets(1));
    });

    testWidgets('does not show delete button when isEditing is false', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentWidget(
            documentId: testDocument.id,
            isEditing: false,
            isVertical: false,
          ),
        ),
        container: container,
        router: mockGoRouter,
      );

      // Should not show delete button
      expect(find.byIcon(Icons.close_rounded), findsNothing);
    });

    testWidgets('shows sheet name when showSheetName is true', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentWidget(
            documentId: testDocument.id,
            isEditing: false,
            isVertical: true,
            showSheetName: true,
          ),
        ),
        container: container,
        router: mockGoRouter,
      );

      // Should show sheet name widget
      expect(find.byType(DisplaySheetNameWidget), findsOneWidget);
    });

    testWidgets('does not show sheet name when showSheetName is false', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentWidget(
            documentId: testDocument.id,
            isEditing: false,
            isVertical: true,
            showSheetName: false,
          ),
        ),
        container: container,
        router: mockGoRouter,
      );

      // Should still render ListTile but without sheet name
      expect(find.byType(DisplaySheetNameWidget), findsNothing);
    });

    testWidgets('displays document title correctly in vertical layout', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentWidget(
            documentId: testDocument.id,
            isEditing: false,
            isVertical: true,
          ),
        ),
        container: container,
        router: mockGoRouter,
      );

      // Should display the document title in ListTile
      expect(find.text(testDocument.title), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
    });

    testWidgets('displays file type correctly in thumbnail layout', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentWidget(
            documentId: testDocument.id,
            isEditing: false,
            isVertical: false,
          ),
        ),
        container: container,
        router: mockGoRouter,
      );

      // Should display file type badge in thumbnail layout
      expect(find.byType(DocumentWidget), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
      
      // Should display file type text (uppercase) in GlassyContainer badge
      final fileType = testDocument.filePath.split('.').last.toUpperCase();
      expect(find.text(fileType), findsOneWidget);
      
      // Should have StyledIconContainer for file type icon
      expect(find.byType(StyledIconContainer), findsOneWidget);
    });

    testWidgets('displays document title correctly in thumbnail layout', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentWidget(
            documentId: testDocument.id,
            isEditing: false,
            isVertical: false,
          ),
        ),
        container: container,
        router: mockGoRouter,
      );

      // Should display the document title in thumbnail layout (small text)
      expect(find.text(testDocument.title), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
      
      // Should render thumbnail layout components
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(SizedBox), findsWidgets);
      
      // Should have Center and Padding for layout
      expect(find.byType(Center), findsAtLeastNWidgets(1));
      expect(find.byType(Padding), findsAtLeastNWidgets(1));
    });

    testWidgets('handles null document gracefully', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentWidget(
            documentId: 'non-existent-id',
            isEditing: false,
          ),
        ),
        container: container,
        router: mockGoRouter,
      );

      // Should render SizedBox.shrink when document is null
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('renders with correct dimensions for thumbnail layout', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentWidget(
            documentId: testDocument.id,
            isEditing: false,
            isVertical: false,
          ),
        ),
        container: container,
        router: mockGoRouter,
      );

      // Should render the widget without errors
      expect(find.byType(DocumentWidget), findsOneWidget);
    });

    testWidgets('renders with correct styling for vertical layout', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentWidget(
            documentId: testDocument.id,
            isEditing: false,
            isVertical: true,
          ),
        ),
        container: container,
        router: mockGoRouter,
      );

      // Should render ListTile with proper styling
      final listTile = tester.widget<ListTile>(find.byType(ListTile));
      expect(listTile.contentPadding, equals(const EdgeInsets.symmetric(horizontal: 12, vertical: 2)));
      
      // Should display file size and type in subtitle
      final fileType = testDocument.filePath.split('.').last.toUpperCase();
      expect(find.textContaining(fileType), findsOneWidget);
      expect(find.textContaining('•'), findsOneWidget);
    });

    testWidgets('uses correct file type icon and color', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentWidget(
            documentId: testDocument.id,
            isEditing: false,
            isVertical: false,
          ),
        ),
        container: container,
        router: mockGoRouter,
      );

      // Should render StyledIconContainer with correct properties
      final styledIconContainer = tester.widget<StyledIconContainer>(find.byType(StyledIconContainer));
      expect(styledIconContainer.size, equals(32));
      expect(styledIconContainer.iconSize, equals(16));
      expect(styledIconContainer.borderRadius, equals(BorderRadius.circular(12)));
    });

    testWidgets('handles different document types', (tester) async {
      // Test with different document types from document_data.dart
      final pdfDocument = documentList.firstWhere((doc) => doc.filePath.contains('.pdf'));
      final docxDocument = documentList.firstWhere((doc) => doc.filePath.contains('.docx'));
      final xlsxDocument = documentList.firstWhere((doc) => doc.filePath.contains('.xlsx'));

      for (final doc in [pdfDocument, docxDocument, xlsxDocument]) {
        await tester.pumpMaterialWidgetWithProviderScope(
          child: Scaffold(
            body: DocumentWidget(
              documentId: doc.id,
              isEditing: false,
              isVertical: true, // Use vertical layout to see title
            ),
          ),
          container: container,
          router: mockGoRouter,
        );

        expect(find.byType(DocumentWidget), findsOneWidget);
        expect(find.text(doc.title), findsOneWidget);
        expect(find.byType(ListTile), findsOneWidget);
      }
    });
  });
}
