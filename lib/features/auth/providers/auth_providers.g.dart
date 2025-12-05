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
    extends $NotifierProvider<AuthState, AuthStateModel> {
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthStateModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthStateModel>(value),
    );
  }
}

String _$authStateHash() => r'0a6c347295121c5567d5f3687611b13c693bf4da';

/// Main auth state provider with authentication management functionality

abstract class _$AuthState extends $Notifier<AuthStateModel> {
  AuthStateModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AuthStateModel, AuthStateModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthStateModel, AuthStateModel>,
              AuthStateModel,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider to check if user is authenticated

@ProviderFor(isAuthenticated)
const isAuthenticatedProvider = IsAuthenticatedProvider._();

/// Provider to check if user is authenticated

final class IsAuthenticatedProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provider to check if user is authenticated
  const IsAuthenticatedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isAuthenticatedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isAuthenticatedHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isAuthenticated(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isAuthenticatedHash() => r'c09e70f35acba5a2ab2cb4dd29cf7026f815815b';

/// Provider for the current authenticated user (null if not authenticated)

@ProviderFor(currentUser)
const currentUserProvider = CurrentUserProvider._();

/// Provider for the current authenticated user (null if not authenticated)

final class CurrentUserProvider
    extends $FunctionalProvider<AuthUserModel?, AuthUserModel?, AuthUserModel?>
    with $Provider<AuthUserModel?> {
  /// Provider for the current authenticated user (null if not authenticated)
  const CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $ProviderElement<AuthUserModel?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthUserModel? create(Ref ref) {
    return currentUser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthUserModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthUserModel?>(value),
    );
  }
}

String _$currentUserHash() => r'45cee4ada16370c58b20cfc60473ea20aa91b3a9';
