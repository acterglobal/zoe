import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/features/auth/models/auth_state_model.dart';
import 'package:zoe/features/auth/providers/auth_providers.dart';
import 'package:zoe/features/auth/services/auth_service.dart';

import '../utils/auth_utils.dart';

void main() {
  group('Auth Providers', () {
    late ProviderContainer container;
    late MockAuthService mockAuthService;
    late MockUser mockUser;
    late MockUserCredential mockUserCredential;

    setUp(() {  
      mockAuthService = MockAuthService();
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

      container = ProviderContainer.test(
        overrides: [authServiceProvider.overrideWithValue(mockAuthService)],
      );
    });

    group('AuthState', () {
      test('initializes with unauthenticated state when no user', () {
        final state = container.read(authStateProvider);
        expect(state, isA<AuthStateUnauthenticated>());
      });

      test('initializes with authenticated state when user exists', () {
        when(() => mockAuthService.currentUser).thenReturn(mockUser);

        final newContainer = ProviderContainer.test(
          overrides: [authServiceProvider.overrideWithValue(mockAuthService)],
        );

        final state = newContainer.read(authStateProvider);
        expect(state, isA<AuthStateAuthenticated>());
        expect((state as AuthStateAuthenticated).user.uid, 'test-uid');
        expect(state.user.email, 'test@example.com');
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

      test('sets loading state during sign in', () async {
        final controller = StreamController<firebase_auth.User?>();
        when(
          () => mockAuthService.authStateChanges,
        ).thenAnswer((_) => controller.stream);

        when(
          () => mockAuthService.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return mockUserCredential;
        });

        final notifier = container.read(authStateProvider.notifier);
        final future = notifier.signIn(
          email: 'test@example.com',
          password: 'password123',
        );

        // Check loading state immediately
        await Future.delayed(const Duration(milliseconds: 10));
        final state = container.read(authStateProvider);
        expect(state, isA<AuthStateLoading>());

        await future;
        controller.close();
      });

      test('sets unauthenticated state on sign in error', () async {
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

        final state = container.read(authStateProvider);
        expect(state, isA<AuthStateUnauthenticated>());
      });

      test('sets unauthenticated state on sign up error', () async {
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

        final state = container.read(authStateProvider);
        expect(state, isA<AuthStateUnauthenticated>());
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
          overrides: [authServiceProvider.overrideWithValue(mockAuthService)],
        );

        // Initial state
        expect(
          newContainer.read(authStateProvider),
          isA<AuthStateUnauthenticated>(),
        );

        // Emit authenticated user
        controller.add(mockUser);
        await Future.delayed(const Duration(milliseconds: 10));

        // State should update to authenticated
        expect(
          newContainer.read(authStateProvider),
          isA<AuthStateAuthenticated>(),
        );

        // Emit null (sign out)
        controller.add(null);
        await Future.delayed(const Duration(milliseconds: 10));

        // State should update to unauthenticated
        expect(
          newContainer.read(authStateProvider),
          isA<AuthStateUnauthenticated>(),
        );
      });
    });

    group('isAuthenticated Provider', () {
      test('returns false when unauthenticated', () {
        final isAuth = container.read(isAuthenticatedProvider);
        expect(isAuth, isFalse);
      });

      test('returns true when authenticated', () {
        when(() => mockAuthService.currentUser).thenReturn(mockUser);

        final newContainer = ProviderContainer.test(
          overrides: [authServiceProvider.overrideWithValue(mockAuthService)],
        );

        final isAuth = newContainer.read(isAuthenticatedProvider);
        expect(isAuth, isTrue);
      });
    });

    group('currentUser Provider', () {
      test('returns null when unauthenticated', () {
        final user = container.read(currentUserProvider);
        expect(user, isNull);
      });

      test('returns user model when authenticated', () {
        when(() => mockAuthService.currentUser).thenReturn(mockUser);

        final newContainer = ProviderContainer.test(
          overrides: [authServiceProvider.overrideWithValue(mockAuthService)],
        );

        final user = newContainer.read(currentUserProvider);
        expect(user, isNotNull);
        expect(user?.uid, 'test-uid');
        expect(user?.email, 'test@example.com');
        expect(user?.displayName, 'Test User');
      });
    });

    group('Edge Cases', () {
      test('handles null display name', () {
        when(() => mockUser.displayName).thenReturn(null);
        when(() => mockAuthService.currentUser).thenReturn(mockUser);

        final newContainer = ProviderContainer.test(
          overrides: [authServiceProvider.overrideWithValue(mockAuthService)],
        );

        final user = newContainer.read(currentUserProvider);
        expect(user?.displayName, isNull);
      });

      test('handles empty email', () {
        when(() => mockUser.email).thenReturn('');
        when(() => mockAuthService.currentUser).thenReturn(mockUser);

        final newContainer = ProviderContainer.test(
          overrides: [authServiceProvider.overrideWithValue(mockAuthService)],
        );

        final user = newContainer.read(currentUserProvider);
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
