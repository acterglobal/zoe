import 'package:riverpod/riverpod.dart';
import 'package:zoe_native/zoe_native.dart';

final clientProvider = FutureProvider<Client>((ref) async {
  return await loadOrGenerateClient();
});
