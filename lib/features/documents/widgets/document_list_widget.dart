import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/widgets/document_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class DocumentListWidget extends ConsumerWidget {
  final ProviderBase<List<DocumentModel>> documentsProvider;
  final bool isEditing;
  final int? maxItems;

  const DocumentListWidget({
    super.key,
    required this.documentsProvider,
    required this.isEditing,
    this.maxItems,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documents = ref.watch(documentsProvider);
    if (documents.isEmpty) {
      return EmptyStateWidget(message: L10n.of(context).noDocumentsFound);
    }

    final documentsToShow = maxItems != null && documents.length > maxItems!
        ? documents.take(maxItems!)
        : documents;

    return Wrap(
        spacing: 10,
        runSpacing: 5,
        children: documentsToShow
            .map(
              (doc) => DocumentWidget(
                documentId: doc.id,
                isEditing: isEditing,
                isVertical: maxItems != null ? true : false,
              ),
            )
            .toList(),
    );
  }
}
