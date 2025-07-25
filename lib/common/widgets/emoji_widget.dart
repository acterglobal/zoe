import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmojiWidget extends ConsumerWidget {
  final String emoji;
  final double? size;
  final bool isEditing;
  final Function(String) onTap;

  const EmojiWidget({
    super.key,
    required this.emoji,
    required this.isEditing,
    this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => isEditing ? onTap(emoji) : null,
      child: Padding(
        padding: const EdgeInsets.only(top: 3, right: 6),
        child: Text(emoji, style: TextStyle(fontSize: size ?? 14)),
      ),
    );
  }
}
