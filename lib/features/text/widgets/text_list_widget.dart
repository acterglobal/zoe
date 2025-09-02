import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/text/models/text_model.dart';
import 'package:zoe/features/text/widgets/text_widget.dart';

class TextListWidget extends ConsumerWidget {
  final ProviderBase<List<TextModel>> textsProvider;
  final bool isEditing;
  final bool shrinkWrap;

  const TextListWidget({
    super.key,
    required this.textsProvider,
    required this.isEditing,
    this.shrinkWrap = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final texts = ref.watch(textsProvider);
    if (texts.isEmpty) return const SizedBox.shrink();

    return ListView.builder(
      shrinkWrap: shrinkWrap,
      padding: EdgeInsets.zero,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
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
