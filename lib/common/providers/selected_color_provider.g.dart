// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_color_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for managing selected theme colors

@ProviderFor(SelectedColor)
const selectedColorProvider = SelectedColorProvider._();

/// Provider for managing selected theme colors
final class SelectedColorProvider
    extends $NotifierProvider<SelectedColor, SelectedColorState> {
  /// Provider for managing selected theme colors
  const SelectedColorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedColorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedColorHash();

  @$internal
  @override
  SelectedColor create() => SelectedColor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SelectedColorState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SelectedColorState>(value),
    );
  }
}

String _$selectedColorHash() => r'8c7f3370d70da0c51481a733fa8564e7def04905';

/// Provider for managing selected theme colors

abstract class _$SelectedColor extends $Notifier<SelectedColorState> {
  SelectedColorState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SelectedColorState, SelectedColorState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SelectedColorState, SelectedColorState>,
              SelectedColorState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
