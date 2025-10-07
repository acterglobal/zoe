import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/models/user_display_type.dart';
import 'package:zoe/features/bullets/model/bullet_model.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import 'package:zoe/features/bullets/widgets/bullet_item_widget.dart';

import '../../../test-utils/test_utils.dart';

BulletModel getBulletModelByIndex(ProviderContainer container, int index) {
  final bulletList = container.read(bulletListProvider);
  if (bulletList.isEmpty) fail('Bullet list is empty');
  if (index < 0 || index >= bulletList.length) {
    fail('Bullet index is out of bounds');
  }
  return bulletList[index];
}

// Pump actions widget
Future<void> pumpActionsWidget({
  required WidgetTester tester,
  required ProviderContainer container,
  required String buttonText,
  required Function(BuildContext, WidgetRef) onPressed,
}) async {
  await tester.pumpMaterialWidgetWithProviderScope(
    container: container,
    child: Consumer(
      builder: (context, ref, child) => ElevatedButton(
        onPressed: () => onPressed(context, ref),
        child: Text(buttonText),
      ),
    ),
  );
}

// Pump bullet item widget
Future<void> pumpBulletItemWidget({
  required WidgetTester tester,
  required ProviderContainer container,
  required String bulletId,
  bool isEditing = false,
  ZoeUserDisplayType userDisplayType = ZoeUserDisplayType.avatarOnly,
  GoRouter? router,
}) async {
  await tester.pumpMaterialWidgetWithProviderScope(
    child: BulletItemWidget(
      bulletId: bulletId,
      isEditing: isEditing,
      userDisplayType: userDisplayType,
    ),
    container: container,
    router: router,
  );
  await tester.pumpAndSettle();
}