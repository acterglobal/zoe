import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/models/content_model.dart';
import 'package:zoey/features/content/providers/content_notifier.dart';

final contentListProvider =
    StateNotifierProvider<ContentListNotifier, List<ContentModel>>((ref) {
      return ContentListNotifier();
    });

final contentListByParentIdProvider =
    Provider.family<List<ContentModel>, String>((ref, parentId) {
      final contentList = ref.watch(contentListProvider);
      return contentList.where((content) {
        return content.parentId == parentId;
      }).toList();
    });
