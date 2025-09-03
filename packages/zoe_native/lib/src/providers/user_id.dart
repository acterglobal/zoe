import 'package:riverpod/riverpod.dart';
import 'package:zoe_native/src/providers/client.dart';

/// My user id
final userIdProvider = FutureProvider<String>((ref) async {
  final client = await ref.watch(clientProvider.future);
  return client.idHex();
});
