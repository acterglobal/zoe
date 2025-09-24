import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/providers/package_info_provider.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/settings/screens/settings_screen.dart';
import 'package:zoe/features/settings/widgets/setting_item_widget.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        currentUserProvider.overrideWith(
          (ref) => null,
        ),
        appNameProvider.overrideWith((ref) => 'Test App'),
        appVersionProvider.overrideWith((ref) => '1.0.0'),
        buildNumberProvider.overrideWith((ref) => '100'),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  Future<void> pumpSettingsScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        parent: container,
        child: MaterialApp(
          localizationsDelegates: const [
            L10n.delegate,
          ],
          home: const SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('displays app bar with correct title', (tester) async {
    await pumpSettingsScreen(tester);
    expect(find.byType(AppBar), findsOneWidget);
  });

  group('Profile Section', () {
    testWidgets('displays guest name when user is null', (tester) async {
      await pumpSettingsScreen(tester);
      expect(find.text('Guest'), findsOneWidget);
      expect(find.text(''), findsOneWidget); // Empty bio when user is null
    });

    testWidgets('displays user information when user is not null', (tester) async {
      // Override the container with a mock user
      container = ProviderContainer(
        overrides: [
          currentUserProvider.overrideWith(
            (ref) => Future<UserModel?>.value(UserModel(
              id: 'test-user-id',
              name: 'John Doe',
              bio: 'Test Bio',
            )),
          ),
          appNameProvider.overrideWith((ref) => 'Test App'),
          appVersionProvider.overrideWith((ref) => '1.0.0'),
          buildNumberProvider.overrideWith((ref) => '100'),
        ],
      );
      
      await pumpSettingsScreen(tester);
      
      // Verify user name and bio are displayed
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Test Bio'), findsOneWidget);
      expect(find.text('Guest'), findsNothing);
    });

    testWidgets('shows profile section with correct icon and color', (tester) async {
      await pumpSettingsScreen(tester);
      final iconWidget = tester.widget<SettingItemWidget>(
        find.ancestor(
          of: find.byIcon(Icons.person_rounded),
          matching: find.byType(SettingItemWidget),
        ),
      );
      expect(iconWidget.iconColor, equals(AppColors.brightMagentaColor));
    });
  });

  group('Appearance Section', () {
    testWidgets('displays theme section with correct icon', (tester) async {
      await pumpSettingsScreen(tester);
      expect(find.byIcon(Icons.palette_outlined), findsOneWidget);
    });
  });

  group('Language Section', () {
    testWidgets('displays language section with correct icon', (tester) async {
      await pumpSettingsScreen(tester);
      expect(find.byIcon(Icons.language_rounded), findsOneWidget);
    });
  });

  group('App Section', () {
    testWidgets('displays all app section items', (tester) async {
      await pumpSettingsScreen(tester);
      expect(find.byIcon(Icons.share_rounded), findsOneWidget);
      expect(find.byIcon(Icons.star_rounded), findsOneWidget);
      expect(find.byIcon(Icons.mail_outline_rounded), findsOneWidget);
    });

    testWidgets('shows dividers between items', (tester) async {
      await pumpSettingsScreen(tester);
      expect(find.byType(Divider), findsNWidgets(kDebugMode ? 5 : 4));
    });
  });

  group('About Section', () {
    testWidgets('displays app information', (tester) async {
      await pumpSettingsScreen(tester);
      expect(find.text('Test App'), findsOneWidget);
      expect(find.text('1.0.0'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
    });

    testWidgets('shows developer tools in debug mode', (tester) async {
      await pumpSettingsScreen(tester);
      if (kDebugMode) {
        expect(find.text('Developer Tools'), findsOneWidget);
        expect(find.byIcon(Icons.developer_mode), findsOneWidget);
      } else {
        expect(find.text('Developer Tools'), findsNothing);
        expect(find.byIcon(Icons.developer_mode), findsNothing);
      }
    });
  });
}