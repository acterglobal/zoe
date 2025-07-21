import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/list/list_bullets/model/bullet_item_model.dart';
import 'package:zoey/features/content/list/list_bullets/providers/notifiers/bullet_list_notifier.dart';

final bulletListProvider =
    StateNotifierProvider<BulletListNotifier, List<BulletItem>>((ref) {
      return BulletListNotifier();
    });

final bulletListByBlockProvider = Provider.family<List<BulletItem>, String>((
  ref,
  String listId,
) {
  final bulletList = ref.watch(bulletListProvider);
  return bulletList.where((bullet) => bullet.listId == listId).toList();
});
