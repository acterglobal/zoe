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
