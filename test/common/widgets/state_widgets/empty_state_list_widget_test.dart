import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_custom_bg_widget.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_list_widget.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_magnifier_widget.dart';
import 'package:zoe/features/content/models/content_model.dart';

import '../../../test-utils/test_utils.dart';

void main() {
  Future<void> pumpEmptyStateListWidget(
    WidgetTester tester, {
    String? message,
    ThemeData? theme,
    Color? color,
    ContentType? contentType,
  }) async {
    await tester.pumpMaterialWidget(
      theme: theme,
      child: EmptyStateListWidget(
        message: message ?? 'Test message',
        color: color ?? Colors.blue,
        contentType: contentType,
      ),
    );
  }

  group('EmptyStateListWidget', () {
    testWidgets('renders empty state list widget correctly', (tester) async {
      await pumpEmptyStateListWidget(tester);

      expect(find.byType(EmptyStateListWidget), findsOneWidget);
    });

    testWidgets('displays message text', (tester) async {
      const message = 'No items available';
      await pumpEmptyStateListWidget(tester, message: message);

      expect(find.text(message), findsOneWidget);
    });

    testWidgets('renders Center widget', (tester) async {
      await pumpEmptyStateListWidget(tester);

      expect(find.byType(Center), findsAtLeastNWidgets(1));
    });

    testWidgets('renders Column layout', (tester) async {
      await pumpEmptyStateListWidget(tester);

      expect(find.byType(Column), findsAtLeastNWidgets(1));
    });

    testWidgets('renders EmptyStateCustomBgWidget', (tester) async {
      await pumpEmptyStateListWidget(tester, contentType: ContentType.task);

      expect(find.byType(EmptyStateCustomBgWidget), findsOneWidget);
    });

    testWidgets('renders EmptyStateMagnifierWidget', (tester) async {
      await pumpEmptyStateListWidget(tester);

      expect(find.byType(EmptyStateMagnifierWidget), findsOneWidget);
    });

    testWidgets('renders Stack layout for animated area', (tester) async {
      await pumpEmptyStateListWidget(tester);

      expect(find.byType(Stack), findsAtLeastNWidgets(1));
    });

    testWidgets('renders AnimatedBuilder', (tester) async {
      await pumpEmptyStateListWidget(tester);

      expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));
    });

    testWidgets('renders SizedBox for spacing between animation and message', (
      tester,
    ) async {
      await pumpEmptyStateListWidget(tester);

      // Verify SizedBox with height 24 exists
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      final hasMessageSpacing = sizedBoxes.any((box) => box.height == 24.0);
      expect(hasMessageSpacing, isTrue);
    });

    testWidgets('applies correct color to EmptyStateCustomBgWidget', (
      tester,
    ) async {
      const testColor = Colors.purple;

      await pumpEmptyStateListWidget(tester, color: testColor);

      final customBgWidget = tester.widget<EmptyStateCustomBgWidget>(
        find.byType(EmptyStateCustomBgWidget),
      );

      expect(customBgWidget.color, equals(testColor));
    });

    testWidgets('passes contentType to EmptyStateCustomBgWidget', (
      tester,
    ) async {
      await pumpEmptyStateListWidget(tester, contentType: ContentType.link);

      final customBgWidget = tester.widget<EmptyStateCustomBgWidget>(
        find.byType(EmptyStateCustomBgWidget),
      );

      expect(customBgWidget.contentType, equals(ContentType.link));
    });

    testWidgets('applies correct color to EmptyStateMagnifierWidget', (
      tester,
    ) async {
      const testColor = Colors.red;

      await pumpEmptyStateListWidget(tester, color: testColor);

      final magnifierWidget = tester.widget<EmptyStateMagnifierWidget>(
        find.byType(EmptyStateMagnifierWidget),
      );

      expect(magnifierWidget.color, equals(testColor));
    });

    testWidgets('message has correct text alignment', (tester) async {
      await pumpEmptyStateListWidget(tester);

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.textAlign, equals(TextAlign.center));
    });

    testWidgets('message has correct font weight', (tester) async {
      await pumpEmptyStateListWidget(tester);

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontWeight, equals(FontWeight.w600));
    });

    testWidgets('animated area has correct dimensions', (tester) async {
      await pumpEmptyStateListWidget(tester);

      // Find the SizedBox for the animated area
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      final animatedAreaBox = sizedBoxes.firstWhere(
        (box) => box.width == 260.0 && box.height == 220.0,
        orElse: () => throw StateError('Animated area box not found'),
      );

      expect(animatedAreaBox.width, equals(260.0));
      expect(animatedAreaBox.height, equals(220.0));
    });

    testWidgets('renders correctly with different content types', (
      tester,
    ) async {
      final contentTypes = [
        ContentType.task,
        ContentType.event,
        ContentType.document,
        ContentType.link,
        ContentType.poll,
      ];

      for (final contentType in contentTypes) {
        await pumpEmptyStateListWidget(tester, contentType: contentType);

        expect(find.byType(EmptyStateListWidget), findsOneWidget);
        expect(find.byType(EmptyStateCustomBgWidget), findsOneWidget);
      }
    });

    testWidgets('renders correctly in light theme', (tester) async {
      await pumpEmptyStateListWidget(tester, theme: ThemeData.light());

      expect(find.byType(EmptyStateListWidget), findsOneWidget);
    });

    testWidgets('renders correctly in dark theme', (tester) async {
      await pumpEmptyStateListWidget(tester, theme: ThemeData.dark());

      expect(find.byType(EmptyStateListWidget), findsOneWidget);
    });

    testWidgets('renders with different messages', (tester) async {
      final messages = [
        'No tasks found',
        'No events found',
        'No documents found',
      ];

      for (final message in messages) {
        await pumpEmptyStateListWidget(tester, message: message);

        expect(find.text(message), findsOneWidget);
      }
    });

    testWidgets('renders with different colors', (tester) async {
      final colors = [Colors.red, Colors.green, Colors.orange, Colors.purple];

      for (final color in colors) {
        await pumpEmptyStateListWidget(tester, color: color);

        expect(find.byType(EmptyStateListWidget), findsOneWidget);

        final customBgWidget = tester.widget<EmptyStateCustomBgWidget>(
          find.byType(EmptyStateCustomBgWidget),
        );

        expect(customBgWidget.color, equals(color));
      }
    });
  });
}
