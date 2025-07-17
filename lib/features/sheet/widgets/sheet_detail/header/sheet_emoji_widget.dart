import 'package:flutter/material.dart';

/// Emoji widget for sheet header
class SheetEmojiWidget extends StatelessWidget {
  final String emoji;
  final bool isEditing;
  final VoidCallback onTap;

  const SheetEmojiWidget({
    super.key,
    required this.emoji,
    required this.isEditing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEditing ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(emoji, style: const TextStyle(fontSize: 32)),
      ),
    );
  }
}
