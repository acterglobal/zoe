import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_list_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/link/providers/link_providers.dart';
import 'package:zoe/features/link/screens/links_list_screen.dart';
import 'package:zoe/features/link/widgets/link_list_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/test_utils.dart';
import '../../../test-utils/mock_searchValue.dart';

void main() {
  group('LinksListScreen', () {
    late ProviderContainer container;

    Future<void> createTestWidget(WidgetTester tester, {Key? key}) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: LinksListScreen(key: key),
      );
    }

    setUp(() {
      container = ProviderContainer.test(
        overrides: [searchValueProvider.overrideWith(MockSearchValue.new)],
      );
    });

    group('Constructor and Initialization', () {
      testWidgets('should render LinksListScreen correctly', (tester) async {
        await createTestWidget(tester);

        expect(find.byType(LinksListScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(ZoeAppBar), findsOneWidget);
      });

      test('should use provided key', () {
        const key = Key('links-list-screen-key');
        final screen = LinksListScreen(key: key);
        expect(screen.key, equals(key));
      });
    });

    group('Widget Structure', () {
      testWidgets('should have correct app bar properties', (tester) async {
        await createTestWidget(tester);

        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.automaticallyImplyLeading, isFalse);

        final zoeAppBar = tester.widget<ZoeAppBar>(find.byType(ZoeAppBar));
        expect(
          zoeAppBar.title,
          equals(L10n.of(tester.element(find.byType(LinksListScreen))).links),
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
    });

    group('Link List Widget', () {
      testWidgets('should have link list widget', (tester) async {
        await createTestWidget(tester);

        expect(find.byType(LinkListWidget), findsOneWidget);
      });

      testWidgets('should have correct link list properties', (tester) async {
        await createTestWidget(tester);

        final linkList = tester.widget<LinkListWidget>(
          find.byType(LinkListWidget),
        );
        expect(linkList.linksProvider, equals(linkListSearchProvider));
        expect(linkList.isEditing, isFalse);
        expect(linkList.shrinkWrap, isFalse);
        expect(linkList.emptyState, isNotNull);
      });

      testWidgets('should have correct empty state widget', (tester) async {
        await createTestWidget(tester);

        final linkList = tester.widget<LinkListWidget>(
          find.byType(LinkListWidget),
        );
        final emptyState = linkList.emptyState as EmptyStateListWidget;

        expect(
          emptyState.message,
          equals(
            L10n.of(tester.element(find.byType(LinksListScreen))).noLinksFound,
          ),
        );
        expect(emptyState.color, equals(Colors.blue));
        expect(emptyState.contentType, equals(ContentType.link));
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

        // Check that the SizedBox widgets have height values
        final firstSizedBox = tester.widget<SizedBox>(sizedBoxes.at(0));
        expect(firstSizedBox.height, anyOf([equals(10), equals(20)]));

        final secondSizedBox = tester.widget<SizedBox>(sizedBoxes.at(1));
        expect(secondSizedBox.height, anyOf([equals(10), equals(20)]));
      });

      testWidgets('should have Expanded widget for link list', (tester) async {
        await createTestWidget(tester);

        expect(find.byType(Expanded), findsAtLeastNWidgets(1));

        // Find the Expanded widget that contains LinkListWidget
        final expandedWidgets = find.byType(Expanded);
        expect(expandedWidgets, findsAtLeastNWidgets(1));

        // Check that at least one Expanded widget contains LinkListWidget
        bool foundLinkList = false;
        for (int i = 0; i < expandedWidgets.evaluate().length; i++) {
          final expanded = tester.widget<Expanded>(expandedWidgets.at(i));
          if (expanded.child is LinkListWidget) {
            foundLinkList = true;
            break;
          }
        }
        expect(foundLinkList, isTrue);
      });
    });

    group('Provider Integration', () {
      testWidgets('should use linkListSearchProvider', (tester) async {
        await createTestWidget(tester);

        final linkList = tester.widget<LinkListWidget>(
          find.byType(LinkListWidget),
        );
        expect(linkList.linksProvider, equals(linkListSearchProvider));
      });

      testWidgets('should respond to search provider updates', (tester) async {
        await createTestWidget(tester);

        // Update search value
        container.read(searchValueProvider.notifier).update('test');

        // The widget should rebuild with the new search value
        await tester.pump();

        expect(find.byType(LinksListScreen), findsOneWidget);
        expect(find.byType(LinkListWidget), findsOneWidget);
      });
    });

    group('Localization', () {
      testWidgets('should display localized strings correctly', (tester) async {
        await createTestWidget(tester);

        // Should show localized links title
        expect(
          find.text(
            L10n.of(tester.element(find.byType(LinksListScreen))).links,
          ),
          findsOneWidget,
        );

        // Should show localized empty state message
        final linkList = tester.widget<LinkListWidget>(
          find.byType(LinkListWidget),
        );
        final emptyState = linkList.emptyState as EmptyStateListWidget;
        expect(
          emptyState.message,
          equals(
            L10n.of(tester.element(find.byType(LinksListScreen))).noLinksFound,
          ),
        );
      });
    });

    group('Search Controller Management', () {
      testWidgets('should handle multiple search updates', (tester) async {
        await createTestWidget(tester);

        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);

        // Type first search
        await tester.enterText(textField, 'first');
        await tester.pump();

        // Clear and type second search
        await tester.enterText(textField, '');
        await tester.pump();
        await tester.enterText(textField, 'second');
        await tester.pump();

        final textFieldWidget = tester.widget<TextField>(textField);
        expect(textFieldWidget.controller?.text, equals('second'));
      });
    });

    group('Initial State', () {
      testWidgets('should render with empty search', (tester) async {
        await createTestWidget(tester);

        // Search field should be empty initially
        final textField = find.byType(TextField);
        final textFieldWidget = tester.widget<TextField>(textField);
        expect(textFieldWidget.controller?.text, isEmpty);
      });
    });
  });
}
