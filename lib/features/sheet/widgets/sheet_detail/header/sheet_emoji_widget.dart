import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';

/// Emoji widget for sheet header
class SheetEmojiWidget extends ConsumerWidget {
  final String sheetId;

  const SheetEmojiWidget({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSheet = ref.watch(sheetProvider(sheetId));
    return GestureDetector(
      onTap: () =>
          ref.read(sheetDetailProvider(sheetId).notifier).updateEmoji(),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          currentSheet.emoji ?? '📄',
          style: const TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}
