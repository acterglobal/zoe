import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/utils/common_utils.dart';
import 'package:zoey/features/documents/providers/document_providers.dart';
import 'package:zoey/l10n/generated/l10n.dart';

Future<void> pickDocumentFile(
  BuildContext context,
  WidgetRef ref,
  String listId,
  String sheetId,
) async {
  final l10n = L10n.of(context);
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      for (final file in result.files) {
        // Add the document first
        ref
            .read(documentListProvider.notifier)
            .addDocument(parentId: listId, sheetId: sheetId);

        // Get the newly added document to update it with file info
        final documents = ref.read(documentListProvider);
        final newDocument = documents.last;

        // Update the document with file information
        ref
            .read(documentListProvider.notifier)
            .updateDocumentFile(
              newDocument.id,
              file.name,
              file.extension ?? 'unknown',
              file.path ?? '',
            );
      }

      // Show success message
      if (context.mounted) {
        CommonUtils.showSnackBar(
          context,
          l10n.addedDocuments(result.files.length),
        );
      }
    }
  } catch (e) {
    // Show error message if file picking fails
    if (context.mounted) {
      CommonUtils.showSnackBar(context, l10n.failedToPickFile(e.toString()));
    }
  }
}
