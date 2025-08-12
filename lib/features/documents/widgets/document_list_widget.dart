import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/documents/providers/document_providers.dart';
import 'package:zoey/features/documents/widgets/document_widget.dart';

class DocumentListWidget extends ConsumerWidget {
  final String parentId;
  final bool isEditing;

  const DocumentListWidget({
    super.key,
    required this.parentId,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documents = ref.watch(documentListByParentProvider(parentId));
    if (documents.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: documents
            .map(
              (doc) => DocumentWidget(documentId: doc.id, isEditing: isEditing),
            )
            .toList(),
      ),
    );
  }
}
