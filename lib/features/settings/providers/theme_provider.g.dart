// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for managing app theme settings

@ProviderFor(Theme)
const themeProvider = ThemeProvider._();

/// Provider for managing app theme settings
final class ThemeProvider extends $NotifierProvider<Theme, AppThemeMode> {
  /// Provider for managing app theme settings
  const ThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeHash();

  @$internal
  @override
  Theme create() => Theme();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppThemeMode>(value),
    );
  }
}

String _$themeHash() => r'e55ddc0a171d74c41a6440c383d74abc4a6a1732';

/// Provider for managing app theme settings

abstract class _$Theme extends $Notifier<AppThemeMode> {
  AppThemeMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AppThemeMode, AppThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppThemeMode, AppThemeMode>,
              AppThemeMode,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider to check if the app is using system theme

@ProviderFor(isSystemTheme)
const isSystemThemeProvider = IsSystemThemeProvider._();

/// Provider to check if the app is using system theme

final class IsSystemThemeProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provider to check if the app is using system theme
  const IsSystemThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isSystemThemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isSystemThemeHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isSystemTheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isSystemThemeHash() => r'dc7ff193e1639d6b4f8a43dbe56e84324a5a9b38';

/// Provider to check if the app is using dark theme

@ProviderFor(isDarkTheme)
const isDarkThemeProvider = IsDarkThemeProvider._();

/// Provider to check if the app is using dark theme

final class IsDarkThemeProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provider to check if the app is using dark theme
  const IsDarkThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isDarkThemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isDarkThemeHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isDarkTheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isDarkThemeHash() => r'73f01a6a01bb7b30aca350920eb8077b80489381';

/// Provider to check if the app is using light theme

@ProviderFor(isLightTheme)
const isLightThemeProvider = IsLightThemeProvider._();

/// Provider to check if the app is using light theme

final class IsLightThemeProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provider to check if the app is using light theme
  const IsLightThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isLightThemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isLightThemeHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isLightTheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isLightThemeHash() => r'042a489b6a6d28a2bdcca92004d4463cb21b9b5c';
