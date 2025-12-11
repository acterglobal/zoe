import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/features/documents/data/document_data.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/widgets/unsupported_preview_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('UnsupportedPreviewWidget', () {
    late DocumentModel testDocument;

    Future<void> createTestWidget(
      WidgetTester tester, {
      required DocumentModel document,
      Key? key,
    }) async {
      await tester.pumpMaterialWidget(
        child: UnsupportedPreviewWidget(key: key, document: document),
      );
    }

    setUp(() {
      // Use existing document from document_data.dart
      testDocument = documentList.first;
    });

    group('Constructor and Initialization', () {
      testWidgets('should render UnsupportedPreviewWidget correctly', (
        tester,
      ) async {
        await createTestWidget(tester, document: testDocument);

        expect(find.byType(UnsupportedPreviewWidget), findsOneWidget);
        expect(find.byType(Center), findsAtLeastNWidgets(1));
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(StyledIconContainer), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
      });

      test('should accept document parameter', () {
        final widget = UnsupportedPreviewWidget(document: testDocument);
        expect(widget.document, equals(testDocument));
      });

      test('should use provided key', () {
        const key = Key('unsupported-preview-key');
        final widget = UnsupportedPreviewWidget(
          key: key,
          document: testDocument,
        );
        expect(widget.key, equals(key));
      });
    });

    group('Widget Structure', () {
      testWidgets('should have correct main layout structure', (tester) async {
        await createTestWidget(tester, document: testDocument);

        // Should have Center widget
        final centers = find.byType(Center);
        expect(centers, findsAtLeastNWidgets(1));

        // Should have Column with mainAxisAlignment center
        final column = tester.widget<Column>(find.byType(Column));
        expect(column.mainAxisAlignment, equals(MainAxisAlignment.center));
        expect(
          column.children,
          hasLength(3),
        ); // StyledIconContainer, SizedBox, Text
      });

      testWidgets('should have correct text widget', (tester) async {
        await createTestWidget(tester, document: testDocument);

        // Should have text with unsupported file message
        expect(
          find.text(
            L10n.of(
              tester.element(find.byType(UnsupportedPreviewWidget)),
            ).thisFileIsNotSupported,
          ),
          findsOneWidget,
        );
      });
    });

    group('StyledIconContainer Properties', () {
      testWidgets('should have correct StyledIconContainer properties', (
        tester,
      ) async {
        await createTestWidget(tester, document: testDocument);

        final iconContainer = tester.widget<StyledIconContainer>(
          find.byType(StyledIconContainer),
        );
        expect(iconContainer.size, equals(80));
        expect(iconContainer.iconSize, equals(40));
        expect(iconContainer.backgroundOpacity, equals(0.1));
        expect(iconContainer.borderOpacity, equals(0.15));
        expect(iconContainer.shadowOpacity, equals(0.12));
        expect(iconContainer.borderRadius, equals(BorderRadius.circular(12)));
      });

      testWidgets('should have file type icon and color', (tester) async {
        await createTestWidget(tester, document: testDocument);

        final iconContainer = tester.widget<StyledIconContainer>(
          find.byType(StyledIconContainer),
        );
        expect(iconContainer.icon, isNotNull);
        expect(iconContainer.primaryColor, isNotNull);
      });
    });

    group('Text Styling', () {
      testWidgets('should have correct text style', (tester) async {
        await createTestWidget(tester, document: testDocument);

        final textWidget = tester.widget<Text>(find.byType(Text));
        final textStyle = textWidget.style;

        expect(textStyle, isNotNull);
        expect(textStyle?.color, isNotNull);
      });

      testWidgets('should use theme colors correctly', (tester) async {
        await createTestWidget(tester, document: testDocument);

        final textWidget = tester.widget<Text>(find.byType(Text));
        final textStyle = textWidget.style;

        // Should have color with alpha value
        expect(textStyle?.color, isNotNull);
      });
    });

    group('Different Document Types', () {
      testWidgets('should handle different file extensions', (tester) async {
        final testDocuments = [
          DocumentModel(
            id: 'doc-1',
            title: 'Test Document',
            parentId: 'list-1',
            sheetId: 'sheet-1',
            filePath: 'test.xyz',
            createdBy: 'test-user',
          ),
          DocumentModel(
            id: 'doc-2',
            title: 'Another Document',
            parentId: 'list-1',
            sheetId: 'sheet-1',
            filePath: 'test.unknown',
            createdBy: 'test-user',
          ),
          DocumentModel(
            id: 'doc-3',
            title: 'Third Document',
            parentId: 'list-1',
            sheetId: 'sheet-1',
            filePath: 'test.weird',
            createdBy: 'test-user',
          ),
        ];

        for (final doc in testDocuments) {
          await createTestWidget(tester, document: doc);

          // Should render successfully for any file type
          expect(find.byType(UnsupportedPreviewWidget), findsOneWidget);
          expect(find.byType(StyledIconContainer), findsOneWidget);
          expect(find.byType(Text), findsOneWidget);
        }
      });

      testWidgets('should handle files with no extension', (tester) async {
        final noExtensionDocument = DocumentModel(
          id: 'no-ext-doc',
          title: 'No Extension Document',
          parentId: 'list-1',
          sheetId: 'sheet-1',
          filePath: 'testfile',
          createdBy: 'test-user',
        );

        await createTestWidget(tester, document: noExtensionDocument);

        expect(find.byType(UnsupportedPreviewWidget), findsOneWidget);
        expect(find.byType(StyledIconContainer), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('should handle files with multiple dots', (tester) async {
        final multiDotDocument = DocumentModel(
          id: 'multi-dot-doc',
          title: 'Multi Dot Document',
          parentId: 'list-1',
          sheetId: 'sheet-1',
          filePath: 'test.file.backup.old',
          createdBy: 'test-user',
        );

        await createTestWidget(tester, document: multiDotDocument);

        expect(find.byType(UnsupportedPreviewWidget), findsOneWidget);
        expect(find.byType(StyledIconContainer), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
      });
    });

    group('Theme Integration', () {
      testWidgets('should use theme colors correctly', (tester) async {
        final customTheme = ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.blue,
            secondary: Colors.green,
            onSurface: Colors.black,
          ),
        );

        await tester.pumpMaterialWidget(
          child: UnsupportedPreviewWidget(document: testDocument),
          theme: customTheme,
        );

        // Widget should use theme colors
        expect(find.byType(UnsupportedPreviewWidget), findsOneWidget);
        expect(find.byType(StyledIconContainer), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('should adapt to dark theme', (tester) async {
        final darkTheme = ThemeData.dark();

        await tester.pumpMaterialWidget(
          child: UnsupportedPreviewWidget(document: testDocument),
          theme: darkTheme,
        );

        // Widget should adapt to dark theme
        expect(find.byType(UnsupportedPreviewWidget), findsOneWidget);
        expect(find.byType(StyledIconContainer), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
      });
    });
  });
}
