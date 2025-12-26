import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:zoe/common/providers/common_providers.dart';

final log = Logger('Firebase-Utils');

// Helper function to run Firestore operations
Future<T?> runFirestoreOperation<T>(
  Ref ref,
  Future<T> Function() operation,
) async {
  final snackbar = ref.read(snackbarServiceProvider);

  try {
    return await operation();
  } on FirebaseException catch (e, stackTrace) {
    log.severe(
      'Firestore error: ${e.code} | message: ${e.message}',
      e,
      stackTrace,
    );
    snackbar.show(getFirebaseErrorMessage(e));
    return null;
  } catch (e, stackTrace) {
    log.severe('Unknown non-Firebase error', e, stackTrace);
    snackbar.show('Something went wrong.');
    return null;
  }
}

// Helper function to get Firebase error message
String getFirebaseErrorMessage(Object e) {
  // 1. Handle Authentication Errors
  if (e is FirebaseAuthException) {
    switch (e.code) {
      case 'invalid-credential':
        return 'Invalid credential. Please try again.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'email-already-in-use':
        return 'An account already exists with same email.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled in Firebase Console.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }

  // 2. Handle Firestore Errors
  if (e is FirebaseException) {
    switch (e.code) {
      case 'permission-denied':
        return 'Access denied. Check your Firestore security rules.';
      case 'not-found':
        return 'The requested document does not exist.';
      case 'unavailable':
        return 'Network error. Please check your internet connection.';
      case 'resource-exhausted':
        return 'Daily quota exceeded. Please contact support.';
      case 'deadline-exceeded':
        return 'The request took too long. Try again.';
      default:
        return e.message ?? 'A database error occurred.';
    }
  }

  return 'An unexpected error occurred.';
}
