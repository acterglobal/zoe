import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/text_block/models/text_block_model.dart';
import 'package:zoey/features/text_block/providers/text_block_list_provider.dart';

final textBlockProvider = Provider.family<TextBlockModel?, String>((
  ref,
  String textBlockId,
) {
  final textBlocks = ref.watch(textBlockListProvider);
  try {
    return textBlocks.firstWhere((textBlock) => textBlock.id == textBlockId);
  } catch (e) {
    // Return null if no matching text block is found
    return null;
  }
});

final textBlockTitleUpdateProvider = Provider<void Function(String, String)>((
  ref,
) {
  return (String blockId, String title) {
    ref.read(textBlockListProvider.notifier).updateBlock(blockId, title: title);
  };
});

final textBlockDescriptionUpdateProvider =
    Provider<void Function(String, String)>((ref) {
      return (String blockId, String description) {
        ref
            .read(textBlockListProvider.notifier)
            .updateBlock(blockId, description: description);
      };
    });
