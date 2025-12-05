// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Login form state provider

@ProviderFor(LoginForm)
const loginFormProvider = LoginFormProvider._();

/// Login form state provider
final class LoginFormProvider
    extends $NotifierProvider<LoginForm, LoginFormStateModel> {
  /// Login form state provider
  const LoginFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginFormProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginFormHash();

  @$internal
  @override
  LoginForm create() => LoginForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoginFormStateModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoginFormStateModel>(value),
    );
  }
}

String _$loginFormHash() => r'ec9f3bb12ed5181dc50db6a15659f69fc11fa7ef';

/// Login form state provider

abstract class _$LoginForm extends $Notifier<LoginFormStateModel> {
  LoginFormStateModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<LoginFormStateModel, LoginFormStateModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LoginFormStateModel, LoginFormStateModel>,
              LoginFormStateModel,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
