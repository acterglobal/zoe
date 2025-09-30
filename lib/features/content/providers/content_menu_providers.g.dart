// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_menu_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for toggling content menu visibility

@ProviderFor(ToggleContentMenu)
const toggleContentMenuProvider = ToggleContentMenuProvider._();

/// Provider for toggling content menu visibility
final class ToggleContentMenuProvider
    extends $NotifierProvider<ToggleContentMenu, bool> {
  /// Provider for toggling content menu visibility
  const ToggleContentMenuProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'toggleContentMenuProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$toggleContentMenuHash();

  @$internal
  @override
  ToggleContentMenu create() => ToggleContentMenu();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$toggleContentMenuHash() => r'6dde25951f53b356d67f6d27c8b5487af41f7089';

/// Provider for toggling content menu visibility

abstract class _$ToggleContentMenu extends $Notifier<bool> {
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
