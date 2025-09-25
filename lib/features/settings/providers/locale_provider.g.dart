// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for managing app locale/language settings

@ProviderFor(AppLocale)
const appLocaleProvider = AppLocaleProvider._();

/// Provider for managing app locale/language settings
final class AppLocaleProvider extends $NotifierProvider<AppLocale, String> {
  /// Provider for managing app locale/language settings
  const AppLocaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLocaleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLocaleHash();

  @$internal
  @override
  AppLocale create() => AppLocale();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$appLocaleHash() => r'11856686eca34706e358ef46a805a8e684f7787b';

/// Provider for managing app locale/language settings

abstract class _$AppLocale extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for current locale as Locale object

@ProviderFor(currentLocale)
const currentLocaleProvider = CurrentLocaleProvider._();

/// Provider for current locale as Locale object

final class CurrentLocaleProvider
    extends $FunctionalProvider<ui.Locale, ui.Locale, ui.Locale>
    with $Provider<ui.Locale> {
  /// Provider for current locale as Locale object
  const CurrentLocaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentLocaleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentLocaleHash();

  @$internal
  @override
  $ProviderElement<ui.Locale> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ui.Locale create(Ref ref) {
    return currentLocale(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ui.Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ui.Locale>(value),
    );
  }
}

String _$currentLocaleHash() => r'6872cd17a2fc75d90c1f3b6cfffa99d81f71a417';

/// Provider to check if the app is using system language

@ProviderFor(isSystemLanguage)
const isSystemLanguageProvider = IsSystemLanguageProvider._();

/// Provider to check if the app is using system language

final class IsSystemLanguageProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provider to check if the app is using system language
  const IsSystemLanguageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isSystemLanguageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isSystemLanguageHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isSystemLanguage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isSystemLanguageHash() => r'fdb8af965a3fe5c63268b51e09d4aab97b61c87d';

/// Provider for available languages filtered by current locale

@ProviderFor(availableLanguages)
const availableLanguagesProvider = AvailableLanguagesProvider._();

/// Provider for available languages filtered by current locale

final class AvailableLanguagesProvider
    extends
        $FunctionalProvider<
          List<LanguageModel>,
          List<LanguageModel>,
          List<LanguageModel>
        >
    with $Provider<List<LanguageModel>> {
  /// Provider for available languages filtered by current locale
  const AvailableLanguagesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableLanguagesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableLanguagesHash();

  @$internal
  @override
  $ProviderElement<List<LanguageModel>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<LanguageModel> create(Ref ref) {
    return availableLanguages(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<LanguageModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<LanguageModel>>(value),
    );
  }
}

String _$availableLanguagesHash() =>
    r'a96237937cb88d97c551030576e74e012398ca99';
