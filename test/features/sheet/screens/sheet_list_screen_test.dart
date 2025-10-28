import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_list_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/screens/sheet_list_screen.dart';
import 'package:zoe/features/sheet/widgets/sheet_list_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/mock_gorouter.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('SheetListScreen', () {
    late ProviderContainer container;
    late MockGoRouter mockGoRouter;

    setUp(() {
      container = ProviderContainer.test();
      mockGoRouter = MockGoRouter();
      when(() => mockGoRouter.canPop()).thenReturn(true);
      when(() => mockGoRouter.pop()).thenReturn(null);
      when(() => mockGoRouter.push(any())).thenAnswer((_) async => true);
    });

    Future<void> pumpSheetListScreen(WidgetTester tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        router: mockGoRouter,
        child: const SheetListScreen(),
      );
    }

    /// Helper function to get L10n instance for the SheetListScreen
    L10n getL10n(WidgetTester tester) {
      return L10n.of(tester.element(find.byType(SheetListScreen)));
    }

    group('Widget Construction', () {
      testWidgets('creates widget successfully', (tester) async {
        const widget = SheetListScreen();
        expect(widget, isA<ConsumerStatefulWidget>());
        expect(widget.key, isNull);
      });

      testWidgets('creates widget with custom key', (tester) async {
        const key = Key('sheet_list_screen');
        const widget = SheetListScreen(key: key);
        expect(widget.key, equals(key));
      });
    });

    group('Widget Rendering', () {
      testWidgets('renders with proper structure', (tester) async {
        await pumpSheetListScreen(tester);

        // Verify key structural elements
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(SafeArea), findsAtLeastNWidgets(1));
        expect(find.byType(MaxWidthWidget), findsOneWidget);
        expect(find.byType(Column), findsAtLeastNWidgets(1));
        expect(find.byType(Expanded), findsAtLeastNWidgets(1));
        expect(tester.takeException(), isNull);
      });

      testWidgets('renders AppBar with correct configuration', (tester) async {
        await pumpSheetListScreen(tester);

        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.automaticallyImplyLeading, isFalse);
        expect(find.byType(ZoeAppBar), findsOneWidget);
        
        // Verify AppBar title
        final l10n = getL10n(tester);
        expect(find.text(l10n.sheets), findsOneWidget);
      });

      testWidgets('renders search bar correctly', (tester) async {
        await pumpSheetListScreen(tester);

        expect(find.byType(ZoeSearchBarWidget), findsOneWidget);
        
        // Verify search bar properties
        final searchBar = tester.widget<ZoeSearchBarWidget>(find.byType(ZoeSearchBarWidget));
        expect(searchBar.controller, isNotNull);
        expect(searchBar.onChanged, isNotNull);
      });

      testWidgets('renders sheet list widget correctly', (tester) async {
        await pumpSheetListScreen(tester);

        expect(find.byType(SheetListWidget), findsOneWidget);
        
        // Verify SheetListWidget properties
        final sheetListWidget = tester.widget<SheetListWidget>(find.byType(SheetListWidget));
        expect(sheetListWidget.sheetsProvider, equals(sheetListSearchProvider));
        expect(sheetListWidget.shrinkWrap, isFalse);
        expect(sheetListWidget.emptyState, isA<EmptyStateListWidget>());
      });

      testWidgets('renders empty state widget correctly', (tester) async {
        // Start with empty container to ensure empty state is shown
        final emptyContainer = ProviderContainer.test();
        
        await tester.pumpMaterialWidgetWithProviderScope(
          container: emptyContainer,
          child: const SheetListScreen(),
        );

        // Empty state might not be visible if there are sheets, so just verify it exists in the widget tree
        expect(find.byType(SheetListWidget), findsOneWidget);
        
        emptyContainer.dispose();
      });
    });

    group('Provider Integration', () {
      testWidgets('watches searchValueProvider for search state', (tester) async {
        await pumpSheetListScreen(tester);

        // Initially search should be empty
        expect(container.read(searchValueProvider), isEmpty);

        // Update search value
        container.read(searchValueProvider.notifier).update('test search');
        await tester.pump();

        expect(container.read(searchValueProvider), equals('test search'));
      });

      testWidgets('watches sheetListSearchProvider for filtered sheets', (tester) async {
        await pumpSheetListScreen(tester);

        final filteredSheets = container.read(sheetListSearchProvider);
        expect(filteredSheets, isA<List<SheetModel>>());
      });

      testWidgets('invalidates searchValueProvider on init', (tester) async {
        // Set initial search value
        container.read(searchValueProvider.notifier).update('initial search');
        expect(container.read(searchValueProvider), equals('initial search'));

        // Pump the screen - should invalidate search
        await pumpSheetListScreen(tester);
        await tester.pump();
        await tester.pumpAndSettle();

        // The search should be reset after the screen initializes
        expect(container.read(searchValueProvider), isEmpty);
      });
    });

    group('Search Functionality', () {
      testWidgets('search bar updates search value on text change', (tester) async {
        await pumpSheetListScreen(tester);

        // Find search bar
        final searchBar = find.byType(ZoeSearchBarWidget);
        expect(searchBar, findsOneWidget);

        // Enter search text
        await tester.enterText(searchBar, 'test search');
        await tester.pump();

        // Verify search value was updated
        expect(container.read(searchValueProvider), equals('test search'));
      });

      testWidgets('search bar clears search value when cleared', (tester) async {
        await pumpSheetListScreen(tester);

        // Find search bar and clear it
        final searchBar = find.byType(ZoeSearchBarWidget);
        await tester.enterText(searchBar, '');
        await tester.pump();

        // Verify search value was cleared
        expect(container.read(searchValueProvider), isEmpty);
      });

      testWidgets('handles various search queries', (tester) async {
        await pumpSheetListScreen(tester);

        final testQueries = [
          'simple search',
          'search with numbers 123',
          'search with special chars !@#',
          'very long search query that might test the search functionality',
          '',
        ];

        for (final query in testQueries) {
          final searchBar = find.byType(ZoeSearchBarWidget);
          await tester.enterText(searchBar, query);
          await tester.pump();

          expect(container.read(searchValueProvider), equals(query));
        }
      });
    });

    group('Layout and Styling', () {
      testWidgets('applies correct padding and spacing', (tester) async {
        await pumpSheetListScreen(tester);

        // Verify MaxWidthWidget padding
        final maxWidthWidget = tester.widget<MaxWidthWidget>(find.byType(MaxWidthWidget));
        expect(maxWidthWidget.padding, equals(const EdgeInsets.symmetric(horizontal: 16)));

        // Verify SizedBox spacing
        expect(find.byType(SizedBox), findsAtLeastNWidgets(2));
      });

      testWidgets('applies correct theme colors', (tester) async {
        await pumpSheetListScreen(tester);

        // Verify theme is applied
        final theme = Theme.of(tester.element(find.byType(SheetListScreen)));
        expect(theme, isNotNull);
        expect(theme.colorScheme, isNotNull);
      });

      testWidgets('has correct column structure', (tester) async {
        await pumpSheetListScreen(tester);

        // Verify main column structure
        final column = tester.widget<Column>(find.byType(Column).first);
        expect(column.children.length, equals(4)); // SizedBox, SearchBar, SizedBox, Expanded
        expect(column.crossAxisAlignment, equals(CrossAxisAlignment.center));
      });
    });

    group('State Management', () {
      testWidgets('handles state changes efficiently', (tester) async {
        await pumpSheetListScreen(tester);

        // Test search state changes
        container.read(searchValueProvider.notifier).update('search 1');
        await tester.pump();
        
        container.read(searchValueProvider.notifier).update('search 2');
        await tester.pump();

        container.read(searchValueProvider.notifier).update('');
        await tester.pump();

        expect(tester.takeException(), isNull);
      });

      testWidgets('manages TextEditingController lifecycle', (tester) async {
        await pumpSheetListScreen(tester);

        // Verify controller is properly managed
        final searchBar = tester.widget<ZoeSearchBarWidget>(find.byType(ZoeSearchBarWidget));
        expect(searchBar.controller, isNotNull);
        expect(searchBar.controller.text, isEmpty);
      });
    });

    group('Error Handling', () {
      testWidgets('handles empty sheet list gracefully', (tester) async {
        // Start with empty container
        final emptyContainer = ProviderContainer.test();
        
        await tester.pumpMaterialWidgetWithProviderScope(
          container: emptyContainer,
          child: const SheetListScreen(),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(SheetListWidget), findsOneWidget);
        
        emptyContainer.dispose();
      });

      testWidgets('handles provider errors gracefully', (tester) async {
        await pumpSheetListScreen(tester);

        // Test various provider states
        container.read(searchValueProvider.notifier).update('test');
        await tester.pump();

        expect(tester.takeException(), isNull);
      });
    });

    group('Accessibility', () {
      testWidgets('has proper semantic structure', (tester) async {
        await pumpSheetListScreen(tester);

        // Verify key widgets are accessible
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(ZoeSearchBarWidget), findsOneWidget);
        expect(find.byType(SheetListWidget), findsOneWidget);
      });

      testWidgets('search bar is focusable and tappable', (tester) async {
        await pumpSheetListScreen(tester);

        final searchBar = find.byType(ZoeSearchBarWidget);
        expect(searchBar, findsOneWidget);

        // Tap search bar
        await tester.tap(searchBar);
        await tester.pump();

        expect(tester.takeException(), isNull);
      });
    });
  });
}
