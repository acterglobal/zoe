import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/features/home/zoe_preview_widget.dart';
import 'package:zoe/features/bullets/model/bullet_model.dart';
import 'package:zoe/features/bullets/screens/bullet_detail_screen.dart';
import 'package:zoe/features/bullets/widgets/bullet_list_widget.dart';
import '../mock_bullet_providers.dart';

@widgetbook.UseCase(name: 'Bullet List Screen', type: BulletListWidget)
Widget buildBulletListScreenUseCase(BuildContext context) {
  final parentId = context.knobs.string(
    label: 'Parent ID',
    initialValue: 'list-bulleted-trip-1',
  );

  final isEditing = context.knobs.boolean(
    label: 'Is Editing',
    initialValue: false,
  );

  final bulletCount = context.knobs.int.input(
    label: 'Number of Bullets',
    initialValue: 3,
  );

  final bullets = List.generate(bulletCount, (index) {
    return BulletModel(
      id: 'bullet-$index',
      title: context.knobs.string(
        label: 'Bullet ${index + 1} Title',
        initialValue: 'Bullet ${index + 1}',
      ),
      parentId: parentId,
      sheetId: 'sheet-1',
      createdAt: DateTime.now().subtract(Duration(days: index)),
      updatedAt: DateTime.now(),
    );
  });

  return ProviderScope(
    overrides: [
      mockBulletListProvider.overrideWith((ref) => MockBulletNotifier(ref)..setBullets(bullets)),
    ],
    child: ZoePreview(
      child: BulletListWidget(
        parentId: parentId,
        isEditing: isEditing,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Bullet Detail Screen', type: BulletDetailScreen)
Widget buildBulletDetailScreenUseCase(BuildContext context) {
  final bulletId = context.knobs.string(
    label: 'Bullet ID',
    initialValue: 'bullet-trip-destinations-1',
  );

  final bullet = BulletModel(
    id: bulletId,
    title: context.knobs.string(
      label: 'Bullet Title',
      initialValue: 'Sample Bullet',
    ),
    parentId: 'list-1',
    sheetId: 'sheet-1',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  return ProviderScope(
    overrides: [
      mockBulletListProvider.overrideWith((ref) => MockBulletNotifier(ref)..setBullets([bullet])),
    ],
    child: ZoePreview(
      child: BulletDetailScreen(bulletId: bulletId),
    ),
  );
}
