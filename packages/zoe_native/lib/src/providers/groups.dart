import 'package:riverpod/riverpod.dart';
import 'package:zoe_native/providers.dart';
import 'package:zoe_native/src/rust/third_party/zoe_state_machine/group.dart';
import 'package:zoe_native/src/rust/third_party/zoe_state_machine/state.dart';
import 'package:zoe_native/src/rust/third_party/zoe_wire_protocol/primitives.dart';

final groupsProvider = FutureProvider<Map<MessageId, GroupSession>>((
  ref,
) async {
  final client = await ref.watch(groupManagerProvider.future);
  return client.allGroupSessions();
});

final groupManagerProvider = FutureProvider<GroupManager>((ref) async {
  final client = await ref.watch(clientProvider.future);
  return client.groupManager();
});
