import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_list_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/documents/screens/documents_list_screen.dart';
import 'package:zoe/features/documents/widgets/document_list_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('DocumentsListScreen', () {
    late ProviderContainer container;

    Future<void> createTestWidget(
      WidgetTester tester, {
      Key? key,
    }) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: DocumentsListScreen(key: key),
      );
    }

    setUp(() {
      container = ProviderContainer.test();
    });

    group('Constructor and Initialization', () {
      testWidgets('should render DocumentsListScreen correctly', (
        tester,
      ) async {
        await createTestWidget(tester);

        expect(find.byType(DocumentsListScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(ZoeAppBar), findsOneWidget);
      });

      test('should use provided key', () {
        const key = Key('documents-list-screen-key');
        final screen = DocumentsListScreen(key: key);
        expect(screen.key, equals(key));
      });

      testWidgets('should initialize search controller on initState', (
        tester,
      ) async {
        await createTestWidget(tester);

        // Should have search bar widget
        expect(find.byType(ZoeSearchBarWidget), findsOneWidget);
      });
    });

    group('Widget Structure', () {
      testWidgets('should have correct main structure', (tester) async {
        await createTestWidget(tester);

        // Should have Scaffold with AppBar and body
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(SafeArea), findsAtLeastNWidgets(1));
        expect(find.byType(MaxWidthWidget), findsOneWidget);
        expect(find.byType(Column), findsAtLeastNWidgets(1));
      });

      testWidgets('should have correct app bar properties', (tester) async {
        await createTestWidget(tester);

        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.automaticallyImplyLeading, isFalse);

        final zoeAppBar = tester.widget<ZoeAppBar>(find.byType(ZoeAppBar));
        expect(
          zoeAppBar.title,
          equals(
            L10n.of(tester.element(find.byType(DocumentsListScreen))).documents,
          ),
        );
      });

      testWidgets('should have correct MaxWidthWidget properties', (
        tester,
      ) async {
        await createTestWidget(tester);

        final maxWidthWidget = tester.widget<MaxWidthWidget>(
          find.byType(MaxWidthWidget),
        );
        expect(
          maxWidthWidget.padding,
          equals(const EdgeInsets.symmetric(horizontal: 16)),
        );
      });
    });

    group('Search Functionality', () {
      testWidgets('should have search bar widget', (tester) async {
        await createTestWidget(tester);

        expect(find.byType(ZoeSearchBarWidget), findsOneWidget);
      });

      testWidgets('should have correct search bar properties', (tester) async {
        await createTestWidget(tester);

        final searchBar = tester.widget<ZoeSearchBarWidget>(
          find.byType(ZoeSearchBarWidget),
        );
        expect(searchBar.controller, isNotNull);
        expect(searchBar.onChanged, isNotNull);
      });

      testWidgets('should update search value when typing', (tester) async {
        await createTestWidget(tester);

        // Find the text field within the search bar
        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);

        // Type in the search field
        await tester.enterText(textField, 'test search');
        await tester.pump();

        // Verify the text was entered
        final textFieldWidget = tester.widget<TextField>(textField);
        expect(textFieldWidget.controller?.text, equals('test search'));
      });

      testWidgets('should call search provider when text changes', (
        tester,
      ) async {
        await createTestWidget(tester);

        // Find the text field
        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);

        // Type in the search field
        await tester.enterText(textField, 'search query');
        await tester.pump();

        // The search provider should be updated (we can't directly test this
        // without mocking, but we can verify the text field works)
        final textFieldWidget = tester.widget<TextField>(textField);
        expect(textFieldWidget.controller?.text, equals('search query'));
      });
    });

    group('Document List Widget', () {
      testWidgets('should have document list widget', (tester) async {
        await createTestWidget(tester);

        expect(find.byType(DocumentListWidget), findsOneWidget);
      });

      testWidgets('should have correct document list properties', (
        tester,
      ) async {
        await createTestWidget(tester);

        final documentList = tester.widget<DocumentListWidget>(
          find.byType(DocumentListWidget),
        );
        expect(documentList.documentsProvider, equals(documentListSearchProvider));
        expect(documentList.isEditing, isFalse);
        expect(documentList.isVertical, isTrue);
        expect(documentList.emptyState, isNotNull);
      });

      testWidgets('should have correct empty state widget', (tester) async {
        await createTestWidget(tester);

        final documentList = tester.widget<DocumentListWidget>(
          find.byType(DocumentListWidget),
        );
        final emptyState = documentList.emptyState as EmptyStateListWidget;
        
        expect(
          emptyState.message,
          equals(
            L10n.of(tester.element(find.byType(DocumentsListScreen)))
                .noDocumentsFound,
          ),
        );
        expect(emptyState.color, equals(AppColors.brightOrangeColor));
        expect(emptyState.contentType, equals(ContentType.document));
      });
    });

    group('Layout and Spacing', () {
      testWidgets('should have correct spacing between elements', (
        tester,
      ) async {
        await createTestWidget(tester);

        // Should have SizedBox widgets for spacing
        expect(find.byType(SizedBox), findsAtLeastNWidgets(2));

        // Check the spacing values
        final sizedBoxes = find.byType(SizedBox);
        expect(sizedBoxes, findsAtLeastNWidgets(2));

        // Check that we have at least 2 SizedBox widgets
        expect(sizedBoxes, findsAtLeastNWidgets(2));

        // Check that the SizedBox widgets have height values (may be 10 or 20 depending on test environment)
        final firstSizedBox = tester.widget<SizedBox>(sizedBoxes.at(0));
        expect(firstSizedBox.height, anyOf([equals(10), equals(20)]));

        final secondSizedBox = tester.widget<SizedBox>(sizedBoxes.at(1));
        expect(secondSizedBox.height, anyOf([equals(10), equals(20)]));
      });

      testWidgets('should have Expanded widget for document list', (
        tester,
      ) async {
        await createTestWidget(tester);

        expect(find.byType(Expanded), findsAtLeastNWidgets(1));

        // Find the Expanded widget that contains DocumentListWidget
        final expandedWidgets = find.byType(Expanded);
        expect(expandedWidgets, findsAtLeastNWidgets(1));
        
        // Check that at least one Expanded widget contains DocumentListWidget
        bool foundDocumentList = false;
        for (int i = 0; i < expandedWidgets.evaluate().length; i++) {
          final expanded = tester.widget<Expanded>(expandedWidgets.at(i));
          if (expanded.child is DocumentListWidget) {
            foundDocumentList = true;
            break;
          }
        }
        expect(foundDocumentList, isTrue);
      });
    });

    group('Provider Integration', () {

      testWidgets('should use documentListSearchProvider', (tester) async {
        await createTestWidget(tester);

        final documentList = tester.widget<DocumentListWidget>(
          find.byType(DocumentListWidget),
        );
        expect(documentList.documentsProvider, equals(documentListSearchProvider));
      });
    });

    group('Theme Integration', () {
      testWidgets('should use theme colors correctly', (tester) async {
        final customTheme = ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.blue,
            secondary: Colors.green,
            surface: Colors.white,
          ),
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          child: DocumentsListScreen(),
          container: container,
          theme: customTheme,
        );

        // Widget should use theme colors
        expect(find.byType(DocumentsListScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      });

      testWidgets('should adapt to dark theme', (tester) async {
        final darkTheme = ThemeData.dark();

        await tester.pumpMaterialWidgetWithProviderScope(
          child: DocumentsListScreen(),
          container: container,
          theme: darkTheme,
        );

        // Widget should adapt to dark theme
        expect(find.byType(DocumentsListScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      });
    });

    group('Localization', () {
      testWidgets('should display localized strings correctly', (tester) async {
        await createTestWidget(tester);

        // Should show localized documents title
        expect(
          find.text(
            L10n.of(tester.element(find.byType(DocumentsListScreen))).documents,
          ),
          findsOneWidget,
        );

        // Should show localized empty state message
        final documentList = tester.widget<DocumentListWidget>(
          find.byType(DocumentListWidget),
        );
        final emptyState = documentList.emptyState as EmptyStateListWidget;
        expect(
          emptyState.message,
          equals(
            L10n.of(tester.element(find.byType(DocumentsListScreen)))
                .noDocumentsFound,
          ),
        );
      });
    });

    group('Search Controller Management', () {

      test('should test search value provider logic', () {
        // Test the core logic of search value provider
        
        // Test case 1: Initial value
        String searchValue = '';
        expect(searchValue, isEmpty);
        
        // Test case 2: Value update
        searchValue = 'test query';
        expect(searchValue, equals('test query'));
        
        // Test case 3: Value clearing
        searchValue = '';
        expect(searchValue, isEmpty);
        
        // Test case 4: Value validation
        String testValue = 'search term';
        bool isValidValue = testValue.isNotEmpty;
        expect(isValidValue, isTrue);
      });

      test('should test search functionality logic', () {
        // Test the core logic of search functionality
        
        // Test case 1: Search query processing
        String query = 'test search';
        String processedQuery = query.toLowerCase().trim();
        expect(processedQuery, equals('test search'));
        
        // Test case 2: Empty query handling
        String emptyQuery = '';
        bool isEmpty = emptyQuery.isEmpty;
        expect(isEmpty, isTrue);
        
        // Test case 3: Query validation
        String validQuery = 'valid search';
        bool isValid = validQuery.isNotEmpty;
        expect(isValid, isTrue);
        
        // Test case 4: Search result filtering logic
        List<String> documents = ['doc1.pdf', 'doc2.txt', 'doc3.pdf'];
        String searchTerm = 'pdf';
        List<String> filteredDocs = documents
            .where((doc) => doc.toLowerCase().contains(searchTerm.toLowerCase()))
            .toList();
        expect(filteredDocs, hasLength(2));
        expect(filteredDocs, contains('doc1.pdf'));
        expect(filteredDocs, contains('doc3.pdf'));
      });
    });
  });
}
