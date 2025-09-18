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

String _$toggleContentMenuHash() => r'92cc9585e3d4ff8cfda143cc4521e164f0f18eba';

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

/// Provider for tracking edit state for specific content by parentId

@ProviderFor(IsEditValue)
const isEditValueProvider = IsEditValueFamily._();

/// Provider for tracking edit state for specific content by parentId
final class IsEditValueProvider extends $NotifierProvider<IsEditValue, bool> {
  /// Provider for tracking edit state for specific content by parentId
  const IsEditValueProvider._({
    required IsEditValueFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'isEditValueProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isEditValueHash();

  @override
  String toString() {
    return r'isEditValueProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  IsEditValue create() => IsEditValue();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IsEditValueProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isEditValueHash() => r'3bc28f85e78b7bd719285d58e5bc2e3d72a856da';

/// Provider for tracking edit state for specific content by parentId

final class IsEditValueFamily extends $Family
    with $ClassFamilyOverride<IsEditValue, bool, bool, bool, String> {
  const IsEditValueFamily._()
    : super(
        retry: null,
        name: r'isEditValueProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for tracking edit state for specific content by parentId

  IsEditValueProvider call(String parentId) =>
      IsEditValueProvider._(argument: parentId, from: this);

  @override
  String toString() => r'isEditValueProvider';
}

/// Provider for tracking edit state for specific content by parentId

abstract class _$IsEditValue extends $Notifier<bool> {
  late final _$args = ref.$arg as String;
  String get parentId => _$args;

  bool build(String parentId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
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
