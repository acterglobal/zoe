import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:zoe_native/zoe_native.dart';
import 'package:zoe_native/providers.dart';
import 'package:example/main.dart' as app;

/// Integration test for zoe_native plugin using a real Flutter app
///
/// This test runs the actual Flutter app and interacts with it to verify:
/// 1. The Rust library loads correctly
/// 2. Client creation works through Riverpod providers
/// 3. Group creation and management functions properly
/// 4. The UI updates correctly when groups are created
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Zoe Native Integration Tests', () {
    testWidgets('should run complete integration test flow', (
      WidgetTester tester,
    ) async {
      // Start the app (only once)
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Verify the app loaded with more flexible matching
      expect(find.text('Zoe Native Integration Test'), findsOneWidget);

      // Wait for initialization to complete
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Check if status shows initializing (it might have changed already)
      final statusFinder = find.textContaining('Status:');
      expect(statusFinder, findsOneWidget);

      // Test 1: Client creation
      await tester.tap(find.text('Test Client'));
      await tester.pumpAndSettle();

      // Wait for client creation with timeout
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      // Verify client was created successfully with more flexible matching
      expect(
        find.textContaining('Client created successfully'),
        findsOneWidget,
      );
      expect(find.text('Status: Client Ready'), findsOneWidget);

      // Test 2: Group creation
      await tester.tap(find.text('Create Group'));
      await tester.pumpAndSettle();

      // Wait for group creation with extended timeout
      await tester.pump(const Duration(seconds: 8));
      await tester.pumpAndSettle();

      // Verify group was created successfully
      expect(find.textContaining('Group created!'), findsOneWidget);
      expect(find.text('Status: Group Created'), findsOneWidget);

      // Note: The group may not be visible in providers immediately since we're offline
      // This is expected behavior - the test verifies the core functionality works

      // Test 3: Clear logs functionality
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      // Verify logs are cleared and status is updated
      expect(find.text('Status: Cleared'), findsOneWidget);
      expect(find.textContaining('Creating client'), findsNothing);
    });
  });
}

// b) Add the direct provider integration tests as requested

/// Direct provider integration tests that use Riverpod providers directly
/// without the Flutter UI layer
void directProviderTests() {
  group('Direct Provider Integration Tests', () {
    late Directory tempDir;
    late Directory tempCacheDir;
    late ProviderContainer container;

    setUpAll(() async {
      // Initialize RustLib for real usage (not mocked)
      await RustLib.init();

      // Create temporary directories for this test session
      tempDir = Directory.systemTemp.createTempSync('zoe_integration_test_');
      tempCacheDir = Directory.systemTemp.createTempSync(
        'zoe_integration_cache_',
      );
    });

    setUp(() async {
      // Create a fresh container for each test with overridden client builder
      container = ProviderContainer(
        overrides: [
          clientProvider.overrideWith((ref) async {
            final builder = await ClientBuilder.default_();
            await builder.dbStorageDir(path: tempDir.path);
            await builder.mediaStorageDir(mediaStorageDir: tempCacheDir.path);
            await builder.autoconnect(autoconnect: false); // Start offline
            return await builder.build();
          }),
        ],
      );
    });

    tearDown(() async {
      // Clean up the container
      container.dispose();
    });

    tearDownAll(() async {
      // Clean up temporary directories
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
      if (tempCacheDir.existsSync()) {
        tempCacheDir.deleteSync(recursive: true);
      }
    });

    test(
      'should create client through Riverpod interface using live Rust code',
      () async {
        // Act: Get client through Riverpod provider (this uses live Rust code)
        final client = await container.read(clientProvider.future);

        // Assert: Client should be created successfully
        expect(client, isNotNull);
        expect(client, isA<Client>());

        // Verify we can get basic client information
        final clientSecretHex = await client.clientSecretHex();
        expect(clientSecretHex, isNotEmpty);
        expect(
          clientSecretHex.length,
          greaterThan(10),
        ); // Should be a valid hex string

        final clientIdHex = await client.idHex();
        expect(clientIdHex, isNotEmpty);
        expect(
          clientIdHex.length,
          greaterThan(10),
        ); // Should be a valid hex string
      },
    );

    test(
      'should create group through client and verify it appears in providers',
      () async {
        // Arrange: Get client through Riverpod provider
        final client = await container.read(clientProvider.future);

        // Verify initially no groups exist
        final initialGroups = await container.read(allGroupIdsProvider.future);
        expect(initialGroups, isEmpty);

        // Act: Create a new group using the live Rust interface
        final groupBuilder = await CreateGroupBuilder.newInstance(
          title: 'Test Integration Group',
        );
        final groupId = await client.createGroup(createGroup: groupBuilder);

        // Assert: Group ID should be returned
        expect(groupId, isNotNull);

        // Wait a moment for the group to be processed and appear in providers
        await Future.delayed(const Duration(milliseconds: 100));

        // Refresh the providers to get updated data
        container.invalidate(allGroupIdsProvider);

        // Verify the group appears in the all groups provider
        final updatedGroups = await container.read(allGroupIdsProvider.future);
        expect(updatedGroups, isNotEmpty);
        expect(updatedGroups, contains(groupId));

        // Verify we can get the group through the group provider
        final groupSession = await container.read(
          groupProvider(groupId).future,
        );
        expect(groupSession, isNotNull);
        expect(groupSession.state.groupId, equals(groupId));

        // Verify the group name matches what we created
        final groupName = await container.read(
          groupNameProvider(groupId).future,
        );
        expect(groupName, equals('Test Integration Group'));

        // Verify we can get group settings
        final groupSettings = await container.read(
          groupSettingsProvider(groupId).future,
        );
        expect(groupSettings, isNotNull);
      },
    );

    test('should handle multiple groups correctly', () async {
      // Arrange: Get client through Riverpod provider
      final client = await container.read(clientProvider.future);

      // Act: Create multiple groups
      final group1Builder = await CreateGroupBuilder.newInstance(
        title: 'First Test Group',
      );
      final group1Id = await client.createGroup(createGroup: group1Builder);

      final group2Builder = await CreateGroupBuilder.newInstance(
        title: 'Second Test Group',
      );
      final group2Id = await client.createGroup(createGroup: group2Builder);

      // Wait for groups to be processed
      await Future.delayed(const Duration(milliseconds: 200));

      // Refresh providers
      container.invalidate(allGroupIdsProvider);

      // Assert: Both groups should appear in providers
      final allGroups = await container.read(allGroupIdsProvider.future);
      expect(allGroups.length, equals(2));
      expect(allGroups, containsAll([group1Id, group2Id]));

      // Verify both groups can be accessed individually
      final group1Session = await container.read(
        groupProvider(group1Id).future,
      );
      final group2Session = await container.read(
        groupProvider(group2Id).future,
      );

      expect(group1Session.state.name, equals('First Test Group'));
      expect(group2Session.state.name, equals('Second Test Group'));

      // Verify groups are sorted by name (alphabetically)
      final group1Name = await container.read(
        groupNameProvider(group1Id).future,
      );
      final group2Name = await container.read(
        groupNameProvider(group2Id).future,
      );

      expect(group1Name, equals('First Test Group'));
      expect(group2Name, equals('Second Test Group'));

      // Since groups are sorted alphabetically by name, 'First' should come before 'Second'
      final firstGroupInList = allGroups.first;
      final firstGroupName = await container.read(
        groupNameProvider(firstGroupInList).future,
      );
      expect(firstGroupName, equals('First Test Group'));
    });
  });
}
