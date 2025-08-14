import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import 'package:zoe/features/bullets/widgets/bullet_item_widget.dart';

class BulletListWidget extends ConsumerWidget {
  final String parentId;
  final bool isEditing;

  const BulletListWidget({
    super.key,
    required this.parentId,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bullets = ref.watch(bulletListByParentProvider(parentId));
    if (bullets.isEmpty) return const SizedBox.shrink();

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bullets.length,
      itemBuilder: (context, index) {
        final bullet = bullets[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 4, top: 4, left: 12),
          child: BulletItemWidget(
            key: ValueKey(bullet.id),
            bulletId: bullet.id,
            isEditing: isEditing,
          ),
        );
      },
    );
  }
}
