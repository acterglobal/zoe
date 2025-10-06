import 'package:zoe/features/documents/models/document_model.dart';

final documentList = [
  DocumentModel(
    id: 'document-1',
    title: 'Project Proposal',
    parentId: 'list-document-1',
    sheetId: 'sheet-1',
    filePath: 'path/to/project_proposal.pdf',
  ),
  DocumentModel(
    id: 'document-2',
    title: 'Meeting Notes',
    parentId: 'list-document-1',
    sheetId: 'sheet-1',
    filePath: 'path/to/meeting_notes.docx',
  ),
  DocumentModel(
    id: 'document-3',
    title: 'Budget Spreadsheet',
    parentId: 'list-document-1',
    sheetId: 'sheet-1',
    filePath: 'path/to/budget.xlsx',
  ),
  DocumentModel(
    id: 'document-4',
    title: 'Design Mockups',
    parentId: 'list-document-2',
    sheetId: 'sheet-1',
    filePath: 'path/to/design_mockups.png',
  ),
];
