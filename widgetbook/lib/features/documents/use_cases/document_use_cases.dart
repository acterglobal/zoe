import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:zoe/features/content/providers/content_menu_providers.dart';
import 'package:zoe/features/content/providers/content_providers.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/documents/screens/document_preview_screen.dart';
import 'package:zoe/features/documents/screens/documents_list_screen.dart';
import 'package:zoe/features/documents/widgets/document_action_button_widget.dart';
import 'package:zoe/features/documents/widgets/document_list_widget.dart';
import 'package:zoe/features/documents/widgets/document_widget.dart';
import 'package:zoe/features/documents/widgets/unsupported_preview_widget.dart';
import 'package:widgetbook_workspace/features/documents/mock_document_providers.dart';
import 'package:widgetbook_workspace/features/home/zoe_preview_widget.dart';

@widgetbook.UseCase(name: 'Document List Screen', type: DocumentListWidget)
Widget buildDocumentListScreenUseCase(BuildContext context) {
  final documentCount = context.knobs.int.input(
    label: 'Number of Documents',
    initialValue: 3,
    description: 'Number of documents to display',
  );

  final isEditing = context.knobs.boolean(
    label: 'Is Editing',
    description: 'Toggle edit mode',
    initialValue: false,
  );

  final maxItems = context.knobs.int.input(
    label: 'Max Items',
    description: 'Maximum number of items to display',
    initialValue: 3,
  );

  final documents = List.generate(documentCount, (index) {

    return DocumentModel(
      id: 'document-\$index',
      title: context.knobs.string(
        label: 'Document \${index + 1} Title',
        initialValue: 'Document \${index + 1}',
        description: 'Title for document \${index + 1}',
      ),
      filePath: context.knobs.string(
        label: 'Document \${index + 1} Path',
        initialValue: 'document-\$index.\$fileType',
        description: 'File path for document \${index + 1}',
      ),
      parentId: context.knobs.string(
        label: 'Document \${index + 1} Parent ID',
        initialValue: 'list-1',
        description: 'Parent ID for document \${index + 1}',
      ),
      sheetId: context.knobs.string(
        label: 'Document \${index + 1} Sheet ID',
        initialValue: 'mock-sheet-1',
        description: 'Sheet ID for document \${index + 1}',
      ),
      createdAt: DateTime.now().subtract(Duration(days: index)),
      updatedAt: DateTime.now(),
    );
  });

  return Consumer(
    builder: (context, ref, _) {
      return ProviderScope(
        overrides: [
          // Mock document providers
          mockDocumentListProvider.overrideWith(
            (ref) => MockDocumentNotifier()..setDocuments(documents),
          ),
          mockDocumentProvider.overrideWith((ref, id) {
            return documents.where((d) => d.id == id).firstOrNull;
          }),
          mockDocumentListByParentProvider.overrideWith((ref, parentId) {
            return documents.where((d) => d.parentId == parentId).toList();
          }),
          mockDocumentListBySheetIdProvider.overrideWith((ref, sheetId) {
            return documents.where((d) => d.sheetId == sheetId).toList();
          }),
          // Mock content providers
          contentListProvider.overrideWith((ref) => []),
          contentProvider.overrideWith((ref, id) => null),
          contentListByParentIdProvider.overrideWith((ref, id) => []),
          isEditValueProvider.overrideWith((ref, id) => false),
        ],
        child: ZoePreview(
          child: DocumentListWidget(
            documentsProvider: documentListProvider,
            isEditing: isEditing,
            maxItems: maxItems,
          ),
        ),
      );
    },
  );
}

@widgetbook.UseCase(name: 'Document Widget', type: DocumentWidget)
Widget buildDocumentWidgetUseCase(BuildContext context) {
  final documentId = context.knobs.string(
    label: 'Document ID',
    initialValue: 'document-1',
  );

  final isEditing = context.knobs.boolean(
    label: 'Is Editing',
    description: 'Toggle edit mode',
    initialValue: false,
  );

  final document = DocumentModel(
    id: documentId,
    title: context.knobs.string(
      label: 'Document Title',
      initialValue: 'Sample Document',
      description: 'Title of the document',
    ),
    filePath: context.knobs.string(
      label: 'File Path',
      initialValue: 'document-1.\$fileType',
      description: 'Path to the document file',
    ),
    parentId: context.knobs.string(
      label: 'Parent ID',
      initialValue: 'list-1',
      description: 'Parent ID of the document',
    ),
    sheetId: context.knobs.string(
      label: 'Sheet ID',
      initialValue: 'mock-sheet-1',
      description: 'Sheet ID of the document',
    ),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  return Consumer(
    builder: (context, ref, _) {
      return ProviderScope(
        overrides: [
          // Mock document providers
          mockDocumentListProvider.overrideWith(
            (ref) => MockDocumentNotifier()..setDocuments([document]),
          ),
          mockDocumentProvider.overrideWith(
            (ref, id) => id == documentId ? document : null,
          ),
          mockDocumentListByParentProvider.overrideWith(
            (ref, parentId) => parentId == document.parentId ? [document] : [],
          ),
          mockDocumentListBySheetIdProvider.overrideWith(
            (ref, sheetId) => sheetId == document.sheetId ? [document] : [],
          ),
          // Mock content providers
          contentListProvider.overrideWith((ref) => []),
          contentProvider.overrideWith((ref, id) => null),
          contentListByParentIdProvider.overrideWith((ref, id) => []),
          isEditValueProvider.overrideWith((ref, id) => false),
        ],
        child: ZoePreview(
          child: DocumentWidget(documentId: documentId, isEditing: isEditing),
        ),
      );
    },
  );
}

@widgetbook.UseCase(name: 'Documents List Screen', type: DocumentsListScreen)
Widget buildDocumentsListScreenUseCase(BuildContext context) {
  return ZoePreview(child: DocumentsListScreen());
}

@widgetbook.UseCase(name: 'Document Detail Screen', type: DocumentPreviewScreen)
Widget buildDocumentPreviewScreenUseCase(BuildContext context) {
  final documentId = context.knobs.string(
    label: 'Document ID',
    initialValue: 'document-1',
  );

  return ZoePreview(child: DocumentPreviewScreen(documentId: documentId));
}

@widgetbook.UseCase(
  name: 'Unsupported Preview Widget',
  type: UnsupportedPreviewWidget,
)
Widget buildUnsupportedPreviewWidgetUseCase(BuildContext context) {
  final document = context.knobs.object.dropdown(
    label: 'Document',
    options: [
      DocumentModel(
        id: 'document-1',
        title: 'Document 1',
        filePath: 'document-1.pdf',
        parentId: '',
        sheetId: '',
      ),
      DocumentModel(
        id: 'document-2',
        title: 'Document 2',
        filePath: 'document-2.pdf',
        parentId: '',
        sheetId: '',
      ),
      DocumentModel(
        id: 'document-3',
        title: 'Document 3',
        filePath: 'document-3.pdf',
        parentId: '',
        sheetId: '',
      ),
    ],
    labelBuilder: (document) => document.title,
  );

  return ZoePreview(child: UnsupportedPreviewWidget(document: document));
}

@widgetbook.UseCase(
  name: 'Document Action Button Widget',
  type: DocumentActionButtons,
)
Widget buildDocumentActionButtonWidgetUseCase(BuildContext context) {
  return ZoePreview(
    child: DocumentActionButtons(
      onDownload: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Downloading...')));
      },
      onShare: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Sharing...')));
      },
    ),
  );
}
