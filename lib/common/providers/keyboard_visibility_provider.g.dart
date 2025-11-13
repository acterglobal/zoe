// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keyboard_visibility_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for keyboard visibility state

@ProviderFor(keyboardVisible)
const keyboardVisibleProvider = KeyboardVisibleProvider._();

/// Provider for keyboard visibility state

final class KeyboardVisibleProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// Provider for keyboard visibility state
  const KeyboardVisibleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keyboardVisibleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keyboardVisibleHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return keyboardVisible(ref);
  }
}

String _$keyboardVisibleHash() => r'40c39614d155fcd929f5b665e15bacf138c9abab';
