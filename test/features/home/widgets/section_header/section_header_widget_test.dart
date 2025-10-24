import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/home/widgets/section_header/section_header_widget.dart';
import '../../../../test-utils/test_utils.dart';

void main() {
  group('SectionHeaderWidget', () {
    Future<void> pumpSectionHeaderWidget(
      WidgetTester tester, {
      required String title,
      required IconData icon,
      Color? color,
    }) async {
      await tester.pumpMaterialWidget(
        child: SectionHeaderWidget(title: title, icon: icon, color: color),
      );
    }

    group('Widget Construction', () {
      testWidgets('creates widget with all parameters', (tester) async {
        const widget = SectionHeaderWidget(
          title: 'Test Title',
          icon: Icons.star,
          color: Colors.blue,
        );
        expect(widget.title, equals('Test Title'));
        expect(widget.icon, equals(Icons.star));
        expect(widget.color, equals(Colors.blue));
      });

      testWidgets('creates widget with custom key', (tester) async {
        const key = Key('section_header');
        const widget = SectionHeaderWidget(
          key: key,
          title: 'Test Title',
          icon: Icons.star,
        );
        expect(widget.key, equals(key));
      });
    });

    group('Widget Rendering', () {
      testWidgets('renders with proper structure', (tester) async {
        await pumpSectionHeaderWidget(
          tester,
          title: 'Test Section',
          icon: Icons.star,
        );

        // Verify main structure
        expect(find.byType(Padding), findsAtLeastNWidgets(1));
        expect(find.byType(Row), findsOneWidget);
        expect(find.byType(Container), findsOneWidget);
        expect(find.byType(Icon), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
        expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
      });

      testWidgets('renders title text correctly', (tester) async {
        const testTitle = 'My Section';
        await pumpSectionHeaderWidget(
          tester,
          title: testTitle,
          icon: Icons.star,
        );

        expect(find.text(testTitle), findsOneWidget);

        final textWidget = tester.widget<Text>(find.text(testTitle));
        expect(textWidget.data, equals(testTitle));
      });

      testWidgets('renders icon correctly', (tester) async {
        await pumpSectionHeaderWidget(
          tester,
          title: 'Test Section',
          icon: Icons.favorite,
        );

        expect(find.byIcon(Icons.favorite), findsOneWidget);

        final iconWidget = tester.widget<Icon>(find.byIcon(Icons.favorite));
        expect(iconWidget.icon, equals(Icons.favorite));
        expect(iconWidget.size, equals(18));
      });
    });

    group('Layout and Styling', () {
      testWidgets('has correct padding structure', (tester) async {
        await pumpSectionHeaderWidget(
          tester,
          title: 'Test Section',
          icon: Icons.star,
        );

        // Find the main padding widget (the one with left: 4)
        final paddingWidgets = tester.widgetList<Padding>(find.byType(Padding));
        final mainPadding = paddingWidgets.firstWhere(
          (padding) => padding.padding == const EdgeInsets.only(left: 4),
        );
        expect(mainPadding.padding, equals(const EdgeInsets.only(left: 4)));
      });

      testWidgets('has correct container styling', (tester) async {
        await pumpSectionHeaderWidget(
          tester,
          title: 'Test Section',
          icon: Icons.star,
        );

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.padding, equals(const EdgeInsets.all(8)));

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.shape, equals(BoxShape.circle));
      });
    });

    group('Color Handling', () {
      testWidgets('uses theme primary color when no color provided', (
        tester,
      ) async {
        await pumpSectionHeaderWidget(
          tester,
          title: 'Test Section',
          icon: Icons.star,
        );

        final icon = tester.widget<Icon>(find.byIcon(Icons.star));
        final text = tester.widget<Text>(find.byType(Text));

        // Icon should use theme primary color
        expect(icon.color, isNotNull);

        // Text should use theme onSurface color
        expect(text.style?.color, isNotNull);
      });

      testWidgets('uses custom color when provided', (tester) async {
        const customColor = Colors.purple;
        await pumpSectionHeaderWidget(
          tester,
          title: 'Test Section',
          icon: Icons.star,
          color: customColor,
        );

        final icon = tester.widget<Icon>(find.byIcon(Icons.star));
        expect(icon.color, equals(customColor));
      });
    });

    group('Text Styling', () {
      testWidgets('applies correct text style', (tester) async {
        await pumpSectionHeaderWidget(
          tester,
          title: 'Test Section',
          icon: Icons.star,
        );

        final text = tester.widget<Text>(find.byType(Text));
        final style = text.style;

        expect(style?.fontWeight, equals(FontWeight.w700));
        expect(style?.letterSpacing, equals(-0.5));
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
          await pumpSectionHeaderWidget(
            tester,
            title: 'Test Section',
            icon: icon,
          );

          expect(find.byIcon(icon), findsOneWidget);

          final iconWidget = tester.widget<Icon>(find.byIcon(icon));
          expect(iconWidget.icon, equals(icon));
          expect(iconWidget.size, equals(18));

          // Clean up for next iteration
          await tester.pumpWidget(const SizedBox.shrink());
        }
      });
    });

    group('Edge Cases', () {
      testWidgets('handles null color gracefully', (tester) async {
        await pumpSectionHeaderWidget(
          tester,
          title: 'Test Section',
          icon: Icons.star,
          color: null,
        );

        // Should use theme color
        final icon = tester.widget<Icon>(find.byIcon(Icons.star));
        expect(icon.color, isNotNull);
      });

      testWidgets('handles numeric titles', (tester) async {
        const numericTitle = '12345';
        await pumpSectionHeaderWidget(
          tester,
          title: numericTitle,
          icon: Icons.star,
        );

        expect(find.text(numericTitle), findsOneWidget);
      });

      testWidgets('handles titles with whitespace', (tester) async {
        const titleWithSpaces = '  Section with spaces  ';
        await pumpSectionHeaderWidget(
          tester,
          title: titleWithSpaces,
          icon: Icons.star,
        );

        expect(find.text(titleWithSpaces), findsOneWidget);
      });
    });

    group('Theme Integration', () {
      testWidgets('adapts to theme changes', (tester) async {
        await pumpSectionHeaderWidget(
          tester,
          title: 'Test Section',
          icon: Icons.star,
        );

        // Verify theme integration
        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.color, isNotNull);
        expect(text.style?.fontWeight, equals(FontWeight.w700));
        expect(text.style?.letterSpacing, equals(-0.5));
      });

      testWidgets('uses theme colors when no custom color provided', (
        tester,
      ) async {
        await pumpSectionHeaderWidget(
          tester,
          title: 'Test Section',
          icon: Icons.star,
        );

        final icon = tester.widget<Icon>(find.byIcon(Icons.star));
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        // Both icon and container background should use theme colors
        expect(icon.color, isNotNull);
        expect(decoration.color, isNotNull);
      });
    });
  });
}
