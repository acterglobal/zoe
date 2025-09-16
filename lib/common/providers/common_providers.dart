import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchValueProvider = StateProvider.autoDispose<String>((ref) => '');

final editContentIdProvider = StateProvider<String?>((ref) => null);
