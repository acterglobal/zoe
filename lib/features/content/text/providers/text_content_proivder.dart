import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/text/models/text_content_model.dart';
import 'package:zoey/features/content/text/providers/text_content_list_provider.dart';

final textContentProvider = Provider.family<TextContentModel?, String>((
  ref,
  String textContentId,
) {
  final textContents = ref.watch(textContentListProvider);
  try {
    return textContents.firstWhere(
      (textContent) => textContent.id == textContentId,
    );
  } catch (e) {
    // Return null if no matching text content is found
    return null;
  }
});

final textContentTitleUpdateProvider = Provider<void Function(String, String)>((
  ref,
) {
  return (String textContentId, String title) {
    ref
        .read(textContentListProvider.notifier)
        .updateTextContent(textContentId, title: title);
  };
});

final textContentDescriptionUpdateProvider =
    Provider<void Function(String, String, String)>((ref) {
      return (
        String textContentId,
        String plainTextDescription,
        String htmlDescription,
      ) {
        ref
            .read(textContentListProvider.notifier)
            .updateTextContent(
              textContentId,
              plainTextDescription: plainTextDescription,
              htmlDescription: htmlDescription,
            );
      };
    });
