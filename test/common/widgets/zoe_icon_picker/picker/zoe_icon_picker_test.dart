import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/models/zoe_icons.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/picker/zoe_icon_picker.dart';
import 'package:zoe/l10n/generated/l10n.dart';

import '../../../../test-utils/test_utils.dart';

void main() {
  late ProviderContainer container;
  const buttonText = 'Open Picker';

  setUp(() {
    container = ProviderContainer.test();
  });

  L10n getL10n(WidgetTester tester) {
    return L10n.of(tester.element(find.byType(ZoeIconPicker)));
  }

  // Helper function to create the widget under test
  Future<void> createWidgetUnderTest(
    WidgetTester tester, {
    Color? initialColor,
    ZoeIcon? initialIcon,
    Function(Color, ZoeIcon)? onIconSelection,
  }) async {
    await tester.pumpActionsWidget(
      container: container,
      buttonText: buttonText,
      onPressed: (context, ref) => ZoeIconPicker.show(
        context: context,
        selectedColor: initialColor,
        selectedIcon: initialIcon,
        onIconSelection: onIconSelection,
      ),
    );
  }

  Future<void> performSearch(WidgetTester tester, String searchValue) async {
    // Find the search bar and enter the search value
    final searchBar = find.byType(ZoeSearchBarWidget);
    expect(searchBar, findsOneWidget);

    // Enter the search value
    await tester.enterText(searchBar, searchValue);
    await tester.pump(const Duration(milliseconds: 100));
  }

  List<ZoeIcon> filterIcons(String searchValue) {
    // Filter the icons based on the search value
    return ZoeIcon.values.where((icon) {
      return icon.name.toLowerCase().contains(searchValue.toLowerCase());
    }).toList();
  }

  Future<void> openPicker(WidgetTester tester) async {
    await tester.tap(find.text(buttonText));
    await tester.pump(const Duration(milliseconds: 100));

    // Check if the bottom sheet is displayed
    expect(find.byType(ZoeIconPicker), findsOneWidget);
  }

  testWidgets('ZoeIconPicker displays initial color and icon correctly', (
    WidgetTester tester,
  ) async {
    await createWidgetUnderTest(
      tester,
      initialColor: Colors.red,
      initialIcon: ZoeIcon.car,
      onIconSelection: (color, icon) {},
    );
    // Tap the button to open the picker
    await openPicker(tester);

    // Find the icon preview by the key set in the Icon widget inside the _buildIconPreviewUI method
    final iconPreview = find.byKey(Key(ZoeIconPicker.iconPreviewKey));

    // Ensure that the icon preview exists
    expect(iconPreview, findsOneWidget);

    // Get the actual Icon widget and verify its properties
    final iconWidget = tester.widget<Icon>(iconPreview);

    // Check if the icon is correct (based on ActerIcon.car.data)
    expect(iconWidget.icon, equals(ZoeIcon.car.data));

    // Check if the icon color matches the selectedColor (red in this case)
    expect(iconWidget.color, equals(Colors.red));
  });

  testWidgets('Color selection updates the preview', (
    WidgetTester tester,
  ) async {
    // Prepare initial color and icon
    final initialColor = Colors.blue;
    final initialIcon = ZoeIcon.list;
    final newColor = Colors.grey;

    // Build the widget
    await createWidgetUnderTest(
      tester,
      initialColor: initialColor,
      initialIcon: initialIcon,
    );

    // Tap the button to open the picker
    await openPicker(tester);
    await tester.pump(const Duration(milliseconds: 100));

    // Test selecting a new color
    final colorPicker = find.byKey(Key('${ZoeIconPicker.colorPickerKey}-0'));
    expect(colorPicker, findsOneWidget);

    // Ensure the color picker is visible and tappable
    await tester.ensureVisible(colorPicker);
    await tester.pump(const Duration(milliseconds: 100));

    // Tap the color picker to select the color
    await tester.tap(colorPicker);
    await tester.pump(const Duration(milliseconds: 100));

    // Verify if the selected color has been updated in the preview
    final iconPreview = find.byKey(Key(ZoeIconPicker.iconPreviewKey));
    expect(iconPreview, findsOneWidget);

    // Get the actual Icon widget and verify its color
    final iconWidget = tester.widget<Icon>(iconPreview);
    expect(iconWidget.icon, equals(ZoeIcon.list.data));
    expect(iconWidget.color, equals(newColor));
  });

  testWidgets('Icon selection updates the preview', (
    WidgetTester tester,
  ) async {
    // Prepare initial color and icon
    final initialColor = Colors.blue;
    final initialIcon = ZoeIcon.list;
    final newIcon = ZoeIcon.pin;

    // Build the widget
    await createWidgetUnderTest(
      tester,
      initialColor: initialColor,
      initialIcon: initialIcon,
    );

    // Tap the button to open the picker
    await openPicker(tester);
    await tester.pump(const Duration(milliseconds: 100));

    final iconPicker = find.byKey(Key('${ZoeIconPicker.iconPickerKey}-1'));
    expect(iconPicker, findsOneWidget);

    // Ensure the color picker is visible and tappable
    await tester.ensureVisible(iconPicker);
    await tester.pump(const Duration(milliseconds: 100));

    // Tap the color picker to select the color
    await tester.tap(iconPicker);
    await tester.pump(const Duration(milliseconds: 100));

    // Verify if the selected color has been updated in the preview
    final iconPreview = find.byKey(Key(ZoeIconPicker.iconPreviewKey));
    expect(iconPreview, findsOneWidget);

    // Get the actual Icon widget and verify its color
    final iconWidget = tester.widget<Icon>(iconPreview);
    expect(iconWidget.icon, equals(newIcon.data));
  });

  testWidgets(
    'Action button triggers the onIconSelection callback with correct values',
    (WidgetTester tester) async {
      // Prepare icon and the callback
      final newIcon = ZoeIcon.pin;
      ZoeIcon? callbackIcon;

      // Build the widget
      await createWidgetUnderTest(
        tester,
        onIconSelection: (color, icon) => callbackIcon = icon,
      );

      // Tap the button to open the picker
      await openPicker(tester);
      await tester.pump(const Duration(milliseconds: 100));

      final iconPicker = find.byKey(Key('${ZoeIconPicker.iconPickerKey}-1'));
      expect(iconPicker, findsOneWidget);

      // Ensure the color picker is visible and tappable
      await tester.ensureVisible(iconPicker);
      await tester.pump(const Duration(milliseconds: 100));

      // Tap the color picker to select the color
      await tester.tap(iconPicker);
      await tester.pump(const Duration(milliseconds: 100));

      // Tap the action button to confirm the selection
      await tester.tap(find.byType(ZoePrimaryButton));
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that the callback icon is the new icon
      expect(callbackIcon, equals(newIcon));
    },
  );

  testWidgets('Search widget is displayed in icon picker', (
    WidgetTester tester,
  ) async {
    await createWidgetUnderTest(tester);

    // Tap the button to open the picker
    await openPicker(tester);

    // Check if the search widget is present
    expect(find.byType(ZoeSearchBarWidget), findsOneWidget);
  });

  testWidgets('Search shows correct icons for specific search term', (
    WidgetTester tester,
  ) async {
    await createWidgetUnderTest(tester, initialIcon: ZoeIcon.file);

    // Tap the button to open the picker
    await openPicker(tester);

    // Perform search for 'car'
    await performSearch(tester, 'car');

    // Find the expected icons that contain 'car' in their name
    final expectedIcons = filterIcons('car');

    // Verify that only matching icons are displayed
    expect(expectedIcons.isNotEmpty, true);

    // Verify that the file icon is displayed because it's the initial icon
    expect(find.byIcon(ZoeIcon.file.data), findsOneWidget);

    // Find the expected car icon because it's the search result
    for (final icon in expectedIcons) {
      expect(find.byIcon(icon.data), findsOneWidget);
    }
  });

  testWidgets('Search with no matching results shows empty list', (
    WidgetTester tester,
  ) async {
    await createWidgetUnderTest(tester);

    // Tap the button to open the picker
    await openPicker(tester);

    // Search for something that doesn't exist
    await performSearch(tester, 'nonexistenticon');

    // Verify that the no icons found message is displayed
    expect(find.text(getL10n(tester).noIconsFound), findsOneWidget);
  });

  testWidgets('Search with case insensitive', (WidgetTester tester) async {
    await createWidgetUnderTest(tester, initialIcon: ZoeIcon.list);

    // Tap the button to open the picker
    await openPicker(tester);

    // Perform search for 'CAR' with uppercase
    await performSearch(tester, 'CAR');

    // Find the expected icons that contain 'CAR' in their name
    final expectedIcons = filterIcons('CAR');

    // Verify that only matching icons are displayed
    expect(expectedIcons.isNotEmpty, true);

    // Find the expected list icon because it's initial icon
    expect(find.byIcon(ZoeIcon.list.data), findsOneWidget);

    // Find the expected car icon because it's the search result
    for (final icon in expectedIcons) {
      expect(find.byIcon(icon.data), findsOneWidget);
    }
  });
}
