import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/bullets/model/bullet_model.dart';
import 'package:zoe/features/bullets/providers/bullet_notifiers.dart';
import 'package:zoe/common/providers/common_providers.dart';

class MockBulletNotifier extends BulletNotifier {
  MockBulletNotifier(super.ref);

  void setBullets(List<BulletModel> bullets) {
    state = bullets;
  }

  @override
  void deleteBullet(String bulletId) {
    state = state.where((bullet) => bullet.id != bulletId).toList();
  }
}

final mockBulletListProvider = StateNotifierProvider<BulletNotifier, List<BulletModel>>(
  (ref) => MockBulletNotifier(ref),
);

final mockBulletProvider = Provider.family<BulletModel?, String>((ref, bulletId) {
  final bulletList = ref.watch(mockBulletListProvider);
  return bulletList.where((b) => b.id == bulletId).firstOrNull;
}, dependencies: [mockBulletListProvider]);

final mockBulletListByParentProvider = Provider.family<List<BulletModel>, String>((
  ref,
  parentId,
) {
  final bulletList = ref.watch(mockBulletListProvider);
  return bulletList.where((b) => b.parentId == parentId).toList();
}, dependencies: [mockBulletListProvider]);

final mockBulletListSearchProvider = Provider<List<BulletModel>>((ref) {
  final bulletList = ref.watch(mockBulletListProvider);
  final searchValue = ref.watch(searchValueProvider);
  if (searchValue.isEmpty) return bulletList;
  return bulletList
      .where((b) => b.title.toLowerCase().contains(searchValue.toLowerCase()))
      .toList();
}, dependencies: [mockBulletListProvider, searchValueProvider]);
