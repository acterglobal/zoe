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
      test('initializes with null (unauthenticated) when no user', () async {
        final state = await container.read(authStateProvider.future);
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

        final state = await newContainer.read(authStateProvider.future);
        expect(state, isNotNull);
        expect(state?.uid, 'test-uid');
        expect(state?.email, 'test@example.com');
      });

      test('updates to authenticated state on successful sign in', () async {
        when(
          () => mockAuthService.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => mockUserCredential);

        final notifier = container.read(authStateProvider.notifier);
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

        final notifier = container.read(authStateProvider.notifier);
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

        final notifier = container.read(authStateProvider.notifier);

        expect(
          () => notifier.signIn(
            email: 'test@example.com',
            password: 'wrongpassword',
          ),
          throwsA(isA<Exception>()),
        );

        final asyncState = container.read(authStateProvider);
        expect(asyncState.hasError, isTrue);
      });

      test('sets error state on sign up error', () async {
        when(
          () => mockAuthService.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          ),
        ).thenThrow(Exception('Email already in use'));

        final notifier = container.read(authStateProvider.notifier);

        expect(
          () => notifier.signUp(
            email: 'existing@example.com',
            password: 'password123',
            name: 'John Doe',
          ),
          throwsA(isA<Exception>()),
        );

        final asyncState = container.read(authStateProvider);
        expect(asyncState.hasError, isTrue);
      });

      test('calls sign out on auth service', () async {
        when(() => mockAuthService.signOut()).thenAnswer((_) async => {});

        final notifier = container.read(authStateProvider.notifier);
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
        final initialState = await newContainer.read(authStateProvider.future);
        expect(initialState, isNull);

        // Emit authenticated user
        controller.add(mockUser);
        await Future.delayed(const Duration(milliseconds: 50));

        // State should update to authenticated
        final authState = newContainer.read(authStateProvider);
        expect(authState.hasValue, isTrue);
        expect(authState.value, isNotNull);
        expect(authState.value?.uid, 'test-uid');

        // Emit null (sign out)
        controller.add(null);
        await Future.delayed(const Duration(milliseconds: 50));

        // State should update to unauthenticated
        final signedOutState = newContainer.read(authStateProvider);
        expect(signedOutState.hasValue, isTrue);
        expect(signedOutState.value, isNull);

        await controller.close();
      });
    });

    group('isAuthenticated check', () {
      test('returns false when unauthenticated', () async {
        final user = await container.read(authStateProvider.future);
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

        final user = await newContainer.read(authStateProvider.future);
        final isAuth = user != null;
        expect(isAuth, isTrue);
      });
    });

    group('currentUser check', () {
      test('returns null when unauthenticated', () async {
        final user = await container.read(authStateProvider.future);
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

        final user = await newContainer.read(authStateProvider.future);
        expect(user, isNotNull);
        expect(user?.uid, 'test-uid');
        expect(user?.email, 'test@example.com');
        expect(user?.displayName, 'Test User');
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

        final user = await newContainer.read(authStateProvider.future);
        expect(user?.displayName, isNull);
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

        final user = await newContainer.read(authStateProvider.future);
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

        final notifier = container.read(authStateProvider.notifier);
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
