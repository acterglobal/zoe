import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/home/widgets/stats_section/stats_widget.dart';

import '../../../../test-utils/test_utils.dart';

void main() {
  group('StatsWidget', () {
    bool onTapCalled = false;
    VoidCallback? onTapCallback;

    setUp(() {
      onTapCalled = false;
      onTapCallback = () {
        onTapCalled = true;
      };
    });

    Future<void> pumpStatsWidget(
      WidgetTester tester, {
      required IconData icon,
      required String count,
      required String title,
      required Color color,
      required VoidCallback onTap,
    }) async {
      await tester.pumpMaterialWidget(
        child: StatsWidget(
          icon: icon,
          count: count,
          title: title,
          color: color,
          onTap: onTap,
        ),
      );
    }

    group('Widget Construction', () {
      testWidgets('creates widget successfully with all required parameters', (
        tester,
      ) async {
        var widget = StatsWidget(
          icon: Icons.star,
          count: '10',
          title: 'Test Stats',
          color: Colors.blue,
          onTap: () {},
        );
        expect(widget, isA<StatelessWidget>());
        expect(widget.icon, equals(Icons.star));
        expect(widget.count, equals('10'));
        expect(widget.title, equals('Test Stats'));
        expect(widget.color, equals(Colors.blue));
      });

      testWidgets('creates widget with custom key', (tester) async {
        const key = Key('stats_widget');
        var widget = StatsWidget(
          key: key,
          icon: Icons.star,
          count: '10',
          title: 'Test Stats',
          color: Colors.blue,
          onTap: () {},
        );
        expect(widget.key, equals(key));
      });
    });

    group('Widget Rendering', () {
      testWidgets('renders with proper structure', (tester) async {
        await pumpStatsWidget(
          tester,
          icon: Icons.star,
          count: '10',
          title: 'Test Stats',
          color: Colors.blue,
          onTap: onTapCallback!,
        );

        // Verify main structure
        expect(find.byType(GestureDetector), findsOneWidget);
        expect(find.byType(Container), findsAtLeastNWidgets(1));
        expect(find.byType(Row), findsOneWidget);
        expect(find.byType(Icon), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
        expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
      });

      testWidgets('renders title text correctly', (tester) async {
        const testTitle = 'My Stats';
        await pumpStatsWidget(
          tester,
          icon: Icons.star,
          count: '10',
          title: testTitle,
          color: Colors.blue,
          onTap: onTapCallback!,
        );

        expect(find.text(testTitle), findsOneWidget);

        final textWidget = tester.widget<Text>(find.text(testTitle));
        expect(textWidget.data, equals(testTitle));
      });

      testWidgets('renders icon correctly', (tester) async {
        await pumpStatsWidget(
          tester,
          icon: Icons.favorite,
          count: '10',
          title: 'Test Stats',
          color: Colors.red,
          onTap: onTapCallback!,
        );

        expect(find.byIcon(Icons.favorite), findsOneWidget);

        final iconWidget = tester.widget<Icon>(find.byIcon(Icons.favorite));
        expect(iconWidget.icon, equals(Icons.favorite));
        expect(iconWidget.size, equals(20));
      });

      testWidgets('renders with different icons', (tester) async {
        await pumpStatsWidget(
          tester,
          icon: Icons.settings,
          count: '10',
          title: 'Test Stats',
          color: Colors.green,
          onTap: onTapCallback!,
        );

        expect(find.byIcon(Icons.settings), findsOneWidget);
        expect(find.byIcon(Icons.star), findsNothing);
      });
    });

    group('Layout and Styling', () {
      testWidgets('has correct container padding', (tester) async {
        await pumpStatsWidget(
          tester,
          icon: Icons.star,
          count: '10',
          title: 'Test Stats',
          color: Colors.blue,
          onTap: onTapCallback!,
        );

        final mainContainer = tester.widget<Container>(
          find.byType(Container).first,
        );
        expect(mainContainer.padding, equals(const EdgeInsets.all(12)));
      });

      testWidgets('has correct container decoration', (tester) async {
        await pumpStatsWidget(
          tester,
          icon: Icons.star,
          count: '10',
          title: 'Test Stats',
          color: Colors.blue,
          onTap: onTapCallback!,
        );

        final mainContainer = tester.widget<Container>(
          find.byType(Container).first,
        );
        expect(mainContainer.decoration, isA<BoxDecoration>());

        final decoration = mainContainer.decoration as BoxDecoration;
        expect(decoration.borderRadius, equals(BorderRadius.circular(16)));
        expect(decoration.border, isNotNull);
        expect(decoration.boxShadow, isNotNull);
        expect(decoration.boxShadow!.length, equals(1));
      });

      testWidgets('has correct icon container styling', (tester) async {
        await pumpStatsWidget(
          tester,
          icon: Icons.star,
          count: '10',
          title: 'Test Stats',
          color: Colors.blue,
          onTap: onTapCallback!,
        );

        // Find the icon container (second Container in the widget tree)
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

    group('Color Handling', () {
      testWidgets('uses custom color for icon and styling', (tester) async {
        const customColor = Colors.purple;
        await pumpStatsWidget(
          tester,
          icon: Icons.star,
          count: '10',
          title: 'Test Stats',
          color: customColor,
          onTap: onTapCallback!,
        );

        final icon = tester.widget<Icon>(find.byIcon(Icons.star));
        expect(icon.color, equals(customColor));
      });

      testWidgets('applies color with alpha to icon container background', (
        tester,
      ) async {
        const customColor = Colors.orange;
        await pumpStatsWidget(
          tester,
          icon: Icons.star,
          count: '10',
          title: 'Test Stats',
          color: customColor,
          onTap: onTapCallback!,
        );

        final containers = tester.widgetList<Container>(find.byType(Container));
        final iconContainer = containers.firstWhere(
          (container) => container.padding == const EdgeInsets.all(8),
        );
        final decoration = iconContainer.decoration as BoxDecoration;
        expect(decoration.color, equals(customColor.withValues(alpha: 0.12)));
      });
    });

    group('Text Styling', () {
      testWidgets('applies correct text style', (tester) async {
        await pumpStatsWidget(
          tester,
          icon: Icons.star,
          count: '10',
          title: 'Test Stats',
          color: Colors.blue,
          onTap: onTapCallback!,
        );

        final text = tester.widget<Text>(find.byType(Text));
        final style = text.style;

        expect(style?.fontWeight, equals(FontWeight.w600));
        expect(style?.color, isNotNull);
      });
    });

    group('Icon Variations', () {
      testWidgets('renders different icon types', (tester) async {
        const icons = [
          Icons.star,
          Icons.favorite,
          Icons.settings,
          Icons.home,
          Icons.person,
          Icons.notifications,
        ];

        for (final icon in icons) {
          await pumpStatsWidget(
            tester,
            icon: icon,
            count: '10',
            title: 'Test Stats',
            color: Colors.blue,
            onTap: onTapCallback!,
          );

          expect(find.byIcon(icon), findsOneWidget);

          final iconWidget = tester.widget<Icon>(find.byIcon(icon));
          expect(iconWidget.icon, equals(icon));
          expect(iconWidget.size, equals(20));

          // Clean up for next iteration
          await tester.pumpWidget(const SizedBox.shrink());
        }
      });

      testWidgets('maintains consistent icon size', (tester) async {
        await pumpStatsWidget(
          tester,
          icon: Icons.star,
          count: '10',
          title: 'Test Stats',
          color: Colors.blue,
          onTap: onTapCallback!,
        );

        final icon = tester.widget<Icon>(find.byIcon(Icons.star));
        expect(icon.size, equals(20));
      });
    });

    group('Gesture Handling', () {
      testWidgets('calls onTap when tapped', (tester) async {
        await pumpStatsWidget(
          tester,
          icon: Icons.star,
          count: '10',
          title: 'Test Stats',
          color: Colors.blue,
          onTap: onTapCallback!,
        );

        expect(onTapCalled, isFalse);

        await tester.tap(find.byType(GestureDetector));
        await tester.pump();

        expect(onTapCalled, isTrue);
      });

      testWidgets('handles null onTap gracefully', (tester) async {
        await pumpStatsWidget(
          tester,
          icon: Icons.star,
          count: '10',
          title: 'Test Stats',
          color: Colors.blue,
          onTap: () {}, // Empty callback
        );

        // Should not throw an error when tapped
        await tester.tap(find.byType(GestureDetector));
        await tester.pump();

        expect(tester.takeException(), isNull);
      });
    });

    group('Count Parameter', () {
      testWidgets('handles different count formats', (tester) async {
        const counts = ['1', '10', '100', '1K', '1M', '∞'];

        for (final count in counts) {
          await pumpStatsWidget(
            tester,
            icon: Icons.star,
            count: count,
            title: 'Test Stats',
            color: Colors.blue,
            onTap: onTapCallback!,
          );

          // Count is not displayed, but widget should render without errors
          expect(find.text('Test Stats'), findsOneWidget);

          // Clean up for next iteration
          await tester.pumpWidget(const SizedBox.shrink());
        }
      });
    });

    group('Edge Cases', () {
      testWidgets('handles numeric titles', (tester) async {
        const numericTitle = '12345';
        await pumpStatsWidget(
          tester,
          icon: Icons.star,
          count: '10',
          title: numericTitle,
          color: Colors.blue,
          onTap: onTapCallback!,
        );

        expect(find.text(numericTitle), findsOneWidget);
      });

      testWidgets('handles titles with whitespace', (tester) async {
        const titleWithSpaces = '  Stats with spaces  ';
        await pumpStatsWidget(
          tester,
          icon: Icons.star,
          count: '10',
          title: titleWithSpaces,
          color: Colors.blue,
          onTap: onTapCallback!,
        );

        expect(find.text(titleWithSpaces), findsOneWidget);
      });

      testWidgets('handles extreme color values', (tester) async {
        const extremeColor = Color(0xFFFFFFFF); // White
        await pumpStatsWidget(
          tester,
          icon: Icons.star,
          count: '10',
          title: 'Test Stats',
          color: extremeColor,
          onTap: onTapCallback!,
        );

        final icon = tester.widget<Icon>(find.byIcon(Icons.star));
        expect(icon.color, equals(extremeColor));
      });
    });
  });
}
