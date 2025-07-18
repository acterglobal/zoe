import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/contents/text/providers/text_content_item_proivder.dart';

class TextContentWidget extends ConsumerWidget {
  final String textContentId;
  final bool isEditing;
  const TextContentWidget({
    super.key,
    required this.textContentId,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textContent = ref.watch(textContentItemProvider(textContentId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        isEditing
            ? _buildTitleTextField(context, ref, textContent.title)
            : _buildTitleText(context, ref, textContent.title),
        const SizedBox(height: 6),
        isEditing
            ? _buildDataTextField(context, ref, textContent.data)
            : _buildDataText(context, ref, textContent.data),
      ],
    );
  }

  Widget _buildTitleTextField(
    BuildContext context,
    WidgetRef ref,
    String title,
  ) {
    final controller = ref.watch(
      textContentTitleControllerProvider(textContentId),
    );
    final updateContent = ref.read(textContentUpdateProvider);

    return TextField(
      controller: controller,
      maxLines: null,
      style: Theme.of(context).textTheme.titleMedium,
      decoration: const InputDecoration(
        hintText: 'Title',
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      onChanged: (value) {
        updateContent(textContentId, 'title', value);
      },
    );
  }

  Widget _buildDataTextField(BuildContext context, WidgetRef ref, String data) {
    final controller = ref.watch(
      textContentDataControllerProvider(textContentId),
    );
    final updateContent = ref.read(textContentUpdateProvider);

    return TextField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyMedium,
      maxLines: null,
      decoration: const InputDecoration(
        hintText: 'Type something...',
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      onChanged: (value) {
        updateContent(textContentId, 'data', value);
      },
    );
  }

  Widget _buildTitleText(BuildContext context, WidgetRef ref, String title) {
    return Text(
      title.isEmpty ? 'Untitled' : title,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget _buildDataText(BuildContext context, WidgetRef ref, String data) {
    return Text(
      data.isEmpty ? '' : data,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
