// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SignupForm)
const signupFormProvider = SignupFormProvider._();

final class SignupFormProvider
    extends $NotifierProvider<SignupForm, SignupFormStateModel> {
  const SignupFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signupFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signupFormHash();

  @$internal
  @override
  SignupForm create() => SignupForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignupFormStateModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignupFormStateModel>(value),
    );
  }
}

String _$signupFormHash() => r'6007b034b45879c0c2a2f96571df767a32daf6ce';

abstract class _$SignupForm extends $Notifier<SignupFormStateModel> {
  SignupFormStateModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SignupFormStateModel, SignupFormStateModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SignupFormStateModel, SignupFormStateModel>,
              SignupFormStateModel,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
