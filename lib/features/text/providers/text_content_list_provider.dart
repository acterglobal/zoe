import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/providers/content_providers.dart';
import 'package:zoey/features/text/models/text_model.dart';

final textContentListProvider = Provider<List<TextModel>>((ref) {
  return ref.watch(contentListProvider).whereType<TextModel>().toList();
});
