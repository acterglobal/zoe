import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/drawer/drawer_header_widget.dart';
import 'package:zoe/common/widgets/drawer/drawer_sheet_list_widget.dart';
import 'package:zoe/common/widgets/drawer/drawer_settings_widget.dart';
import 'package:zoe/common/widgets/drawer/hamburger_drawer_widget.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import '../../../features/sheet/mocks/sheet_mocks.dart';
import '../../../test-utils/mock_gorouter.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  late ProviderContainer container;
  late MockGoRouter mockGoRouter;

  setUp(() {
    container = ProviderContainer.test(
      overrides: [sheetListProvider.overrideWith(() => MockSheetList())],
    );
    mockGoRouter = MockGoRouter();
  });

  Future<void> pumpHamburgerDrawerWidget(
    WidgetTester tester, {
    ThemeData? theme,
  }) async {
    await tester.pumpMaterialWidgetWithProviderScope(
      container: container,
      router: mockGoRouter,
      theme: theme,
      child: const HamburgerDrawerWidget(),
    );
  }

  group('HamburgerDrawerWidget', () {
    testWidgets('renders hamburger drawer widget correctly', (tester) async {
      await pumpHamburgerDrawerWidget(tester);

      // Verify drawer is present in the widget tree
      expect(find.byType(HamburgerDrawerWidget), findsOneWidget);
    });

    testWidgets('renders Drawer widget', (tester) async {
      await pumpHamburgerDrawerWidget(tester);

      // Verify Drawer is present in the widget tree
      expect(find.byType(Drawer), findsOneWidget);
    });

    testWidgets('renders child widgets correctly', (tester) async {
      await pumpHamburgerDrawerWidget(tester);

      // Verify all child widgets are present
      expect(find.byType(DrawerHeaderWidget), findsOneWidget);
      expect(find.byType(DrawerSheetListWidget), findsOneWidget);
      expect(find.byType(DrawerSettingsWidget), findsOneWidget);
    });

    testWidgets('has two divider elements', (tester) async {
      await pumpHamburgerDrawerWidget(tester);

      // Verify Divider elements are present
      expect(find.byType(Divider), findsNWidgets(2));
    });

    testWidgets('renders SafeArea and Column', (tester) async {
      await pumpHamburgerDrawerWidget(tester);

      // Verify SafeArea and Column are present
      expect(find.byType(SafeArea), findsAtLeastNWidgets(1));
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('uses Expanded for drawer content', (tester) async {
      await pumpHamburgerDrawerWidget(tester);

      // Verify Expanded widgets are present within the drawer
      expect(find.byType(Expanded), findsWidgets);
    });

    testWidgets('renders correctly in different themes', (tester) async {
      // Test with light theme
      await pumpHamburgerDrawerWidget(tester, theme: ThemeData.light());
      expect(find.byType(HamburgerDrawerWidget), findsOneWidget);

      // Test with dark theme
      await pumpHamburgerDrawerWidget(tester, theme: ThemeData.dark());
      expect(find.byType(HamburgerDrawerWidget), findsOneWidget);
    });
  });
}
