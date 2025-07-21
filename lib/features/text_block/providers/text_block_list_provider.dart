import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/text_block/data/text_block_list.dart';
import 'package:zoey/features/text_block/models/text_block_model.dart';

// StateNotifier provider for the text block list
final textBlockListProvider =
    StateNotifierProvider<TextBlockListNotifier, List<TextBlockModel>>((ref) {
      return TextBlockListNotifier();
    });

// StateNotifier for managing the text block list
class TextBlockListNotifier extends StateNotifier<List<TextBlockModel>> {
  TextBlockListNotifier() : super(textBlockList);

  // Update a specific text block item
  void updateBlock(String textBlockId, {String? title, String? description}) {
    state = state.map((textBlock) {
      if (textBlock.id == textBlockId) {
        return textBlock.copyWith(
          title: title ?? textBlock.title,
          description: description ?? textBlock.description,
        );
      }
      return textBlock;
    }).toList();

    // Also update the original list to keep it in sync
    final index = textBlockList.indexWhere(
      (element) => element.id == textBlockId,
    );
    if (index != -1) {
      textBlockList[index] = state.firstWhere(
        (textBlock) => textBlock.id == textBlockId,
      );
    }
  }

  // Add new text block
  void addBlock(TextBlockModel textBlock) {
    state = [...state, textBlock];
    textBlockList.add(textBlock);
  }

  // Remove text block
  void removeBlock(String textBlockId) {
    state = state.where((textBlock) => textBlock.id != textBlockId).toList();
    textBlockList.removeWhere((element) => element.id == textBlockId);
  }
}
