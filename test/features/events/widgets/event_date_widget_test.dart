import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/widgets/event_date_widget.dart';
import 'package:zoe/features/events/data/event_list.dart';
import 'package:zoe/common/utils/date_time_utils.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('EventDateWidget', () {
    late EventModel testEvent;

    setUp(() {
      testEvent = eventList.first;
    });

    group('Widget Rendering', () {
      testWidgets('should render with default properties', (WidgetTester tester) async {
        await tester.pumpMaterialWidget(
          child: EventDateWidget(event: testEvent),
        );

        expect(find.byType(EventDateWidget), findsOneWidget);
        expect(find.byType(Container), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Text), findsNWidgets(2)); // Month and day text
      });

      testWidgets('should render with custom properties', (WidgetTester tester) async {
        await tester.pumpMaterialWidget(
          child: EventDateWidget(
            event: testEvent,
            width: 60,
            height: 60,
            borderRadius: 12,
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        
        // Check constraints instead of direct width/height
        expect(container.constraints?.minWidth, equals(60));
        expect(container.constraints?.minHeight, equals(60));
        expect(decoration.borderRadius, equals(BorderRadius.circular(12)));
      });

      testWidgets('should display correct month and day text', (WidgetTester tester) async {
        await tester.pumpMaterialWidget(
          child: EventDateWidget(event: testEvent),
        );

        // Get the expected month and day from the test event
        final expectedMonth = DateTimeUtils.getMonthText(testEvent.startDate);
        final expectedDay = DateTimeUtils.getDayText(testEvent.startDate);
        
        // Check for month text
        expect(find.text(expectedMonth), findsOneWidget);
        
        // Check for day text
        expect(find.text(expectedDay), findsOneWidget);
      });

      testWidgets('should display correct text for different dates', (WidgetTester tester) async {
        final differentEvent = testEvent.copyWith(
          startDate: DateTime(2024, 12, 25), // December 25, 2024
        );

        await tester.pumpMaterialWidget(
          child: EventDateWidget(event: differentEvent),
        );

        // Check for December month text
        expect(find.text('DEC'), findsOneWidget);
        
        // Check for day 25
        expect(find.text('25'), findsOneWidget);
      });
    });

    group('Styling and Theme', () {
      testWidgets('should apply correct text styles', (WidgetTester tester) async {
        await tester.pumpMaterialWidget(
          child: EventDateWidget(event: testEvent),
        );

        final expectedMonth = DateTimeUtils.getMonthText(testEvent.startDate);
        final expectedDay = DateTimeUtils.getDayText(testEvent.startDate);
        
        final monthText = tester.widget<Text>(find.text(expectedMonth));
        final dayText = tester.widget<Text>(find.text(expectedDay));

        // Check month text style
        expect(monthText.style?.fontSize, equals(8));
        expect(monthText.style?.fontWeight, equals(FontWeight.w600));
        expect(monthText.style?.height, equals(1.0));

        // Check day text style
        expect(dayText.style?.fontSize, equals(16));
        expect(dayText.style?.fontWeight, equals(FontWeight.bold));
        expect(dayText.style?.height, equals(1.0));
      });

      testWidgets('should apply theme colors', (WidgetTester tester) async {
        await tester.pumpMaterialWidget(
          child: EventDateWidget(event: testEvent),
        );

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        
        // Check that surface color is applied
        expect(decoration.color, isNotNull);
        
        // Check that border is applied
        expect(decoration.border, isNotNull);
      });

      testWidgets('should respect theme in dark mode', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body: EventDateWidget(event: testEvent),
            ),
          ),
        );

        final expectedMonth = DateTimeUtils.getMonthText(testEvent.startDate);
        final expectedDay = DateTimeUtils.getDayText(testEvent.startDate);

        expect(find.byType(EventDateWidget), findsOneWidget);
        expect(find.text(expectedMonth), findsOneWidget);
        expect(find.text(expectedDay), findsOneWidget);
      });
    });
    group('Edge Cases', () {
      testWidgets('should handle single digit day', (WidgetTester tester) async {
        final singleDigitEvent = testEvent.copyWith(
          startDate: DateTime(2024, 3, 5), // March 5, 2024
        );

        await tester.pumpMaterialWidget(
          child: EventDateWidget(event: singleDigitEvent),
        );

        expect(find.text('5'), findsOneWidget);
      });

      testWidgets('should handle double digit day', (WidgetTester tester) async {
        final doubleDigitEvent = testEvent.copyWith(
          startDate: DateTime(2024, 3, 25), // March 25, 2024
        );

        await tester.pumpMaterialWidget(
          child: EventDateWidget(event: doubleDigitEvent),
        );

        expect(find.text('25'), findsOneWidget);
      });

      testWidgets('should handle different months', (WidgetTester tester) async {
        final months = [
          (DateTime(2024, 1, 15), 'JAN'),
          (DateTime(2024, 6, 15), 'JUN'),
          (DateTime(2024, 9, 15), 'SEP'),
          (DateTime(2024, 11, 15), 'NOV'),
        ];

        for (final (date, expectedMonth) in months) {
          final event = testEvent.copyWith(startDate: date);
          
          await tester.pumpMaterialWidget(
            child: EventDateWidget(event: event),
          );

          expect(find.text(expectedMonth), findsOneWidget);
          
          // Clear the widget tree for next iteration
          await tester.pumpWidget(Container());
        }
      });
    });

    group('Property Validation', () {
      testWidgets('should use default values when not specified', (WidgetTester tester) async {
        await tester.pumpMaterialWidget(
          child: EventDateWidget(event: testEvent),
        );

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        
        expect(container.constraints?.minWidth, equals(40));
        expect(container.constraints?.minHeight, equals(40));
        expect(decoration.borderRadius, equals(BorderRadius.circular(6)));
      });

      testWidgets('should accept custom values', (WidgetTester tester) async {
        const customWidth = 80.0;
        const customHeight = 80.0;
        const customBorderRadius = 16.0;

        await tester.pumpMaterialWidget(
          child: EventDateWidget(
            event: testEvent,
            width: customWidth,
            height: customHeight,
            borderRadius: customBorderRadius,
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        
        expect(container.constraints?.minWidth, equals(customWidth));
        expect(container.constraints?.minHeight, equals(customHeight));
        expect(decoration.borderRadius, equals(BorderRadius.circular(customBorderRadius)));
      });
    });

    group('Integration with DateTimeUtils', () {
      testWidgets('should use DateTimeUtils for month formatting', (WidgetTester tester) async {
        await tester.pumpMaterialWidget(
          child: EventDateWidget(event: testEvent),
        );

        // The widget should display the month in uppercase format as per DateTimeUtils.getMonthText
        final expectedMonth = DateTimeUtils.getMonthText(testEvent.startDate);
        expect(find.text(expectedMonth), findsOneWidget);
      });

      testWidgets('should use DateTimeUtils for day formatting', (WidgetTester tester) async {
        await tester.pumpMaterialWidget(
          child: EventDateWidget(event: testEvent),
        );

        // The widget should display the day as a single number as per DateTimeUtils.getDayText
        final expectedDay = DateTimeUtils.getDayText(testEvent.startDate);
        expect(find.text(expectedDay), findsOneWidget);
      });
    });
  });
}