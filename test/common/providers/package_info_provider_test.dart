import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:zoe/common/providers/package_info_provider.dart';

void main() {
  group('Package Info Providers', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
    });
    group('packageInfoProvider', () {
      test('provider state is AsyncValue', () {
        final asyncValue = container.read(packageInfoProvider);
        
        expect(asyncValue, isA<AsyncValue<PackageInfo>>());
      });

      test('provider can be overridden', () async {
        final mockPackageInfo = PackageInfo(
          appName: 'Test App',
          packageName: 'com.test.app',
          version: '1.0.0',
          buildNumber: '1',
          buildSignature: 'test-signature',
        );

        final overrideContainer = ProviderContainer.test(
          overrides: [
            packageInfoProvider.overrideWith((ref) => Future.value(mockPackageInfo)),
          ],
        );

        final packageInfo = await overrideContainer.read(packageInfoProvider.future);
        
        expect(packageInfo.appName, equals('Test App'));
        expect(packageInfo.packageName, equals('com.test.app'));
        expect(packageInfo.version, equals('1.0.0'));
        expect(packageInfo.buildNumber, equals('1'));
      });
    });

    group('appVersionProvider', () {
      test('returns version when data is available', () async {
        final mockPackageInfo = PackageInfo(
          appName: 'Test App',
          packageName: 'com.test.app',
          version: '2.1.0',
          buildNumber: '21',
          buildSignature: 'test-signature',
        );

        final overrideContainer = ProviderContainer.test(
          overrides: [
            packageInfoProvider.overrideWith((ref) => Future.value(mockPackageInfo)),
          ],
        );

        // Wait for the async provider to complete
        await overrideContainer.read(packageInfoProvider.future);
        
        final version = overrideContainer.read(appVersionProvider);
        expect(version, equals('2.1.0'));

      });

      test('returns loading state initially', () {
        final version = container.read(appVersionProvider);
        expect(version, equals('Loading...'));
      });

      test('provider can be overridden directly', () {
        const testVersion = '3.0.0-beta';

        final overrideContainer = ProviderContainer.test(
          overrides: [
            appVersionProvider.overrideWith((ref) => testVersion),
          ],
        );

        final version = overrideContainer.read(appVersionProvider);
        expect(version, equals(testVersion));

      });
    });

    group('appNameProvider', () {
      test('returns app name when data is available', () async {
        final mockPackageInfo = PackageInfo(
          appName: 'My Test App',
          packageName: 'com.test.app',
          version: '1.0.0',
          buildNumber: '1',
          buildSignature: 'test-signature',
        );

        final overrideContainer = ProviderContainer.test(
          overrides: [
            packageInfoProvider.overrideWith((ref) => Future.value(mockPackageInfo)),
          ],
        );

        // Wait for the async provider to complete
        await overrideContainer.read(packageInfoProvider.future);
        
        final appName = overrideContainer.read(appNameProvider);
        expect(appName, equals('My Test App'));

      });

      test('returns loading state initially', () {
        final appName = container.read(appNameProvider);
        expect(appName, equals('Loading...'));
      });

      test('provider can be overridden directly', () {
        const testAppName = 'Custom App Name';

        final overrideContainer = ProviderContainer.test(
          overrides: [
            appNameProvider.overrideWith((ref) => testAppName),
          ],
        );

        final appName = overrideContainer.read(appNameProvider);
        expect(appName, equals(testAppName));

      });
    });

    group('buildNumberProvider', () {
      test('returns build number when data is available', () async {
        final mockPackageInfo = PackageInfo(
          appName: 'Test App',
          packageName: 'com.test.app',
          version: '1.0.0',
          buildNumber: '42',
          buildSignature: 'test-signature',
        );

        final overrideContainer = ProviderContainer.test(
          overrides: [
            packageInfoProvider.overrideWith((ref) => Future.value(mockPackageInfo)),
          ],
        );

        // Wait for the async provider to complete
        await overrideContainer.read(packageInfoProvider.future);
        
        final buildNumber = overrideContainer.read(buildNumberProvider);
        expect(buildNumber, equals('42'));

      });

      test('returns loading state initially', () {
        final buildNumber = container.read(buildNumberProvider);
        expect(buildNumber, equals('Loading...'));
      });

      test('provider can be overridden directly', () {
        const testBuildNumber = '999';

        final overrideContainer = ProviderContainer.test(
          overrides: [
            buildNumberProvider.overrideWith((ref) => testBuildNumber),
          ],
        );

        final buildNumber = overrideContainer.read(buildNumberProvider);
        expect(buildNumber, equals(testBuildNumber));

      });
    });

    group('packageNameProvider', () {
      test('returns package name when data is available', () async {
        final mockPackageInfo = PackageInfo(
          appName: 'Test App',
          packageName: 'com.example.myapp',
          version: '1.0.0',
          buildNumber: '1',
          buildSignature: 'test-signature',
        );

        final overrideContainer = ProviderContainer.test(
          overrides: [
            packageInfoProvider.overrideWith((ref) => Future.value(mockPackageInfo)),
          ],
        );

        // Wait for the async provider to complete
        await overrideContainer.read(packageInfoProvider.future);
        
        final packageName = overrideContainer.read(packageNameProvider);
        expect(packageName, equals('com.example.myapp'));

      });

      test('returns loading state initially', () {
        final packageName = container.read(packageNameProvider);
        expect(packageName, equals('Loading...'));
      });

      test('provider can be overridden directly', () {
        const testPackageName = 'com.custom.app';

        final overrideContainer = ProviderContainer.test(
          overrides: [
            packageNameProvider.overrideWith((ref) => testPackageName),
          ],
        );

        final packageName = overrideContainer.read(packageNameProvider);
        expect(packageName, equals(testPackageName));

      });
    });
  });
}