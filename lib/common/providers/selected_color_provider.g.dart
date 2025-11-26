// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_color_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for managing selected color

@ProviderFor(SelectedColor)
const selectedColorProvider = SelectedColorProvider._();

/// Provider for managing selected color
final class SelectedColorProvider
    extends $NotifierProvider<SelectedColor, Color> {
  /// Provider for managing selected color
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
  Override overrideWithValue(Color value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Color>(value),
    );
  }
}

String _$selectedColorHash() => r'4c69598d3ea1366274fbdb660b75ea80ce62fd4b';

/// Provider for managing selected color

abstract class _$SelectedColor extends $Notifier<Color> {
  Color build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Color, Color>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Color, Color>,
              Color,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
