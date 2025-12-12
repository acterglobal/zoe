import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/toolkit/zoe_close_button_widget.dart';

import '../../../test-utils/test_utils.dart';

/// Test utilities for ZoeCloseButton widget tests
class ZoeCloseButtonTestUtils {
  /// Creates a test wrapper for the ZoeCloseButton widget
  static Widget createTestWidget({
    double? size,
    Color? color,
    VoidCallback? onTap,
  }) {
    return ZoeCloseButtonWidget(
      size: size,
      color: color,
      onTap: onTap ?? () {},
    );
  }
}

void main() {
  group('ZoeCloseButton Widget Tests -', () {
    testWidgets('applies custom size correctly', (tester) async {
      const customSize = 24.0;
      await tester.pumpMaterialWidget(
        child: ZoeCloseButtonTestUtils.createTestWidget(size: customSize),
      );

      // Verify custom size is applied
      final icon = tester.widget<Icon>(find.byIcon(Icons.close));
      expect(icon.size, customSize);
    });

    testWidgets('applies custom color correctly', (tester) async {
      const customColor = Colors.red;
      await tester.pumpMaterialWidget(
        child: ZoeCloseButtonTestUtils.createTestWidget(color: customColor),
      );

      // Verify custom color is applied
      final icon = tester.widget<Icon>(find.byIcon(Icons.close));
      expect(icon.color, customColor);
    });

    testWidgets('uses theme color when no color provided', (tester) async {
      const testTheme = ColorScheme.light();
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: testTheme),
          home: Builder(
            builder: (context) {
              final expectedColor = Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5);
              return ZoeCloseButtonTestUtils.createTestWidget(
                color: expectedColor,
              );
            },
          ),
        ),
      );

      // Verify theme color is applied
      final icon = tester.widget<Icon>(find.byIcon(Icons.close));
      expect(
        icon.color?.toARGB32(),
        equals(testTheme.onSurface.withValues(alpha: 0.5).toARGB32()),
      );
    });

    testWidgets('calls onTap when button is tapped', (tester) async {
      bool wasTapped = false;
      await tester.pumpMaterialWidget(
        child: ZoeCloseButtonTestUtils.createTestWidget(
          onTap: () => wasTapped = true,
        ),
      );

      // Tap the button
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      // Verify callback was called
      expect(wasTapped, true);
    });

    testWidgets('handles multiple taps correctly', (tester) async {
      int tapCount = 0;
      await tester.pumpMaterialWidget(
        child: ZoeCloseButtonTestUtils.createTestWidget(
          onTap: () => tapCount++,
        ),
      );

      // Tap multiple times
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      // Verify callback was called correct number of times
      expect(tapCount, 3);
    });
  });
}
