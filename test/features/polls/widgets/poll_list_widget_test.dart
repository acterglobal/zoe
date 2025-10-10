import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/features/polls/data/polls.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/widgets/poll_list_widget.dart';
import 'package:zoe/features/polls/widgets/poll_widget.dart';
import 'package:zoe/features/quick-search/widgets/quick_search_tab_section_header_widget.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('PollListWidget Tests', () {
    late List<PollModel> testPolls;

    setUp(() {
      testPolls = polls.take(2).toList(); // Use first 2 polls for testing
    });

    Future<void> createWidgetUnderTest({
      required WidgetTester tester,
      required Provider<List<PollModel>> pollsProvider,
      required bool isEditing,
      int? maxItems,
      bool shrinkWrap = true,
      bool showCardView = true,
      Widget emptyState = const SizedBox.shrink(),
      bool showSectionHeader = false,
    }) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: PollListWidget(
          pollsProvider: pollsProvider,
          isEditing: isEditing,
          maxItems: maxItems,
          shrinkWrap: shrinkWrap,
          showCardView: showCardView,
          emptyState: emptyState,
          showSectionHeader: showSectionHeader,
        ),
        container: ProviderContainer.test(
          overrides: [
            pollsProvider.overrideWithValue(testPolls),
            searchValueProvider.overrideWith(() => SearchValue()),
          ],
        ),
      );
    }

    group('Basic Rendering', () {
      testWidgets('renders list of polls', (tester) async {
        final pollsProvider = Provider<List<PollModel>>((ref) => testPolls);

        await createWidgetUnderTest(
          tester: tester,
          pollsProvider: pollsProvider,
          isEditing: false,
          showCardView: false,
        );

        // Should find ListView
        expect(find.byType(ListView), findsOneWidget);

        // Should find PollWidgets
        expect(find.byType(PollWidget), findsNWidgets(testPolls.length));
      });

      testWidgets('renders empty state when no polls', (tester) async {
        final pollsProvider = Provider<List<PollModel>>((ref) => []);
        const customEmptyState = Text('No polls found');

        await tester.pumpMaterialWidgetWithProviderScope(
          child: PollListWidget(
            pollsProvider: pollsProvider,
            isEditing: false,
            emptyState: customEmptyState,
          ),
          container: ProviderContainer.test(
            overrides: [
              pollsProvider.overrideWithValue([]),
              searchValueProvider.overrideWith(() => SearchValue()),
            ],
          ),
        );

        // Should find custom empty state
        expect(find.text('No polls found'), findsOneWidget);

        // Should not find ListView or PollWidgets
        expect(find.byType(ListView), findsNothing);
        expect(find.byType(PollWidget), findsNothing);
      });
    });

    group('Max Items Limitation', () {
      testWidgets('limits items when maxItems is specified', (tester) async {
        final pollsProvider = Provider<List<PollModel>>((ref) => testPolls);

        await createWidgetUnderTest(
          tester: tester,
          pollsProvider: pollsProvider,
          isEditing: false,
          maxItems: 1,
        );

        // Should only show 1 poll despite having 2
        expect(find.byType(PollWidget), findsOneWidget);
      });

      testWidgets('shows all items when maxItems is null', (tester) async {
        final pollsProvider = Provider<List<PollModel>>((ref) => testPolls);

        await createWidgetUnderTest(
          tester: tester,
          pollsProvider: pollsProvider,
          isEditing: false,
          maxItems: null,
        );

        // Should show all polls
        expect(find.byType(PollWidget), findsNWidgets(testPolls.length));
      });

      testWidgets('handles maxItems greater than available polls', (
        tester,
      ) async {
        final pollsProvider = Provider<List<PollModel>>((ref) => testPolls);

        await createWidgetUnderTest(
          tester: tester,
          pollsProvider: pollsProvider,
          isEditing: false,
          maxItems: 10,
        );

        // Should show all available polls (2)
        expect(find.byType(PollWidget), findsNWidgets(testPolls.length));
      });
    });

    group('ListView Properties', () {
      testWidgets('uses shrinkWrap when enabled', (tester) async {
        final pollsProvider = Provider<List<PollModel>>((ref) => testPolls);

        await createWidgetUnderTest(
          tester: tester,
          pollsProvider: pollsProvider,
          isEditing: false,
          shrinkWrap: true,
        );

        final listView = tester.widget<ListView>(find.byType(ListView));

        expect(listView.shrinkWrap, true);
        expect(listView.physics, const NeverScrollableScrollPhysics());
      });

      testWidgets('disables shrinkWrap when false', (tester) async {
        final pollsProvider = Provider<List<PollModel>>((ref) => testPolls);

        await createWidgetUnderTest(
          tester: tester,
          pollsProvider: pollsProvider,
          isEditing: false,
          shrinkWrap: false,
        );

        final listView = tester.widget<ListView>(find.byType(ListView));

        expect(listView.shrinkWrap, false);
        expect(listView.physics, isA<ScrollPhysics>());
      });
    });

    group('test Properties', () {
      testWidgets('applies correct styling to GlassyContainer', (tester) async {
        final pollsProvider = Provider<List<PollModel>>((ref) => testPolls);

        await createWidgetUnderTest(
          tester: tester,
          pollsProvider: pollsProvider,
          isEditing: false,
          showCardView: true,
        );

        final glassyContainers = tester.widgetList<GlassyContainer>(
          find.byType(GlassyContainer),
        );

        // Check that we have containers
        expect(glassyContainers.isNotEmpty, true);

        // Check properties of first container
        final firstContainer = glassyContainers.first;
        expect(firstContainer.borderRadius, isA<BorderRadius>());
        expect(firstContainer.borderOpacity, isA<double>());
        expect(firstContainer.margin, isA<EdgeInsets>());
        expect(firstContainer.padding, isA<EdgeInsets>());
      });

      testWidgets('uses correct key for PollWidget', (tester) async {
        final pollsProvider = Provider<List<PollModel>>((ref) => testPolls);

        await createWidgetUnderTest(
          tester: tester,
          pollsProvider: pollsProvider,
          isEditing: false,
          showCardView: true,
        );

        final pollWidgets = tester.widgetList<PollWidget>(
          find.byType(PollWidget),
        );

        // Check that we have the expected number of widgets
        expect(pollWidgets.length, testPolls.length);

        // Check that each widget has a pollId
        for (final pollWidget in pollWidgets) {
          expect(pollWidget.pollId, isA<String>());
        }
      });
    });

    group('Section Header', () {
      testWidgets('shows section header when enabled', (tester) async {
        final pollsProvider = Provider<List<PollModel>>((ref) => testPolls);

        await createWidgetUnderTest(
          tester: tester,
          pollsProvider: pollsProvider,
          isEditing: false,
          showSectionHeader: true,
          maxItems: 1, // Limit items to prevent layout issues
        );

        // Should find QuickSearchTabSectionHeaderWidget
        expect(find.byType(QuickSearchTabSectionHeaderWidget), findsOneWidget);

        // Should find SizedBox for spacing
        expect(find.byType(SizedBox), findsWidgets);

        // Should still find ListView
        expect(find.byType(ListView), findsOneWidget);

        // Verify the widget renders
        expect(find.byType(PollListWidget), findsOneWidget);
      });

      testWidgets('hides section header when disabled', (tester) async {
        final pollsProvider = Provider<List<PollModel>>((ref) => testPolls);

        await createWidgetUnderTest(
          tester: tester,
          pollsProvider: pollsProvider,
          isEditing: false,
          showSectionHeader: false,
        );

        // Should not find QuickSearchTabSectionHeaderWidget
        expect(find.byType(QuickSearchTabSectionHeaderWidget), findsNothing);

        // Should find ListView directly
        expect(find.byType(ListView), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles empty polls list', (tester) async {
        final pollsProvider = Provider<List<PollModel>>((ref) => []);

        await tester.pumpMaterialWidgetWithProviderScope(
          child: PollListWidget(pollsProvider: pollsProvider, isEditing: false),
          container: ProviderContainer.test(
            overrides: [
              pollsProvider.overrideWithValue([]),
              searchValueProvider.overrideWith(() => SearchValue()),
            ],
          ),
        );

        expect(find.byType(ListView), findsNothing);
        expect(find.byType(PollWidget), findsNothing);
      });

      testWidgets('handles zero maxItems', (tester) async {
        final pollsProvider = Provider<List<PollModel>>((ref) => testPolls);

        await createWidgetUnderTest(
          tester: tester,
          pollsProvider: pollsProvider,
          isEditing: false,
          maxItems: 0,
        );

        expect(find.byType(PollWidget), findsNothing);
      });
    });
  });
}
