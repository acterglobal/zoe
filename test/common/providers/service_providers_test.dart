import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoe/common/providers/service_providers.dart';
import 'package:zoe/core/preference_service/preferences_service.dart';
import 'package:zoe/features/settings/models/theme.dart';

void main() {
  group('Service Providers', () {
    late ProviderContainer container;

    setUp(() {
      // Mock SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer.test();
    });

    group('preferencesServiceProvider', () {
      test('returns PreferencesService instance', () {
        final preferencesService = container.read(preferencesServiceProvider);

        expect(preferencesService, isA<PreferencesService>());
      });

      test('provider works with PreferencesService methods', () async {
        final service = container.read(preferencesServiceProvider);

        // Test that the service can be initialized
        await service.init();

        // Test theme mode methods
        final themeMode = await service.getThemeMode();
        expect(themeMode, equals(AppThemeMode.system));

        final setResult = await service.setThemeMode(AppThemeMode.light);
        expect(setResult, isTrue);

        final updatedThemeMode = await service.getThemeMode();
        expect(updatedThemeMode, equals(AppThemeMode.light));
      });

      test('provider works with login user methods', () async {
        final service = container.read(preferencesServiceProvider);

        // Test login user methods
        final userId = await service.getLoginUserId();
        expect(userId, isNull);

        final setResult = await service.setLoginUserId('test-user-123');
        expect(setResult, isTrue);

        final retrievedUserId = await service.getLoginUserId();
        expect(retrievedUserId, equals('test-user-123'));

        final clearResult = await service.clearLoginUserId();
        expect(clearResult, isTrue);

        final clearedUserId = await service.getLoginUserId();
        expect(clearedUserId, isNull);
      });

      test('provider handles multiple user IDs', () async {
        final service = container.read(preferencesServiceProvider);

        const userIds = ['user1', 'user2', 'user3'];

        for (final userId in userIds) {
          final setResult = await service.setLoginUserId(userId);
          expect(setResult, isTrue);

          final retrievedUserId = await service.getLoginUserId();
          expect(retrievedUserId, equals(userId));
        }
      });

      test('provider handles empty user ID', () async {
        final service = container.read(preferencesServiceProvider);

        final setResult = await service.setLoginUserId('');
        expect(setResult, isTrue);

        final retrievedUserId = await service.getLoginUserId();
        expect(retrievedUserId, equals(''));
      });
    });
  });
}
