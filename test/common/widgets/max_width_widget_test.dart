import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import '../../test-utils/test_utils.dart';

/// Test utilities for MaxWidthWidget tests
class MaxWidthWidgetTestUtils {
  /// Creates a test wrapper for the MaxWidthWidget
  static Widget createTestWidget({
    Widget? child,
    bool? isScrollable,
    EdgeInsets? padding,
  }) {
    return MaxWidthWidget(
      isScrollable: isScrollable ?? false,
      padding: padding,
      child: child ?? const Text('Test Content'),
    );
  }
}

void main() {
  group('MaxWidthWidget Tests -', () {
    testWidgets('renders with required properties', (tester) async {
      await tester.pumpMaterialWidget(
        child: MaxWidthWidgetTestUtils.createTestWidget(),
      );

      // Verify widget is rendered
      expect(find.byType(MaxWidthWidget), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('renders with custom child', (tester) async {
      const customChild = Text('Custom Child');

      await tester.pumpMaterialWidget(
        child: MaxWidthWidgetTestUtils.createTestWidget(child: customChild),
      );

      // Verify custom child is rendered
      expect(find.text('Custom Child'), findsOneWidget);
      expect(find.text('Test Content'), findsNothing);
    });

    testWidgets('applies max width constraint of 600', (tester) async {
      await tester.pumpMaterialWidget(
        child: MaxWidthWidgetTestUtils.createTestWidget(),
      );

      // Verify max width constraint is applied
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints?.maxWidth, 600);
    });

    testWidgets('applies custom padding', (tester) async {
      const customPadding = EdgeInsets.all(16);

      await tester.pumpMaterialWidget(
        child: MaxWidthWidgetTestUtils.createTestWidget(padding: customPadding),
      );

      // Verify padding is applied
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.padding, customPadding);
    });

    testWidgets('handles null padding', (tester) async {
      await tester.pumpMaterialWidget(
        child: MaxWidthWidgetTestUtils.createTestWidget(padding: null),
      );

      // Verify widget renders without padding
      expect(find.byType(MaxWidthWidget), findsOneWidget);
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.padding, isNull);
    });

    testWidgets('renders without scroll when isScrollable is false', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(
        child: MaxWidthWidgetTestUtils.createTestWidget(isScrollable: false),
      );

      // Verify no SingleChildScrollView is present
      expect(find.byType(SingleChildScrollView), findsNothing);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('renders with scroll when isScrollable is true', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(
        child: MaxWidthWidgetTestUtils.createTestWidget(isScrollable: true),
      );

      // Verify SingleChildScrollView is present
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('scrollable works with overflow content', (tester) async {
      // Create content that would cause overflow
      final overflowChild = Column(
        children: List.generate(
          20,
          (index) => SizedBox(height: 50, child: Text('Item $index')),
        ),
      );

      await tester.pumpMaterialWidget(
        child: MaxWidthWidgetTestUtils.createTestWidget(
          child: overflowChild,
          isScrollable: true,
        ),
      );

      // Verify scrollable wrapper is present
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 19'), findsOneWidget);
    });

    testWidgets('handles edge case with zero padding', (tester) async {
      await tester.pumpMaterialWidget(
        child: MaxWidthWidgetTestUtils.createTestWidget(
          padding: EdgeInsets.zero,
        ),
      );

      // Verify zero padding is applied
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.padding, EdgeInsets.zero);
    });

    testWidgets('handles edge case with large padding', (tester) async {
      const largePadding = EdgeInsets.all(100);

      await tester.pumpMaterialWidget(
        child: MaxWidthWidgetTestUtils.createTestWidget(padding: largePadding),
      );

      // Verify large padding is applied
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.padding, largePadding);
    });

    testWidgets('handles empty child', (tester) async {
      const emptyChild = SizedBox.shrink();

      await tester.pumpMaterialWidget(
        child: MaxWidthWidgetTestUtils.createTestWidget(child: emptyChild),
      );

      // Verify widget renders with empty child
      expect(find.byType(MaxWidthWidget), findsOneWidget);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('handles scroll physics', (tester) async {
      await tester.pumpMaterialWidget(
        child: MaxWidthWidgetTestUtils.createTestWidget(
          isScrollable: true,
          child: const SizedBox(height: 1000, child: Text('Tall Content')),
        ),
      );

      // Verify scrollable is present
      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView, isNotNull);
      expect(find.text('Tall Content'), findsOneWidget);
    });
  });
}
