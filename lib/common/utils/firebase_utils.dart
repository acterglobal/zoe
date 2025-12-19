import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:zoe/common/providers/common_providers.dart';

final log = Logger('ZoeApp-FireStore');

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

    switch (e.code) {
      case 'invalid-credential':
        snackbar.show('Invalid credentials.');
      case 'permission-denied':
        snackbar.show('You do not have permission.');
        break;
      case 'not-found':
        snackbar.show('Document not found.');
        break;
      case 'unavailable':
        snackbar.show('Network unavailable.');
        break;
      default:
        snackbar.show('Unexpected Firestore error.');
    }

    return null;
  } catch (e, stackTrace) {
    log.severe('Unknown non-Firebase error', e, stackTrace);

    snackbar.show('Something went wrong.');
    return null;
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

const int _whereInLimit = 30;

/// Creates a Firestore-safe whereIn filter for any list size.
/// Enforces Firestore limits strictly.
Filter whereInFilter(String field, List<Object?> values) {
  assert(values.isNotEmpty, 'values must not be empty');

  // Case 1: Simple whereIn
  if (values.length <= _whereInLimit) {
    return Filter(field, whereIn: values);
  }

  // Split into batches of 30
  final filters = <Filter>[];
  for (var i = 0; i < values.length; i += _whereInLimit) {
    filters.add(
      Filter(
        field,
        whereIn: values.sublist(
          i,
          i + _whereInLimit > values.length ? values.length : i + _whereInLimit,
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
