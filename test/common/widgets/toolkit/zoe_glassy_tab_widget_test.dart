import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_glassy_tab_widget.dart';

import '../../../test-utils/test_utils.dart';

/// Test utilities for ZoeGlassyTab widget tests
class ZoeGlassyTabTestUtils {
  /// Creates a test wrapper for the ZoeGlassyTab widget
  static ZoeGlassyTabWidget createTestWidget({
    List<String>? tabTexts,
    int? selectedIndex,
    Function(int)? onTabChanged,
    double height = 60,
    EdgeInsets margin = const EdgeInsets.symmetric(vertical: 4),
    double borderRadius = 25,
    double borderOpacity = 0.1,
  }) {
    return ZoeGlassyTabWidget(
      tabTexts: tabTexts ?? ['Tab 1', 'Tab 2', 'Tab 3'],
      selectedIndex: selectedIndex ?? 0,
      onTabChanged: onTabChanged ?? (_) {},
      height: height,
      margin: margin,
      borderRadius: borderRadius,
      borderOpacity: borderOpacity,
    );
  }
}

void main() {
  group('ZoeGlassyTab Widget Tests -', () {
    testWidgets('renders all tabs correctly', (tester) async {
      final tabs = ['First', 'Second', 'Third'];
      await tester.pumpMaterialWidget(
        child: ZoeGlassyTabTestUtils.createTestWidget(
          tabTexts: tabs,
        ),
      );

      // Verify all tabs are rendered
      for (final tab in tabs) {
        expect(find.text(tab), findsOneWidget);
      }
    });

    testWidgets('applies default height correctly', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeGlassyTabTestUtils.createTestWidget(),
      );

      // Verify default height
      final container = tester.widget<GlassyContainer>(
        find.byType(GlassyContainer),
      );
      expect(container.height, 60);
    });

    testWidgets('applies custom height correctly', (tester) async {
      const customHeight = 80.0;
      await tester.pumpMaterialWidget(
        child: ZoeGlassyTabTestUtils.createTestWidget(
          height: customHeight,
        ),
      );

      // Verify custom height
      final container = tester.widget<GlassyContainer>(
        find.byType(GlassyContainer),
      );
      expect(container.height, customHeight);
    });

    testWidgets('applies default margin correctly', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeGlassyTabTestUtils.createTestWidget(),
      );

      // Verify default margin
      final container = tester.widget<GlassyContainer>(
        find.byType(GlassyContainer),
      );
      expect(
        container.margin,
        const EdgeInsets.symmetric(vertical: 4),
      );
    });

    testWidgets('applies custom margin correctly', (tester) async {
      const customMargin = EdgeInsets.all(8);
      await tester.pumpMaterialWidget(
        child: ZoeGlassyTabTestUtils.createTestWidget(
          margin: customMargin,
        ),
      );

      // Verify custom margin
      final container = tester.widget<GlassyContainer>(
        find.byType(GlassyContainer),
      );
      expect(container.margin, customMargin);
    });

    testWidgets('applies default border radius correctly', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeGlassyTabTestUtils.createTestWidget(),
      );

      // Verify default border radius
      final container = tester.widget<GlassyContainer>(
        find.byType(GlassyContainer),
      );
      expect(container.borderRadius, BorderRadius.circular(25));
    });

    testWidgets('applies custom border radius correctly', (tester) async {
      const customRadius = 16.0;
      await tester.pumpMaterialWidget(
        child: ZoeGlassyTabTestUtils.createTestWidget(
          borderRadius: customRadius,
        ),
      );

      // Verify custom border radius
      final container = tester.widget<GlassyContainer>(
        find.byType(GlassyContainer),
      );
      expect(container.borderRadius, BorderRadius.circular(customRadius));
    });

    testWidgets('applies default border opacity correctly', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeGlassyTabTestUtils.createTestWidget(),
      );

      // Verify default border opacity
      final container = tester.widget<GlassyContainer>(
        find.byType(GlassyContainer),
      );
      expect(container.borderOpacity, 0.1);
    });

    testWidgets('applies custom border opacity correctly', (tester) async {
      const customOpacity = 0.5;
      await tester.pumpMaterialWidget(
        child: ZoeGlassyTabTestUtils.createTestWidget(
          borderOpacity: customOpacity,
        ),
      );

      // Verify custom border opacity
      final container = tester.widget<GlassyContainer>(
        find.byType(GlassyContainer),
      );
      expect(container.borderOpacity, customOpacity);
    });

    testWidgets('shows selected tab correctly', (tester) async {
      const selectedIndex = 1;
      final tabs = ['First', 'Second', 'Third'];
      await tester.pumpMaterialWidget(
        child: ZoeGlassyTabTestUtils.createTestWidget(
          tabTexts: tabs,
          selectedIndex: selectedIndex,
        ),
      );

      // Find all tab containers
      final tabContainers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(ListView),
          matching: find.byType(Container),
        ),
      );

      // Verify selected tab has border and others don't
      int index = 0;
      for (final container in tabContainers) {
        final decoration = container.decoration as BoxDecoration;
        if (index == selectedIndex) {
          expect(decoration.border, isNotNull);
          expect(decoration.color,
              equals(ThemeData.light().colorScheme.primary.withValues(alpha: 0.2)));
        } else {
          expect(decoration.border, isNull);
          expect(decoration.color, Colors.transparent);
        }
        index++;
      }
    });

    testWidgets('calls onTabChanged when tab is tapped', (tester) async {
      int? tappedIndex;
      await tester.pumpMaterialWidget(
        child: ZoeGlassyTabTestUtils.createTestWidget(
          onTabChanged: (index) => tappedIndex = index,
        ),
      );

      // Tap the second tab
      await tester.tap(find.text('Tab 2'));
      await tester.pump();

      // Verify callback was called with correct index
      expect(tappedIndex, 1);
    });

    testWidgets('has horizontal scrolling enabled', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeGlassyTabTestUtils.createTestWidget(
          tabTexts: List.generate(10, (i) => 'Tab $i'),
        ),
      );

      // Verify ListView is horizontal
      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.scrollDirection, Axis.horizontal);
    });

    testWidgets('implements PreferredSizeWidget correctly', (tester) async {
      const customHeight = 80.0;
      final widget = ZoeGlassyTabTestUtils.createTestWidget(
        height: customHeight,
      ) as PreferredSizeWidget;

      expect(widget.preferredSize.height, customHeight);
    });

    testWidgets('applies correct text styles', (tester) async {
      const selectedIndex = 1;
      final tabs = ['First', 'Second', 'Third'];
      await tester.pumpMaterialWidget(
        child: ZoeGlassyTabTestUtils.createTestWidget(
          tabTexts: tabs,
          selectedIndex: selectedIndex,
        ),
      );

      // Find all tab texts
      final textWidgets = tester.widgetList<Text>(find.byType(Text));

      // Verify text styles
      int index = 0;
      for (final text in textWidgets) {
        final style = text.style!;
        expect(style.fontSize, 12);
        expect(
          style.fontWeight,
          index == selectedIndex ? FontWeight.w600 : FontWeight.w500,
        );
        index++;
      }
    });
  });
}