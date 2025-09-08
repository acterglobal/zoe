import 'package:zoe/features/documents/models/document_model.dart';

final documentList = [
  // Getting Started Guide Documents
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

  // Mobile App Development Documents
  DocumentModel(
    id: 'document-app-1',
    title: 'API Documentation',
    parentId: 'list-document-app-1',
    sheetId: 'sheet-2',
    filePath: 'path/to/api_docs.md',
  ),
  DocumentModel(
    id: 'document-app-2',
    title: 'UI/UX Design Mockups',
    parentId: 'list-document-app-1',
    sheetId: 'sheet-2',
    filePath: 'path/to/design_mockups.fig',
  ),
  DocumentModel(
    id: 'document-app-3',
    title: 'Technical Architecture',
    parentId: 'list-document-app-1',
    sheetId: 'sheet-2',
    filePath: 'path/to/architecture.pdf',
  ),

  // Community Garden Documents
  DocumentModel(
    id: 'document-garden-1',
    title: 'Garden Layout Plan',
    parentId: 'list-document-garden-1',
    sheetId: 'sheet-3',
    filePath: 'path/to/garden_layout.pdf',
  ),
  DocumentModel(
    id: 'document-garden-2',
    title: 'Planting Calendar',
    parentId: 'list-document-garden-1',
    sheetId: 'sheet-3',
    filePath: 'path/to/planting_calendar.xlsx',
  ),
  DocumentModel(
    id: 'document-garden-3',
    title: 'Composting Guide',
    parentId: 'list-document-garden-1',
    sheetId: 'sheet-3',
    filePath: 'path/to/composting_guide.pdf',
  ),
  
  // Wedding Planning Documents
  DocumentModel(
    id: 'document-wedding-1',
    title: 'Venue Contract',
    parentId: 'list-document-wedding-1',
    sheetId: 'sheet-4',
    filePath: 'path/to/venue_contract.pdf',
  ),
  DocumentModel(
    id: 'document-wedding-2',
    title: 'Wedding Budget Spreadsheet',
    parentId: 'list-document-wedding-1',
    sheetId: 'sheet-4',
    filePath: 'path/to/wedding_budget.xlsx',
  ),
  DocumentModel(
    id: 'document-wedding-3',
    title: 'Guest List Template',
    parentId: 'list-document-wedding-1',
    sheetId: 'sheet-4',
    filePath: 'path/to/guest_list.xlsx',
  ),
  DocumentModel(
    id: 'document-wedding-4',
    title: 'Vendor Contacts',
    parentId: 'list-document-wedding-1',
    sheetId: 'sheet-4',
    filePath: 'path/to/vendor_contacts.docx',
  ),

  // Fitness Journey Documents
  DocumentModel(
    id: 'document-fitness-1',
    title: 'Workout Program',
    parentId: 'list-document-fitness-1',
    sheetId: 'sheet-5',
    filePath: 'path/to/workout_program.pdf',
  ),
  DocumentModel(
    id: 'document-fitness-2',
    title: 'Progress Photos',
    parentId: 'list-document-fitness-1',
    sheetId: 'sheet-5',
    filePath: 'path/to/progress_photos.zip',
  ),
  DocumentModel(
    id: 'document-fitness-3',
    title: 'Meal Plan Templates',
    parentId: 'list-document-fitness-1',
    sheetId: 'sheet-5',
    filePath: 'path/to/meal_plans.xlsx',
  ),
  DocumentModel(
    id: 'document-fitness-4',
    title: 'Exercise Form Guides',
    parentId: 'list-document-fitness-1',
    sheetId: 'sheet-5',
    filePath: 'path/to/exercise_guides.pdf',
  ),
];