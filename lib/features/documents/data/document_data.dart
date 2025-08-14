import 'package:Zoe/features/documents/models/document_model.dart';

final documentList = [
  // Sheet 1 Documents
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
  
  // Sheet 2 Documents
  DocumentModel(
    id: 'document-4',
    title: 'Design Mockups',
    parentId: 'list-document-2',
    sheetId: 'sheet-2',
    filePath: 'path/to/design_mockups.fig',
  ),
  DocumentModel(
    id: 'document-5',
    title: 'Logo Assets',
    parentId: 'list-document-2',
    sheetId: 'sheet-2',
    filePath: 'path/to/logo_package.zip',
  ),
  DocumentModel(
    id: 'document-6',
    title: 'Brand Guidelines',
    parentId: 'list-document-2',
    sheetId: 'sheet-2',
    filePath: 'path/to/brand_guidelines.pdf',
  ),
  
  // Sheet 3 Documents
  DocumentModel(
    id: 'document-7',
    title: 'API Documentation',
    parentId: 'list-document-3',
    sheetId: 'sheet-3',
    filePath: 'path/to/api_docs.md',
  ),
  DocumentModel(
    id: 'document-8',
    title: 'Database Schema',
    parentId: 'list-document-3',
    sheetId: 'sheet-3',
    filePath: 'path/to/schema.sql',
  ),
  DocumentModel(
    id: 'document-9',
    title: 'Test Results',
    parentId: 'list-document-3',
    sheetId: 'sheet-3',
    filePath: 'path/to/test_results.html',
  ),
  
  // Sheet 4 Documents
  DocumentModel(
    id: 'document-10',
    title: 'Marketing Plan',
    parentId: 'list-document-4',
    sheetId: 'sheet-4',
    filePath: 'path/to/marketing_plan.pptx',
  ),
  DocumentModel(
    id: 'document-11',
    title: 'Social Media Content',
    parentId: 'list-document-4',
    sheetId: 'sheet-4',
    filePath: 'path/to/content_calendar.csv',
  ),
  DocumentModel(
    id: 'document-12',
    title: 'Campaign Analytics',
    parentId: 'list-document-4',
    sheetId: 'sheet-4',
    filePath: 'path/to/analytics.json',
  ),
];