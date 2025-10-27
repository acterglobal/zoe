import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/link/models/link_model.dart';
import 'package:zoe/features/link/providers/link_providers.dart';
import 'package:zoe/features/link/widgets/link_list_widget.dart';
import 'package:zoe/features/link/widgets/link_widget.dart';
import 'package:zoe/features/quick-search/widgets/quick_search_tab_section_header_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/mock_gorouter.dart';
import '../../../test-utils/test_utils.dart';
import '../utils/link_utils.dart';

void main() {
  group('LinkListWidget', () {
    late ProviderContainer container;
    late MockGoRouter mockGoRouter;

    setUp(() {
      container = ProviderContainer.test();
      mockGoRouter = MockGoRouter();
    });

    Future<void> pumpLinkListWidget(
      WidgetTester tester, {
      bool isEditing = false,
      bool showCardView = true,
      bool showSectionHeader = false,
      int? maxItems,
      Widget? emptyState,
      bool shrinkWrap = true,
    }) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        router: mockGoRouter,
        child: LinkListWidget(
          linksProvider: linkListProvider.select((list) => list),
          isEditing: isEditing,
          shrinkWrap: shrinkWrap,
          showCardView: showCardView,
          showSectionHeader: showSectionHeader,
          maxItems: maxItems,
          emptyState: emptyState ?? const SizedBox.shrink(),
        ),
      );
    }

    group('Empty State', () {
      testWidgets('renders default empty state when links are empty', (
        tester,
      ) async {
        // Clear all links
        final allLinks = container.read(linkListProvider);
        for (final link in allLinks) {
          container.read(linkListProvider.notifier).deleteLink(link.id);
        }

        await pumpLinkListWidget(tester, emptyState: const Text('No links found'));

        expect(find.text('No links found'), findsOneWidget);
      });
    });

    group('Link Rendering', () {
      testWidgets('renders links when list is not empty', (tester) async {
        await pumpLinkListWidget(tester);

        // Only 6 widgets are visible initially in the test environment
        expect(find.byType(LinkWidget), findsAtLeastNWidgets(6));
      });

      testWidgets('limits links when maxItems is specified', (tester) async {
        await pumpLinkListWidget(tester, maxItems: 2);

        expect(find.byType(LinkWidget), findsNWidgets(2));
      });

      testWidgets('renders all links when maxItems is null', (tester) async {
        await pumpLinkListWidget(tester);

        // Only 6 widgets are visible initially in the test environment
        expect(find.byType(LinkWidget), findsAtLeastNWidgets(6));
      });

      testWidgets('displays link titles correctly', (tester) async {
        final testLink = getLinkByIndex(container);

        await pumpLinkListWidget(tester);
        await tester.pumpAndSettle();

        expect(find.text(testLink.title), findsOneWidget);
      });
    });

    group('Card View', () {
      testWidgets('renders links in cards when showCardView is true', (
        tester,
      ) async {
        await pumpLinkListWidget(tester, showCardView: true);

        expect(find.byType(Card), findsAtLeastNWidgets(1));
        expect(find.byType(LinkWidget), findsWidgets);
      });

      testWidgets('renders links without cards when showCardView is false', (
        tester,
      ) async {
        await pumpLinkListWidget(tester, showCardView: false);

        expect(find.byType(Card), findsNothing);
        expect(find.byType(LinkWidget), findsWidgets);
      });
    });

    group('Section Header', () {
      testWidgets('shows section header when showSectionHeader is true', (
        tester,
      ) async {
        await pumpLinkListWidget(tester, showSectionHeader: true, maxItems: 2);

        expect(find.byType(QuickSearchTabSectionHeaderWidget), findsOneWidget);
        expect(find.byType(Column), findsWidgets);
      });

      testWidgets('hides section header when showSectionHeader is false', (
        tester,
      ) async {
        await pumpLinkListWidget(tester, showSectionHeader: false);

        expect(find.byType(QuickSearchTabSectionHeaderWidget), findsNothing);
      });

      testWidgets('section header displays localized title', (tester) async {
        await pumpLinkListWidget(tester, showSectionHeader: true, maxItems: 2);

        expect(
          find.text(
            L10n.of(
              tester.element(find.byType(QuickSearchTabSectionHeaderWidget)),
            ).links,
          ),
          findsOneWidget,
        );
      });
    });

    group('ListView Configuration', () {
      testWidgets('has correct ListView properties', (tester) async {
        await pumpLinkListWidget(tester);

        final listView = tester.widget<ListView>(find.byType(ListView));
        expect(listView.shrinkWrap, isTrue);
        expect(listView.physics, isA<NeverScrollableScrollPhysics>());
      });

      testWidgets('has correct physics configuration', (tester) async {
        await pumpLinkListWidget(tester);

        final listView = tester.widget<ListView>(find.byType(ListView));
        expect(listView.shrinkWrap, isTrue);
        expect(listView.physics, isA<NeverScrollableScrollPhysics>());
      });
    });

    group('Provider Integration', () {
      testWidgets('updates when links are added', (tester) async {
        await pumpLinkListWidget(tester);

        final initialCount = find.byType(LinkWidget).evaluate().length;
        expect(initialCount, greaterThan(0));

        // Add a new link
        final newLink = LinkModel(
          id: 'new-link-test',
          sheetId: 'sheet-1',
          parentId: 'sheet-1',
          title: 'New Link Test',
          url: 'https://example.com',
          orderIndex: 0,
        );
        container.read(linkListProvider.notifier).addLink(newLink);
        await tester.pumpAndSettle();

        // The provider should have been updated even if the new item isn't visible
        final providerCount = container.read(linkListProvider).length;
        expect(providerCount, greaterThan(initialCount));
      });

      testWidgets('updates when links are modified', (tester) async {
        final testLink = getLinkByIndex(container);

        await pumpLinkListWidget(tester);
        await tester.pumpAndSettle();

        expect(find.text(testLink.title), findsOneWidget);

        // Update the link title
        container
            .read(linkListProvider.notifier)
            .updateLinkTitle(testLink.id, 'Updated Link Title');
        await tester.pumpAndSettle();

        // Should display updated title
        expect(find.text('Updated Link Title'), findsOneWidget);
      });

      testWidgets('updates when links are deleted', (tester) async {
        final testLink = getLinkByIndex(container);

        await pumpLinkListWidget(tester);

        expect(find.byType(LinkWidget), findsAtLeastNWidgets(6));
        expect(find.text(testLink.title), findsOneWidget);

        // Delete the link
        container.read(linkListProvider.notifier).deleteLink(testLink.id);
        await tester.pumpAndSettle();

        // Should not show deleted link
        expect(find.text(testLink.title), findsNothing);
      });
    });
  });
}
