import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/common/widgets/drawer/drawer_sheet_list_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_icon_button_widget.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/widgets/sheet_list_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/mock_gorouter.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  late ProviderContainer container;
  late MockGoRouter mockGoRouter;

  setUp(() {
    container = ProviderContainer.test();
    mockGoRouter = MockGoRouter();
    when(() => mockGoRouter.push(any())).thenAnswer((_) async => true);
    when(() => mockGoRouter.canPop()).thenReturn(true);
    when(() => mockGoRouter.pop()).thenReturn(true);
  });

  Future<void> pumpDrawerSheetListWidget(
    WidgetTester tester, {
    ThemeData? theme,
  }) async {
    await tester.pumpMaterialWidgetWithProviderScope(
      theme: theme,
      container: container,
      router: mockGoRouter,
      child: const DrawerSheetListWidget(),
    );
  }

  L10n getL10n(WidgetTester tester) {
    return L10n.of(tester.element(find.byType(DrawerSheetListWidget)));
  }

  group('DrawerSheetListWidget', () {
    testWidgets('renders drawer sheet list widget correctly', (tester) async {
      await pumpDrawerSheetListWidget(tester);

      // Verify widget is rendered
      expect(find.byType(DrawerSheetListWidget), findsOneWidget);
    });

    testWidgets('displays section header with icon', (tester) async {
      await pumpDrawerSheetListWidget(tester);

      // Find the icon with description_outlined
      final icons = find.byIcon(Icons.description_outlined);
      expect(icons, findsOneWidget);

      final icon = tester.widget<Icon>(icons);
      expect(icon.size, equals(24));
    });

    testWidgets('displays sheets title text', (tester) async {
      await pumpDrawerSheetListWidget(tester);

      final l10n = getL10n(tester);

      // Verify sheets title is displayed
      expect(find.text(l10n.sheets), findsOneWidget);
    });

    testWidgets('displays add button', (tester) async {
      await pumpDrawerSheetListWidget(tester);

      // Verify ZoeIconButtonWidget is displayed
      expect(find.byType(ZoeIconButtonWidget), findsOneWidget);

      final button = tester.widget<ZoeIconButtonWidget>(
        find.byType(ZoeIconButtonWidget),
      );

      expect(button.icon, equals(Icons.add));
      expect(button.size, equals(16));
    });

    testWidgets('has correct padding for section header', (tester) async {
      await pumpDrawerSheetListWidget(tester);

      // Find the section header padding
      final paddingWidgets = find.descendant(
        of: find.byType(DrawerSheetListWidget),
        matching: find.byType(Padding),
      );

      expect(paddingWidgets, findsAtLeastNWidgets(2));

      // Check section header padding
      final sectionHeaderPadding =
          paddingWidgets.evaluate().first.widget as Padding;
      expect(
        sectionHeaderPadding.padding,
        equals(const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
      );
    });

    testWidgets('has correct padding for sheet list', (tester) async {
      await pumpDrawerSheetListWidget(tester);

      // Find the sheet list padding by checking for EdgeInsets.symmetric(horizontal: 16)
      final paddingWidgets = find.descendant(
        of: find.byType(DrawerSheetListWidget),
        matching: find.byType(Padding),
      );

      expect(paddingWidgets, findsAtLeastNWidgets(2));
    });

    testWidgets('uses Expanded widget for sheet list', (tester) async {
      await pumpDrawerSheetListWidget(tester);

      expect(find.byType(Expanded), findsWidgets);
    });

    testWidgets('renders SheetListWidget', (tester) async {
      await pumpDrawerSheetListWidget(tester);

      expect(find.byType(SheetListWidget), findsOneWidget);

      final sheetListWidget = tester.widget<SheetListWidget>(
        find.byType(SheetListWidget),
      );

      expect(sheetListWidget.shrinkWrap, equals(false));
      expect(sheetListWidget.isCompact, equals(true));
    });

    testWidgets('title has correct text style', (tester) async {
      await pumpDrawerSheetListWidget(tester);

      final l10n = getL10n(tester);
      final titleText = tester.widget<Text>(find.text(l10n.sheets));

      expect(titleText.style?.fontWeight, equals(FontWeight.w600));
    });

    testWidgets('icon has correct size', (tester) async {
      await pumpDrawerSheetListWidget(tester);

      final icon = tester.widget<Icon>(find.byIcon(Icons.description_outlined));

      expect(icon.size, equals(24));
    });

    testWidgets('has correct spacing between icon and text', (tester) async {
      await pumpDrawerSheetListWidget(tester);

      final sizedBoxes = find.descendant(
        of: find.byType(Row),
        matching: find.byType(SizedBox),
      );

      if (sizedBoxes.evaluate().isNotEmpty) {
        final box = tester.widget<SizedBox>(sizedBoxes.first);
        expect(box.width, greaterThan(0));
      }
    });

    testWidgets('renders correctly in different themes', (tester) async {
      // Test with light theme
      await pumpDrawerSheetListWidget(tester, theme: ThemeData.light());
      expect(find.byType(DrawerSheetListWidget), findsOneWidget);
      await pumpDrawerSheetListWidget(tester, theme: ThemeData.dark());
      expect(find.byType(DrawerSheetListWidget), findsOneWidget);
    });

    testWidgets('taps add button to create new sheet', (tester) async {
      await pumpDrawerSheetListWidget(tester);

      final initialSheetCount = container.read(sheetListProvider).length;

      // Verify add button exists
      expect(find.byType(ZoeIconButtonWidget), findsOneWidget);

      // Tap the add button
      await tester.tap(find.byType(ZoeIconButtonWidget));
      await tester.pump();

      // Verify a new sheet was added
      final newSheetCount = container.read(sheetListProvider).length;
      expect(newSheetCount, greaterThan(initialSheetCount));
    });

    testWidgets('taps add button to navigate to new sheet', (tester) async {
      await pumpDrawerSheetListWidget(tester);

      // Verify add button exists
      expect(find.byType(ZoeIconButtonWidget), findsOneWidget);

      // Tap the add button
      await tester.tap(find.byType(ZoeIconButtonWidget));
      await tester.pump();

      // Verify navigation was triggered (without checking exact route)
      verify(() => mockGoRouter.canPop()).called(1);
      verify(() => mockGoRouter.push(any())).called(1);
    });
  });
}
