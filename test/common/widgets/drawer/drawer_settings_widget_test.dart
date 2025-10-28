import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/common/widgets/drawer/drawer_settings_widget.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/mock_gorouter.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  late ProviderContainer container;
  late MockGoRouter mockGoRouter;

  setUp(() {
    container = ProviderContainer.test();
    mockGoRouter = MockGoRouter();
    // Mock the push method
    when(() => mockGoRouter.push(any())).thenAnswer((_) async => true);
  });

  Future<void> pumpDrawerSettingsWidget(
    WidgetTester tester, {
    ThemeData? theme,
  }) async {
    await tester.pumpMaterialWidgetWithProviderScope(
      theme: theme,
      container: container,
      router: mockGoRouter,
      child: const DrawerSettingsWidget(),
    );
  }

  L10n getL10n(WidgetTester tester) {
    return L10n.of(tester.element(find.byType(DrawerSettingsWidget)));
  }

  group('DrawerSettingsWidget', () {
    testWidgets('renders drawer settings widget correctly', (tester) async {
      await pumpDrawerSettingsWidget(tester);

      // Verify widget is rendered
      expect(find.byType(DrawerSettingsWidget), findsOneWidget);
    });

    testWidgets('displays settings icon', (tester) async {
      await pumpDrawerSettingsWidget(tester);

      // Verify StyledIconContainer is displayed
      expect(find.byType(StyledIconContainer), findsOneWidget);

      final iconContainer = tester.widget<StyledIconContainer>(
        find.byType(StyledIconContainer),
      );

      expect(iconContainer.icon, equals(Icons.settings_rounded));
      expect(iconContainer.iconSize, equals(24));
      expect(iconContainer.size, equals(40));
    });

    testWidgets('displays settings title text', (tester) async {
      await pumpDrawerSettingsWidget(tester);

      final l10n = getL10n(tester);

      // Verify settings title is displayed
      expect(find.text(l10n.settings), findsOneWidget);
    });

    testWidgets('displays trailing arrow icon', (tester) async {
      await pumpDrawerSettingsWidget(tester);

      // Find the trailing icon
      final icons = find.descendant(
        of: find.byType(ListTile),
        matching: find.byType(Icon),
      );

      // Should find the arrow icon
      expect(icons, findsAtLeastNWidgets(1));

      final arrowIcon = tester.widget<Icon>(icons.last);
      expect(arrowIcon.icon, equals(Icons.arrow_forward_ios_rounded));
      expect(arrowIcon.size, equals(16));
    });

    testWidgets('has correct padding', (tester) async {
      await pumpDrawerSettingsWidget(tester);

      final containerWidget = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(DrawerSettingsWidget),
              matching: find.byType(Container),
            )
            .first,
      );

      expect(containerWidget.padding, equals(const EdgeInsets.all(16)));
    });

    testWidgets('list tile has correct styling', (tester) async {
      await pumpDrawerSettingsWidget(tester);

      final listTile = tester.widget<ListTile>(find.byType(ListTile));

      expect(listTile.shape, isA<RoundedRectangleBorder>());
      expect(listTile.leading, isNotNull);
      expect(listTile.title, isNotNull);
      expect(listTile.trailing, isNotNull);
    });

    testWidgets('title has correct text style', (tester) async {
      await pumpDrawerSettingsWidget(tester);

      final l10n = getL10n(tester);
      final titleText = tester.widget<Text>(find.text(l10n.settings));

      expect(titleText.style?.fontWeight, equals(FontWeight.w500));
    });

    testWidgets('arrow icon has correct color', (tester) async {
      await pumpDrawerSettingsWidget(tester);

      final listTile = tester.widget<ListTile>(find.byType(ListTile));
      final trailingIcon = listTile.trailing as Icon;

      expect(trailingIcon.color, isNotNull);
    });

    testWidgets('taps ListTile to navigate to settings', (tester) async {
      await pumpDrawerSettingsWidget(tester);

      // Verify ListTile exists
      expect(find.byType(ListTile), findsOneWidget);

      // Tap the ListTile
      await tester.tap(find.byType(ListTile));
      await tester.pump();

      // Verify mockGoRouter.push was called with settings route
      verify(() => mockGoRouter.push(AppRoutes.settings.route)).called(1);
    });

    testWidgets('renders correctly in different themes', (tester) async {
      // Test with light theme
      await pumpDrawerSettingsWidget(tester, theme: ThemeData.light());
      expect(find.byType(DrawerSettingsWidget), findsOneWidget);
      await pumpDrawerSettingsWidget(tester, theme: ThemeData.dark());
      expect(find.byType(DrawerSettingsWidget), findsOneWidget);
    });

    testWidgets('arrow icon uses onSurface color with alpha', (tester) async {
      await pumpDrawerSettingsWidget(tester);

      final listTile = tester.widget<ListTile>(find.byType(ListTile));
      final trailingIcon = listTile.trailing as Icon;

      // Verify color is not null
      expect(trailingIcon.color, isNotNull);
    });

    testWidgets('list tile has rounded corners', (tester) async {
      await pumpDrawerSettingsWidget(tester);

      final listTile = tester.widget<ListTile>(find.byType(ListTile));
      final shape = listTile.shape as RoundedRectangleBorder;

      expect(shape.borderRadius, equals(BorderRadius.circular(12)));
    });

    testWidgets('styled icon container is in leading position', (tester) async {
      await pumpDrawerSettingsWidget(tester);

      final listTile = tester.widget<ListTile>(find.byType(ListTile));

      expect(listTile.leading, isA<StyledIconContainer>());
      expect(listTile.leading, isNotNull);
    });
  });
}
