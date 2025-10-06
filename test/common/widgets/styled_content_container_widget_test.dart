import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/styled_content_container_widget.dart';
import '../../test-utils/test_utils.dart';

/// Test utilities for StyledContentContainer tests
class StyledContentContainerTestUtils {
  /// Creates a test widget for the StyledContentContainer
  static Widget createTestWidget({
    Widget? child,
    Color? primaryColor,
    Color? secondaryColor,
    double? size,
    BorderRadius? borderRadius,
    double? backgroundOpacity,
    double? borderOpacity,
    double? shadowOpacity,
  }) {
    return StyledContentContainer(
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      size: size ?? 64,
      borderRadius: borderRadius,
      backgroundOpacity: backgroundOpacity ?? 0.12,
      borderOpacity: borderOpacity ?? 0.2,
      shadowOpacity: shadowOpacity ?? 0.15,
      child: child ?? const Text('Test Content'),
    );
  }
}

void main() {
  group('StyledContentContainer Tests -', () {
    testWidgets('renders with required properties', (tester) async {
      await tester.pumpMaterialWidget(
        child: StyledContentContainerTestUtils.createTestWidget(),
      );

      // Verify widget is rendered
      expect(find.byType(StyledContentContainer), findsOneWidget);
      expect(find.byType(Container), findsAtLeastNWidgets(1));
    });

    testWidgets('displays child content', (tester) async {
      await tester.pumpMaterialWidget(
        child: StyledContentContainerTestUtils.createTestWidget(
          child: const Text('Test Child'),
        ),
      );

      // Verify child content is displayed
      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('applies correct size dimensions', (tester) async {
      const testSize = 100.0;
      await tester.pumpMaterialWidget(
        child: StyledContentContainerTestUtils.createTestWidget(size: testSize),
      );

      // Verify constraints are applied
      final renderBox = tester.renderObject<RenderBox>(
        find.byType(StyledContentContainer),
      );
      expect(renderBox.size.width, equals(testSize));
      expect(renderBox.size.height, equals(testSize));
    });

    testWidgets('applies correct size dimensions with default value', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(
        child: StyledContentContainerTestUtils.createTestWidget(),
      );

      // Verify default size is applied
      final renderBox = tester.renderObject<RenderBox>(
        find.byType(StyledContentContainer),
      );
      expect(renderBox.size.width, equals(64));
      expect(renderBox.size.height, equals(64));
    });

    testWidgets('applies custom primary color', (tester) async {
      const customPrimaryColor = Colors.red;
      await tester.pumpMaterialWidget(
        child: StyledContentContainerTestUtils.createTestWidget(
          primaryColor: customPrimaryColor,
        ),
      );

      // Verify Container decoration uses custom primary color
      final container = tester.widget<Container>(find.byType(Container).first);
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
    });

    testWidgets('applies custom secondary color', (tester) async {
      const customSecondaryColor = Colors.blue;
      const customPrimaryColor = Colors.red;

      await tester.pumpMaterialWidget(
        child: StyledContentContainerTestUtils.createTestWidget(
          primaryColor: customPrimaryColor,
          secondaryColor: customSecondaryColor,
        ),
      );

      // Verify Container decoration uses custom secondary color
      final container = tester.widget<Container>(find.byType(Container).first);
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
        child: StyledContentContainerTestUtils.createTestWidget(),
        theme: theme,
      );

      // Verify Container decoration uses theme primary color
      final container = tester.widget<Container>(find.byType(Container).first);
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
    });

    testWidgets('applies custom border radius', (tester) async {
      const borderRadius = BorderRadius.all(Radius.circular(20));
      await tester.pumpMaterialWidget(
        child: StyledContentContainerTestUtils.createTestWidget(
          borderRadius: borderRadius,
        ),
      );

      // Verify Container decoration uses custom border radius
      final container = tester.widget<Container>(find.byType(Container).first);
      final boxDecoration = container.decoration as BoxDecoration;
      expect(boxDecoration.borderRadius, equals(borderRadius));
    });

    testWidgets('applies default border radius when null', (tester) async {
      const testSize = 64.0;
      await tester.pumpMaterialWidget(
        child: StyledContentContainerTestUtils.createTestWidget(size: testSize),
      );

      // Verify Container decoration uses default border radius calculation
      final container = tester.widget<Container>(find.byType(Container).first);
      final boxDecoration = container.decoration as BoxDecoration;
      final expectedBorderRadius = BorderRadius.circular(testSize * 0.28);
      expect(boxDecoration.borderRadius, equals(expectedBorderRadius));
    });

    testWidgets('applies background opacity correctly', (tester) async {
      const backgroundOpacity = 0.5;
      await tester.pumpMaterialWidget(
        child: StyledContentContainerTestUtils.createTestWidget(
          backgroundOpacity: backgroundOpacity,
        ),
      );

      // Verify Container decoration uses custom background opacity
      final container = tester.widget<Container>(find.byType(Container).first);
      final boxDecoration = container.decoration as BoxDecoration;
      final linearGradient = boxDecoration.gradient as LinearGradient;

      // Check gradient colors have applied opacity with correct multipliers
      // Based on the implementation: base opacity, 0.67 * base opacity, 0.5 * base opacity
      expect(linearGradient.colors[0].a, closeTo(backgroundOpacity, 0.01));
      expect(
        linearGradient.colors[1].a,
        closeTo(backgroundOpacity * 0.67, 0.01),
      );
      expect(
        linearGradient.colors[2].a,
        closeTo(backgroundOpacity * 0.5, 0.01),
      );
    });

    testWidgets('applies border opacity correctly', (tester) async {
      const borderOpacity = 0.8;
      await tester.pumpMaterialWidget(
        child: StyledContentContainerTestUtils.createTestWidget(
          borderOpacity: borderOpacity,
        ),
      );

      // Verify Container decoration uses custom border opacity
      final container = tester.widget<Container>(find.byType(Container).first);
      final boxDecoration = container.decoration as BoxDecoration;
      final border = boxDecoration.border as Border;

      expect(border.top.color.a, closeTo(borderOpacity, 0.01));
    });

    testWidgets('applies shadow opacity correctly', (tester) async {
      const shadowOpacity = 0.3;
      await tester.pumpMaterialWidget(
        child: StyledContentContainerTestUtils.createTestWidget(
          shadowOpacity: shadowOpacity,
        ),
      );

      // Verify Container decoration uses custom shadow opacity
      final container = tester.widget<Container>(find.byType(Container).first);
      final boxDecoration = container.decoration as BoxDecoration;
      final boxShadows = boxDecoration.boxShadow;

      expect(boxShadows!.length, equals(2));

      // Check shadow colors have applied opacity
      // Based on implementation: first shadow uses base opacity, second shadow uses 0.53 * base opacity
      expect(boxShadows[0].color.a, closeTo(shadowOpacity, 0.01));
      expect(boxShadows[1].color.a, closeTo(shadowOpacity * 0.53, 0.01));
    });
  });
}
