import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_list_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:zoe/features/events/data/event_list.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/features/events/screens/events_list_screen.dart';
import 'package:zoe/features/events/widgets/event_list_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/test_utils.dart';
 

void main() {
  group('EventsListScreen', () {
    late ProviderContainer container;
    late List<EventModel> testEvents;

    setUp(() {
      container = ProviderContainer();
      testEvents = eventList.take(3).toList();
    });

    Future<void> pumpScreen(
      WidgetTester tester, {
      List<EventModel>? events,
    }) async {
      final scoped = ProviderContainer(overrides: [
        eventListSearchProvider.overrideWithValue(events ?? []),
      ]);

      await tester.pumpMaterialWidgetWithProviderScope(
        child: const EventsListScreen(),
        container: scoped,
      );
      await tester.pump();

      // Replace the global container with scoped for provider reads if needed
      container.dispose();
      container = scoped;
    }

    testWidgets('renders app bar, search bar and event list', (tester) async {
      await pumpScreen(tester, events: testEvents);

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(ZoeAppBar), findsOneWidget);
      expect(
        find.text(L10n.of(tester.element(find.byType(EventsListScreen))).events),
        findsWidgets,
      );
      expect(find.byType(ZoeSearchBarWidget), findsOneWidget);
      expect(find.byType(MaxWidthWidget), findsOneWidget);
      expect(find.byType(EventListWidget), findsOneWidget);
    });

    testWidgets('shows empty state when no events found', (tester) async {
      await pumpScreen(tester, events: []);

      expect(find.byType(EmptyStateListWidget), findsOneWidget);
      expect(
        find.text(L10n.of(tester.element(find.byType(EventsListScreen))).noEventsFound),
        findsOneWidget,
      );
    });

    testWidgets('updates searchValueProvider when typing in search bar', (tester) async {
      await pumpScreen(tester, events: testEvents);

      // Keep the provider alive and capture updates
      String? observed;
      final sub = container.listen<String>(
        searchValueProvider,
        (prev, next) => observed = next,
        fireImmediately: true,
      );

      // Find the TextField inside search bar and type
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Due to post-frame invalidation in initState, type twice
      await tester.enterText(textField, 'seed');
      await tester.pump();
      await tester.enterText(textField, 'meeting');
      await tester.pump();

      // Verify provider updated (observe latest value)
      expect(observed, 'meeting');

      // Cancel listener
      sub.close();
    });

    testWidgets('passes correct providers and flags to EventListWidget', (tester) async {
      await pumpScreen(tester, events: testEvents);

      final eventList = tester.widget<EventListWidget>(find.byType(EventListWidget));
      // Verify props we can check directly
      expect(eventList.isEditing, isFalse);
      expect(eventList.shrinkWrap, isFalse);
      expect(eventList.emptyState, isA<EmptyStateListWidget>());
    });
  });
}


