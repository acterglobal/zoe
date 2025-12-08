import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/features/auth/services/auth_service.dart';

import '../utils/auth_utils.dart';

void main() {
  group('AuthService', () {
    late AuthService authService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;
    late MockUserCredential mockUserCredential;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();
      mockUserCredential = MockUserCredential();
      authService = AuthService(mockFirebaseAuth);

      // Setup default mock behaviors
      when(() => mockUser.uid).thenReturn('test-uid');
      when(() => mockUser.email).thenReturn('test@example.com');
      when(() => mockUser.displayName).thenReturn('Test User');
      when(() => mockUserCredential.user).thenReturn(mockUser);
    });

    group('signUp', () {
      test('creates user with email and password successfully', () async {
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => mockUserCredential);

        final result = await authService.signUp(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(result, equals(mockUserCredential));
        verify(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          ),
        ).called(1);
      });

      test('updates display name when provided', () async {
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => mockUserCredential);
        when(
          () => mockUser.updateDisplayName(any()),
        ).thenAnswer((_) async => {});
        when(() => mockUser.reload()).thenAnswer((_) async => {});

        await authService.signUp(
          email: 'test@example.com',
          password: 'password123',
          displayName: 'John Doe',
        );

        verify(() => mockUser.updateDisplayName('John Doe')).called(1);
        verify(() => mockUser.reload()).called(1);
      });

      test('does not update display name when not provided', () async {
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => mockUserCredential);

        await authService.signUp(
          email: 'test@example.com',
          password: 'password123',
        );

        verifyNever(() => mockUser.updateDisplayName(any()));
        verifyNever(() => mockUser.reload());
      });

      test('throws exception for weak password', () async {
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(FirebaseAuthException(code: 'weak-password'));

        expect(
          () => authService.signUp(email: 'test@example.com', password: '123'),
          throwsA(isA<Exception>()),
        );
      });

      test('throws exception for email already in use', () async {
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

        expect(
          () => authService.signUp(
            email: 'existing@example.com',
            password: 'password123',
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('throws exception for invalid email', () async {
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(FirebaseAuthException(code: 'invalid-email'));

        expect(
          () => authService.signUp(
            email: 'invalid-email',
            password: 'password123',
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('signIn', () {
      test('signs in user with email and password successfully', () async {
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => mockUserCredential);

        final result = await authService.signIn(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(result, equals(mockUserCredential));
        verify(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          ),
        ).called(1);
      });

      test('throws exception for user not found', () async {
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(FirebaseAuthException(code: 'user-not-found'));

        expect(
          () => authService.signIn(
            email: 'nonexistent@example.com',
            password: 'password123',
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('throws exception for wrong password', () async {
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(FirebaseAuthException(code: 'wrong-password'));

        expect(
          () => authService.signIn(
            email: 'test@example.com',
            password: 'wrongpassword',
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('throws exception for disabled user', () async {
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(FirebaseAuthException(code: 'user-disabled'));

        expect(
          () => authService.signIn(
            email: 'disabled@example.com',
            password: 'password123',
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('throws exception for too many requests', () async {
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(FirebaseAuthException(code: 'too-many-requests'));

        expect(
          () => authService.signIn(
            email: 'test@example.com',
            password: 'password123',
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('signOut', () {
      test('signs out user successfully', () async {
        when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async => {});
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

        await authService.signOut();

        verify(() => mockFirebaseAuth.signOut()).called(1);
      });

      test('handles sign out errors', () async {
        when(() => mockFirebaseAuth.signOut()).thenThrow(Exception('Error'));

        expect(() => authService.signOut(), throwsA(isA<Exception>()));
      });
    });

    group('currentUser', () {
      test('returns current user when authenticated', () {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

        final user = authService.currentUser;

        expect(user, equals(mockUser));
      });

      test('returns null when not authenticated', () {
        when(() => mockFirebaseAuth.currentUser).thenReturn(null);

        final user = authService.currentUser;

        expect(user, isNull);
      });
    });

    group('authStateChanges', () {
      test('emits auth state changes', () {
        final stream = Stream<User?>.fromIterable([null, mockUser, null]);
        when(
          () => mockFirebaseAuth.authStateChanges(),
        ).thenAnswer((_) => stream);

        expect(
          authService.authStateChanges,
          emitsInOrder([null, mockUser, null]),
        );
      });
    });

    group('Error Handling', () {
      test('handles unknown Firebase auth errors', () async {
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(FirebaseAuthException(code: 'unknown-error'));

        expect(
          () => authService.signIn(
            email: 'test@example.com',
            password: 'password123',
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('handles non-Firebase exceptions', () async {
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception('Network error'));

        expect(
          () => authService.signIn(
            email: 'test@example.com',
            password: 'password123',
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Edge Cases', () {
      test('handles empty email and password', () async {
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(FirebaseAuthException(code: 'invalid-email'));

        expect(
          () => authService.signIn(email: '', password: ''),
          throwsA(isA<Exception>()),
        );
      });

      test('handles null user in credential', () async {
        when(() => mockUserCredential.user).thenReturn(null);
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => mockUserCredential);

        final result = await authService.signUp(
          email: 'test@example.com',
          password: 'password123',
          displayName: 'Test User',
        );

        expect(result.user, isNull);
        verifyNever(() => mockUser.updateDisplayName(any()));
      });
    });
  });
}
