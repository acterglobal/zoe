import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/events/data/event_list.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/widgets/event_list_widget.dart';
import 'package:zoe/features/events/widgets/event_widget.dart';
import 'package:zoe/features/quick-search/widgets/quick_search_tab_section_header_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/test_utils.dart';
import '../../../test-utils/mock_gorouter.dart';

void main() {
  group('EventListWidget', () {
    late List<EventModel> testEvents;
    late ProviderContainer container;

    setUp(() {
      testEvents = eventList.take(3).toList();
      container = ProviderContainer();
    });

    Future<void> pumpWidget(
      WidgetTester tester, {
      required List<EventModel> events,
      bool isEditing = false,
      int? maxItems,
      bool shrinkWrap = true,
      Widget? emptyState,
      bool showSectionHeader = false,
      GoRouter? router,
    }) async {
      final provider = Provider<List<EventModel>>((ref) => events);
      
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        router: router,
        child: EventListWidget(
          eventsProvider: provider,
          isEditing: isEditing,
          maxItems: maxItems,
          shrinkWrap: shrinkWrap,
          emptyState: emptyState ?? const SizedBox.shrink(),
          showSectionHeader: showSectionHeader,
        ),
      );
      await tester.pump();
    }

    group('Basic Rendering', () {
      testWidgets('renders event list with events', (tester) async {
        await pumpWidget(tester, events: testEvents);

        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(EventWidget), findsNWidgets(3));
      });

      testWidgets('shows empty state when no events', (tester) async {
        const emptyWidget = Text('No events found!');
        await pumpWidget(
          tester,
          events: [],
          emptyState: emptyWidget,
        );

        expect(find.byType(ListView), findsNothing);
        expect(find.text('No events found!'), findsOneWidget);
      });

      testWidgets('shows default empty state when no events', (tester) async {
        await pumpWidget(tester, events: []);

        expect(find.byType(ListView), findsNothing);
        expect(find.byType(SizedBox), findsOneWidget);
      });
    });

    group('Section Header', () {
      testWidgets('shows section header when enabled', (tester) async {
        await pumpWidget(
          tester,
          events: testEvents,
          showSectionHeader: true,
        );

        expect(find.byType(QuickSearchTabSectionHeaderWidget), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
      });

      testWidgets('hides section header when disabled', (tester) async {
        await pumpWidget(
          tester,
          events: testEvents,
          showSectionHeader: false,
        );

        expect(find.byType(QuickSearchTabSectionHeaderWidget), findsNothing);
        expect(find.byType(ListView), findsOneWidget);
      });

      testWidgets('section header has correct properties', (tester) async {
        await pumpWidget(
          tester,
          events: testEvents,
          showSectionHeader: true,
        );

        final header = tester.widget<QuickSearchTabSectionHeaderWidget>(
          find.byType(QuickSearchTabSectionHeaderWidget),
        );

        final context = tester.element(find.byType(EventListWidget));
        final l10n = L10n.of(context);

        expect(header.title, l10n.events);
        expect(header.icon, Icons.event_rounded);
        expect(header.color, AppColors.secondaryColor);
      });

      testWidgets('section header has correct spacing', (tester) async {
        await pumpWidget(
          tester,
          events: testEvents,
          showSectionHeader: true,
        );

        final sizedBoxes = tester.widgetList<SizedBox>(
          find.descendant(
            of: find.byType(Column),
            matching: find.byType(SizedBox),
          ),
        );

        expect(sizedBoxes.any((box) => box.height == 16), isTrue);
      });
    });

    group('Max Items Limitation', () {
      testWidgets('limits items when maxItems specified', (tester) async {
        await pumpWidget(
          tester,
          events: testEvents,
          maxItems: 2,
        );

        expect(find.byType(EventWidget), findsNWidgets(2));
      });

      testWidgets('shows all items when maxItems is null', (tester) async {
        await pumpWidget(
          tester,
          events: testEvents,
          maxItems: null,
        );

        expect(find.byType(EventWidget), findsNWidgets(3));
      });

      testWidgets('handles maxItems of zero', (tester) async {
        await pumpWidget(
          tester,
          events: testEvents,
          maxItems: 0,
        );

        expect(find.byType(EventWidget), findsNothing);
      });
    });

    group('ListView Configuration', () {
      testWidgets('configures shrinkWrap correctly', (tester) async {
        await pumpWidget(
          tester,
          events: testEvents,
          shrinkWrap: true,
        );

        final listView = tester.widget<ListView>(find.byType(ListView));
        expect(listView.shrinkWrap, isTrue);
        expect(listView.physics, isA<NeverScrollableScrollPhysics>());
      });

      testWidgets('configures scrollable physics when shrinkWrap false', (tester) async {
        await pumpWidget(
          tester,
          events: testEvents,
          shrinkWrap: false,
        );

        final listView = tester.widget<ListView>(find.byType(ListView));
        expect(listView.shrinkWrap, isFalse);
        expect(listView.physics, isA<AlwaysScrollableScrollPhysics>());
      });
    });

    group('Event Widget Integration', () {
      testWidgets('creates EventWidget with correct keys', (tester) async {
        await pumpWidget(tester, events: testEvents);

        final eventWidgets = tester.widgetList<EventWidget>(find.byType(EventWidget));
        
        for (int i = 0; i < testEvents.length; i++) {
          final eventWidget = eventWidgets.elementAt(i);
          final expectedEvent = testEvents[i];
          
          expect(eventWidget.key, isA<ValueKey<String>>());
          expect((eventWidget.key as ValueKey<String>).value, expectedEvent.id);
          expect(eventWidget.eventId, expectedEvent.id);
        }
      });
    });

    group('Edge Cases', () {
      testWidgets('handles single event', (tester) async {
        await pumpWidget(tester, events: [testEvents.first]);

        expect(find.byType(EventWidget), findsOneWidget);
      });

      testWidgets('handles large number of events', (tester) async {
        final manyEvents = List.generate(10, (index) => 
          testEvents.first.copyWith(id: 'event-$index')
        );
        
        await pumpWidget(tester, events: manyEvents);

        expect(find.byType(EventWidget), findsAtLeastNWidgets(5));
      });
    });

    group('Navigation Integration', () {
      testWidgets('tapping View All navigates to events list', (tester) async {
        final mockRouter = await mockAnyPushGoRouter();

        await pumpWidget(
          tester,
          events: testEvents,
          showSectionHeader: true,
          router: mockRouter,
        );

        final l10n = L10n.of(tester.element(find.byType(EventListWidget)));
        final viewAllFinder = find.text(l10n.viewAll);

        await tester.tap(viewAllFinder);
        await tester.pumpAndSettle();

        verify(() => mockRouter.push(AppRoutes.eventsList.route)).called(1);
      });
    });
  });
}
