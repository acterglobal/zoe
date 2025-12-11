import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../providers/common_providers.dart';

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
