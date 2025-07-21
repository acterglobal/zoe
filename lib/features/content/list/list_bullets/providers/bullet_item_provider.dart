import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/bullets/model/bullet_item_model.dart';
import 'package:zoey/features/bullets/providers/bullet_list_providers.dart';

final bulletItemProvider = Provider.family<BulletItem?, String>((
  ref,
  String bulletItemId,
) {
  final bulletList = ref.watch(bulletListProvider);
  try {
    return bulletList.firstWhere((bullet) => bullet.id == bulletItemId);
  } catch (e) {
    return null;
  }
});

final bulletItemTitleUpdateProvider = Provider<void Function(String, String)>((
  ref,
) {
  return (String bulletItemId, String title) {
    ref.read(bulletListProvider.notifier).updateBullet(bulletItemId, title);
  };
});

final bulletItemDeleteProvider = Provider<void Function(String)>((ref) {
  return (String bulletItemId) {
    ref.read(bulletListProvider.notifier).deleteBullet(bulletItemId);
  };
});
