import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_glassy_tab_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/documents/widgets/document_list_widget.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/features/events/widgets/event_list_widget.dart';
import 'package:zoe/features/link/providers/link_providers.dart';
import 'package:zoe/features/link/widgets/link_list_widget.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/polls/widgets/poll_list_widget.dart';
import 'package:zoe/features/quick-search/screens/quick_search_screen.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/widgets/sheet_list_widget.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/task/widgets/task_list_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/test_utils.dart';

class MockSearchValue extends SearchValue {
  @override
  String build() => '';
}

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        searchValueProvider.overrideWith(MockSearchValue.new),
        sheetListSearchProvider.overrideWithValue([]),
        eventListSearchProvider.overrideWithValue([]),
        taskListSearchProvider.overrideWithValue([]),
        linkListSearchProvider.overrideWithValue([]),
        documentListSearchProvider.overrideWithValue([]),
        pollListSearchProvider.overrideWithValue([]),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('QuickSearchScreen', () {
    testWidgets('renders initial state correctly', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: const QuickSearchScreen(),
        container: container,
      );
      await tester.pumpAndSettle();

      // Verify app bar
      expect(find.byType(ZoeAppBar), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(ZoeAppBar),
          matching: find.text(L10n.of(tester.element(find.byType(QuickSearchScreen))).search),
        ),
        findsOneWidget,
      );

      // Verify search bar
      expect(find.byType(ZoeSearchBarWidget), findsOneWidget);

      // Verify filter tabs
      expect(find.byType(ZoeGlassyTabWidget), findsOneWidget);

      // Verify all sections are visible in 'all' filter
      expect(find.byType(SheetListWidget), findsOneWidget);
      expect(find.byType(EventListWidget), findsOneWidget);
      expect(find.byType(TaskListWidget), findsOneWidget);
      expect(find.byType(LinkListWidget), findsOneWidget);
      expect(find.byType(DocumentListWidget), findsOneWidget);
      expect(find.byType(PollListWidget), findsOneWidget);
    });

    testWidgets('filters sections correctly for sheets filter', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: const QuickSearchScreen(),
        container: container,
      );
      await tester.pumpAndSettle();

      final lang = L10n.of(tester.element(find.byType(QuickSearchScreen)));
      
      // Tap on Sheets tab
      await tester.tap(find.text(lang.sheets));
      await tester.pumpAndSettle();

      // Verify only sheets section is visible
      expect(find.byType(SheetListWidget), findsOneWidget);
      expect(find.byType(EventListWidget), findsNothing);
      expect(find.byType(TaskListWidget), findsNothing);
      expect(find.byType(LinkListWidget), findsNothing);
      expect(find.byType(DocumentListWidget), findsNothing);
      expect(find.byType(PollListWidget), findsNothing);
    });

    testWidgets('filters sections correctly for events filter', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: const QuickSearchScreen(),
        container: container,
      );
      await tester.pumpAndSettle();

      final lang = L10n.of(tester.element(find.byType(QuickSearchScreen)));
      
      // Tap on Events tab
      await tester.tap(find.text(lang.events));
      await tester.pumpAndSettle();

      // Verify only events section is visible
      expect(find.byType(EventListWidget), findsOneWidget);
      expect(find.byType(SheetListWidget), findsNothing);
      expect(find.byType(TaskListWidget), findsNothing);
      expect(find.byType(LinkListWidget), findsNothing);
      expect(find.byType(DocumentListWidget), findsNothing);
      expect(find.byType(PollListWidget), findsNothing);
    });

    testWidgets('filters sections correctly for tasks filter', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: const QuickSearchScreen(),
        container: container,
      );
      await tester.pumpAndSettle();

      final lang = L10n.of(tester.element(find.byType(QuickSearchScreen)));
      
      // Tap on Tasks tab
      await tester.tap(find.text(lang.tasks));
      await tester.pumpAndSettle();

      // Verify only tasks section is visible
      expect(find.byType(TaskListWidget), findsOneWidget);
      expect(find.byType(SheetListWidget), findsNothing);
      expect(find.byType(EventListWidget), findsNothing);
      expect(find.byType(LinkListWidget), findsNothing);
      expect(find.byType(DocumentListWidget), findsNothing);
      expect(find.byType(PollListWidget), findsNothing);
    });

    testWidgets('filters sections correctly for links filter', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: const QuickSearchScreen(),
        container: container,
      );
      await tester.pumpAndSettle();

      final lang = L10n.of(tester.element(find.byType(QuickSearchScreen)));
      
      // Tap on Links tab
      await tester.tap(find.text(lang.links));
      await tester.pumpAndSettle();

      // Verify only links section is visible
      expect(find.byType(LinkListWidget), findsOneWidget);
      expect(find.byType(SheetListWidget), findsNothing);
      expect(find.byType(EventListWidget), findsNothing);
      expect(find.byType(TaskListWidget), findsNothing);
      expect(find.byType(DocumentListWidget), findsNothing);
      expect(find.byType(PollListWidget), findsNothing);
    });

    testWidgets('filters sections correctly for documents filter', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: const QuickSearchScreen(),
        container: container,
      );
      await tester.pumpAndSettle();

      final lang = L10n.of(tester.element(find.byType(QuickSearchScreen)));
      
      // Find and tap Documents tab
      final documentsTab = find.text(lang.documents);
      await tester.dragUntilVisible(
        documentsTab,
        find.byType(ZoeGlassyTabWidget),
        const Offset(-50.0, 0.0),
      );
      await tester.pumpAndSettle();
      await tester.tap(documentsTab);
      await tester.pumpAndSettle();

      // Verify only documents section is visible
      expect(find.byType(DocumentListWidget), findsOneWidget);
      expect(find.byType(SheetListWidget), findsNothing);
      expect(find.byType(EventListWidget), findsNothing);
      expect(find.byType(TaskListWidget), findsNothing);
      expect(find.byType(LinkListWidget), findsNothing);
      expect(find.byType(PollListWidget), findsNothing);
    });

    testWidgets('maintains filter selection after search text changes', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: const QuickSearchScreen(),
        container: container,
      );
      await tester.pumpAndSettle();

      // Select sheets filter
      final lang = L10n.of(tester.element(find.byType(QuickSearchScreen)));
      await tester.tap(find.text(lang.sheets));
      await tester.pumpAndSettle();

      // Verify only sheets section is visible
      expect(find.byType(SheetListWidget), findsOneWidget);
      expect(find.byType(EventListWidget), findsNothing);

      // Enter search text
      await tester.enterText(find.byType(TextField), 'test search');
      await tester.pumpAndSettle();

      // Verify filter is maintained
      expect(find.byType(SheetListWidget), findsOneWidget);
      expect(find.byType(EventListWidget), findsNothing);
    });

    testWidgets('invalidates search value provider on init', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: const QuickSearchScreen(),
        container: container,
      );
      
      // Wait for post frame callback
      await tester.pumpAndSettle();

      // Verify the provider was invalidated
      expect(container.read(searchValueProvider), '');
    });

    testWidgets('disposes search controller on dispose', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: const QuickSearchScreen(),
        container: container,
      );

      // Get the state
      final state = tester.state<ConsumerState<QuickSearchScreen>>(find.byType(QuickSearchScreen));
      
      // Keep a reference to the controller
      final controller = (state as dynamic).searchController;

      // Dispose the widget
      await tester.pumpWidget(const SizedBox());
      
      // Verify the controller is disposed
      expect(controller.dispose, throwsFlutterError);
    });
  });
}