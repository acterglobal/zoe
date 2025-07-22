import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/providers/content_providers.dart';
import 'package:zoey/features/text/models/text_model.dart';
import 'package:zoey/features/text/providers/text_content_list_provider.dart';

final textContentProvider = Provider.family<TextModel?, String>((
  ref,
  String textContentId,
) {
  try {
    return ref
        .watch(textContentListProvider)
        .firstWhere((textContent) => textContent.id == textContentId);
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
        .read(contentListProvider.notifier)
        .updateContentTitle(textContentId, title);
  };
});

final textContentDescriptionUpdateProvider =
    Provider<void Function(String, String, String)>((ref) {
      return (
        String textContentId,
        String plainTextDescription,
        String htmlDescription,
      ) {
        ref.read(contentListProvider.notifier).updateContentDescription(
          textContentId,
          (plainText: plainTextDescription, htmlText: htmlDescription),
        );
      };
    });
