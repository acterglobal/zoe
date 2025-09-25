import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'package_info_provider.g.dart';

/// Provider for PackageInfo that loads app information
@riverpod
Future<PackageInfo> packageInfo(Ref ref) async {
  return await PackageInfo.fromPlatform();
}

/// Provider for app version string
@riverpod
String appVersion(Ref ref) {
  final packageInfoAsync = ref.watch(packageInfoProvider);
  return packageInfoAsync.when(
    data: (packageInfo) => packageInfo.version,
    loading: () => 'Loading...',
    error: (error, stackTrace) => 'Unknown',
  );
}

/// Provider for app name
@riverpod
String appName(Ref ref) {
  final packageInfoAsync = ref.watch(packageInfoProvider);
  return packageInfoAsync.when(
    data: (packageInfo) => packageInfo.appName,
    loading: () => 'Loading...',
    error: (error, stackTrace) => 'Unknown',
  );
}

/// Provider for build number
@riverpod
String buildNumber(Ref ref) {
  final packageInfoAsync = ref.watch(packageInfoProvider);
  return packageInfoAsync.when(
    data: (packageInfo) => packageInfo.buildNumber,
    loading: () => 'Loading...',
    error: (error, stackTrace) => 'Unknown',
  );
}

/// Provider for package name
@riverpod
String packageName(Ref ref) {
  final packageInfoAsync = ref.watch(packageInfoProvider);
  return packageInfoAsync.when(
    data: (packageInfo) => packageInfo.packageName,
    loading: () => 'Loading...',
    error: (error, stackTrace) => 'Unknown',
  );
}