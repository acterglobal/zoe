import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'common_providers.g.dart';

@riverpod
class SearchValue extends _$SearchValue {
  @override
  String build() => '';

  void update(String value) => state = value;
}

final editContentIdProvider = StateProvider<String?>((ref) => null);

/// Firebase reference
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});
