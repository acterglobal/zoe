import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/providers/content_list_providers.dart';
import 'package:zoey/features/list/models/list_model.dart';

final listsProvider = Provider<List<ListModel>>((ref) {
  return ref.watch(contentNotifierProvider).whereType<ListModel>().toList();
});
