import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

/// Service for handling Firebase Authentication operations
class AuthService {
  final FirebaseAuth _firebaseAuth;
  final Logger _logger = Logger('AuthService');

  AuthService(this._firebaseAuth);

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Get the current user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Sign up with email and password
  Future<UserCredential> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      _logger.info('Attempting to sign up user');
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (displayName != null && userCredential.user != null) {
        await userCredential.user!.updateDisplayName(displayName);
        await userCredential.user!.reload();
      }

      _logger.info('Successfully signed up user: ${userCredential.user?.uid}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _logger.warning('Sign up failed: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      _logger.severe('Unexpected error during sign up: $e');
      rethrow;
    }
  }

  /// Sign in with email and password
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _logger.info('Attempting to sign in user');
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _logger.info('Successfully signed in user: ${userCredential.user?.uid}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _logger.warning('Sign in failed: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      _logger.severe('Unexpected error during sign in: $e');
      rethrow;
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      _logger.info('Signing out user: ${_firebaseAuth.currentUser?.uid}');
      await _firebaseAuth.signOut();
      _logger.info('Successfully signed out');
    } on FirebaseAuthException catch (e) {
      _logger.warning('Signing out failed: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      _logger.severe('Error during sign out: $e');
      rethrow;
    }
  }

  /// Delete account of the current user
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user is currently signed in.',
        );
      }
      _logger.info('Deleting account of user: ${user.uid}');
      await user.delete();
      _logger.info('Successfully deleted account');
    } on FirebaseAuthException catch (e) {
      _logger.warning('Delete account failed: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      _logger.severe('Error during deleting account: $e');
      rethrow;
    }
  }

  /// Handle Firebase Auth exceptions and convert to user-friendly messages
  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return Exception(
          'The password is too weak. Please use a stronger password.',
        );
      case 'email-already-in-use':
        return Exception('An account already exists with this email.');
      case 'invalid-email':
        return Exception('The email address is not valid.');
      case 'user-not-found':
        return Exception('No account found with this email.');
      case 'wrong-password':
        return Exception('Incorrect password. Please try again.');
      case 'user-disabled':
        return Exception('This account has been disabled.');
      case 'too-many-requests':
        return Exception('Too many attempts. Please try again later.');
      case 'operation-not-allowed':
        return Exception('Email/password sign-in is not enabled.');
      default:
        return Exception(e.message);
    }
  }
}

/// Provider for FirebaseAuth instance
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Provider for AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return AuthService(firebaseAuth);
});
