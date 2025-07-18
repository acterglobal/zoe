import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/contents/bullet-lists/providers/bullets_content_item_proivder.dart';

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
    final bulletsContent = ref.watch(
      bulletsContentItemProvider(bulletsContentId),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        isEditing
            ? _buildTitleTextField(context, ref, bulletsContent.title)
            : _buildTitleText(context, ref, bulletsContent.title),
        const SizedBox(height: 6),
        isEditing
            ? _buildDataTextField(context, ref, bulletsContent.bullets)
            : _buildDataText(context, ref, bulletsContent.bullets),
      ],
    );
  }

  Widget _buildTitleTextField(
    BuildContext context,
    WidgetRef ref,
    String title,
  ) {
    final controller = TextEditingController(text: title);
    return TextField(
      controller: controller,
      maxLines: null,
      style: Theme.of(context).textTheme.titleMedium,
      decoration: InputDecoration(hintText: 'Title'),
    );
  }

  Widget _buildDataTextField(
    BuildContext context,
    WidgetRef ref,
    List<String> bullets,
  ) {
    return ListView.builder(
      itemCount: bullets.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final controller = TextEditingController(text: bullets[index]);
        return Row(
          children: [
            Icon(Icons.circle_sharp, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: null,
                decoration: InputDecoration(hintText: 'Bullets'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTitleText(BuildContext context, WidgetRef ref, String title) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }

  Widget _buildDataText(
    BuildContext context,
    WidgetRef ref,
    List<String> bullets,
  ) {
    return ListView.builder(
      itemCount: bullets.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Row(
        children: [
          Icon(Icons.circle_sharp, size: 6),
          const SizedBox(width: 8),
          Expanded(child: Text(bullets[index])),
        ],
      ),
    );
  }
}
