import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/bullets/actions/bullet_actions.dart';
import 'package:zoe/features/bullets/model/bullet_model.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';

import '../../../helpers/test_utils.dart';

Future<void> pumpBulletShareActionsWidget({
  required WidgetTester tester,
  required ProviderContainer container,
  required String bulletId,
}) async {
  await tester.pumpMaterialWidgetWithProviderScope(
    container: container,
    child: Consumer(
      builder: (context, ref, child) => ElevatedButton(
        onPressed: () => BulletActions.shareBullet(context, bulletId),
        child: const Text('Share'),
      ),
    ),
  );
}

Future<void> pumpBulletCopyActionsWidget({
  required WidgetTester tester,
  required ProviderContainer container,
  required String bulletId,
}) async {
  await tester.pumpMaterialWidgetWithProviderScope(
    container: container,
    child: Consumer(
      builder: (context, ref, child) => ElevatedButton(
        onPressed: () => BulletActions.copyBullet(context, ref, bulletId),
        child: const Text('Copy'),
      ),
    ),
  );
}

Future<void> pumpBulletEditActionsWidget({
  required WidgetTester tester,
  required ProviderContainer container,
  required String bulletId,
}) async {
  await tester.pumpMaterialWidgetWithProviderScope(
    container: container,
    child: Consumer(
      builder: (context, ref, child) => ElevatedButton(
        onPressed: () => BulletActions.editBullet(ref, bulletId),
        child: const Text('Edit'),
      ),
    ),
  );
}

Future<void> pumpBulletDeleteActionsWidget({
  required WidgetTester tester,
  required ProviderContainer container,
  required String bulletId,
}) async {
  await tester.pumpMaterialWidgetWithProviderScope(
    container: container,
    child: Consumer(
      builder: (context, ref, child) => ElevatedButton(
        onPressed: () => BulletActions.deleteBullet(context, ref, bulletId),
        child: const Text('Delete'),
      ),
    ),
  );
}

/// Helper function to add a bullet to the container and return the bullet model
BulletModel addBulletAndGetModel(
  ProviderContainer container, {
  String? title,
  String? parentId,
  String? sheetId,
  int? orderIndex,
}) {
  final notifier = container.read(bulletListProvider.notifier);
  notifier.addBullet(
    title: title ?? 'Test Bullet',
    parentId: parentId ?? 'parent-1',
    sheetId: sheetId ?? 'sheet-1',
    orderIndex: orderIndex,
  );

  // Bullet ID is the last bullet in the list
  final bulletList = container.read(bulletListProvider);
  if (bulletList.isEmpty) fail('Bullet list is empty');
  if (orderIndex != null) {
    return bulletList.firstWhere(
      (b) => b.orderIndex == orderIndex,
      orElse: () => fail('Bullet with order index $orderIndex not found'),
    );
  }
  return bulletList.last;
}
