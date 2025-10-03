import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/zoe_circle_widget.dart';
import '../../test-utils/test_utils.dart';

/// Test utilities for ZoeCircleWidget tests
class ZoeCircleWidgetTestUtils {
  /// Creates a test widget for the ZoeCircleWidget
  static Widget createTestWidget({double? size, Color? color}) {
    return ZoeCircleWidget(size: size ?? 50.0, color: color ?? Colors.blue);
  }
}

void main() {
  group('ZoeCircleWidget Tests -', () {
    testWidgets('renders with required properties', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeCircleWidgetTestUtils.createTestWidget(),
      );

      // Verify widget is rendered
      expect(find.byType(ZoeCircleWidget), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('applies correct size dimensions', (tester) async {
      const testSize = 100.0;
      await tester.pumpMaterialWidget(
        child: ZoeCircleWidgetTestUtils.createTestWidget(size: testSize),
      );

      // Verify constraints are applied
      final renderBox = tester.renderObject<RenderBox>(
        find.byType(ZoeCircleWidget),
      );
      expect(renderBox.size.width, equals(testSize));
      expect(renderBox.size.height, equals(testSize));
    });

    testWidgets('applies correct color', (tester) async {
      const customColor = Colors.red;
      await tester.pumpMaterialWidget(
        child: ZoeCircleWidgetTestUtils.createTestWidget(color: customColor),
      );

      // Verify Container decoration uses custom color
      final container = tester.widget<Container>(find.byType(Container));
      final boxDecoration = container.decoration as BoxDecoration;
      expect(boxDecoration.color, equals(customColor));
    });

    testWidgets('handles various color values', (tester) async {
      final testColors = [
        Colors.red,
        Colors.green,
        Colors.blue,
        Colors.yellow,
        Colors.purple,
        Colors.orange,
        Colors.pink,
        Colors.teal,
        Colors.transparent,
        const Color(0xFF123456), // Custom hex color
        const Color.fromARGB(255, 128, 64, 32), // ARGB color
        Colors.white,
        Colors.black,
        Colors.grey,
      ];

      for (final color in testColors) {
        await tester.pumpMaterialWidget(
          child: ZoeCircleWidgetTestUtils.createTestWidget(color: color),
        );

        // Verify Container decoration uses correct color
        final container = tester.widget<Container>(find.byType(Container));
        final boxDecoration = container.decoration as BoxDecoration;
        expect(boxDecoration.color, equals(color));
      }
    });

    testWidgets('handles different decimal sizes', (tester) async {
      final decimalSizes = [12.5, 33.33, 66.666, 99.9999];

      for (final size in decimalSizes) {
        await tester.pumpMaterialWidget(
          child: ZoeCircleWidgetTestUtils.createTestWidget(size: size),
        );

        // Verify widget renders with decimal size
        final renderBox = tester.renderObject<RenderBox>(
          find.byType(ZoeCircleWidget),
        );
        expect(renderBox.size.width, equals(size));
        expect(renderBox.size.height, equals(size));
      }
    });

    testWidgets('has no child widgets', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeCircleWidgetTestUtils.createTestWidget(),
      );

      // Verify the Container has no child widgets (the circle is purely decorative)
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.child, isNull);
    });
  });
}
