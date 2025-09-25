// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whatsapp_group_connect_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for is connecting state

@ProviderFor(IsConnecting)
const isConnectingProvider = IsConnectingProvider._();

/// Provider for is connecting state
final class IsConnectingProvider extends $NotifierProvider<IsConnecting, bool> {
  /// Provider for is connecting state
  const IsConnectingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isConnectingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isConnectingHash();

  @$internal
  @override
  IsConnecting create() => IsConnecting();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isConnectingHash() => r'5ea0b82bdf5cbfbb712be8564f3074e39788172d';

/// Provider for is connecting state

abstract class _$IsConnecting extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
