import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Zoe/features/text/providers/text_providers.dart';
import 'package:Zoe/features/text/widgets/text_widget.dart';

class TextListWidget extends ConsumerWidget {
  final String parentId;
  final bool isEditing;

  const TextListWidget({
    super.key,
    required this.parentId,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final texts = ref.watch(textByParentProvider(parentId));
    if (texts.isEmpty) return const SizedBox.shrink();

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: texts.length,
      itemBuilder: (context, index) {
        final text = texts[index];
        return Padding(
          padding: const EdgeInsets.only(left: 24),
          child: TextWidget(
            key: ValueKey(text.id),
            textId: text.id,
            isEditing: isEditing,
          ),
        );
      },
    );
  }
}
