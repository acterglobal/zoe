import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
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

// Helper function to upload a file to Firebase Storage
Future<String?> uploadFileToStorage({
  required Ref ref,
  required String bucketName,
  String? subFolderName,
  required XFile file,
}) async {
  final snackbar = ref.read(snackbarServiceProvider);
  final firebaseStorage = ref.read(firebaseStorageProvider);

  try {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '${timestamp}_${basename(file.path)}';

    // Create a reference to the file
    final storageRef = firebaseStorage.ref().child(
      '$bucketName/${subFolderName != null ? '$subFolderName/' : ''}$fileName',
    );

    // Wait for the upload to complete
    final TaskSnapshot snapshot = await storageRef.putFile(File(file.path));

    // Get the download URL
    return await snapshot.ref.getDownloadURL();
  } on FirebaseException catch (e) {
    snackbar.show(getFirebaseErrorMessage(e));
    return null;
  }
}

// Helper function to delete a file from Firebase Storage
Future<void> deleteFileFromStorage({
  required Ref ref,
  required String fileUrl,
}) async {
  final snackbar = ref.read(snackbarServiceProvider);
  final firebaseStorage = ref.read(firebaseStorageProvider);

  try {
    // Create a reference to the file using its download URL
    final storageRef = firebaseStorage.refFromURL(fileUrl);
    // Delete the file
    await storageRef.delete();
  } on FirebaseException catch (e) {
    snackbar.show(getFirebaseErrorMessage(e));
  }
}

// Delete content documents related to field name and isEqualTo
Future<void> runFirestoreDeleteContentOperation({
  required Ref ref,
  required String collectionName,
  required String fieldName,
  required String isEqualTo,
}) async {
  final firestore = ref.read(firestoreProvider);

  // Get all documents with the given sheetId
  final docsData = await firestore
      .collection(collectionName)
      .where(Filter(fieldName, isEqualTo: isEqualTo))
      .get();
  final docsList = docsData.docs;
  if (docsList.isEmpty) return;

  // Delete all documents
  final batch = firestore.batch();
  for (final doc in docsList) {
    batch.delete(doc.reference);
  }
  await batch.commit();
}

/// Creates a Firestore-safe whereIn filter for any list size.
/// Enforces Firestore limits strictly.
Filter whereInFilter(String field, List<Object?> values) {
  assert(values.isNotEmpty, 'values must not be empty');
  const int whereInLimit = 30;

  // Case 1: Simple whereIn
  if (values.length <= whereInLimit) {
    return Filter(field, whereIn: values);
  }

  // Split into batches of 30
  final filters = <Filter>[];
  for (var i = 0; i < values.length; i += whereInLimit) {
    filters.add(
      Filter(
        field,
        whereIn: values.sublist(
          i,
          i + whereInLimit > values.length ? values.length : i + whereInLimit,
        ),
      ),
    );
  }

  assert(filters.length >= 2, 'At least two filters are required');

  Filter combined = Filter.or(filters[0], filters[1]);

  for (var i = 2; i < filters.length; i++) {
    combined = Filter.or(combined, filters[i]);
  }

  return combined;
}
