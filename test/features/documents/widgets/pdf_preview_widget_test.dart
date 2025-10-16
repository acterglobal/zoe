import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/widgets/pdf_preview_widget.dart';
import 'package:zoe/features/documents/data/document_data.dart';
import 'package:zoe/l10n/generated/l10n.dart';

import '../../../test-utils/test_utils.dart';

void main() {
  group('PdfPreviewWidget', () {
    late ProviderContainer container;
    late DocumentModel testDocument;

    Future<void> createTestWidget(
      WidgetTester tester, {
      required DocumentModel document,
      Key? key,
    }) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: PdfPreviewWidget(key: key, document: document),
      );
    }

    setUp(() {
      container = ProviderContainer.test();

      // Use a valid PDF from mock data or fallback to any available document
      testDocument = documentList.firstWhere(
        (doc) => doc.filePath.toLowerCase().endsWith('.pdf'),
        orElse: () => documentList.first,
      );
    });

    group('Constructor', () {
      testWidgets('should render PdfPreviewWidget correctly', (tester) async {
        await createTestWidget(tester, document: testDocument);

        expect(find.byType(PdfPreviewWidget), findsOneWidget);
        expect(find.byType(Center), findsAtLeastNWidgets(1));
      });

      test('should accept document parameter', () {
        final widget = PdfPreviewWidget(document: testDocument);
        expect(widget.document, equals(testDocument));
      });

      test('should use provided key', () {
        const key = Key('pdf-preview-key');
        final widget = PdfPreviewWidget(key: key, document: testDocument);
        expect(widget.key, equals(key));
      });
    });

    group('UI Building', () {
      testWidgets('should show error container when PDF file does not exist', (
        tester,
      ) async {
        final errorDocument = DocumentModel(
          id: 'error-doc',
          title: 'Missing PDF',
          parentId: 'list-1',
          sheetId: 'sheet-1',
          filePath: '/non/existent/path.pdf',
        );

        await createTestWidget(tester, document: errorDocument);

        expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
        expect(find.text(L10n.of(tester.element(find.byType(PdfPreviewWidget))).pdfFileNotFound), findsOneWidget);
      });

      testWidgets('should show StyledIconContainer when file exists', (
        tester,
      ) async {
        final existingFile = File('pubspec.yaml'); 

        final validDocument = DocumentModel(
          id: 'valid-doc',
          title: 'Valid PDF',
          parentId: 'list-1',
          sheetId: 'sheet-1',
          filePath: existingFile.path,
        );

        await createTestWidget(tester, document: validDocument);

        expect(find.byType(StyledIconContainer), findsOneWidget);
      });

      testWidgets('should render proper structure for error container', (
        tester,
      ) async {
        final errorDocument = DocumentModel(
          id: 'error-doc',
          title: 'Invalid PDF',
          parentId: 'list-1',
          sheetId: 'sheet-1',
          filePath: '/non/existent/path.pdf',
        );

        await createTestWidget(tester, document: errorDocument);

        expect(find.byType(GlassyContainer), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
        expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
        expect(find.byType(Text), findsAtLeastNWidgets(2));
        expect(find.byType(SizedBox), findsAtLeastNWidgets(2));
      });
    });
  });
}
