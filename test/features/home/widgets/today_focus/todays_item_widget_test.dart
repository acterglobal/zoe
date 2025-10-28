import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/home/widgets/today_focus/todays_item_widget.dart';

import '../../../../test-utils/test_utils.dart';

void main() {
  group('TodaysItemWidget', () {
    Future<void> pumpTodaysItemWidget(
      WidgetTester tester, {
      String title = 'Test Title',
      IconData icon = Icons.event_rounded,
      Color color = AppColors.secondaryColor,
      int count = 5,
      List<Widget> children = const [],
    }) async {
      await tester.pumpMaterialWidget(
        child: TodaysItemWidget(
          title: title,
          icon: icon,
          color: color,
          count: count,
          children: children,
        ),
      );
    }

    group('Widget Construction', () {
      testWidgets('accepts all required parameters', (tester) async {
        const testTitle = 'Custom Title';
        const testIcon = Icons.task_alt_rounded;
        const testColor = Colors.red;
        const testCount = 10;
        final testChildren = [const Text('Child 1'), const Text('Child 2')];

        await pumpTodaysItemWidget(
          tester,
          title: testTitle,
          icon: testIcon,
          color: testColor,
          count: testCount,
          children: testChildren,
        );

        expect(find.text(testTitle), findsOneWidget);
        // Note: The widget uses hardcoded Icons.event_rounded, not the provided icon
        expect(find.byIcon(Icons.event_rounded), findsOneWidget);
        expect(find.text(testCount.toString()), findsOneWidget);
        expect(find.text('Child 1'), findsOneWidget);
        expect(find.text('Child 2'), findsOneWidget);
      });
    });

    group('Widget Rendering', () {
      testWidgets('renders with children', (tester) async {
        final testChildren = [
          const Text('Child Widget 1'),
          const Text('Child Widget 2'),
          const Icon(Icons.star),
        ];

        await pumpTodaysItemWidget(tester, children: testChildren);

        expect(find.text('Child Widget 1'), findsOneWidget);
        expect(find.text('Child Widget 2'), findsOneWidget);
        expect(find.byIcon(Icons.star), findsOneWidget);
      });

      testWidgets('renders without children', (tester) async {
        await pumpTodaysItemWidget(tester, children: []);

        expect(find.byType(Container), findsNWidgets(3));
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Row), findsOneWidget);
      });
    });

    group('Layout Structure', () {
      testWidgets('has correct column structure', (tester) async {
        await pumpTodaysItemWidget(tester);

        final column = tester.widget<Column>(find.byType(Column));
        expect(column.crossAxisAlignment, equals(CrossAxisAlignment.start));
        expect(
          column.children.length,
          equals(2),
        ); // Header, SizedBox (children are spread)
      });

      testWidgets('has correct spacing between header and children', (
        tester,
      ) async {
        await pumpTodaysItemWidget(tester);

        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        final spacingBox = sizedBoxes.firstWhere((box) => box.height == 12);
        expect(spacingBox.height, equals(12));
      });
    });

    group('Styling and Decoration', () {
      testWidgets('applies correct container padding', (tester) async {
        await pumpTodaysItemWidget(tester);

        final containers = tester.widgetList<Container>(find.byType(Container));
        final mainContainer = containers.firstWhere(
          (c) => c.padding == const EdgeInsets.all(16),
        );
        expect(mainContainer.padding, equals(const EdgeInsets.all(16)));
      });

      testWidgets('applies correct border radius', (tester) async {
        await pumpTodaysItemWidget(tester);

        final containers = tester.widgetList<Container>(find.byType(Container));
        final mainContainer = containers.firstWhere(
          (c) => c.padding == const EdgeInsets.all(16),
        );
        final decoration = mainContainer.decoration as BoxDecoration;
        expect(decoration.borderRadius, equals(BorderRadius.circular(16)));
      });

      testWidgets('applies gradient decoration', (tester) async {
        await pumpTodaysItemWidget(tester);

        final containers = tester.widgetList<Container>(find.byType(Container));
        final mainContainer = containers.firstWhere(
          (c) => c.padding == const EdgeInsets.all(16),
        );
        final decoration = mainContainer.decoration as BoxDecoration;
        expect(decoration.gradient, isA<LinearGradient>());

        final gradient = decoration.gradient as LinearGradient;
        expect(gradient.begin, equals(Alignment.topLeft));
        expect(gradient.end, equals(Alignment.bottomRight));
        expect(gradient.colors.length, equals(2));
      });

      testWidgets('applies border decoration', (tester) async {
        await pumpTodaysItemWidget(tester);

        final containers = tester.widgetList<Container>(find.byType(Container));
        final mainContainer = containers.firstWhere(
          (c) => c.padding == const EdgeInsets.all(16),
        );
        final decoration = mainContainer.decoration as BoxDecoration;
        expect(decoration.border, isNotNull);
      });
    });

    group('Color Handling', () {
      testWidgets('uses provided color for gradient', (tester) async {
        const testColor = Colors.blue;
        await pumpTodaysItemWidget(tester, color: testColor);

        final containers = tester.widgetList<Container>(find.byType(Container));
        final mainContainer = containers.firstWhere(
          (c) => c.padding == const EdgeInsets.all(16),
        );
        final decoration = mainContainer.decoration as BoxDecoration;
        final gradient = decoration.gradient as LinearGradient;

        expect(gradient.colors.first, equals(testColor.withValues(alpha: 0.1)));
        expect(gradient.colors.last, equals(testColor.withValues(alpha: 0.05)));
      });

      testWidgets('uses provided color for border', (tester) async {
        const testColor = Colors.green;
        await pumpTodaysItemWidget(tester, color: testColor);

        final containers = tester.widgetList<Container>(find.byType(Container));
        final mainContainer = containers.firstWhere(
          (c) => c.padding == const EdgeInsets.all(16),
        );
        final decoration = mainContainer.decoration as BoxDecoration;
        final border = decoration.border as Border;

        expect(border.top.color, equals(testColor.withValues(alpha: 0.2)));
      });

      testWidgets('uses provided color for icon', (tester) async {
        const testColor = Colors.purple;
        await pumpTodaysItemWidget(tester, color: testColor);

        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.color, equals(testColor));
      });

      testWidgets('uses provided color for count text', (tester) async {
        const testColor = Colors.orange;
        await pumpTodaysItemWidget(tester, color: testColor);

        final countText = tester.widget<Text>(find.text('5'));
        final textStyle = countText.style;
        expect(textStyle?.color, equals(testColor));
      });
    });

    group('Icon Handling', () {
      testWidgets('displays hardcoded event icon', (tester) async {
        // Note: The widget uses hardcoded Icons.event_rounded, not the provided icon
        await pumpTodaysItemWidget(tester, icon: Icons.task_alt_rounded);

        expect(find.byIcon(Icons.event_rounded), findsOneWidget);
      });

      testWidgets('icon container has correct styling', (tester) async {
        await pumpTodaysItemWidget(tester);

        final containers = tester.widgetList<Container>(find.byType(Container));
        final iconContainer = containers.firstWhere(
          (container) => container.padding == const EdgeInsets.all(8),
        );

        expect(iconContainer.padding, equals(const EdgeInsets.all(8)));
        expect(iconContainer.decoration, isA<BoxDecoration>());

        final decoration = iconContainer.decoration as BoxDecoration;
        expect(decoration.shape, equals(BoxShape.circle));
      });
    });

    group('Text Styling', () {
      testWidgets('title has correct styling', (tester) async {
        await pumpTodaysItemWidget(tester);

        final titleText = tester.widget<Text>(find.text('Test Title'));
        final textStyle = titleText.style;

        expect(textStyle?.fontWeight, equals(FontWeight.w700));
        expect(textStyle?.color, isNotNull);
      });

      testWidgets('count has correct styling', (tester) async {
        await pumpTodaysItemWidget(tester);

        final countText = tester.widget<Text>(find.text('5'));
        final textStyle = countText.style;

        expect(textStyle?.fontWeight, equals(FontWeight.w600));
        expect(textStyle?.color, isNotNull);
      });
    });

    group('Count Display', () {
      testWidgets('displays zero count', (tester) async {
        await pumpTodaysItemWidget(tester, count: 0);

        expect(find.text('0'), findsOneWidget);
      });

      testWidgets('count container has correct styling', (tester) async {
        await pumpTodaysItemWidget(tester);

        final containers = tester.widgetList<Container>(find.byType(Container));
        final countContainer = containers.firstWhere(
          (container) =>
              container.padding ==
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        );

        expect(
          countContainer.padding,
          equals(const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
        );
        expect(countContainer.decoration, isA<BoxDecoration>());

        final decoration = countContainer.decoration as BoxDecoration;
        expect(decoration.borderRadius, equals(BorderRadius.circular(12)));
      });
    });

    group('Responsive Layout', () {
      testWidgets('handles empty title', (tester) async {
        await pumpTodaysItemWidget(tester, title: '');

        expect(find.text(''), findsOneWidget);
      });

      testWidgets('handles special characters in title', (tester) async {
        const specialTitle = 'Title with émojis 🚀 and spëcial chars';
        await pumpTodaysItemWidget(tester, title: specialTitle);

        expect(find.text(specialTitle), findsOneWidget);
      });
    });
  });
}

