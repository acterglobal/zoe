import 'package:riverpod/riverpod.dart';
import 'package:zoe_native/providers.dart';
import 'package:zoe_native/zoe_native.dart';

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
