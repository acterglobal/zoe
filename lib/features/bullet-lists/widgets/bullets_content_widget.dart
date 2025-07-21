import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoey/common/widgets/toolkit/zoe_close_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_delete_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/core/routing/app_routes.dart';
import 'package:zoey/features/bullet-lists/models/bullets_content_model.dart';
import 'package:zoey/features/bullet-lists/providers/bullets_content_item_proivder.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';

class BulletsContentWidget extends ConsumerWidget {
  final String bulletsContentId;
  final bool isEditing;
  const BulletsContentWidget({
    super.key,
    required this.bulletsContentId,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Icon(
                Icons.list,
                size: 16,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: ZoeInlineTextEditWidget(
                hintText: 'List title',
                isEditing: isEditing,
                text: ref
                    .watch(bulletsContentItemProvider(bulletsContentId))
                    .title,
                textStyle: Theme.of(context).textTheme.bodyLarge,
                onTextChanged: (value) => ref
                    .read(bulletsContentUpdateProvider)
                    .call(bulletsContentId, title: value),
              ),
            ),
            const SizedBox(width: 6),
            if (isEditing)
              ZoeDeleteButtonWidget(
                onTap: () {
                  final bulletsContent = ref.read(
                    bulletsContentItemProvider(bulletsContentId),
                  );
                  ref
                      .read(
                        sheetDetailProvider(bulletsContent.parentId).notifier,
                      )
                      .deleteContent(bulletsContentId);
                },
              ),
          ],
        ),
        const SizedBox(height: 6),
        _buildBulletsList(context, ref),
        if (isEditing)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: GestureDetector(
              onTap: () {
                final currentBulletsContent = ref.read(
                  bulletsContentItemProvider(bulletsContentId),
                );
                final updatedBullets = [
                  ...currentBulletsContent.bullets,
                  BulletItem(title: ''),
                ];
                ref
                    .read(bulletsContentUpdateProvider)
                    .call(bulletsContentId, bullets: updatedBullets);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.add,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Add item',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBulletsList(BuildContext context, WidgetRef ref) {
    final bulletsContent = ref.watch(
      bulletsContentItemProvider(bulletsContentId),
    );
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bulletsContent.bullets.length,
      itemBuilder: (context, index) =>
          _buildBulletItem(context, ref, bulletsContent, index),
    );
  }

  Widget _buildBulletItem(
    BuildContext context,
    WidgetRef ref,
    BulletsContentModel bulletsContent,
    int index,
  ) {
    final bulletItem = bulletsContent.bullets[index];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ZoeInlineTextEditWidget(
              hintText: 'List item',
              isEditing: isEditing,
              text: bulletItem.title,
              textStyle: Theme.of(context).textTheme.bodyMedium,
              onTextChanged: (value) => ref
                  .read(bulletsContentUpdateProvider)
                  .call(
                    bulletsContentId,
                    bullets: [
                      ...bulletsContent.bullets.map(
                        (bullet) => bullet.id == bulletItem.id
                            ? bullet.copyWith(title: value)
                            : bullet,
                      ),
                    ],
                  ),
            ),
          ),
          const SizedBox(width: 6),
          if (isEditing) ...[
            GestureDetector(
              onTap: () => context.push(
                AppRoutes.bulletDetail.route.replaceAll(
                  ':bulletId',
                  bulletItem.id,
                ),
              ),
              child: Icon(
                Icons.edit,
                size: 16,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(width: 6),
            ZoeCloseButtonWidget(
              onTap: () {
                final updatedItems = bulletsContent.bullets
                    .where((bullet) => bullet.id != bulletItem.id)
                    .toList();
                ref
                    .read(bulletsContentUpdateProvider)
                    .call(bulletsContentId, bullets: updatedItems);
              },
            ),
          ],
        ],
      ),
    );
  }
}
