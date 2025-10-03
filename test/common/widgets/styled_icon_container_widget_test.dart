import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import '../../test-utils/test_utils.dart';

/// Test utilities for StyledIconContainer tests
class StyledIconContainerTestUtils {
  /// Creates a test widget for the StyledIconContainer
  static Widget createTestWidget({
    IconData? icon,
    VoidCallback? onTap,
    Color? primaryColor,
    Color? secondaryColor,
    double? size,
    double? iconSize,
    BorderRadius? borderRadius,
    double? backgroundOpacity,
    double? borderOpacity,
    double? shadowOpacity,
  }) {
    return StyledIconContainer(
      icon: icon ?? Icons.star,
      onTap: onTap,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      size: size ?? 64,
      iconSize: iconSize ?? 32,
      borderRadius: borderRadius,
      backgroundOpacity: backgroundOpacity ?? 0.12,
      borderOpacity: borderOpacity ?? 0.2,
      shadowOpacity: shadowOpacity ?? 0.15,
    );
  }
}

void main() {
  group('StyledIconContainer Tests -', () {
    testWidgets('renders with required properties', (tester) async {
      await tester.pumpMaterialWidget(
        child: StyledIconContainerTestUtils.createTestWidget(),
      );

      // Verify widget is rendered
      expect(find.byType(StyledIconContainer), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('displays icon correctly', (tester) async {
      await tester.pumpMaterialWidget(
        child: StyledIconContainerTestUtils.createTestWidget(
          icon: Icons.favorite,
        ),
      );

      // Verify icon is displayed
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, equals(Icons.favorite));
    });

    testWidgets('applies correct size dimensions', (tester) async {
      const testSize = 100.0;
      await tester.pumpMaterialWidget(
        child: StyledIconContainerTestUtils.createTestWidget(size: testSize),
      );

      // Verify constraints are applied
      final renderBox = tester.renderObject<RenderBox>(
        find.byType(StyledIconContainer),
      );
      expect(renderBox.size.width, equals(testSize));
      expect(renderBox.size.height, equals(testSize));
    });

    testWidgets('applies custom icon size', (tester) async {
      const customIconSize = 48.0;
      await tester.pumpMaterialWidget(
        child: StyledIconContainerTestUtils.createTestWidget(
          iconSize: customIconSize,
        ),
      );

      // Verify icon size is applied
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, equals(customIconSize));
    });

    testWidgets('applies default icon size', (tester) async {
      await tester.pumpMaterialWidget(
        child: StyledIconContainerTestUtils.createTestWidget(),
      );

      // Verify default icon size is applied
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, equals(32));
    });

    testWidgets('applies custom primary color', (tester) async {
      const customPrimaryColor = Colors.red;
      await tester.pumpMaterialWidget(
        child: StyledIconContainerTestUtils.createTestWidget(
          primaryColor: customPrimaryColor,
        ),
      );

      // Verify Container decoration uses custom primary color
      final container = tester.widget<Container>(find.byType(Container));
      final boxDecoration = container.decoration as BoxDecoration;
      final linearGradient = boxDecoration.gradient as LinearGradient;

      // Check gradient colors contain custom primary color
      expect(
        linearGradient.colors.any(
          (color) =>
              color.r == customPrimaryColor.r &&
              color.g == customPrimaryColor.g &&
              color.b == customPrimaryColor.b,
        ),
        isTrue,
      );

      // Check border color
      final border = boxDecoration.border as Border;
      expect(border.top.color.r, equals(customPrimaryColor.r));
      expect(border.top.color.g, equals(customPrimaryColor.g));
      expect(border.top.color.b, equals(customPrimaryColor.b));

      // Check icon color
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color?.r, equals(customPrimaryColor.r));
      expect(icon.color?.g, equals(customPrimaryColor.g));
      expect(icon.color?.b, equals(customPrimaryColor.b));
    });

    testWidgets('applies custom secondary color', (tester) async {
      const customSecondaryColor = Colors.blue;
      const customPrimaryColor = Colors.red;

      await tester.pumpMaterialWidget(
        child: StyledIconContainerTestUtils.createTestWidget(
          primaryColor: customPrimaryColor,
          secondaryColor: customSecondaryColor,
        ),
      );

      // Verify Container decoration uses custom secondary color
      final container = tester.widget<Container>(find.byType(Container));
      final boxDecoration = container.decoration as BoxDecoration;
      final linearGradient = boxDecoration.gradient as LinearGradient;

      // Check gradient colors contain custom secondary color
      expect(
        linearGradient.colors.any(
          (color) =>
              color.r == customSecondaryColor.r &&
              color.g == customSecondaryColor.g &&
              color.b == customSecondaryColor.b,
        ),
        isTrue,
      );
    });

    testWidgets('uses theme primary color when primaryColor is null', (
      tester,
    ) async {
      const themePrimaryColor = Color(0xFF6200EE);
      final theme = ThemeData.light().copyWith(
        colorScheme: ColorScheme.light().copyWith(primary: themePrimaryColor),
      );

      await tester.pumpMaterialWidget(
        child: StyledIconContainerTestUtils.createTestWidget(),
        theme: theme,
      );

      // Verify Container decoration uses theme primary color
      final container = tester.widget<Container>(find.byType(Container));
      final boxDecoration = container.decoration as BoxDecoration;
      final linearGradient = boxDecoration.gradient as LinearGradient;

      // Check gradient colors contain theme primary color
      expect(
        linearGradient.colors.any(
          (color) =>
              color.r == themePrimaryColor.r &&
              color.g == themePrimaryColor.g &&
              color.b == themePrimaryColor.b,
        ),
        isTrue,
      );

      // Check icon uses theme primary color
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color?.r, equals(themePrimaryColor.r));
      expect(icon.color?.g, equals(themePrimaryColor.g));
      expect(icon.color?.b, equals(themePrimaryColor.b));
    });

    testWidgets('uses theme secondary color when secondaryColor is null', (
      tester,
    ) async {
      const themeSecondaryColor = Color(0xFF03DAC6);
      final theme = ThemeData.light().copyWith(
        colorScheme: ColorScheme.light().copyWith(
          secondary: themeSecondaryColor,
        ),
      );

      await tester.pumpMaterialWidget(
        child: StyledIconContainerTestUtils.createTestWidget(),
        theme: theme,
      );

      // Verify Container decoration uses theme secondary color
      final container = tester.widget<Container>(find.byType(Container));
      final boxDecoration = container.decoration as BoxDecoration;
      final linearGradient = boxDecoration.gradient as LinearGradient;

      // Check gradient colors contain theme secondary color
      expect(
        linearGradient.colors.any(
          (color) =>
              color.r == themeSecondaryColor.r &&
              color.g == themeSecondaryColor.g &&
              color.b == themeSecondaryColor.b,
        ),
        isTrue,
      );
    });

    testWidgets('applies custom border radius', (tester) async {
      const borderRadius = BorderRadius.all(Radius.circular(20));
      await tester.pumpMaterialWidget(
        child: StyledIconContainerTestUtils.createTestWidget(
          borderRadius: borderRadius,
        ),
      );

      // Verify Container decoration uses custom border radius
      final container = tester.widget<Container>(find.byType(Container));
      final boxDecoration = container.decoration as BoxDecoration;
      expect(boxDecoration.borderRadius, equals(borderRadius));
    });

    testWidgets('applies default border radius when null', (tester) async {
      const testSize = 64.0;
      await tester.pumpMaterialWidget(
        child: StyledIconContainerTestUtils.createTestWidget(size: testSize),
      );

      // Verify Container decoration uses default border radius calculation
      final container = tester.widget<Container>(find.byType(Container));
      final boxDecoration = container.decoration as BoxDecoration;
      final expectedBorderRadius = BorderRadius.circular(testSize * 0.28);
      expect(boxDecoration.borderRadius, equals(expectedBorderRadius));
    });

    testWidgets('applies border opacity correctly', (tester) async {
      const borderOpacity = 0.8;
      await tester.pumpMaterialWidget(
        child: StyledIconContainerTestUtils.createTestWidget(
          borderOpacity: borderOpacity,
        ),
      );

      // Verify Container decoration uses custom border opacity
      final container = tester.widget<Container>(find.byType(Container));
      final boxDecoration = container.decoration as BoxDecoration;
      final border = boxDecoration.border as Border;

      expect(border.top.color.a, closeTo(borderOpacity, 0.01));
    });

    testWidgets('handles tap callback correctly', (tester) async {
      bool callbackExecuted = false;
      void onTapCallback() {
        callbackExecuted = true;
      }

      await tester.pumpMaterialWidget(
        child: StyledIconContainerTestUtils.createTestWidget(
          onTap: onTapCallback,
        ),
      );

      // Verify GestureDetector is present
      expect(find.byType(GestureDetector), findsOneWidget);

      // Tap the widget
      await tester.tap(find.byType(StyledIconContainer));
      await tester.pump();

      // Verify callback was executed
      expect(callbackExecuted, isTrue);
    });

    testWidgets('handles null onTap callback', (tester) async {
      await tester.pumpMaterialWidget(
        child: StyledIconContainerTestUtils.createTestWidget(onTap: null),
      );

      // Verify GestureDetector is present but onTap should be null
      final gestureDetector = tester.widget<GestureDetector>(
        find.byType(GestureDetector),
      );
      expect(gestureDetector.onTap, isNull);

      // Tap should not cause any errors
      await tester.tap(find.byType(StyledIconContainer));
      await tester.pump();
    });

    testWidgets('handles edge case icons correctly', (tester) async {
      // Test with various icon types
      final testIcons = [
        Icons.star,
        Icons.favorite,
        Icons.home,
        Icons.settings,
      ];

      for (final icon in testIcons) {
        await tester.pumpMaterialWidget(
          child: StyledIconContainerTestUtils.createTestWidget(icon: icon),
        );

        // Verify icon is displayed correctly
        final iconWidget = tester.widget<Icon>(find.byType(Icon));
        expect(iconWidget.icon, equals(icon));
      }
    });
  });
}
