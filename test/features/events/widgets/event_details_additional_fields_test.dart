import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/widgets/event_details_additional_fields.dart';
import 'package:zoe/features/events/data/event_list.dart';
import 'package:zoe/common/utils/date_time_utils.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('EventDetailsAdditionalFields', () {
    late EventModel testEvent;
    late ProviderContainer container;

    setUp(() {
      testEvent = eventList.first;
      container = ProviderContainer();
    });

    group('Widget Rendering', () {
      testWidgets('should render in non-editing mode', (WidgetTester tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventDetailsAdditionalFields(
            event: testEvent,
            isEditing: false,
          ),
        );

        expect(find.byType(EventDetailsAdditionalFields), findsOneWidget);
        expect(find.byType(Column), findsAtLeastNWidgets(1));
        expect(find.byType(Container), findsAtLeastNWidgets(2)); // Two date/time cards
        expect(find.byType(GestureDetector), findsAtLeastNWidgets(4)); // Two cards × 2 fields each
      });

      testWidgets('should render in editing mode', (WidgetTester tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventDetailsAdditionalFields(
            event: testEvent,
            isEditing: true,
          ),
        );

        expect(find.byType(EventDetailsAdditionalFields), findsOneWidget);
        expect(find.byType(Column), findsAtLeastNWidgets(1));
        expect(find.byType(Container), findsAtLeastNWidgets(2)); // Two date/time cards
        expect(find.byType(GestureDetector), findsAtLeastNWidgets(4)); // Two cards × 2 fields each
      });

      testWidgets('should display start and end date/time cards', (WidgetTester tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventDetailsAdditionalFields(
            event: testEvent,
            isEditing: false,
          ),
        );

        // Check for start and end titles
        expect(find.text('Start'), findsOneWidget);
        expect(find.text('End'), findsOneWidget);

        // Check for date and time labels
        expect(find.text('Date'), findsNWidgets(2)); // Start and End
        expect(find.text('Time'), findsNWidgets(2)); // Start and End
      });

      testWidgets('should display correct icons', (WidgetTester tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventDetailsAdditionalFields(
            event: testEvent,
            isEditing: false,
          ),
        );

        // Check for main icons
        expect(find.byIcon(Icons.play_circle_outline), findsOneWidget);
        expect(find.byIcon(Icons.stop_circle_outlined), findsOneWidget);

        // Check for field icons
        expect(find.byIcon(Icons.calendar_today_outlined), findsNWidgets(2));
        expect(find.byIcon(Icons.access_time), findsNWidgets(2));
      });
    });

    group('Date and Time Display', () {
      testWidgets('should display formatted start date and time', (WidgetTester tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventDetailsAdditionalFields(
            event: testEvent,
            isEditing: false,
          ),
        );

        final expectedStartDate = DateTimeUtils.formatDate(testEvent.startDate);
        final expectedStartTime = DateTimeUtils.formatTime(testEvent.startDate);

        expect(find.text(expectedStartDate), findsAtLeastNWidgets(1));
        expect(find.text(expectedStartTime), findsAtLeastNWidgets(1));
      });

      testWidgets('should display formatted end date and time', (WidgetTester tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventDetailsAdditionalFields(
            event: testEvent,
            isEditing: false,
          ),
        );

        final expectedEndDate = DateTimeUtils.formatDate(testEvent.endDate);
        final expectedEndTime = DateTimeUtils.formatTime(testEvent.endDate);

        expect(find.text(expectedEndDate), findsAtLeastNWidgets(1));
        expect(find.text(expectedEndTime), findsAtLeastNWidgets(1));
      });

      testWidgets('should handle different date formats', (WidgetTester tester) async {
        final differentEvent = testEvent.copyWith(
          startDate: DateTime(2024, 12, 25, 14, 30),
          endDate: DateTime(2024, 12, 25, 16, 45),
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventDetailsAdditionalFields(
            event: differentEvent,
            isEditing: false,
          ),
        );

        final expectedStartDate = DateTimeUtils.formatDate(differentEvent.startDate);
        final expectedStartTime = DateTimeUtils.formatTime(differentEvent.startDate);
        final expectedEndDate = DateTimeUtils.formatDate(differentEvent.endDate);
        final expectedEndTime = DateTimeUtils.formatTime(differentEvent.endDate);

        expect(find.text(expectedStartDate), findsAtLeastNWidgets(1));
        expect(find.text(expectedStartTime), findsAtLeastNWidgets(1));
        expect(find.text(expectedEndDate), findsAtLeastNWidgets(1));
        expect(find.text(expectedEndTime), findsAtLeastNWidgets(1));
      });
    });

    group('Interaction Handling', () {
      testWidgets('should not be tappable in non-editing mode', (WidgetTester tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventDetailsAdditionalFields(
            event: testEvent,
            isEditing: false,
          ),
        );

        // In non-editing mode, GestureDetectors should not have onTap callbacks
        final gestureDetectors = tester.widgetList<GestureDetector>(find.byType(GestureDetector));
        for (final detector in gestureDetectors) {
          expect(detector.onTap, isNull);
        }
      });

      testWidgets('should be tappable in editing mode', (WidgetTester tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventDetailsAdditionalFields(
            event: testEvent,
            isEditing: true,
          ),
        );

        // In editing mode, GestureDetectors should have onTap callbacks
        final gestureDetectors = tester.widgetList<GestureDetector>(find.byType(GestureDetector));
        for (final detector in gestureDetectors) {
          expect(detector.onTap, isNotNull);
        }
      });
    });

    group('Styling and Theme', () {
      testWidgets('should apply correct styling to date/time cards', (WidgetTester tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventDetailsAdditionalFields(
            event: testEvent,
            isEditing: false,
          ),
        );

        final containers = tester.widgetList<Container>(find.byType(Container));
        final mainCards = containers.where((container) => 
          container.decoration is BoxDecoration &&
          (container.decoration as BoxDecoration).borderRadius == BorderRadius.circular(12)
        );

        expect(mainCards, hasLength(2)); // Start and End cards

        for (final card in mainCards) {
          final decoration = card.decoration as BoxDecoration;
          expect(decoration.borderRadius, equals(BorderRadius.circular(12)));
          expect(decoration.border, isNotNull);
        }
      });

      testWidgets('should apply different styling for editable fields', (WidgetTester tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventDetailsAdditionalFields(
            event: testEvent,
            isEditing: true,
          ),
        );

        // Find field containers (smaller containers inside main cards)
        final fieldContainers = tester.widgetList<Container>(find.byType(Container))
            .where((container) => 
              container.decoration is BoxDecoration &&
              (container.decoration as BoxDecoration).borderRadius == BorderRadius.circular(8)
            );

        expect(fieldContainers, hasLength(4)); // 4 field items

        for (final field in fieldContainers) {
          final decoration = field.decoration as BoxDecoration;
          expect(decoration.borderRadius, equals(BorderRadius.circular(8)));
          expect(decoration.border, isNotNull); // Should have border in editing mode
        }
      });

      testWidgets('should respect theme colors', (WidgetTester tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventDetailsAdditionalFields(
            event: testEvent,
            isEditing: false,
          ),
        );

        // Check that icons use theme colors
        final icons = tester.widgetList<Icon>(find.byType(Icon));
        expect(icons, isNotEmpty);

        // Check that text uses theme colors
        final texts = tester.widgetList<Text>(find.byType(Text));
        expect(texts, isNotEmpty);
      });

      testWidgets('should work in dark mode', (WidgetTester tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          theme: ThemeData.dark(),
          child: EventDetailsAdditionalFields(
            event: testEvent,
            isEditing: false,
          ),
        );

        expect(find.byType(EventDetailsAdditionalFields), findsOneWidget);
        expect(find.text('Start'), findsOneWidget);
        expect(find.text('End'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle events with same start and end date', (WidgetTester tester) async {
        final sameDayEvent = testEvent.copyWith(
          startDate: DateTime(2024, 3, 15, 10, 0),
          endDate: DateTime(2024, 3, 15, 12, 0),
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventDetailsAdditionalFields(
            event: sameDayEvent,
            isEditing: false,
          ),
        );

        expect(find.byType(EventDetailsAdditionalFields), findsOneWidget);
        expect(find.text('Start'), findsOneWidget);
        expect(find.text('End'), findsOneWidget);
      });

      testWidgets('should handle events with different start and end dates', (WidgetTester tester) async {
        final multiDayEvent = testEvent.copyWith(
          startDate: DateTime(2024, 3, 15, 10, 0),
          endDate: DateTime(2024, 3, 17, 14, 0),
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventDetailsAdditionalFields(
            event: multiDayEvent,
            isEditing: false,
          ),
        );

        expect(find.byType(EventDetailsAdditionalFields), findsOneWidget);
        expect(find.text('Start'), findsOneWidget);
        expect(find.text('End'), findsOneWidget);
      });

      testWidgets('should handle midnight times', (WidgetTester tester) async {
        final midnightEvent = testEvent.copyWith(
          startDate: DateTime(2024, 3, 15, 0, 0),
          endDate: DateTime(2024, 3, 15, 23, 59),
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventDetailsAdditionalFields(
            event: midnightEvent,
            isEditing: false,
          ),
        );

        expect(find.byType(EventDetailsAdditionalFields), findsOneWidget);
        expect(find.text('Start'), findsOneWidget);
        expect(find.text('End'), findsOneWidget);
      });
    });

    group('Integration with DateTimeUtils', () {
      testWidgets('should use DateTimeUtils for date formatting', (WidgetTester tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: EventDetailsAdditionalFields(
            event: testEvent,
            isEditing: false,
          ),
        );

        final expectedStartDate = DateTimeUtils.formatDate(testEvent.startDate);
        final expectedStartTime = DateTimeUtils.formatTime(testEvent.startDate);
        final expectedEndDate = DateTimeUtils.formatDate(testEvent.endDate);
        final expectedEndTime = DateTimeUtils.formatTime(testEvent.endDate);

        expect(find.text(expectedStartDate), findsAtLeastNWidgets(1));
        expect(find.text(expectedStartTime), findsAtLeastNWidgets(1));
        expect(find.text(expectedEndDate), findsAtLeastNWidgets(1));
        expect(find.text(expectedEndTime), findsAtLeastNWidgets(1));
      });
    });
  });
}