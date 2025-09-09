import 'package:riverpod/riverpod.dart';
import 'package:zoe_native/providers.dart';
import 'package:zoe_native/src/rust/api/client.dart';
import 'package:zoe_native/zoe_native.dart';

final connectionStatusProvider = StreamProvider<OverallConnectionStatus>((
  ref,
) async* {
  final client = await ref.watch(clientProvider.future);
  final stream = overallStatusStream(client: client);
  await for (final status in stream) {
    yield status;
  }
});
