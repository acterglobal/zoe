import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/bullets/providers/bullet_list_providers.dart';
import 'package:zoey/features/bullets/widgets/bullet_item_widget.dart';

class BulletListWidget extends ConsumerWidget {
  final String listId;
  final bool isEditing;

  const BulletListWidget({
    super.key,
    required this.listId,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bullets = ref.watch(bulletListByBlockProvider(listId));
    if (bullets.isEmpty) return const SizedBox.shrink();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bullets.length,
      itemBuilder: (context, index) {
        final bullet = bullets[index];
        return BulletItemWidget(
          key: ValueKey(bullet.id),
          bulletItemId: bullet.id,
          isEditing: isEditing,
        );
      },
    );
  }
}
