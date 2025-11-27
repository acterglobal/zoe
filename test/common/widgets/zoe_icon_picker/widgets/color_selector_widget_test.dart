import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/models/color_data.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/widgets/color_selector_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../../test-utils/test_utils.dart';

void main() {
  Future<void> pumpColorSelectorWidget(
    WidgetTester tester, {
    required Color selectedColor,
    required ValueChanged<Color> onColorChanged,
  }) async {
    await tester.pumpMaterialWidget(
      child: ColorSelectorWidget(
        selectedColor: selectedColor,
        onColorChanged: onColorChanged,
        colors: iconPickerColors,
      ),
    );
  }

  L10n getL10n(WidgetTester tester) {
    return WidgetTesterExtension.getL10n(tester, byType: ColorSelectorWidget);
  }

  ThemeData getTheme(WidgetTester tester) {
    return WidgetTesterExtension.getTheme(tester, byType: ColorSelectorWidget);
  }

  group('Color Selector Widget', () {
    group('UI Structure', () {
      testWidgets('displays all required widgets', (tester) async {
        await pumpColorSelectorWidget(
          tester,
          selectedColor: Colors.grey,
          onColorChanged: (_) {},
        );

        // Verify title text is displayed
        final l10n = getL10n(tester);
        expect(find.text(l10n.selectColor), findsOneWidget);

        // Verify Text widget with correct style
        final textWidget = tester.widget<Text>(find.text(l10n.selectColor));
        final theme = getTheme(tester);
        expect(textWidget.style, equals(theme.textTheme.headlineSmall));

        // Verify Column structure
        expect(find.byType(Column), findsOneWidget);

        // Verify Wrap for color boxes
        expect(find.byType(Wrap), findsOneWidget);

        // Verify SizedBox for spacing
        expect(find.byType(SizedBox), findsWidgets);
      });

      testWidgets('displays all color options from iconPickerColors', (
        tester,
      ) async {
        await pumpColorSelectorWidget(
          tester,
          selectedColor: Colors.grey,
          onColorChanged: (_) {},
        );

        // Verify all color boxes are displayed
        for (int i = 0; i < iconPickerColors.length; i++) {
          expect(
            find.byKey(Key('${ColorSelectorWidget.colorPickerKey}-$i')),
            findsOneWidget,
          );
        }

        // Verify correct number of InkWell widgets
        expect(find.byType(InkWell), findsNWidgets(iconPickerColors.length));
      });

      testWidgets('has correct widget hierarchy', (tester) async {
        await pumpColorSelectorWidget(
          tester,
          selectedColor: Colors.grey,
          onColorChanged: (_) {},
        );

        // Verify Column contains Text and Wrap
        final column = tester.widget<Column>(find.byType(Column));
        expect(column.children.length, equals(3)); // Text, SizedBox, Wrap

        // Verify Wrap contains InkWell widgets
        final wrap = tester.widget<Wrap>(find.byType(Wrap));
        expect(wrap.children.length, equals(iconPickerColors.length));
      });
    });

    group('Color Selection', () {
      testWidgets('highlights selected color with border', (tester) async {
        final selectedColor = iconPickerColors[2]; // redAccent

        await pumpColorSelectorWidget(
          tester,
          selectedColor: selectedColor,
          onColorChanged: (_) {},
        );

        // Find the container for the selected color
        final selectedIndex = iconPickerColors.indexOf(selectedColor);
        final selectedInkWell = find.byKey(
          Key('${ColorSelectorWidget.colorPickerKey}-$selectedIndex'),
        );

        expect(selectedInkWell, findsOneWidget);

        // Verify the container has a border
        final container = tester.widget<Container>(
          find.descendant(
            of: selectedInkWell,
            matching: find.byType(Container),
          ),
        );

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.border, isNotNull);
        expect(decoration.border, isA<Border>());
      });

      testWidgets('non-selected colors do not have border', (tester) async {
        final selectedColor = iconPickerColors[0]; // grey

        await pumpColorSelectorWidget(
          tester,
          selectedColor: selectedColor,
          onColorChanged: (_) {},
        );

        // Check a non-selected color (index 1)
        final nonSelectedInkWell = find.byKey(
          Key('${ColorSelectorWidget.colorPickerKey}-1'),
        );

        final container = tester.widget<Container>(
          find.descendant(
            of: nonSelectedInkWell,
            matching: find.byType(Container),
          ),
        );

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.border, isNull);
      });

      testWidgets('displays correct background color for each option', (
        tester,
      ) async {
        await pumpColorSelectorWidget(
          tester,
          selectedColor: Colors.grey,
          onColorChanged: (_) {},
        );

        // Verify each color box has the correct background color
        for (int i = 0; i < iconPickerColors.length; i++) {
          final inkWell = find.byKey(
            Key('${ColorSelectorWidget.colorPickerKey}-$i'),
          );

          final container = tester.widget<Container>(
            find.descendant(of: inkWell, matching: find.byType(Container)),
          );

          final decoration = container.decoration as BoxDecoration;
          expect(decoration.color, equals(iconPickerColors[i]));
        }
      });
    });

    group('Interaction', () {
      testWidgets('calls onColorChanged when color is tapped', (tester) async {
        Color? changedColor;
        final initialColor = iconPickerColors[0];

        await pumpColorSelectorWidget(
          tester,
          selectedColor: initialColor,
          onColorChanged: (color) => changedColor = color,
        );

        // Tap on a different color (index 3)
        final colorToSelect = iconPickerColors[3];
        final inkWellToTap = find.byKey(
          Key('${ColorSelectorWidget.colorPickerKey}-3'),
        );

        await tester.tap(inkWellToTap);
        await tester.pump();

        // Verify onColorChanged was called with the correct color
        expect(changedColor, equals(colorToSelect));
      });

      testWidgets('calls onColorChanged for each color option', (tester) async {
        Color? changedColor;

        await pumpColorSelectorWidget(
          tester,
          selectedColor: iconPickerColors[0],
          onColorChanged: (color) => changedColor = color,
        );

        // Test tapping each color
        for (int i = 0; i < iconPickerColors.length; i++) {
          final inkWell = find.byKey(
            Key('${ColorSelectorWidget.colorPickerKey}-$i'),
          );

          await tester.tap(inkWell);
          await tester.pump();

          expect(changedColor, equals(iconPickerColors[i]));
        }
      });

      testWidgets('allows selecting the same color again', (tester) async {
        int callCount = 0;
        Color? changedColor;
        final selectedColor = iconPickerColors[2];

        await pumpColorSelectorWidget(
          tester,
          selectedColor: selectedColor,
          onColorChanged: (color) {
            changedColor = color;
            callCount++;
          },
        );

        // Tap the already selected color
        final inkWell = find.byKey(
          Key('${ColorSelectorWidget.colorPickerKey}-2'),
        );

        await tester.tap(inkWell);
        await tester.pump();

        // Verify callback was called
        expect(callCount, equals(1));
        expect(changedColor, equals(selectedColor));
      });
    });

    group('Widget Properties', () {
      testWidgets('color boxes have correct dimensions', (tester) async {
        await pumpColorSelectorWidget(
          tester,
          selectedColor: Colors.grey,
          onColorChanged: (_) {},
        );

        // Check first color box dimensions
        final container = tester.widget<Container>(
          find.descendant(
            of: find.byKey(Key('${ColorSelectorWidget.colorPickerKey}-0')),
            matching: find.byType(Container),
          ),
        );

        expect(container.constraints?.maxHeight, equals(40));
        expect(container.constraints?.maxWidth, equals(40));
      });

      testWidgets('color boxes have correct border radius', (tester) async {
        await pumpColorSelectorWidget(
          tester,
          selectedColor: Colors.grey,
          onColorChanged: (_) {},
        );

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byKey(Key('${ColorSelectorWidget.colorPickerKey}-0')),
            matching: find.byType(Container),
          ),
        );

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.borderRadius, equals(BorderRadius.circular(100)));
      });

      testWidgets('InkWell has correct border radius', (tester) async {
        await pumpColorSelectorWidget(
          tester,
          selectedColor: Colors.grey,
          onColorChanged: (_) {},
        );

        final inkWell = tester.widget<InkWell>(
          find.byKey(Key('${ColorSelectorWidget.colorPickerKey}-0')),
        );

        expect(inkWell.borderRadius, equals(BorderRadius.circular(100)));
      });

      testWidgets('selected color border has correct properties', (
        tester,
      ) async {
        final selectedColor = iconPickerColors[1];

        await pumpColorSelectorWidget(
          tester,
          selectedColor: selectedColor,
          onColorChanged: (_) {},
        );

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byKey(Key('${ColorSelectorWidget.colorPickerKey}-1')),
            matching: find.byType(Container),
          ),
        );

        final decoration = container.decoration as BoxDecoration;
        final border = decoration.border as Border;

        // Verify border color and width
        expect(border.top.color, equals(Colors.white));
        expect(border.top.width, equals(1));
      });
    });

    group('Edge Cases', () {
      testWidgets('handles color not in iconPickerColors list', (tester) async {
        final customColor = const Color(0xFF123456);

        await pumpColorSelectorWidget(
          tester,
          selectedColor: customColor,
          onColorChanged: (_) {},
        );

        // Should still display all colors without error
        expect(find.byType(InkWell), findsNWidgets(iconPickerColors.length));

        // No color should have a border since selected color is not in the list
        for (int i = 0; i < iconPickerColors.length; i++) {
          final container = tester.widget<Container>(
            find.descendant(
              of: find.byKey(Key('${ColorSelectorWidget.colorPickerKey}-$i')),
              matching: find.byType(Container),
            ),
          );

          final decoration = container.decoration as BoxDecoration;
          expect(decoration.border, isNull);
        }
      });

      testWidgets('updates selection when selectedColor prop changes', (
        tester,
      ) async {
        final initialColor = iconPickerColors[0];

        await pumpColorSelectorWidget(
          tester,
          selectedColor: initialColor,
          onColorChanged: (_) {},
        );

        // Verify initial selection
        var container = tester.widget<Container>(
          find.descendant(
            of: find.byKey(Key('${ColorSelectorWidget.colorPickerKey}-0')),
            matching: find.byType(Container),
          ),
        );
        var decoration = container.decoration as BoxDecoration;
        expect(decoration.border, isNotNull);

        // Update with new selected color
        final newColor = iconPickerColors[4];
        await pumpColorSelectorWidget(
          tester,
          selectedColor: newColor,
          onColorChanged: (_) {},
        );

        // Verify new selection
        container = tester.widget<Container>(
          find.descendant(
            of: find.byKey(Key('${ColorSelectorWidget.colorPickerKey}-4')),
            matching: find.byType(Container),
          ),
        );
        decoration = container.decoration as BoxDecoration;
        expect(decoration.border, isNotNull);

        // Verify old selection no longer has border
        container = tester.widget<Container>(
          find.descendant(
            of: find.byKey(Key('${ColorSelectorWidget.colorPickerKey}-0')),
            matching: find.byType(Container),
          ),
        );
        decoration = container.decoration as BoxDecoration;
        expect(decoration.border, isNull);
      });
    });
  });
}
