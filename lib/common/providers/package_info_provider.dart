import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Provider for PackageInfo that loads app information
final packageInfoProvider = FutureProvider<PackageInfo>((ref) async {
  return await PackageInfo.fromPlatform();
});

/// Provider for app version string
final appVersionProvider = Provider<String>((ref) {
  final packageInfoAsync = ref.watch(packageInfoProvider);
  return packageInfoAsync.when(
    data: (packageInfo) => packageInfo.version,
    loading: () => 'Loading...',
    error: (error, stackTrace) => 'Unknown',
  );
});

/// Provider for app name
final appNameProvider = Provider<String>((ref) {
  final packageInfoAsync = ref.watch(packageInfoProvider);
  return packageInfoAsync.when(
    data: (packageInfo) => packageInfo.appName,
    loading: () => 'Loading...',
    error: (error, stackTrace) => 'Unknown',
  );
});

/// Provider for build number
final buildNumberProvider = Provider<String>((ref) {
  final packageInfoAsync = ref.watch(packageInfoProvider);
  return packageInfoAsync.when(
    data: (packageInfo) => packageInfo.buildNumber,
    loading: () => 'Loading...',
    error: (error, stackTrace) => 'Unknown',
  );
});

/// Provider for package name
final packageNameProvider = Provider<String>((ref) {
  final packageInfoAsync = ref.watch(packageInfoProvider);
  return packageInfoAsync.when(
    data: (packageInfo) => packageInfo.packageName,
    loading: () => 'Loading...',
    error: (error, stackTrace) => 'Unknown',
  );
});
