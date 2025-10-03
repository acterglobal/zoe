import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/bullets/actions/bullet_actions.dart';
import 'package:zoe/features/bullets/model/bullet_model.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import 'package:zoe/features/bullets/screens/bullet_detail_screen.dart';
import 'package:zoe/features/users/models/user_model.dart';

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

Future<void> pumpBulletDetailScreen({
  required WidgetTester tester,
  required ProviderContainer container,
  required String bulletId,
  bool isWrapMediaQuery = false,
}) async {
  // Create the screen
  final screen = BulletDetailScreen(bulletId: bulletId);

  // Wrap the screen in a MediaQuery if needed
  final child = isWrapMediaQuery
      ? MediaQuery(
          data: const MediaQueryData(size: Size(1080, 1920)),
          child: screen,
        )
      : screen;

  // Pump the screen
  await tester.pumpMaterialWidgetWithProviderScope(
    child: child,
    container: container,
  );
  await tester.pump(const Duration(milliseconds: 100));
}

// Test bullet data
const nonExistentBulletId = 'non-existent-id';
const testBulletId = 'test-bullet-id';
const testBulletTitle = 'Test Bullet Title';
const testParentId = 'test-parent-id';
const testSheetId = 'test-sheet-id';

// Test user data
const testUserId = 'user_1';
const testUserName = 'Test User';
const testUserBio = 'Test Bio';

final testUserModel = UserModel(
  id: testUserId,
  name: testUserName,
  bio: testUserBio,
);

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
    title: title ?? testBulletTitle,
    parentId: parentId ?? testParentId,
    sheetId: sheetId ?? testSheetId,
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
