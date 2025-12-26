import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/core/constants/firestore_constants.dart';

import 'firebase_storage_actions.dart';

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

  if (collectionName == FirestoreCollections.sheets) {
    await deleteSheetAvatarAndCoverImageFromStorage(ref, docsList);
  } else if (collectionName == FirestoreCollections.documents) {
    await deleteDocumentsFromStorage(ref, docsList);
  }

  // Delete all documents
  final batch = firestore.batch();
  for (final doc in docsList) {
    batch.delete(doc.reference);
  }
  await batch.commit();
}

// Creates a Firestore-safe whereIn filter for any list size.
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
