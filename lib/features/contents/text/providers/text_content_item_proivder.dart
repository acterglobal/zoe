import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/contents/text/model/text_content_model.dart';
import 'package:zoey/features/contents/text/providers/text_content_list_provider.dart';

final textContentItemProvider = Provider.family<TextContentModel, String>((
  ref,
  String id,
) {
  return ref
      .watch(textContentListProvider)
      .firstWhere((element) => element.id == id);
});
