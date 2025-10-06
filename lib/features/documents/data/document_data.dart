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
  // Trip Planning Documents
  DocumentModel(
    id: 'document-5',
    title: 'Trip Itinerary',
    parentId: 'list-document-2',
    sheetId: 'sheet-2',
    filePath: 'path/to/trip_itinerary.pdf',
  ),
  DocumentModel(
    id: 'document-6',
    title: 'Hotel Booking Confirmation',
    parentId: 'list-document-2',
    sheetId: 'sheet-2',
    filePath: 'path/to/hotel_confirmation.pdf',
  ),
  DocumentModel(
    id: 'document-7',
    title: 'Flight Tickets',
    parentId: 'list-document-2',
    sheetId: 'sheet-2',
    filePath: 'path/to/flight_tickets.pdf',
  ),
  DocumentModel(
    id: 'document-8',
    title: 'Travel Insurance Policy',
    parentId: 'list-document-2',
    sheetId: 'sheet-2',
    filePath: 'path/to/travel_insurance.pdf',
  ),
  DocumentModel(
    id: 'document-9',
    title: 'Passport Copies',
    parentId: 'list-document-2',
    sheetId: 'sheet-2',
    filePath: 'path/to/passport_copies.pdf',
  ),
  DocumentModel(
    id: 'document-10',
    title: 'Emergency Contacts List',
    parentId: 'list-document-2',
    sheetId: 'sheet-2',
    filePath: 'path/to/emergency_contacts.docx',
  ),
];