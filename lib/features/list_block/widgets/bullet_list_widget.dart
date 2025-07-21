import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/list_block/providers/bullet_list_providers.dart';
import 'package:zoey/features/list_block/widgets/bullet_item_widget.dart';

class BulletListWidget extends ConsumerWidget {
  final String listBlockId;
  final bool isEditing;
  const BulletListWidget({
    super.key,
    required this.listBlockId,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bullets = ref.watch(bulletListProvider(listBlockId));
    if (bullets == null || bullets.isEmpty) return const SizedBox.shrink();
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bullets.length,
      itemBuilder: (context, index) => BulletItemWidget(
        bulletItemId: bullets[index].id,
        isEditing: isEditing,
      ),
    );
  }
}
