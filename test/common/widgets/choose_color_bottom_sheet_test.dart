import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/choose_color_bottom_sheet.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/widgets/color_selector_widget.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

import '../../test-utils/test_utils.dart';
import '../../features/sheet/utils/sheet_utils.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer.test();
  });

  Future<void> pumpChooseColorBottomSheet(
    WidgetTester tester, {
    required String sheetId,
  }) async {
    await tester.pumpMaterialWidgetWithProviderScope(
      container: container,
      child: ChooseColorBottomSheet(sheetId: sheetId),
    );
  }

  L10n getL10n(WidgetTester tester) {
    return WidgetTesterExtension.getL10n(
      tester,
      byType: ChooseColorBottomSheet,
    );
  }

  ThemeData getTheme(WidgetTester tester) {
    return WidgetTesterExtension.getTheme(
      tester,
      byType: ChooseColorBottomSheet,
    );
  }

  group('Choose Color Bottom Sheet Widget', () {
    group('UI Structure', () {
      testWidgets('displays all required widgets', (tester) async {
        final testSheet = getSheetByIndex(container);
        await pumpChooseColorBottomSheet(tester, sheetId: testSheet.id);

        // Verify MaxWidthWidget is used
        expect(find.byType(MaxWidthWidget), findsOneWidget);

        // Verify ColorSelectorWidget is displayed
        expect(find.byType(ColorSelectorWidget), findsOneWidget);

        // Verify save button is displayed
        expect(find.byType(ZoePrimaryButton), findsOneWidget);
        final l10n = getL10n(tester);
        expect(find.text(l10n.save), findsOneWidget);
      });

      testWidgets('has correct widget hierarchy', (tester) async {
        final testSheet = getSheetByIndex(container);
        await pumpChooseColorBottomSheet(tester, sheetId: testSheet.id);

        // Verify MaxWidthWidget contains Column
        final maxWidthWidget = tester.widget<MaxWidthWidget>(
          find.byType(MaxWidthWidget),
        );
        expect(maxWidthWidget.child, isA<Column>());

        // Verify Column structure
        expect(find.byType(Column), findsWidgets);

        // Verify SizedBox for spacing
        expect(find.byType(SizedBox), findsWidgets);
      });

      testWidgets('MaxWidthWidget has correct properties', (tester) async {
        final testSheet = getSheetByIndex(container);
        await pumpChooseColorBottomSheet(tester, sheetId: testSheet.id);

        final maxWidthWidget = tester.widget<MaxWidthWidget>(
          find.byType(MaxWidthWidget),
        );

        // Verify padding includes bottom insets
        expect(maxWidthWidget.padding?.left, equals(16));
        expect(maxWidthWidget.padding?.right, equals(16));
      });
    });

    group('Initialization', () {
      testWidgets('initializes with sheet theme color when available', (
        tester,
      ) async {
        final testColor = Colors.purple;
        final testSheet = getSheetByIndex(container).copyWith(
          theme: SheetTheme(primary: testColor, secondary: Colors.purple[100]!),
        );

        // Update the sheet in the provider
        container.read(sheetListProvider.notifier).state = [testSheet];

        await pumpChooseColorBottomSheet(tester, sheetId: testSheet.id);
        await tester.pump();

        // Verify ColorSelectorWidget has the sheet's theme color
        final colorSelector = tester.widget<ColorSelectorWidget>(
          find.byType(ColorSelectorWidget),
        );
        expect(colorSelector.selectedColor, equals(testColor));
      });

      testWidgets(
        'initializes with theme primary color when sheet has no theme',
        (tester) async {
          final testSheet = getSheetByIndex(container).copyWith(theme: null);

          // Update the sheet in the provider
          container.read(sheetListProvider.notifier).state = [testSheet];

          await pumpChooseColorBottomSheet(tester, sheetId: testSheet.id);
          await tester.pump();

          final theme = getTheme(tester);

          // Verify ColorSelectorWidget has the theme's primary color
          final colorSelector = tester.widget<ColorSelectorWidget>(
            find.byType(ColorSelectorWidget),
          );
          expect(
            colorSelector.selectedColor,
            equals(theme.colorScheme.primary),
          );
        },
      );
    });

    group('Interaction', () {
      testWidgets('updates selected color when user selects a new color', (
        tester,
      ) async {
        final testSheet = getSheetByIndex(container);
        await pumpChooseColorBottomSheet(tester, sheetId: testSheet.id);
        await tester.pump();

        final newColor = Colors.red;

        // Get the ColorSelectorWidget
        final colorSelector = tester.widget<ColorSelectorWidget>(
          find.byType(ColorSelectorWidget),
        );

        // Simulate color change
        colorSelector.onColorChanged(newColor);
        await tester.pump();

        // Verify the color was updated
        final updatedColorSelector = tester.widget<ColorSelectorWidget>(
          find.byType(ColorSelectorWidget),
        );
        expect(updatedColorSelector.selectedColor, equals(newColor));
      });

      testWidgets(
        'saves selected color to sheet theme when save button is tapped',
        (tester) async {
          final testSheet = getSheetByIndex(container);
          await pumpChooseColorBottomSheet(tester, sheetId: testSheet.id);
          await tester.pump();

          final newColor = Colors.green;

          // Get the ColorSelectorWidget and change color
          final colorSelector = tester.widget<ColorSelectorWidget>(
            find.byType(ColorSelectorWidget),
          );
          colorSelector.onColorChanged(newColor);
          await tester.pump();

          // Tap save button
          final saveButton = find.byType(ZoePrimaryButton);
          await tester.tap(saveButton);
          await tester.pump();

          // Verify sheet theme was updated
          final updatedSheet = container.read(sheetProvider(testSheet.id));
          expect(updatedSheet?.theme?.primary, equals(newColor));
        },
      );

      testWidgets('updates secondary color with alpha when saving', (
        tester,
      ) async {
        final testSheet = getSheetByIndex(container);
        await pumpChooseColorBottomSheet(tester, sheetId: testSheet.id);
        await tester.pump();

        final newColor = Colors.blue;

        // Get the ColorSelectorWidget and change color
        final colorSelector = tester.widget<ColorSelectorWidget>(
          find.byType(ColorSelectorWidget),
        );
        colorSelector.onColorChanged(newColor);
        await tester.pump();

        // Tap save button
        final saveButton = find.byType(ZoePrimaryButton);
        await tester.tap(saveButton);
        await tester.pumpAndSettle();

        // Verify secondary color was set with alpha
        final updatedSheet = container.read(sheetProvider(testSheet.id));
        final expectedSecondary = newColor.withValues(alpha: 0.2);
        expect(updatedSheet?.theme?.secondary, equals(expectedSecondary));
      });

      testWidgets('save button has correct properties', (tester) async {
        final testSheet = getSheetByIndex(container);
        await pumpChooseColorBottomSheet(tester, sheetId: testSheet.id);

        final saveButton = tester.widget<ZoePrimaryButton>(
          find.byType(ZoePrimaryButton),
        );

        final l10n = getL10n(tester);
        expect(saveButton.text, equals(l10n.save));
        expect(saveButton.onPressed, isNotNull);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles null sheet gracefully', (tester) async {
        const nonExistentSheetId = 'non-existent-sheet-id';

        await pumpChooseColorBottomSheet(tester, sheetId: nonExistentSheetId);
        await tester.pump();

        final theme = getTheme(tester);

        // Should fall back to theme primary color
        final colorSelector = tester.widget<ColorSelectorWidget>(
          find.byType(ColorSelectorWidget),
        );
        expect(colorSelector.selectedColor, equals(theme.colorScheme.primary));
      });

      testWidgets('handles sheet with null theme', (tester) async {
        final testSheet = getSheetByIndex(container).copyWith(theme: null);
        container.read(sheetListProvider.notifier).state = [testSheet];

        await pumpChooseColorBottomSheet(tester, sheetId: testSheet.id);
        await tester.pump();

        final theme = getTheme(tester);

        // Should fall back to theme primary color
        final colorSelector = tester.widget<ColorSelectorWidget>(
          find.byType(ColorSelectorWidget),
        );
        expect(colorSelector.selectedColor, equals(theme.colorScheme.primary));
      });
    });

    group('Button Color Changes', () {
      testWidgets(
        'button uses default colors when selected color matches theme primary',
        (tester) async {
          final testSheet = getSheetByIndex(container);
          await pumpChooseColorBottomSheet(tester, sheetId: testSheet.id);
          await tester.pump();

          final theme = getTheme(tester);
          final primaryColor = theme.colorScheme.primary;

          // Get the ColorSelectorWidget and select the theme primary color
          final colorSelector = tester.widget<ColorSelectorWidget>(
            find.byType(ColorSelectorWidget),
          );
          colorSelector.onColorChanged(primaryColor);
          await tester.pump();

          // Verify button has null primaryColor and secondaryColor
          final saveButton = tester.widget<ZoePrimaryButton>(
            find.byType(ZoePrimaryButton),
          );
          expect(saveButton.primaryColor, isNull);
          expect(saveButton.secondaryColor, isNull);
        },
      );

      testWidgets(
        'button uses selected color when different from theme primary',
        (tester) async {
          final testSheet = getSheetByIndex(container);
          await pumpChooseColorBottomSheet(tester, sheetId: testSheet.id);
          await tester.pump();

          final newColor = Colors.red;

          // Get the ColorSelectorWidget and change to a different color
          final colorSelector = tester.widget<ColorSelectorWidget>(
            find.byType(ColorSelectorWidget),
          );
          colorSelector.onColorChanged(newColor);
          await tester.pump();

          // Verify button uses the selected color
          final saveButton = tester.widget<ZoePrimaryButton>(
            find.byType(ZoePrimaryButton),
          );
          expect(saveButton.primaryColor, equals(newColor));
          expect(
            saveButton.secondaryColor,
            equals(newColor.withValues(alpha: 0.2)),
          );
        },
      );

      testWidgets('button color updates when color selection changes', (
        tester,
      ) async {
        final testSheet = getSheetByIndex(container);
        await pumpChooseColorBottomSheet(tester, sheetId: testSheet.id);
        await tester.pump();

        final theme = getTheme(tester);
        final primaryColor = theme.colorScheme.primary;

        // Get the ColorSelectorWidget
        final colorSelector = tester.widget<ColorSelectorWidget>(
          find.byType(ColorSelectorWidget),
        );

        // First, select a custom color
        final customColor = Colors.blue;
        colorSelector.onColorChanged(customColor);
        await tester.pump();

        // Verify button uses custom color
        var saveButton = tester.widget<ZoePrimaryButton>(
          find.byType(ZoePrimaryButton),
        );
        expect(saveButton.primaryColor, equals(customColor));
        expect(
          saveButton.secondaryColor,
          equals(customColor.withValues(alpha: 0.2)),
        );

        // Then, change back to theme primary color
        colorSelector.onColorChanged(primaryColor);
        await tester.pump();

        // Verify button now uses default colors
        saveButton = tester.widget<ZoePrimaryButton>(
          find.byType(ZoePrimaryButton),
        );
        expect(saveButton.primaryColor, isNull);
        expect(saveButton.secondaryColor, isNull);
      });

      testWidgets('button color reflects initial sheet theme color', (
        tester,
      ) async {
        final customColor = Colors.orange;
        final testSheet = getSheetByIndex(container).copyWith(
          theme: SheetTheme(
            primary: customColor,
            secondary: customColor.withValues(alpha: 0.2),
          ),
        );

        container.read(sheetListProvider.notifier).state = [testSheet];

        await pumpChooseColorBottomSheet(tester, sheetId: testSheet.id);
        await tester.pump();

        // Verify button initially uses the sheet's custom theme color
        final saveButton = tester.widget<ZoePrimaryButton>(
          find.byType(ZoePrimaryButton),
        );
        expect(saveButton.primaryColor, equals(customColor));
        expect(
          saveButton.secondaryColor,
          equals(customColor.withValues(alpha: 0.2)),
        );
      });
    });
  });
}
