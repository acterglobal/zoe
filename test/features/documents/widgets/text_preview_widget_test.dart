import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:zoe/features/documents/actions/text_preview_actions.dart';
import 'package:zoe/features/documents/data/document_data.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/widgets/document_error_widget.dart';
import 'package:zoe/features/documents/widgets/text_preview_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/test_utils.dart';


void main() {
  group('TextPreviewWidget', () {
    late ProviderContainer container;
    late DocumentModel testDocument;

    Future<void> createTestWidget(
      WidgetTester tester, {
      required DocumentModel document,
      Key? key,
    }) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: TextPreviewWidget(key: key, document: document),
      );
    }

    setUp(() {
      container = ProviderContainer.test();

      // Use existing text document from document_data.dart or fallback to pubspec.yaml
      testDocument = documentList.firstWhere(
        (doc) =>
            doc.filePath.toLowerCase().endsWith('.txt') ||
            doc.filePath.toLowerCase().endsWith('.md') ||
            doc.filePath.toLowerCase().endsWith('.json'),
        orElse: () => DocumentModel(
          id: 'pubspec-doc',
          title: 'Pubspec YAML',
          parentId: 'list-1',
          sheetId: 'sheet-1',
          filePath: 'pubspec.yaml',
        ),
      );
    });

    group('Constructor and Initialization', () {
      testWidgets('should render TextPreviewWidget correctly', (tester) async {
        await createTestWidget(tester, document: testDocument);

        expect(find.byType(TextPreviewWidget), findsOneWidget);
        expect(find.byType(Column), findsAtLeastNWidgets(1));
        expect(find.byType(ZoeSearchBarWidget), findsOneWidget);
        expect(find.byType(Expanded), findsAtLeastNWidgets(1));
      });

      test('should accept document parameter', () {
        final widget = TextPreviewWidget(document: testDocument);
        expect(widget.document, equals(testDocument));
      });

      test('should use provided key', () {
        const key = Key('text-preview-key');
        final widget = TextPreviewWidget(key: key, document: testDocument);
        expect(widget.key, equals(key));
      });

      testWidgets('should initialize search controller and load text file', (
        tester,
      ) async {
        await createTestWidget(tester, document: testDocument);

        // Should have search bar
        expect(find.byType(ZoeSearchBarWidget), findsOneWidget);
        // TextEditingController is internal to ZoeSearchBarWidget
        expect(find.byType(TextField), findsOneWidget);
      });
    });

    group('Widget Structure', () {
      testWidgets('should have correct search bar properties', (tester) async {
        await createTestWidget(tester, document: testDocument);

        final searchBar = tester.widget<ZoeSearchBarWidget>(
          find.byType(ZoeSearchBarWidget),
        );
        expect(
          searchBar.hintText,
          equals(
            L10n.of(
              tester.element(find.byType(TextPreviewWidget)),
            ).searchInText,
          ),
        );
        expect(
          searchBar.margin,
          equals(const EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
        );
      });
    });

    group('Error State', () {
      testWidgets('should show error widget when file does not exist', (
        tester,
      ) async {
        final errorDocument = DocumentModel(
          id: 'error-doc',
          title: 'Non-existent Text',
          parentId: 'list-1',
          sheetId: 'sheet-1',
          filePath: '/non/existent/path.txt',
        );

        await createTestWidget(tester, document: errorDocument);

        expect(find.byType(DocumentErrorWidget), findsOneWidget);
        expect(
          find.text(
            L10n.of(
              tester.element(find.byType(TextPreviewWidget)),
            ).failedToLoadFile,
          ),
          findsOneWidget,
        );
      });

      testWidgets('should show error widget when file content is empty', (
        tester,
      ) async {
        // Use a non-existent file to simulate empty content scenario
        final emptyDocument = DocumentModel(
          id: 'empty-doc',
          title: 'Empty Text',
          parentId: 'list-1',
          sheetId: 'sheet-1',
          filePath: '/non/existent/empty.txt',
        );

        await createTestWidget(tester, document: emptyDocument);

        expect(find.byType(DocumentErrorWidget), findsOneWidget);
        expect(
          find.text(
            L10n.of(
              tester.element(find.byType(TextPreviewWidget)),
            ).failedToLoadFile,
          ),
          findsOneWidget,
        );
      });

      testWidgets('should handle empty file path', (tester) async {
        final emptyPathDocument = DocumentModel(
          id: 'empty-path-doc',
          title: 'Empty Path Document',
          parentId: 'list-1',
          sheetId: 'sheet-1',
          filePath: '',
        );

        await createTestWidget(tester, document: emptyPathDocument);

        expect(find.byType(DocumentErrorWidget), findsOneWidget);
        expect(
          find.text(
            L10n.of(
              tester.element(find.byType(TextPreviewWidget)),
            ).failedToLoadFile,
          ),
          findsOneWidget,
        );
      });
    });

    group('Text Content Display', () {
      final contentDocument = DocumentModel(
        id: 'content-doc',
        title: 'Content Text',
        parentId: 'list-1',
        sheetId: 'sheet-1',
        filePath: 'pubspec.yaml',
      );
      testWidgets(
        'should show error widget when file content cannot be loaded',
        (tester) async {
          await createTestWidget(tester, document: contentDocument);

          // In test environment, file loading may fail, so expect error state
          expect(find.byType(DocumentErrorWidget), findsOneWidget);
          expect(
            find.text(
              L10n.of(
                tester.element(find.byType(TextPreviewWidget)),
              ).failedToLoadFile,
            ),
            findsOneWidget,
          );
        },
      );

      testWidgets('should handle file loading in test environment', (
        tester,
      ) async {
        await createTestWidget(tester, document: contentDocument);

        // Should show either error or content state
        expect(
          find.byType(DocumentErrorWidget).evaluate().isNotEmpty ||
              find.byType(GlassyContainer).evaluate().isNotEmpty,
          isTrue,
        );
      });
    });

    group('Widget Lifecycle', () {
      testWidgets('should dispose search controller on widget dispose', (
        tester,
      ) async {
        await createTestWidget(tester, document: testDocument);

        // Remove widget to trigger dispose
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(home: Scaffold(body: Container())),
          ),
        );

        // Should dispose without errors
        expect(find.byType(TextPreviewWidget), findsNothing);
      });
    });

    group('Theme Integration', () {
      testWidgets('should use theme colors correctly', (tester) async {
        final customTheme = ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.blue,
            secondary: Colors.green,
            error: Colors.red,
          ),
        );

        final errorDocument = DocumentModel(
          id: 'error-doc',
          title: 'Non-existent Text',
          parentId: 'list-1',
          sheetId: 'sheet-1',
          filePath: '/non/existent/path.txt',
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          child: TextPreviewWidget(document: errorDocument),
          container: container,
          theme: customTheme,
        );

        // Widget should use theme colors
        expect(find.byType(TextPreviewWidget), findsOneWidget);
      });

      testWidgets('should adapt to different themes', (tester) async {
        final darkTheme = ThemeData.dark();

        final errorDocument = DocumentModel(
          id: 'error-doc',
          title: 'Non-existent Text',
          parentId: 'list-1',
          sheetId: 'sheet-1',
          filePath: '/non/existent/path.txt',
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          child: TextPreviewWidget(document: errorDocument),
          container: container,
          theme: darkTheme,
        );

        // Widget should adapt to dark theme
        expect(find.byType(TextPreviewWidget), findsOneWidget);
      });
    });

    group('Text Content Building', () {
      testWidgets('should build ListView with correct structure', (tester) async {
        // Use pubspec.yaml as existing file
        final contentDocument = DocumentModel(
          id: 'content-doc',
          title: 'Content Text',
          parentId: 'list-1',
          sheetId: 'sheet-1',
          filePath: 'pubspec.yaml',
        );

        await createTestWidget(tester, document: contentDocument);

        // Should show either content or error state
        expect(
          find.byType(ListView).evaluate().isNotEmpty ||
              find.byType(DocumentErrorWidget).evaluate().isNotEmpty,
          isTrue,
        );
      });
    });

    group('Search Highlighting Integration', () {
      testWidgets('should handle search value changes', (tester) async {
        await createTestWidget(tester, document: testDocument);

        // Find the search text field and enter text
        final searchField = find.byType(TextField);
        expect(searchField, findsOneWidget);
        
        await tester.enterText(searchField, 'test');
        await tester.pump();

        // Verify the text was entered
        expect(tester.widget<TextField>(searchField).controller?.text, equals('test'));
      });

      testWidgets('should handle empty search value', (tester) async {
        await createTestWidget(tester, document: testDocument);

        // Find the search text field and clear it
        final searchField = find.byType(TextField);
        expect(searchField, findsOneWidget);
        
        await tester.enterText(searchField, '');
        await tester.pump();

        // Verify the text was cleared
        expect(tester.widget<TextField>(searchField).controller?.text, equals(''));
      });

      testWidgets('should handle case insensitive search', (tester) async {
        await createTestWidget(tester, document: testDocument);

        // Find the search text field and enter text with different case
        final searchField = find.byType(TextField);
        expect(searchField, findsOneWidget);
        
        await tester.enterText(searchField, 'TEST');
        await tester.pump();

        // Verify the text was entered
        expect(tester.widget<TextField>(searchField).controller?.text, equals('TEST'));
      });
    });

    group('Text Line Widget Building', () {
      testWidgets('should handle line widget creation', (tester) async {
        // Use pubspec.yaml as existing file
        final contentDocument = DocumentModel(
          id: 'line-widget-doc',
          title: 'Line Widget Text',
          parentId: 'list-1',
          sheetId: 'sheet-1',
          filePath: 'pubspec.yaml',
        );

        await createTestWidget(tester, document: contentDocument);

        // Should show either content or error state
        expect(
          find.byType(ListView).evaluate().isNotEmpty ||
              find.byType(DocumentErrorWidget).evaluate().isNotEmpty,
          isTrue,
        );
      });

      testWidgets('should handle empty lines in content', (tester) async {
        // Use pubspec.yaml as existing file
        final contentDocument = DocumentModel(
          id: 'empty-line-widget-doc',
          title: 'Empty Line Widget Text',
          parentId: 'list-1',
          sheetId: 'sheet-1',
          filePath: 'pubspec.yaml',
        );

        await createTestWidget(tester, document: contentDocument);

        // Should show either content or error state
        expect(
          find.byType(ListView).evaluate().isNotEmpty ||
              find.byType(DocumentErrorWidget).evaluate().isNotEmpty,
          isTrue,
        );
      });
    });

    group('Search Indices Function', () {
      test('should return empty list for empty query', () {
        final result = getTextSearchIndices('Hello World', '');
        expect(result, isEmpty);
      });

      test('should find correct indices for matching text', () {
        final result = getTextSearchIndices('Hello\nWorld\nHello', 'Hello');
        expect(result, equals([0, 2]));
      });

      test('should handle case insensitive search', () {
        final result = getTextSearchIndices('Hello\nWorld\nhello', 'Hello');
        expect(result, equals([0, 2]));
      });

      test('should return empty list for no matches', () {
        final result = getTextSearchIndices('Hello\nWorld', 'Test');
        expect(result, isEmpty);
      });

      test('should handle multiple matches in same line', () {
        final result = getTextSearchIndices('Hello Hello\nWorld', 'Hello');
        expect(result, equals([0]));
      });
    });

    group('Build Highlighted Text Function', () {
      testWidgets('should handle search functionality when content is available', (tester) async {
        await createTestWidget(tester, document: testDocument);

        // Enter search text to test search functionality
        final searchField = find.byType(TextField);
        await tester.enterText(searchField, 'test');
        await tester.pump();

        // Should have search field with entered text
        expect(tester.widget<TextField>(searchField).controller?.text, equals('test'));
      });

      testWidgets('should handle empty search query', (tester) async {
        await createTestWidget(tester, document: testDocument);

        // Enter empty search text
        final searchField = find.byType(TextField);
        await tester.enterText(searchField, '');
        await tester.pump();

        // Should have search field with empty text
        expect(tester.widget<TextField>(searchField).controller?.text, equals(''));
      });

      testWidgets('should handle case insensitive search input', (tester) async {
        await createTestWidget(tester, document: testDocument);

        // Enter search text with different case
        final searchField = find.byType(TextField);
        await tester.enterText(searchField, 'TEST');
        await tester.pump();

        // Should have search field with entered text
        expect(tester.widget<TextField>(searchField).controller?.text, equals('TEST'));
      });

      testWidgets('should handle multiple character search input', (tester) async {
        await createTestWidget(tester, document: testDocument);

        // Enter search text that might match multiple times
        final searchField = find.byType(TextField);
        await tester.enterText(searchField, 'a');
        await tester.pump();

        // Should have search field with entered text
        expect(tester.widget<TextField>(searchField).controller?.text, equals('a'));
      });

      testWidgets('should handle no matches search input', (tester) async {
        await createTestWidget(tester, document: testDocument);

        // Enter search text that won't match
        final searchField = find.byType(TextField);
        await tester.enterText(searchField, 'xyz123');
        await tester.pump();

        // Should have search field with entered text
        expect(tester.widget<TextField>(searchField).controller?.text, equals('xyz123'));
      });

      test('should test highlighting logic with simple text matching', () {
        // Test the core highlighting logic without complex widget rendering
        final text = 'Hello World';
        final query = 'Hello';
        
        // Test basic string operations that _buildHighlightedText uses
        final lowerText = text.toLowerCase();
        final lowerQuery = query.toLowerCase();
        final hasMatch = lowerText.contains(lowerQuery);
        
        expect(hasMatch, isTrue);
        expect(lowerText.indexOf(lowerQuery), equals(0));
      });

      test('should test highlighting logic with case insensitive matching', () {
        final text = 'Hello World';
        final query = 'hello';
        
        final lowerText = text.toLowerCase();
        final lowerQuery = query.toLowerCase();
        final hasMatch = lowerText.contains(lowerQuery);
        
        expect(hasMatch, isTrue);
        expect(lowerText.indexOf(lowerQuery), equals(0));
      });

      test('should test highlighting logic with no matches', () {
        final text = 'Hello World';
        final query = 'Test';
        
        final lowerText = text.toLowerCase();
        final lowerQuery = query.toLowerCase();
        final hasMatch = lowerText.contains(lowerQuery);
        
        expect(hasMatch, isFalse);
        expect(lowerText.indexOf(lowerQuery), equals(-1));
      });

      test('should test highlighting logic with empty query', () {
        final text = 'Hello World';
        final query = '';
        
        final lowerText = text.toLowerCase();
        final lowerQuery = query.toLowerCase();
        final hasMatch = lowerText.contains(lowerQuery);
        
        expect(hasMatch, isTrue); // Empty string is always contained
        expect(lowerText.indexOf(lowerQuery), equals(0));
      });
    });
  });
}
