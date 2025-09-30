import 'dart:async';

import 'package:collection/collection.dart';
import 'package:riverpod/riverpod.dart';
import 'package:zoe_native/providers.dart';
import 'package:zoe_native/src/rust/third_party/zoe_app_primitives/metadata.dart';
import 'package:zoe_native/zoe_native.dart';
import 'package:logging/logging.dart';

final _log = Logger('zoe_native::providers::group');

class GroupNotFoundException implements Exception {
  final MessageId groupId;
  GroupNotFoundException(this.groupId);
}

/// Provider the list of all spaces, keeps up to date with the order and the underlying client
final _allGroupsProvider =
    AsyncNotifierProvider<AllGroupsNotifier, Map<MessageId, GroupSession>>(
      () => AllGroupsNotifier(),
    );

class AllGroupsNotifier extends AsyncNotifier<Map<MessageId, GroupSession>> {
  late StreamSubscription<GroupDataUpdate> _streamSubscription;
  late Map<MessageId, GroupSession> _state;
  @override
  Future<Map<MessageId, GroupSession>> build() async {
    final groupsManager = await ref.watch(groupManagerProvider.future);
    _state = await groupsManager.allGroupSessions();
    final stream = groupUpdatesStream(manager: groupsManager);
    _streamSubscription = stream.listen((update) {
      final (keysUpdate, groupIdToAlert) = switch (update) {
        GroupDataUpdate_GroupRemoved(field0: final removed) => _remove(removed),
        GroupDataUpdate_GroupUpdated(field0: final session) ||
        GroupDataUpdate_GroupAdded(field0: final session) => _update(session),
      };

      ref.invalidate(
        groupProvider(groupIdToAlert),
      ); // we inform the outer provider that they must update

      if (keysUpdate) {
        // the list of keys has changed, we need to inform the provider
        ref.invalidate(allGroupIdsProvider);
      }
    });

    ref.onDispose(() {
      _streamSubscription.cancel();
    });
    return _state;
  }

  (bool, MessageId) _remove(GroupSession session) {
    final groupId = session.state.groupId;
    if (_state.remove(session.state.groupId) == null) {
      _log.severe(
        "ProgrammingError? Tried to remove $groupId that isn't in anymore.",
      );
    }
    return (true, groupId);
  }

  (bool, MessageId) _update(GroupSession session) {
    final groupId = session.state.groupId;
    final hadSession = _state[groupId] != null;
    _state[groupId] = session;
    return (!hadSession, groupId);
  }
}

final allGroupIdsProvider = FutureProvider<List<MessageId>>((ref) async {
  final groups = await ref.watch(_allGroupsProvider.future);
  final entries = groups.entries.toList();
  // predictable order by name
  entries.sortBy((k) => k.value.state.name.toLowerCase());
  return entries.map((e) => e.key).toList();
});

final groupManagerProvider = FutureProvider<GroupManager>((ref) async {
  final client = await ref.watch(clientProvider.future);
  return client.groupManager();
});

final groupProvider = FutureProvider.family<GroupSession, MessageId>((
  ref,
  groupId,
) async {
  final groups = await ref.watch(_allGroupsProvider.future);
  final group = groups[groupId];
  if (group == null) {
    throw GroupNotFoundException(groupId);
  }
  return group;
});

final groupNameProvider = FutureProvider.family<String?, MessageId>((
  ref,
  groupId,
) async {
  final group = await ref.watch(groupProvider(groupId).future);
  return group.state.name;
});

final groupDescriptionProvider = FutureProvider.family<String?, MessageId>((
  ref,
  groupId,
) async {
  final group = await ref.watch(groupProvider(groupId).future);
  return group.state.metadata
      .map(
        (m) => switch (m) {
          Metadata_Description(field0: final value) => value,
          _ => null,
        },
      )
      .firstWhereOrNull((value) => value != null);
});

final groupAvatarProvider = FutureProvider.family<Image?, MessageId>((
  ref,
  groupId,
) async {
  final group = await ref.watch(groupProvider(groupId).future);
  return group.state.metadata
      .map(
        (m) => switch (m) {
          Metadata_Avatar(field0: final value) => value,
          _ => null,
        },
      )
      .firstWhereOrNull((value) => value != null);
});

final groupBackgroundProvider = FutureProvider.family<Image?, MessageId>((
  ref,
  groupId,
) async {
  final group = await ref.watch(groupProvider(groupId).future);
  return group.state.metadata
      .map(
        (m) => switch (m) {
          Metadata_Background(field0: final value) => value,
          _ => null,
        },
      )
      .firstWhereOrNull((value) => value != null);
});

final groupSettingsProvider = FutureProvider.family<GroupSettings, MessageId>((
  ref,
  groupId,
) async {
  final group = await ref.watch(groupProvider(groupId).future);
  return group.state.settings;
});
