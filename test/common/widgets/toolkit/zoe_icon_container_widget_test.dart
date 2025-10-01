import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/toolkit/zoe_icon_container_widget.dart';

import '../../../helpers/test_utils.dart';

/// Test utilities for ZoeIconContainer widget tests
class ZoeIconContainerTestUtils {
  /// Creates a test wrapper for the ZoeIconContainer widget
  static ZoeIconContainer createTestWidget({
    IconData? icon = Icons.close,
    double? size = 72,
    Color? backgroundColor,
    Color? iconColor,
    Color? borderColor,
    double? borderWidth = 1.0,
    double? borderRadius = 36,
    VoidCallback? onTap,
  }) {
    return ZoeIconContainer(
      icon: icon ?? Icons.close,
      size: size ?? 72,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      borderColor: borderColor,
      borderWidth: borderWidth ?? 1.0,
      borderRadius: borderRadius ?? 36,
      onTap: onTap,
    );
  }
}

void main() {
  group('ZoeIconContainer Widget Tests -', () {
    testWidgets('renders with default properties correctly', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeIconContainerTestUtils.createTestWidget(),
      );

      // Verify Container is rendered
      final container = tester.widget<Container>(find.byType(Container));
      expect(container, isNotNull);

      // Verify default size
      expect(container.constraints?.maxWidth, 72);
      expect(container.constraints?.maxHeight, 72);

      // Verify Icon is rendered with default properties
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.close);
      expect(icon.size, 36); // Half of container size
    });

    testWidgets('applies custom icon correctly', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeIconContainerTestUtils.createTestWidget(
          icon: Icons.add,
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.add);
    });

    testWidgets('applies custom size correctly', (tester) async {
      const customSize = 100.0;
      await tester.pumpMaterialWidget(
        child: ZoeIconContainerTestUtils.createTestWidget(
          size: customSize,
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints?.maxWidth, customSize);
      expect(container.constraints?.maxHeight, customSize);

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, customSize * 0.5); // Half of container size
    });

    testWidgets('applies custom colors correctly', (tester) async {
      final customBackgroundColor = Colors.blue;
      final customIconColor = Colors.red;
      final customBorderColor = Colors.green;

      await tester.pumpMaterialWidget(
        child: ZoeIconContainerTestUtils.createTestWidget(
          backgroundColor: customBackgroundColor,
          iconColor: customIconColor,
          borderColor: customBorderColor,
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      
      expect(decoration.color, equals(customBackgroundColor));
      
      final border = decoration.border as Border;
      expect(border.top.color, equals(customBorderColor));

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color, equals(customIconColor));
    });

    testWidgets('applies custom border properties correctly', (tester) async {
      const customBorderWidth = 2.0;
      const customBorderRadius = 20.0;

      await tester.pumpMaterialWidget(
        child: ZoeIconContainerTestUtils.createTestWidget(
          borderWidth: customBorderWidth,
          borderRadius: customBorderRadius,
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      
      expect(
        decoration.borderRadius, 
        equals(BorderRadius.circular(customBorderRadius)),
      );
      
      final border = decoration.border as Border;
      expect(border.top.width, equals(customBorderWidth));
    });

    testWidgets('applies default border properties correctly', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeIconContainerTestUtils.createTestWidget(),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      
      expect(
        decoration.borderRadius, 
        equals(BorderRadius.circular(36)),
      );
      
      final border = decoration.border as Border;
      expect(border.top.width, equals(1.0));
    });
  });
}
