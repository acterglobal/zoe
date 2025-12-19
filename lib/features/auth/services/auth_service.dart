import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:zoe/common/providers/common_providers.dart';

/// Provider for AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return AuthService(firebaseAuth);
});

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
      rethrow;
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
      rethrow;
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
      rethrow;
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
      await _firebaseAuth.signOut();
      _logger.info('Successfully deleted account');
    } on FirebaseAuthException catch (e) {
      _logger.warning('Delete account failed: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      _logger.severe('Error during deleting account: $e');
      rethrow;
    }
  }
}
