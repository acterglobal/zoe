import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/bullets/model/bullet_model.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';

BulletModel getBulletByIndex(ProviderContainer container, {int index = 0}) {
  final bulletList = container.read(bulletListProvider);
  if (bulletList.isEmpty) fail('Bullet list is empty');
  if (index < 0 || index >= bulletList.length) {
    fail('Bullet index is out of bounds');
  }
  return bulletList[index];
}
