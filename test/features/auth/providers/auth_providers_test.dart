import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/common/providers/service_providers.dart';
import 'package:zoe/features/auth/providers/auth_providers.dart';
import 'package:zoe/features/auth/services/auth_service.dart';

import '../../../test-utils/mock_preferences.dart';
import '../utils/auth_utils.dart';

void main() {
  group('Auth Providers', () {
    late ProviderContainer container;
    late MockAuthService mockAuthService;
    late MockPreferencesService mockPreferencesService;
    late MockUser mockUser;
    late MockUserCredential mockUserCredential;

    setUp(() {
      mockAuthService = MockAuthService();
      mockPreferencesService = MockPreferencesService();
      mockUser = MockUser();
      mockUserCredential = MockUserCredential();

      // Setup default mock behaviors
      when(() => mockUser.uid).thenReturn('test-uid');
      when(() => mockUser.email).thenReturn('test@example.com');
      when(() => mockUser.displayName).thenReturn('Test User');
      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockAuthService.currentUser).thenReturn(null);
      when(
        () => mockAuthService.authStateChanges,
      ).thenAnswer((_) => Stream.value(null));

      // Mock PreferencesService methods
      when(
        () => mockPreferencesService.setLoginUserId(any()),
      ).thenAnswer((_) async => true);
      when(
        () => mockPreferencesService.clearLoginUserId(),
      ).thenAnswer((_) async => true);
      when(
        () => mockPreferencesService.getLoginUserId(),
      ).thenAnswer((_) async => null);

      container = ProviderContainer.test(
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
          preferencesServiceProvider.overrideWithValue(mockPreferencesService),
        ],
      );
    });

    group('AuthState', () {
      test('initializes with null (unauthenticated) when no user', () {
        final state = container.read(authProvider);
        expect(state, isNull);
      });

      test('initializes with user model when user exists', () async {
        when(() => mockAuthService.currentUser).thenReturn(mockUser);
        when(
          () => mockAuthService.authStateChanges,
        ).thenAnswer((_) => Stream.value(mockUser));

        final newContainer = ProviderContainer.test(
          overrides: [
            authServiceProvider.overrideWithValue(mockAuthService),
            preferencesServiceProvider.overrideWithValue(
              mockPreferencesService,
            ),
          ],
        );

        final state = newContainer.read(authProvider);
        expect(state, isNotNull);
        expect(state?.id, 'test-uid');
        expect(state?.email, 'test@example.com');
      });

      test('updates to authenticated state on successful sign in', () async {
        when(
          () => mockAuthService.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => mockUserCredential);

        final notifier = container.read(authProvider.notifier);
        await notifier.signIn(
          email: 'test@example.com',
          password: 'password123',
        );

        // State should be loading during sign in
        // Then updated by authStateChanges listener
        verify(
          () => mockAuthService.signIn(
            email: 'test@example.com',
            password: 'password123',
          ),
        ).called(1);
      });

      test('updates to authenticated state on successful sign up', () async {
        when(
          () => mockAuthService.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          ),
        ).thenAnswer((_) async => mockUserCredential);

        final notifier = container.read(authProvider.notifier);
        await notifier.signUp(
          email: 'test@example.com',
          password: 'password123',
          name: 'John Doe',
        );

        verify(
          () => mockAuthService.signUp(
            email: 'test@example.com',
            password: 'password123',
            displayName: 'John Doe',
          ),
        ).called(1);
      });

      test('sets error state on sign in error', () async {
        when(
          () => mockAuthService.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception('Invalid credentials'));

        final notifier = container.read(authProvider.notifier);

        expect(
          () => notifier.signIn(
            email: 'test@example.com',
            password: 'wrongpassword',
          ),
          throwsA(isA<Exception>()),
        );

        final state = container.read(authProvider);
        expect(state, isNull);
      });

      test('sets error state on sign up error', () async {
        when(
          () => mockAuthService.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          ),
        ).thenThrow(Exception('Email already in use'));

        final notifier = container.read(authProvider.notifier);

        expect(
          () => notifier.signUp(
            email: 'existing@example.com',
            password: 'password123',
            name: 'John Doe',
          ),
          throwsA(isA<Exception>()),
        );

        final state = container.read(authProvider);
        expect(state, isNull);
      });

      test('calls sign out on auth service', () async {
        when(() => mockAuthService.signOut()).thenAnswer((_) async => {});

        final notifier = container.read(authProvider.notifier);
        await notifier.signOut();

        verify(() => mockAuthService.signOut()).called(1);
      });

      test('handles auth state changes stream', () async {
        final controller = StreamController<firebase_auth.User?>();
        when(
          () => mockAuthService.authStateChanges,
        ).thenAnswer((_) => controller.stream);
        when(() => mockAuthService.currentUser).thenReturn(null);

        final newContainer = ProviderContainer.test(
          overrides: [
            authServiceProvider.overrideWithValue(mockAuthService),
            preferencesServiceProvider.overrideWithValue(
              mockPreferencesService,
            ),
          ],
        );

        // Initial state - wait for build to complete
        final initialState = newContainer.read(authProvider);
        expect(initialState, isNull);

        // Emit authenticated user
        controller.add(mockUser);
        await Future.delayed(const Duration(milliseconds: 50));

        // State should update to authenticated
        final authState = newContainer.read(authProvider);
        expect(authState, isNotNull);
        expect(authState?.id, 'test-uid');

        // Emit null (sign out)
        controller.add(null);
        await Future.delayed(const Duration(milliseconds: 50));

        // State should update to unauthenticated
        final signedOutState = newContainer.read(authProvider);
        expect(signedOutState, isNull);

        await controller.close();
      });
    });

    group('isAuthenticated check', () {
      test('returns false when unauthenticated', () async {
        final user = container.read(authProvider);
        final isAuth = user != null;
        expect(isAuth, isFalse);
      });

      test('returns true when authenticated', () async {
        when(() => mockAuthService.currentUser).thenReturn(mockUser);
        when(
          () => mockAuthService.authStateChanges,
        ).thenAnswer((_) => Stream.value(mockUser));

        final newContainer = ProviderContainer.test(
          overrides: [
            authServiceProvider.overrideWithValue(mockAuthService),
            preferencesServiceProvider.overrideWithValue(
              mockPreferencesService,
            ),
          ],
        );

        final user = newContainer.read(authProvider);
        final isAuth = user != null;
        expect(isAuth, isTrue);
      });
    });

    group('currentUser check', () {
      test('returns null when unauthenticated', () {
        final user = container.read(authProvider);
        expect(user, isNull);
      });

      test('returns user model when authenticated', () async {
        when(() => mockAuthService.currentUser).thenReturn(mockUser);
        when(
          () => mockAuthService.authStateChanges,
        ).thenAnswer((_) => Stream.value(mockUser));

        final newContainer = ProviderContainer.test(
          overrides: [
            authServiceProvider.overrideWithValue(mockAuthService),
            preferencesServiceProvider.overrideWithValue(
              mockPreferencesService,
            ),
          ],
        );

        final user = newContainer.read(authProvider);
        expect(user, isNotNull);
        expect(user?.id, 'test-uid');
        expect(user?.email, 'test@example.com');
        expect(user?.name, 'Test User');
      });
    });

    group('Edge Cases', () {
      test('handles null display name', () async {
        when(() => mockUser.displayName).thenReturn(null);
        when(() => mockAuthService.currentUser).thenReturn(mockUser);
        when(
          () => mockAuthService.authStateChanges,
        ).thenAnswer((_) => Stream.value(mockUser));

        final newContainer = ProviderContainer.test(
          overrides: [
            authServiceProvider.overrideWithValue(mockAuthService),
            preferencesServiceProvider.overrideWithValue(
              mockPreferencesService,
            ),
          ],
        );

        final user = newContainer.read(authProvider);
        expect(user?.name, isNull);
      });

      test('handles empty email', () async {
        when(() => mockUser.email).thenReturn('');
        when(() => mockAuthService.currentUser).thenReturn(mockUser);
        when(
          () => mockAuthService.authStateChanges,
        ).thenAnswer((_) => Stream.value(mockUser));

        final newContainer = ProviderContainer.test(
          overrides: [
            authServiceProvider.overrideWithValue(mockAuthService),
            preferencesServiceProvider.overrideWithValue(
              mockPreferencesService,
            ),
          ],
        );

        final user = newContainer.read(authProvider);
        expect(user?.email, '');
      });

      test('trims display name in sign up', () async {
        when(
          () => mockAuthService.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          ),
        ).thenAnswer((_) async => mockUserCredential);

        final notifier = container.read(authProvider.notifier);
        await notifier.signUp(
          email: 'test@example.com',
          password: 'password123',
          name: '  John Doe  ',
        );

        verify(
          () => mockAuthService.signUp(
            email: 'test@example.com',
            password: 'password123',
            displayName: 'John Doe',
          ),
        ).called(1);
      });
    });
  });
}
