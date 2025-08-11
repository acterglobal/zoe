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

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final document = documents[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 4, top: 4, left: 12),
          child: DocumentWidget(
            key: ValueKey(document.id),
            documentId: document.id,
            isEditing: isEditing,
          ),
        );
      },
    );
  }
}
