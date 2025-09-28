// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for PackageInfo that loads app information

@ProviderFor(packageInfo)
const packageInfoProvider = PackageInfoProvider._();

/// Provider for PackageInfo that loads app information

final class PackageInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<PackageInfo>,
          PackageInfo,
          FutureOr<PackageInfo>
        >
    with $FutureModifier<PackageInfo>, $FutureProvider<PackageInfo> {
  /// Provider for PackageInfo that loads app information
  const PackageInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'packageInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$packageInfoHash();

  @$internal
  @override
  $FutureProviderElement<PackageInfo> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PackageInfo> create(Ref ref) {
    return packageInfo(ref);
  }
}

String _$packageInfoHash() => r'e85c18fc1df698cf58e72da2ff3d20b5e68db434';

/// Provider for app version string

@ProviderFor(appVersion)
const appVersionProvider = AppVersionProvider._();

/// Provider for app version string

final class AppVersionProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// Provider for app version string
  const AppVersionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appVersionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appVersionHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return appVersion(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$appVersionHash() => r'7958a558638ba7331e7394ee88612ae761a5e1cc';

/// Provider for app name

@ProviderFor(appName)
const appNameProvider = AppNameProvider._();

/// Provider for app name

final class AppNameProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// Provider for app name
  const AppNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appNameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appNameHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return appName(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$appNameHash() => r'f6e00a10f81f8d67ee3829c1fddaed39c13bbc28';

/// Provider for build number

@ProviderFor(buildNumber)
const buildNumberProvider = BuildNumberProvider._();

/// Provider for build number

final class BuildNumberProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// Provider for build number
  const BuildNumberProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'buildNumberProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$buildNumberHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return buildNumber(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$buildNumberHash() => r'61f7648990cfab47316948ccb478189836360208';

/// Provider for package name

@ProviderFor(packageName)
const packageNameProvider = PackageNameProvider._();

/// Provider for package name

final class PackageNameProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// Provider for package name
  const PackageNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'packageNameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$packageNameHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return packageName(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$packageNameHash() => r'39669b158ee5c2e6daa891e4bbecad8c804793fc';
