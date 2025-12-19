import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/snackbar_service.dart';

part 'common_providers.g.dart';

@riverpod
class SearchValue extends _$SearchValue {
  @override
  String build() => '';

  void update(String value) => state = value;
}

final editContentIdProvider = StateProvider<String?>((ref) => null);

/// Provider for FirebaseAuth instance
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Firebase reference
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// Snackbar service provider
final snackbarServiceProvider = Provider<SnackbarService>(
  (ref) => SnackbarService(),
);
