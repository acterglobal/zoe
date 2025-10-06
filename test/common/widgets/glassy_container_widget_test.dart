import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import '../../test-utils/test_utils.dart';

/// Test utilities for GlassyContainer tests
class GlassyContainerTestUtils {
  /// Creates a test wrapper for the GlassyContainer
  static Widget createTestWidget({
    Widget? child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    Color? shadowColor,
    double? shadowOpacity,
    double? blurRadius,
    Offset? shadowOffset,
    double? borderOpacity,
    double? surfaceOpacity,
    List<Color>? customGradientColors,
    double? width,
    double? height,
    VoidCallback? onTap,
  }) {
    return GlassyContainer(
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      shadowColor: shadowColor,
      shadowOpacity: shadowOpacity ?? 0.05,
      blurRadius: blurRadius ?? 12,
      shadowOffset: shadowOffset ?? const Offset(0, 4),
      borderOpacity: borderOpacity ?? 0.15,
      surfaceOpacity: surfaceOpacity ?? 0.85,
      customGradientColors: customGradientColors,
      width: width,
      height: height,
      onTap: onTap,
      child: child ?? const Text('Test Content'),
    );
  }
}

void main() {
  group('GlassyContainer Tests -', () {

    testWidgets('renders with custom child', (tester) async {
      const customChild = Text('Custom Child');

      await tester.pumpMaterialWidget(
        child: GlassyContainerTestUtils.createTestWidget(child: customChild),
      );

      // Verify custom child is rendered
      expect(find.text('Custom Child'), findsOneWidget);
      expect(find.text('Test Content'), findsNothing);
    });

    testWidgets('applies custom padding', (tester) async {
      const customPadding = EdgeInsets.all(16);

      await tester.pumpMaterialWidget(
        child: GlassyContainerTestUtils.createTestWidget(
          padding: customPadding,
        ),
      );

      // Verify padding is applied
      final containers = tester.widgetList<Container>(find.byType(Container));
      final containerWithPadding = containers.firstWhere(
        (container) => container.padding == customPadding,
      );
      expect(containerWithPadding.padding, customPadding);
    });

    testWidgets('applies custom margin', (tester) async {
      const customMargin = EdgeInsets.all(8);

      await tester.pumpMaterialWidget(
        child: GlassyContainerTestUtils.createTestWidget(margin: customMargin),
      );

      // Verify margin is applied
      final containers = tester.widgetList<Container>(find.byType(Container));
      final containerWithMargin = containers.firstWhere(
        (container) => container.margin == customMargin,
      );
      expect(containerWithMargin.margin, customMargin);
    });

    testWidgets('applies custom border radius', (tester) async {
      const customBorderRadius = BorderRadius.all(Radius.circular(12));

      await tester.pumpMaterialWidget(
        child: GlassyContainerTestUtils.createTestWidget(
          borderRadius: customBorderRadius,
        ),
      );

      // Verify border radius is applied
      final containers = tester.widgetList<Container>(find.byType(Container));
      final containerWithDecoration = containers.firstWhere(
        (container) => container.decoration is BoxDecoration,
      );
      final decoration = containerWithDecoration.decoration as BoxDecoration;
      expect(decoration.borderRadius, customBorderRadius);
    });

    testWidgets('applies default border radius when not provided', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(
        child: GlassyContainerTestUtils.createTestWidget(),
      );

      // Verify default border radius is applied
      final containers = tester.widgetList<Container>(find.byType(Container));
      final containerWithDecoration = containers.firstWhere(
        (container) => container.decoration is BoxDecoration,
      );
      final decoration = containerWithDecoration.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(20));
    });

    testWidgets('applies custom width and height', (tester) async {
      const customWidth = 200.0;
      const customHeight = 150.0;

      await tester.pumpMaterialWidget(
        child: GlassyContainerTestUtils.createTestWidget(
          width: customWidth,
          height: customHeight,
        ),
      );

      // Verify width and height are applied
      final containers = tester.widgetList<Container>(find.byType(Container));
      final outerContainer = containers.firstWhere(
        (container) => container.constraints?.maxWidth == customWidth,
      );
      expect(outerContainer.constraints?.maxWidth, customWidth);
      expect(outerContainer.constraints?.maxHeight, customHeight);
    });

    testWidgets('applies gradient decoration', (tester) async {
      await tester.pumpMaterialWidget(
        child: GlassyContainerTestUtils.createTestWidget(),
      );

      // Verify gradient decoration is applied
      final containers = tester.widgetList<Container>(find.byType(Container));
      final containerWithDecoration = containers.firstWhere(
        (container) => container.decoration is BoxDecoration,
      );
      final decoration = containerWithDecoration.decoration as BoxDecoration;
      expect(decoration.gradient, isA<LinearGradient>());

      final gradient = decoration.gradient as LinearGradient;
      expect(gradient.begin, Alignment.topLeft);
      expect(gradient.end, Alignment.bottomRight);
      expect(gradient.stops, const [0.0, 0.5, 1.0]);
    });

    testWidgets('applies custom gradient colors', (tester) async {
      const customColors = [Colors.red, Colors.green, Colors.blue];

      await tester.pumpMaterialWidget(
        child: GlassyContainerTestUtils.createTestWidget(
          customGradientColors: customColors,
        ),
      );

      // Verify custom gradient colors are applied
      final containers = tester.widgetList<Container>(find.byType(Container));
      final containerWithDecoration = containers.firstWhere(
        (container) => container.decoration is BoxDecoration,
      );
      final decoration = containerWithDecoration.decoration as BoxDecoration;
      final gradient = decoration.gradient as LinearGradient;
      expect(gradient.colors, customColors);
    });

    testWidgets('applies border decoration', (tester) async {
      await tester.pumpMaterialWidget(
        child: GlassyContainerTestUtils.createTestWidget(),
      );

      // Verify border is applied
      final containers = tester.widgetList<Container>(find.byType(Container));
      final containerWithDecoration = containers.firstWhere(
        (container) => container.decoration is BoxDecoration,
      );
      final decoration = containerWithDecoration.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
    });

    testWidgets('handles onTap callback', (tester) async {
      bool tapCalled = false;

      await tester.pumpMaterialWidget(
        child: GlassyContainerTestUtils.createTestWidget(
          onTap: () => tapCalled = true,
        ),
      );

      // Tap the container
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      // Verify callback is called
      expect(tapCalled, isTrue);
    });

    testWidgets('handles null onTap callback', (tester) async {
      await tester.pumpMaterialWidget(
        child: GlassyContainerTestUtils.createTestWidget(onTap: null),
      );

      // Tap should not throw an error
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();
      expect(find.byType(GlassyContainer), findsOneWidget);
    });

    testWidgets('handles custom shadow properties', (tester) async {
      const customShadowColor = Colors.purple;
      const customShadowOpacity = 0.2;
      const customBlurRadius = 20.0;
      const customShadowOffset = Offset(2, 8);

      await tester.pumpMaterialWidget(
        child: GlassyContainerTestUtils.createTestWidget(
          shadowColor: customShadowColor,
          shadowOpacity: customShadowOpacity,
          blurRadius: customBlurRadius,
          shadowOffset: customShadowOffset,
        ),
      );

      // Verify widget renders with custom shadow properties
      expect(find.byType(GlassyContainer), findsOneWidget);
      expect(find.byType(Container), findsAtLeastNWidgets(1));
    });

    testWidgets('handles custom opacity properties', (tester) async {
      const customBorderOpacity = 0.3;
      const customSurfaceOpacity = 0.9;

      await tester.pumpMaterialWidget(
        child: GlassyContainerTestUtils.createTestWidget(
          borderOpacity: customBorderOpacity,
          surfaceOpacity: customSurfaceOpacity,
        ),
      );

      // Verify widget renders with custom opacity properties
      expect(find.byType(GlassyContainer), findsOneWidget);
      expect(find.byType(Container), findsAtLeastNWidgets(1));
    });

    testWidgets('adapts to light theme', (tester) async {
      await tester.pumpMaterialWidget(
        child: Theme(
          data: ThemeData.light(),
          child: GlassyContainerTestUtils.createTestWidget(),
        ),
      );

      // Verify widget renders in light theme
      expect(find.byType(GlassyContainer), findsOneWidget);
      expect(find.byType(Container), findsAtLeastNWidgets(1));
    });

    testWidgets('adapts to dark theme', (tester) async {
      await tester.pumpMaterialWidget(
        child: Theme(
          data: ThemeData.dark(),
          child: GlassyContainerTestUtils.createTestWidget(),
        ),
      );

      // Verify widget renders in dark theme
      expect(find.byType(GlassyContainer), findsOneWidget);
      expect(find.byType(Container), findsAtLeastNWidgets(1));
    });

    testWidgets('handles complex child widget', (tester) async {
      const complexChild = Column(
        children: [Text('Title'), Text('Subtitle'), Icon(Icons.star)],
      );

      await tester.pumpMaterialWidget(
        child: GlassyContainerTestUtils.createTestWidget(child: complexChild),
      );

      // Verify complex child is rendered
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('handles zero dimensions', (tester) async {
      await tester.pumpMaterialWidget(
        child: GlassyContainerTestUtils.createTestWidget(width: 0, height: 0),
      );

      // Verify widget renders with zero dimensions
      expect(find.byType(GlassyContainer), findsOneWidget);
      final containers = tester.widgetList<Container>(find.byType(Container));
      final outerContainer = containers.firstWhere(
        (container) => container.constraints?.maxWidth == 0,
      );
      expect(outerContainer.constraints?.maxWidth, 0);
      expect(outerContainer.constraints?.maxHeight, 0);
    });

    testWidgets('handles very large dimensions', (tester) async {
      const largeWidth = 1000.0;
      const largeHeight = 1000.0;

      await tester.pumpMaterialWidget(
        child: GlassyContainerTestUtils.createTestWidget(
          width: largeWidth,
          height: largeHeight,
        ),
      );

      // Verify widget renders with large dimensions
      expect(find.byType(GlassyContainer), findsOneWidget);
      final containers = tester.widgetList<Container>(find.byType(Container));
      final outerContainer = containers.firstWhere(
        (container) => container.constraints?.maxWidth == largeWidth,
      );
      expect(outerContainer.constraints?.maxWidth, largeWidth);
      expect(outerContainer.constraints?.maxHeight, largeHeight);
    });

    testWidgets('handles edge case opacity values', (tester) async {
      await tester.pumpMaterialWidget(
        child: GlassyContainerTestUtils.createTestWidget(
          shadowOpacity: 0.0,
          borderOpacity: 0.0,
          surfaceOpacity: 0.0,
        ),
      );

      // Verify widget renders with zero opacity values
      expect(find.byType(GlassyContainer), findsOneWidget);
    });

    testWidgets('handles maximum opacity values', (tester) async {
      await tester.pumpMaterialWidget(
        child: GlassyContainerTestUtils.createTestWidget(
          shadowOpacity: 1.0,
          borderOpacity: 1.0,
          surfaceOpacity: 1.0,
        ),
      );

      // Verify widget renders with maximum opacity values
      expect(find.byType(GlassyContainer), findsOneWidget);
    });

    testWidgets('handles negative blur radius', (tester) async {
      await tester.pumpMaterialWidget(
        child: GlassyContainerTestUtils.createTestWidget(blurRadius: -5.0),
      );

      // Verify widget renders with negative blur radius
      expect(find.byType(GlassyContainer), findsOneWidget);
    });

    testWidgets('handles large blur radius', (tester) async {
      await tester.pumpMaterialWidget(
        child: GlassyContainerTestUtils.createTestWidget(blurRadius: 100.0),
      );

      // Verify widget renders with large blur radius
      expect(find.byType(GlassyContainer), findsOneWidget);
    });

    testWidgets('handles custom shadow offset', (tester) async {
      const customOffset = Offset(-5, -10);

      await tester.pumpMaterialWidget(
        child: GlassyContainerTestUtils.createTestWidget(
          shadowOffset: customOffset,
        ),
      );

      // Verify widget renders with custom shadow offset
      expect(find.byType(GlassyContainer), findsOneWidget);
    });
  });
}
