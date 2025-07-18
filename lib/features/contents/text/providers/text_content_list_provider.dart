import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/contents/text/data/text_content_list.dart';
import 'package:zoey/features/contents/text/model/text_content_model.dart';

final textContentListProvider = Provider<List<TextContentModel>>((ref) {
  return textContentList;
});
