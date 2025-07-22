import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/providers/content_menu_providers.dart';

class EmojiWidget extends ConsumerWidget {
  final String emoji;
  final double? size;
  final Function(String) onTap;
  const EmojiWidget({
    super.key,
    required this.emoji,
    this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(isEditValueProvider);
    return GestureDetector(
      onTap: () => isEditing ? onTap(emoji) : null,
      child: Padding(
        padding: const EdgeInsets.only(top: 3, right: 6),
        child: Text(emoji, style: TextStyle(fontSize: size ?? 14)),
      ),
    );
  }
}
