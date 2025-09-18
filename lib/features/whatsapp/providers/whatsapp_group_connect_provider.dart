import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'whatsapp_group_connect_provider.g.dart';

/// Provider for is connecting state
@riverpod
class IsConnecting extends _$IsConnecting {
  @override
  bool build() => false;

  void update(bool value) => state = value;
}

