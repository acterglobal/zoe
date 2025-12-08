// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Main auth state provider with authentication management functionality

@ProviderFor(AuthState)
const authStateProvider = AuthStateProvider._();

/// Main auth state provider with authentication management functionality
final class AuthStateProvider
    extends $AsyncNotifierProvider<AuthState, AuthUserModel?> {
  /// Main auth state provider with authentication management functionality
  const AuthStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStateHash();

  @$internal
  @override
  AuthState create() => AuthState();
}

String _$authStateHash() => r'065038f9f011981683075fac1a60872e4d56cb3a';

/// Main auth state provider with authentication management functionality

abstract class _$AuthState extends $AsyncNotifier<AuthUserModel?> {
  FutureOr<AuthUserModel?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<AuthUserModel?>, AuthUserModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuthUserModel?>, AuthUserModel?>,
              AsyncValue<AuthUserModel?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
