import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/bottom_sheet_option_widget.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';

import '../../test-utils/test_utils.dart';

void main() {
  Future<void> pumpBottomSheetOptionWidget(
    WidgetTester tester, {
    IconData icon = Icons.star,
    String title = 'Test Title',
    String? subtitle,
    Color color = Colors.blue,
    VoidCallback? onTap,
  }) async {
    await tester.pumpMaterialWidget(
      child: BottomSheetOptionWidget(
        icon: icon,
        title: title,
        subtitle: subtitle,
        color: color,
        onTap: onTap ?? () {},
      ),
    );
  }

  group('BottomSheetOptionWidget Tests -', () {
    testWidgets('renders with required properties', (tester) async {
      await pumpBottomSheetOptionWidget(tester);

      // Verify widget is rendered
      expect(find.byType(BottomSheetOptionWidget), findsOneWidget);
    });

    testWidgets('displays title correctly', (tester) async {
      const testTitle = 'Custom Test Title';

      await pumpBottomSheetOptionWidget(tester, title: testTitle);

      // Verify title is displayed
      expect(find.text(testTitle), findsOneWidget);

      // Verify title uses correct text style
      final titleText = tester.widget<Text>(find.text(testTitle));
      expect(titleText.style, isNotNull);
    });

    testWidgets('displays subtitle when provided', (tester) async {
      const testTitle = 'Main Title';
      const testSubtitle = 'This is a subtitle';

      await pumpBottomSheetOptionWidget(
        tester,
        title: testTitle,
        subtitle: testSubtitle,
      );

      // Verify both title and subtitle are displayed
      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testSubtitle), findsOneWidget);

      // Verify subtitle uses correct text style
      final subtitleText = tester.widget<Text>(find.text(testSubtitle));
      expect(subtitleText.style, isNotNull);
    });

    testWidgets('hides subtitle when not provided', (tester) async {
      const testTitle = 'Title Only';

      await pumpBottomSheetOptionWidget(
        tester,
        title: testTitle,
        subtitle: null,
      );

      // Verify only title is displayed
      expect(find.text(testTitle), findsOneWidget);

      // Verify no subtitle text exists
      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      expect(textWidgets.length, equals(1)); // Only title text
    });

    testWidgets('displays icon correctly', (tester) async {
      const testIcon = Icons.favorite;

      await pumpBottomSheetOptionWidget(tester, icon: testIcon);

      // Verify StyledIconContainer is present with correct icon
      expect(find.byType(StyledIconContainer), findsOneWidget);

      final styledIconContainer = tester.widget<StyledIconContainer>(
        find.byType(StyledIconContainer),
      );
      expect(styledIconContainer.icon, testIcon);
    });

    testWidgets('applies color to StyledIconContainer', (tester) async {
      const testColor = Colors.red;

      await pumpBottomSheetOptionWidget(tester, color: testColor);

      // Verify color is applied to StyledIconContainer
      final styledIconContainer = tester.widget<StyledIconContainer>(
        find.byType(StyledIconContainer),
      );
      expect(styledIconContainer.primaryColor, testColor);
    });

    testWidgets('displays chevron icon correctly', (tester) async {
      await pumpBottomSheetOptionWidget(tester);

      // Verify chevron icon is displayed
      expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);

      // Verify chevron icon properties
      final chevronIcon = tester.widget<Icon>(
        find.byIcon(Icons.chevron_right_rounded),
      );
      expect(chevronIcon.size, equals(24));
    });

    group('User Interactions -', () {
      testWidgets('calls onTap when tapped', (tester) async {
        bool wasTapped = false;

        await pumpBottomSheetOptionWidget(
          tester,
          onTap: () => wasTapped = true,
        );

        // Tap the widget
        await tester.tap(find.byType(BottomSheetOptionWidget));
        await tester.pumpAndSettle();

        // Verify callback was called
        expect(wasTapped, isTrue);
      });

      testWidgets('calls onTap when GestureDetector is tapped', (tester) async {
        int tapCount = 0;

        await pumpBottomSheetOptionWidget(tester, onTap: () => tapCount++);

        // Tap multiple times (use BottomSheetOptionWidget to be specific)
        await tester.tap(find.byType(BottomSheetOptionWidget));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(BottomSheetOptionWidget));
        await tester.pumpAndSettle();

        // Verify callback was called multiple times
        expect(tapCount, equals(2));
      });

      testWidgets('handles rapid taps correctly', (tester) async {
        int tapCount = 0;

        await pumpBottomSheetOptionWidget(tester, onTap: () => tapCount++);

        // Perform rapid taps
        for (int i = 0; i < 5; i++) {
          await tester.tap(find.byType(BottomSheetOptionWidget));
        }
        await tester.pumpAndSettle();

        // Verify all taps were registered
        expect(tapCount, equals(5));
      });
    });

    group('Layout Structure -', () {
      testWidgets('has correct widget hierarchy', (tester) async {
        await pumpBottomSheetOptionWidget(tester, subtitle: 'Test Subtitle');

        // Verify the widget hierarchy
        expect(
          find.byType(GestureDetector),
          findsAtLeastNWidgets(1),
        ); // Multiple from child widgets
        expect(find.byType(GlassyContainer), findsOneWidget);
        expect(find.byType(Row), findsOneWidget);
        expect(find.byType(StyledIconContainer), findsOneWidget);
        expect(
          find.byType(SizedBox),
          findsAtLeastNWidgets(2),
        ); // Width spacing + height spacing
        expect(find.byType(Expanded), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
      });

      testWidgets('applies correct padding to GlassyContainer', (tester) async {
        await pumpBottomSheetOptionWidget(tester);

        // Verify GlassyContainer padding
        final glassyContainer = tester.widget<GlassyContainer>(
          find.byType(GlassyContainer),
        );
        expect(glassyContainer.padding, equals(const EdgeInsets.all(10)));
      });

      testWidgets('applies correct border radius to GlassyContainer', (
        tester,
      ) async {
        await pumpBottomSheetOptionWidget(tester);

        // Verify GlassyContainer border radius
        final glassyContainer = tester.widget<GlassyContainer>(
          find.byType(GlassyContainer),
        );
        expect(glassyContainer.borderRadius, equals(BorderRadius.circular(16)));
      });

      testWidgets('applies correct opacity values to GlassyContainer', (
        tester,
      ) async {
        await pumpBottomSheetOptionWidget(tester);

        // Verify GlassyContainer opacity values
        final glassyContainer = tester.widget<GlassyContainer>(
          find.byType(GlassyContainer),
        );
        expect(glassyContainer.borderOpacity, equals(0.1));
        expect(glassyContainer.shadowOpacity, equals(0.05));
      });

      testWidgets('applies correct properties to StyledIconContainer', (
        tester,
      ) async {
        await pumpBottomSheetOptionWidget(tester);

        // Verify StyledIconContainer properties
        final styledIconContainer = tester.widget<StyledIconContainer>(
          find.byType(StyledIconContainer),
        );
        expect(styledIconContainer.size, equals(52));
        expect(
          styledIconContainer.borderRadius,
          equals(BorderRadius.circular(24)),
        );
      });

      testWidgets('uses Expanded widget for text content', (tester) async {
        await pumpBottomSheetOptionWidget(
          tester,
          title: 'Very Long Title That Should Expand',
          subtitle: 'Very Long Subtitle That Should Also Expand',
        );

        // Verify Expanded widget is used for text content
        expect(find.byType(Expanded), findsOneWidget);

        // Verify Column is inside Expanded
        final expanded = tester.widget<Expanded>(find.byType(Expanded));
        expect(expanded.child, isA<Column>());
      });

      testWidgets('applies correct cross axis alignment to Column', (
        tester,
      ) async {
        await pumpBottomSheetOptionWidget(tester, subtitle: 'Test Subtitle');

        // Verify Column cross axis alignment
        final column = tester.widget<Column>(find.byType(Column));
        expect(column.crossAxisAlignment, equals(CrossAxisAlignment.start));
      });
    });
    
    group('Edge Cases -', () {
      testWidgets('handles empty title gracefully', (tester) async {
        await pumpBottomSheetOptionWidget(tester, title: '');

        // Verify widget renders without errors
        expect(find.byType(BottomSheetOptionWidget), findsOneWidget);
        expect(find.text(''), findsOneWidget);
      });

      testWidgets('handles very long title', (tester) async {
        const longTitle =
            'This is a very long title that should be handled gracefully by the widget layout system';

        await pumpBottomSheetOptionWidget(tester, title: longTitle);

        // Verify widget renders without errors
        expect(find.byType(BottomSheetOptionWidget), findsOneWidget);
        expect(find.text(longTitle), findsOneWidget);
      });

      testWidgets('handles very long subtitle', (tester) async {
        const longSubtitle =
            'This is a very long subtitle that should be handled gracefully by the widget layout system and should not cause overflow issues';

        await pumpBottomSheetOptionWidget(
          tester,
          title: 'Title',
          subtitle: longSubtitle,
        );

        // Verify widget renders without errors
        expect(find.byType(BottomSheetOptionWidget), findsOneWidget);
        expect(find.text(longSubtitle), findsOneWidget);
      });

      testWidgets('handles null subtitle correctly', (tester) async {
        await pumpBottomSheetOptionWidget(
          tester,
          title: 'Title Only',
          subtitle: null,
        );

        // Verify widget renders without errors
        expect(find.byType(BottomSheetOptionWidget), findsOneWidget);
        expect(find.text('Title Only'), findsOneWidget);

        // Verify no additional text widgets for subtitle
        final textWidgets = tester.widgetList<Text>(find.byType(Text));
        expect(textWidgets.length, equals(1));
      });

      testWidgets('handles different icon types', (tester) async {
        final testIcons = [
          Icons.home,
          Icons.settings,
          Icons.person,
          Icons.notifications,
          Icons.help,
        ];

        for (final icon in testIcons) {
          await pumpBottomSheetOptionWidget(
            tester,
            icon: icon,
            title: 'Test $icon',
          );

          // Verify widget renders with each icon
          expect(find.byType(BottomSheetOptionWidget), findsOneWidget);

          final styledIconContainer = tester.widget<StyledIconContainer>(
            find.byType(StyledIconContainer),
          );
          expect(styledIconContainer.icon, icon);

          // Clear the widget tree for next iteration
          await tester.pumpWidget(const SizedBox());
        }
      });

      testWidgets('handles different color values', (tester) async {
        final testColors = [
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.orange,
          Colors.purple,
          const Color(0xFF123456),
        ];

        for (final color in testColors) {
          await pumpBottomSheetOptionWidget(
            tester,
            color: color,
            title: 'Test Color',
          );

          // Verify widget renders with each color
          expect(find.byType(BottomSheetOptionWidget), findsOneWidget);

          final styledIconContainer = tester.widget<StyledIconContainer>(
            find.byType(StyledIconContainer),
          );
          expect(styledIconContainer.primaryColor, color);

          // Clear the widget tree for next iteration
          await tester.pumpWidget(const SizedBox());
        }
      });
    });

    group('Accessibility -', () {
      testWidgets('is accessible for screen readers', (tester) async {
        await pumpBottomSheetOptionWidget(
          tester,
          title: 'Accessible Title',
          subtitle: 'Accessible Subtitle',
        );

        // Verify text is accessible
        expect(find.text('Accessible Title'), findsOneWidget);
        expect(find.text('Accessible Subtitle'), findsOneWidget);

        // Verify tappable area exists
        expect(find.byType(GestureDetector), findsAtLeastNWidgets(1));
      });

      testWidgets('maintains semantic structure', (tester) async {
        await pumpBottomSheetOptionWidget(
          tester,
          title: 'Semantic Title',
          subtitle: 'Semantic Subtitle',
        );

        // Verify semantic structure is maintained
        expect(find.byType(BottomSheetOptionWidget), findsOneWidget);
        expect(find.byType(Row), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
      });
    });
  });
}
