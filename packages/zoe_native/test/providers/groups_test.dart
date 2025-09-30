import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:zoe_native/src/providers/groups.dart';
import 'package:zoe_native/src/providers/client.dart';
import 'package:zoe_native/src/rust/third_party/zoe_client/client.dart';
import 'package:zoe_native/src/rust/third_party/zoe_state_machine/group.dart';
import 'package:zoe_native/src/rust/third_party/zoe_state_machine/state.dart';
import 'package:zoe_native/src/rust/third_party/zoe_app_primitives/group/states.dart';
import 'package:zoe_native/src/rust/third_party/zoe_app_primitives/group/events/settings.dart';
import 'package:zoe_native/src/rust/third_party/zoe_app_primitives/metadata.dart';
import 'package:zoe_native/src/rust/third_party/zoe_app_primitives/file/image.dart';
import 'package:zoe_native/src/rust/third_party/zoe_wire_protocol/primitives.dart';
import 'package:zoe_native/src/rust/third_party/zoe_wire_protocol/crypto.dart';
import 'package:zoe_native/zoe_native.dart';

// Mock classes
class MockClient extends Mock implements Client {}

class MockGroupManager extends Mock implements GroupManager {}

class MockGroupSession extends Mock implements GroupSession {}

class MockGroupState extends Mock implements GroupState {}

class MockGroupSettings extends Mock implements GroupSettings {}

class MockImage extends Mock implements Image {}

class MockEncryptionKey extends Mock implements EncryptionKey {}

class MockMessageId extends Mock implements MessageId {}

class MockRustLibApi extends Mock implements RustLibApi {}

// Fake classes for fallback values
class FakeMessageId extends Fake implements MessageId {}

class FakeGroupSession extends Fake implements GroupSession {}

class FakeGroupState extends Fake implements GroupState {}

class FakeGroupSettings extends Fake implements GroupSettings {}

class FakeEncryptionKey extends Fake implements EncryptionKey {}

class FakeGroupManager extends Fake implements GroupManager {}

void main() {
  late MockClient mockClient;
  late MockGroupManager mockGroupManager;
  late MockRustLibApi mockApi;

  setUpAll(() {
    // Register fallback values for mocktail first
    registerFallbackValue(FakeMessageId());
    registerFallbackValue(FakeGroupSession());
    registerFallbackValue(FakeGroupState());
    registerFallbackValue(FakeGroupSettings());
    registerFallbackValue(FakeEncryptionKey());
    registerFallbackValue(FakeGroupManager());

    // Initialize mock RustLib to prevent initialization errors
    mockApi = MockRustLibApi();

    // Mock the groupUpdatesStream API call to return an empty stream
    when(
      () => mockApi.crateApiGroupGroupUpdatesStream(
        manager: any(named: 'manager'),
      ),
    ).thenAnswer((_) => Stream<GroupDataUpdate>.empty());

    RustLib.initMock(api: mockApi);
  });

  setUp(() {
    mockClient = MockClient();
    mockGroupManager = MockGroupManager();

    // Mock the client to return our mock group manager
    when(
      () => mockClient.groupManager(),
    ).thenAnswer((_) async => mockGroupManager);
  });

  /// Helper function to create a provider container with mocked client
  ProviderContainer createTestContainer() {
    return ProviderContainer(
      overrides: [clientProvider.overrideWith((ref) async => mockClient)],
    );
  }

  group('GroupManagerProvider', () {
    test('should return GroupManager from client', () async {
      final container = createTestContainer();

      final groupManager = await container.read(groupManagerProvider.future);

      expect(groupManager, equals(mockGroupManager));
      verify(() => mockClient.groupManager()).called(1);

      container.dispose();
    });

    test('should cache GroupManager instance', () async {
      final container = createTestContainer();

      // Read the provider twice
      final groupManager1 = await container.read(groupManagerProvider.future);
      final groupManager2 = await container.read(groupManagerProvider.future);

      expect(groupManager1, equals(groupManager2));
      // Should only call groupManager() once due to caching
      verify(() => mockClient.groupManager()).called(1);

      container.dispose();
    });
  });

  group('AllGroupIdsProvider', () {
    test('should return empty list when no groups exist', () async {
      when(
        () => mockGroupManager.allGroupSessions(),
      ).thenAnswer((_) async => <MessageId, GroupSession>{});

      final container = createTestContainer();

      final groupIds = await container.read(allGroupIdsProvider.future);

      expect(groupIds, isEmpty);

      container.dispose();
    });

    test('should handle groups with proper sorting', () async {
      // Create mock objects
      final mockId1 = MockMessageId();
      final mockId2 = MockMessageId();
      final mockId3 = MockMessageId();

      final mockSession1 = MockGroupSession();
      final mockState1 = MockGroupState();
      final mockSession2 = MockGroupSession();
      final mockState2 = MockGroupState();
      final mockSession3 = MockGroupSession();
      final mockState3 = MockGroupState();

      // Set up the mock states
      when(() => mockState1.name).thenReturn('Zebra Group');
      when(() => mockState1.groupId).thenReturn(mockId1);
      when(() => mockState1.metadata).thenReturn(<Metadata>[]);
      when(() => mockState1.settings).thenReturn(MockGroupSettings());
      when(() => mockSession1.state).thenReturn(mockState1);
      when(() => mockSession1.currentKey).thenReturn(MockEncryptionKey());
      when(() => mockSession1.previousKeys).thenReturn(<EncryptionKey>[]);

      when(() => mockState2.name).thenReturn('Alpha Group');
      when(() => mockState2.groupId).thenReturn(mockId2);
      when(() => mockState2.metadata).thenReturn(<Metadata>[]);
      when(() => mockState2.settings).thenReturn(MockGroupSettings());
      when(() => mockSession2.state).thenReturn(mockState2);
      when(() => mockSession2.currentKey).thenReturn(MockEncryptionKey());
      when(() => mockSession2.previousKeys).thenReturn(<EncryptionKey>[]);

      when(() => mockState3.name).thenReturn('Beta Group');
      when(() => mockState3.groupId).thenReturn(mockId3);
      when(() => mockState3.metadata).thenReturn(<Metadata>[]);
      when(() => mockState3.settings).thenReturn(MockGroupSettings());
      when(() => mockSession3.state).thenReturn(mockState3);
      when(() => mockSession3.currentKey).thenReturn(MockEncryptionKey());
      when(() => mockSession3.previousKeys).thenReturn(<EncryptionKey>[]);

      when(() => mockGroupManager.allGroupSessions()).thenAnswer(
        (_) async => <MessageId, GroupSession>{
          mockId1: mockSession1,
          mockId2: mockSession2,
          mockId3: mockSession3,
        },
      );

      final container = createTestContainer();

      final groupIds = await container.read(allGroupIdsProvider.future);

      // Should be sorted by name: Alpha, Beta, Zebra
      expect(groupIds.length, equals(3));
      expect(groupIds[0], equals(mockId2)); // Alpha Group
      expect(groupIds[1], equals(mockId3)); // Beta Group
      expect(groupIds[2], equals(mockId1)); // Zebra Group

      container.dispose();
    });
  });

  group('GroupProvider', () {
    test('should return group session for existing group', () async {
      final mockId = MockMessageId();
      final mockSession = MockGroupSession();
      final mockState = MockGroupState();

      when(() => mockState.name).thenReturn('Test Group');
      when(() => mockState.groupId).thenReturn(mockId);
      when(() => mockState.metadata).thenReturn(<Metadata>[]);
      when(() => mockState.settings).thenReturn(MockGroupSettings());
      when(() => mockSession.state).thenReturn(mockState);
      when(() => mockSession.currentKey).thenReturn(MockEncryptionKey());
      when(() => mockSession.previousKeys).thenReturn(<EncryptionKey>[]);

      when(
        () => mockGroupManager.allGroupSessions(),
      ).thenAnswer((_) async => <MessageId, GroupSession>{mockId: mockSession});

      final container = createTestContainer();

      final group = await container.read(groupProvider(mockId).future);

      expect(group, equals(mockSession));

      container.dispose();
    });

    test(
      'should throw GroupNotFoundException for non-existent group',
      () async {
        final mockId = MockMessageId();

        when(
          () => mockGroupManager.allGroupSessions(),
        ).thenAnswer((_) async => <MessageId, GroupSession>{});

        final container = createTestContainer();

        try {
          await container.read(groupProvider(mockId).future);
          fail('Expected GroupNotFoundException to be thrown');
        } catch (e) {
          expect(e, isA<GroupNotFoundException>());
        } finally {
          container.dispose();
        }
      },
    );
  });

  group('GroupNameProvider', () {
    test('should return group name', () async {
      final mockId = MockMessageId();
      final mockSession = MockGroupSession();
      final mockState = MockGroupState();

      when(() => mockState.name).thenReturn('My Test Group');
      when(() => mockState.groupId).thenReturn(mockId);
      when(() => mockState.metadata).thenReturn(<Metadata>[]);
      when(() => mockState.settings).thenReturn(MockGroupSettings());
      when(() => mockSession.state).thenReturn(mockState);
      when(() => mockSession.currentKey).thenReturn(MockEncryptionKey());
      when(() => mockSession.previousKeys).thenReturn(<EncryptionKey>[]);

      when(
        () => mockGroupManager.allGroupSessions(),
      ).thenAnswer((_) async => <MessageId, GroupSession>{mockId: mockSession});

      final container = createTestContainer();

      final groupName = await container.read(groupNameProvider(mockId).future);

      expect(groupName, equals('My Test Group'));

      container.dispose();
    });
  });

  group('GroupDescriptionProvider', () {
    test('should return group description from metadata', () async {
      final mockId = MockMessageId();
      final mockSession = MockGroupSession();
      final mockState = MockGroupState();
      final descriptionMetadata = Metadata.description(
        'This is a test group description',
      );

      when(() => mockState.name).thenReturn('Test Group');
      when(() => mockState.groupId).thenReturn(mockId);
      when(() => mockState.metadata).thenReturn([descriptionMetadata]);
      when(() => mockState.settings).thenReturn(MockGroupSettings());
      when(() => mockSession.state).thenReturn(mockState);
      when(() => mockSession.currentKey).thenReturn(MockEncryptionKey());
      when(() => mockSession.previousKeys).thenReturn(<EncryptionKey>[]);

      when(
        () => mockGroupManager.allGroupSessions(),
      ).thenAnswer((_) async => <MessageId, GroupSession>{mockId: mockSession});

      final container = createTestContainer();

      final description = await container.read(
        groupDescriptionProvider(mockId).future,
      );

      expect(description, equals('This is a test group description'));

      container.dispose();
    });

    test('should return null when no description metadata exists', () async {
      final mockId = MockMessageId();
      final mockSession = MockGroupSession();
      final mockState = MockGroupState();

      when(() => mockState.name).thenReturn('Test Group');
      when(() => mockState.groupId).thenReturn(mockId);
      when(() => mockState.metadata).thenReturn(<Metadata>[]); // No metadata
      when(() => mockState.settings).thenReturn(MockGroupSettings());
      when(() => mockSession.state).thenReturn(mockState);
      when(() => mockSession.currentKey).thenReturn(MockEncryptionKey());
      when(() => mockSession.previousKeys).thenReturn(<EncryptionKey>[]);

      when(
        () => mockGroupManager.allGroupSessions(),
      ).thenAnswer((_) async => <MessageId, GroupSession>{mockId: mockSession});

      final container = createTestContainer();

      final description = await container.read(
        groupDescriptionProvider(mockId).future,
      );

      expect(description, isNull);

      container.dispose();
    });
  });

  group('GroupAvatarProvider', () {
    test('should return group avatar from metadata', () async {
      final mockId = MockMessageId();
      final mockSession = MockGroupSession();
      final mockState = MockGroupState();
      final mockImage = MockImage();
      final avatarMetadata = Metadata.avatar(mockImage);

      when(() => mockState.name).thenReturn('Test Group');
      when(() => mockState.groupId).thenReturn(mockId);
      when(() => mockState.metadata).thenReturn([avatarMetadata]);
      when(() => mockState.settings).thenReturn(MockGroupSettings());
      when(() => mockSession.state).thenReturn(mockState);
      when(() => mockSession.currentKey).thenReturn(MockEncryptionKey());
      when(() => mockSession.previousKeys).thenReturn(<EncryptionKey>[]);

      when(
        () => mockGroupManager.allGroupSessions(),
      ).thenAnswer((_) async => <MessageId, GroupSession>{mockId: mockSession});

      final container = createTestContainer();

      final avatar = await container.read(groupAvatarProvider(mockId).future);

      expect(avatar, equals(mockImage));

      container.dispose();
    });

    test('should return null when no avatar metadata exists', () async {
      final mockId = MockMessageId();
      final mockSession = MockGroupSession();
      final mockState = MockGroupState();

      when(() => mockState.name).thenReturn('Test Group');
      when(() => mockState.groupId).thenReturn(mockId);
      when(() => mockState.metadata).thenReturn(<Metadata>[]); // No metadata
      when(() => mockState.settings).thenReturn(MockGroupSettings());
      when(() => mockSession.state).thenReturn(mockState);
      when(() => mockSession.currentKey).thenReturn(MockEncryptionKey());
      when(() => mockSession.previousKeys).thenReturn(<EncryptionKey>[]);

      when(
        () => mockGroupManager.allGroupSessions(),
      ).thenAnswer((_) async => <MessageId, GroupSession>{mockId: mockSession});

      final container = createTestContainer();

      final avatar = await container.read(groupAvatarProvider(mockId).future);

      expect(avatar, isNull);

      container.dispose();
    });
  });

  group('GroupBackgroundProvider', () {
    test('should return group background from metadata', () async {
      final mockId = MockMessageId();
      final mockSession = MockGroupSession();
      final mockState = MockGroupState();
      final mockImage = MockImage();
      final backgroundMetadata = Metadata.background(mockImage);

      when(() => mockState.name).thenReturn('Test Group');
      when(() => mockState.groupId).thenReturn(mockId);
      when(() => mockState.metadata).thenReturn([backgroundMetadata]);
      when(() => mockState.settings).thenReturn(MockGroupSettings());
      when(() => mockSession.state).thenReturn(mockState);
      when(() => mockSession.currentKey).thenReturn(MockEncryptionKey());
      when(() => mockSession.previousKeys).thenReturn(<EncryptionKey>[]);

      when(
        () => mockGroupManager.allGroupSessions(),
      ).thenAnswer((_) async => <MessageId, GroupSession>{mockId: mockSession});

      final container = createTestContainer();

      final background = await container.read(
        groupBackgroundProvider(mockId).future,
      );

      expect(background, equals(mockImage));

      container.dispose();
    });

    test('should return null when no background metadata exists', () async {
      final mockId = MockMessageId();
      final mockSession = MockGroupSession();
      final mockState = MockGroupState();

      when(() => mockState.name).thenReturn('Test Group');
      when(() => mockState.groupId).thenReturn(mockId);
      when(() => mockState.metadata).thenReturn(<Metadata>[]); // No metadata
      when(() => mockState.settings).thenReturn(MockGroupSettings());
      when(() => mockSession.state).thenReturn(mockState);
      when(() => mockSession.currentKey).thenReturn(MockEncryptionKey());
      when(() => mockSession.previousKeys).thenReturn(<EncryptionKey>[]);

      when(
        () => mockGroupManager.allGroupSessions(),
      ).thenAnswer((_) async => <MessageId, GroupSession>{mockId: mockSession});

      final container = createTestContainer();

      final background = await container.read(
        groupBackgroundProvider(mockId).future,
      );

      expect(background, isNull);

      container.dispose();
    });
  });

  group('GroupSettingsProvider', () {
    test('should return group settings', () async {
      final mockId = MockMessageId();
      final mockSession = MockGroupSession();
      final mockState = MockGroupState();
      final mockSettings = MockGroupSettings();

      when(() => mockState.name).thenReturn('Test Group');
      when(() => mockState.groupId).thenReturn(mockId);
      when(() => mockState.metadata).thenReturn(<Metadata>[]);
      when(() => mockState.settings).thenReturn(mockSettings);
      when(() => mockSession.state).thenReturn(mockState);
      when(() => mockSession.currentKey).thenReturn(MockEncryptionKey());
      when(() => mockSession.previousKeys).thenReturn(<EncryptionKey>[]);

      when(
        () => mockGroupManager.allGroupSessions(),
      ).thenAnswer((_) async => <MessageId, GroupSession>{mockId: mockSession});

      final container = createTestContainer();

      final settings = await container.read(
        groupSettingsProvider(mockId).future,
      );

      expect(settings, equals(mockSettings));

      container.dispose();
    });
  });

  group('Provider Invalidation', () {
    test('should invalidate groupProvider when group is updated', () async {
      final mockId = MockMessageId();
      final initialSession = MockGroupSession();
      final initialState = MockGroupState();

      // Set up initial session
      when(() => initialState.name).thenReturn('Initial Name');
      when(() => initialState.groupId).thenReturn(mockId);
      when(() => initialState.metadata).thenReturn(<Metadata>[]);
      when(() => initialState.settings).thenReturn(MockGroupSettings());
      when(() => initialSession.state).thenReturn(initialState);
      when(() => initialSession.currentKey).thenReturn(MockEncryptionKey());
      when(() => initialSession.previousKeys).thenReturn(<EncryptionKey>[]);

      // Start with initial session
      when(() => mockGroupManager.allGroupSessions()).thenAnswer(
        (_) async => <MessageId, GroupSession>{mockId: initialSession},
      );

      final container = createTestContainer();

      // Read initial group
      final initialGroup = await container.read(groupProvider(mockId).future);
      expect(initialGroup.state.name, equals('Initial Name'));

      // Update the mock state to return updated name
      when(() => initialState.name).thenReturn('Updated Name');

      // Invalidate the provider to simulate stream update
      container.invalidate(groupProvider(mockId));

      // Read updated group - should get the updated name
      final updatedGroup = await container.read(groupProvider(mockId).future);
      expect(updatedGroup.state.name, equals('Updated Name'));

      container.dispose();
    });

    test(
      'should invalidate allGroupIdsProvider when groups list changes',
      () async {
        final mockId = MockMessageId();
        final mockSession = MockGroupSession();
        final mockState = MockGroupState();

        when(() => mockState.name).thenReturn('Group 1');
        when(() => mockState.groupId).thenReturn(mockId);
        when(() => mockState.metadata).thenReturn(<Metadata>[]);
        when(() => mockState.settings).thenReturn(MockGroupSettings());
        when(() => mockSession.state).thenReturn(mockState);
        when(() => mockSession.currentKey).thenReturn(MockEncryptionKey());
        when(() => mockSession.previousKeys).thenReturn(<EncryptionKey>[]);

        // Start with empty groups
        when(
          () => mockGroupManager.allGroupSessions(),
        ).thenAnswer((_) async => <MessageId, GroupSession>{});

        final container = createTestContainer();

        // Read initial empty list
        final initialGroups = await container.read(allGroupIdsProvider.future);
        expect(initialGroups, isEmpty);

        // Update mock to return one group
        when(() => mockGroupManager.allGroupSessions()).thenAnswer(
          (_) async => <MessageId, GroupSession>{mockId: mockSession},
        );

        // Invalidate the underlying provider to simulate stream update
        // Note: In real usage, the AllGroupsNotifier would handle this automatically
        container.refresh(groupManagerProvider);

        // Read updated list
        final updatedGroups = await container.read(allGroupIdsProvider.future);
        expect(updatedGroups.length, equals(1));
        expect(updatedGroups[0], equals(mockId));

        container.dispose();
      },
    );
  });
}
