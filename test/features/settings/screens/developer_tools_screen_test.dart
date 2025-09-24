import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/settings/screens/developer_tools_screen.dart';
import 'package:zoe/features/settings/widgets/setting_card_widget.dart';
import 'package:zoe/features/settings/widgets/setting_item_widget.dart';

import '../../../helpers/test_utils.dart';

void main() {
  Future<void> pumpDeveloperToolsScreen(WidgetTester tester) async {
    await tester.pumpMaterialWidget(child: const DeveloperToolsScreen());
    await tester.pumpAndSettle();
  }

  group('AppBar', () {
    testWidgets('displays correct title', (tester) async {
      await pumpDeveloperToolsScreen(tester);
      expect(find.text('Developer Tools'), findsOneWidget);
    });
  });

  group('System Testing Section', () {
    testWidgets('displays correct title and content', (tester) async {
      await pumpDeveloperToolsScreen(tester);

      // Find the System Testing card
      final systemTestingCard = find.ancestor(
        of: find.text('System Testing'),
        matching: find.byType(SettingCardWidget),
      );
      expect(systemTestingCard, findsOneWidget);

      // Verify Systems Check item
      expect(find.text('Systems Check'), findsOneWidget);
      expect(
        find.text('Comprehensive system diagnostics and testing'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.health_and_safety), findsOneWidget);
    });

    testWidgets('Systems Check has correct color', (tester) async {
      await pumpDeveloperToolsScreen(tester);

      final systemCheckItem = tester.widget<SettingItemWidget>(
        find.ancestor(
          of: find.text('Systems Check'),
          matching: find.byType(SettingItemWidget),
        ),
      );

      expect(systemCheckItem.iconColor, equals(const Color(0xFF10B981)));
    });
  });

  group('Client Management Section', () {
    testWidgets('displays correct title and content', (tester) async {
      await pumpDeveloperToolsScreen(tester);

      // Find the Client Management card
      final clientManagementCard = find.ancestor(
        of: find.text('Client Management'),
        matching: find.byType(SettingCardWidget),
      );
      expect(clientManagementCard, findsOneWidget);

      // Verify Reset Client item
      expect(find.text('Reset Client'), findsOneWidget);
      expect(
        find.text('Clear stored secrets and force client regeneration'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('Reset Client has correct colors', (tester) async {
      await pumpDeveloperToolsScreen(tester);

      // Check title color
      final clientManagementCard = tester.widget<SettingCardWidget>(
        find.ancestor(
          of: find.text('Client Management'),
          matching: find.byType(SettingCardWidget),
        ),
      );
      expect(clientManagementCard.titleColor, equals(const Color(0xFFEF4444)));

      // Check icon color
      final resetClientItem = tester.widget<SettingItemWidget>(
        find.ancestor(
          of: find.text('Reset Client'),
          matching: find.byType(SettingItemWidget),
        ),
      );
      expect(resetClientItem.iconColor, equals(const Color(0xFFEF4444)));
    });

    testWidgets('shows confirmation dialog when Reset Client is tapped', (
      tester,
    ) async {
      await pumpDeveloperToolsScreen(tester);

      // Tap Reset Client
      await tester.tap(find.text('Reset Client'));
      await tester.pumpAndSettle();

      // Verify dialog content
      expect(find.text('Reset Client'), findsNWidgets(2)); // Title and item
      expect(
        find.text(
          'This will clear all stored client secrets and force the app to generate a new client identity. '
          'You may need to re-authenticate with services.\n\n'
          'Are you sure you want to continue?',
        ),
        findsOneWidget,
      );

      // Verify dialog buttons
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Reset'), findsOneWidget);
    });

    testWidgets('closes dialog when Cancel is tapped', (tester) async {
      await pumpDeveloperToolsScreen(tester);

      // Open dialog
      await tester.tap(find.text('Reset Client'));
      await tester.pumpAndSettle();

      // Tap Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Verify dialog is closed
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('shows success message on reset', (tester) async {
      // Mock resetClient to succeed
      const channel = MethodChannel('zoe_native');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            if (call.method == 'resetClient') return null;
            return null;
          });

      await pumpDeveloperToolsScreen(tester);

      // Open dialog and tap Reset
      await tester.tap(find.text('Reset Client'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reset'));
      
      // Wait for the entire operation to complete
      await tester.pumpAndSettle();

      // Verify success message
      expect(find.text('Client reset successfully'), findsOneWidget);
      expect(
        (tester.widget<SnackBar>(find.byType(SnackBar))).backgroundColor,
        equals(const Color(0xFF10B981)),
      );
    });
  });
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpUntilFound(
    Finder finder, {
    Duration timeout = const Duration(seconds: 2),
  }) async {
    final endTime = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(endTime)) {
      await pump(const Duration(milliseconds: 50));
      if (any(finder)) return;
    }
    throw TestFailure('pumpUntilFound: Widget not found: $finder');
  }
}
