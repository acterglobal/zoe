import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/toolkit/zoe_icon_button_widget.dart';

import '../../../test-utils/test_utils.dart';

/// Test utilities for ZoeIconButton widget tests
class ZoeIconButtonTestUtils {
  /// Creates a test wrapper for the ZoeIconButton widget
  static ZoeIconButtonWidget createTestWidget({
    IconData icon = Icons.close,
    VoidCallback? onTap,
    double size = 24,
    double padding = 10,
  }) {
    return ZoeIconButtonWidget(
      icon: icon,
      onTap: onTap,
      size: size,
      padding: padding,
    );
  }
}

void main() {
  group('ZoeIconButton Widget Tests -', () {
    testWidgets('renders with default properties correctly', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeIconButtonTestUtils.createTestWidget(),
      );

      // Verify IconButton is rendered
      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(iconButton, isNotNull);

      // Verify Icon is rendered with default properties
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.close);
      expect(icon.size, 24);
    });

    testWidgets('applies custom icon correctly', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeIconButtonTestUtils.createTestWidget(
          icon: Icons.add,
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.add);
    });

    testWidgets('applies custom size correctly', (tester) async {
      const customSize = 32.0;
      await tester.pumpMaterialWidget(
        child: ZoeIconButtonTestUtils.createTestWidget(
          size: customSize,
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, customSize);
    });

    testWidgets('applies custom padding correctly', (tester) async {
      const customPadding = 16.0;
      await tester.pumpMaterialWidget(
        child: ZoeIconButtonTestUtils.createTestWidget(
          padding: customPadding,
        ),
      );

      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      final style = iconButton.style;
      expect(style?.padding?.resolve({}), const EdgeInsets.all(customPadding));
    });

    testWidgets('handles tap correctly', (tester) async {
      bool wasTapped = false;
      await tester.pumpMaterialWidget(
        child: ZoeIconButtonTestUtils.createTestWidget(
          onTap: () => wasTapped = true,
        ),
      );

      await tester.tap(find.byType(IconButton));
      expect(wasTapped, true);
    });

    testWidgets('applies correct colors in light theme', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeIconButtonTestUtils.createTestWidget(),
        theme: ThemeData.light(),
      );

      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      final style = iconButton.style;

      // Verify background color
      final backgroundColor = style?.backgroundColor?.resolve({});
      expect(backgroundColor, equals(Colors.black.withValues(alpha: 0.05)));

      // Verify border color
      final side = style?.side?.resolve({});
      expect(side?.color, equals(Colors.black.withValues(alpha: 0.1)));
    });

    testWidgets('applies correct colors in dark theme', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeIconButtonTestUtils.createTestWidget(),
        theme: ThemeData.dark(),
      );

      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      final style = iconButton.style;

      // Verify background color
      final backgroundColor = style?.backgroundColor?.resolve({});
      expect(backgroundColor, equals(Colors.white.withValues(alpha: 0.08)));

      // Verify border color
      final side = style?.side?.resolve({});
      expect(side?.color, equals(Colors.white.withValues(alpha: 0.15)));
    });
  });
}