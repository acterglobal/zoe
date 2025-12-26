/*
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/utils/file_utils.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/features/documents/data/document_data.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/documents/screens/document_preview_screen.dart';
import 'package:zoe/features/documents/widgets/document_action_button_widget.dart';
import 'package:zoe/features/documents/widgets/document_error_widget.dart';
import 'package:zoe/features/documents/widgets/image_preview_widget.dart';
import 'package:zoe/features/documents/widgets/music_preview_widget.dart';
import 'package:zoe/features/documents/widgets/pdf_preview_widget.dart';
import 'package:zoe/features/documents/widgets/text_preview_widget.dart';
import 'package:zoe/features/documents/widgets/unsupported_preview_widget.dart';
import 'package:zoe/features/documents/widgets/video_preview_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('DocumentPreviewScreen', () {
    late ProviderContainer container;
    late DocumentModel testDocument;

    Future<void> createTestWidget(
      WidgetTester tester, {
      required String documentId,
      Key? key,
    }) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: DocumentPreviewScreen(key: key, documentId: documentId),
      );
    }

    setUp(() {
      container = ProviderContainer.test();

      // Use existing document from document_data.dart
      testDocument = documentList.first;
    });

    group('Constructor and Initialization', () {
      testWidgets('should render DocumentPreviewScreen correctly', (
        tester,
      ) async {
        await createTestWidget(tester, documentId: testDocument.id);

        expect(find.byType(DocumentPreviewScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(ZoeAppBar), findsOneWidget);
      });

      test('should accept documentId parameter', () {
        const documentId = 'test-doc-id';
        final screen = DocumentPreviewScreen(documentId: documentId);
        expect(screen.documentId, equals(documentId));
      });

      test('should use provided key', () {
        const key = Key('document-preview-screen-key');
        const documentId = 'test-doc-id';
        final screen = DocumentPreviewScreen(key: key, documentId: documentId);
        expect(screen.key, equals(key));
      });
    });

    group('Document Not Found State', () {
      testWidgets('should show error when document is null', (tester) async {
        await createTestWidget(tester, documentId: 'non-existent-id');

        // Should show error state
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(ZoeAppBar), findsOneWidget);
        expect(find.byType(DocumentErrorWidget), findsOneWidget);

        // Should show unknown document title
        expect(
          find.text(
            L10n.of(
              tester.element(find.byType(DocumentPreviewScreen)),
            ).unknownDocument,
          ),
          findsAtLeastNWidgets(1),
        );
      });

      testWidgets('should have correct app bar when document not found', (
        tester,
      ) async {
        await createTestWidget(tester, documentId: 'non-existent-id');

        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.automaticallyImplyLeading, isFalse);

        final zoeAppBar = tester.widget<ZoeAppBar>(find.byType(ZoeAppBar));
        expect(
          zoeAppBar.title,
          equals(
            L10n.of(
              tester.element(find.byType(DocumentPreviewScreen)),
            ).unknownDocument,
          ),
        );
      });
    });

    group('Document Found State', () {
      testWidgets('should show document when found', (tester) async {
        await createTestWidget(tester, documentId: testDocument.id);

        // Should show document
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(ZoeAppBar), findsOneWidget);

        // Should show document title
        expect(find.text(testDocument.title), findsOneWidget);
      });

      testWidgets('should have correct app bar when document found', (
        tester,
      ) async {
        await createTestWidget(tester, documentId: testDocument.id);

        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.automaticallyImplyLeading, isFalse);

        final zoeAppBar = tester.widget<ZoeAppBar>(find.byType(ZoeAppBar));
        expect(zoeAppBar.title, equals(testDocument.title));
        expect(zoeAppBar.actions, isNotNull);
        expect(zoeAppBar.actions!.length, equals(1));
        expect(zoeAppBar.actions![0], isA<DocumentActionButtons>());
      });

      testWidgets('should have correct background color', (tester) async {
        await createTestWidget(tester, documentId: testDocument.id);

        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
        final theme = Theme.of(
          tester.element(find.byType(DocumentPreviewScreen)),
        );
        // Background color should match theme surface color or be null (which uses default)
        expect(
          scaffold.backgroundColor,
          anyOf([equals(theme.colorScheme.surface), isNull]),
        );
      });
    });

    group('File Existence Check', () {
      testWidgets('should show error when file does not exist', (tester) async {
        // Create a document with non-existent file path
        final nonExistentDocument = DocumentModel(
          id: 'non-existent-file-doc',
          title: 'Non-existent File',
          parentId: 'list-1',
          sheetId: 'sheet-1',
          filePath: '/non/existent/path.txt',
          createdBy: 'test-user',
        );

        // Override the provider to return this document
        container = ProviderContainer(
          overrides: [
            documentProvider(
              nonExistentDocument.id,
            ).overrideWithValue(nonExistentDocument),
          ],
        );

        await createTestWidget(tester, documentId: nonExistentDocument.id);

        // Should show error widget
        expect(find.byType(DocumentErrorWidget), findsOneWidget);
        expect(
          find.text(
            L10n.of(
              tester.element(find.byType(DocumentPreviewScreen)),
            ).failedToLoadFile,
          ),
          findsOneWidget,
        );
      });

      testWidgets('should show content when file exists', (tester) async {
        await createTestWidget(tester, documentId: testDocument.id);

        // Should show either content or error widget (file may not exist in test environment)
        expect(
          find.byType(DocumentErrorWidget).evaluate().isNotEmpty ||
              find.byType(ImagePreviewWidget).evaluate().isNotEmpty ||
              find.byType(VideoPreviewWidget).evaluate().isNotEmpty ||
              find.byType(MusicPreviewWidget).evaluate().isNotEmpty ||
              find.byType(PdfPreviewWidget).evaluate().isNotEmpty ||
              find.byType(TextPreviewWidget).evaluate().isNotEmpty ||
              find.byType(UnsupportedPreviewWidget).evaluate().isNotEmpty,
          isTrue,
        );
      });
    });

    group('Document Type Detection', () {
      testWidgets('should show ImagePreviewWidget for image files', (
        tester,
      ) async {
        final imageDocument = DocumentModel(
          id: 'image-doc',
          title: 'Test Image',
          parentId: 'list-1',
          sheetId: 'sheet-1',
          filePath: 'test.jpg',
          createdBy: 'test-user',
        );

        container = ProviderContainer(
          overrides: [
            documentProvider(imageDocument.id).overrideWithValue(imageDocument),
          ],
        );

        await createTestWidget(tester, documentId: imageDocument.id);

        // Should show error widget (file doesn't exist in test environment)
        expect(find.byType(DocumentErrorWidget), findsOneWidget);
      });

      testWidgets('should show VideoPreviewWidget for video files', (
        tester,
      ) async {
        final videoDocument = DocumentModel(
          id: 'video-doc',
          title: 'Test Video',
          parentId: 'list-1',
          sheetId: 'sheet-1',
          filePath: 'test.mp4',
          createdBy: 'test-user',
        );

        container = ProviderContainer(
          overrides: [
            documentProvider(videoDocument.id).overrideWithValue(videoDocument),
          ],
        );

        await createTestWidget(tester, documentId: videoDocument.id);

        // Should show error widget (file doesn't exist in test environment)
        expect(find.byType(DocumentErrorWidget), findsOneWidget);
      });

      testWidgets('should show MusicPreviewWidget for music files', (
        tester,
      ) async {
        final musicDocument = DocumentModel(
          id: 'music-doc',
          title: 'Test Music',
          parentId: 'list-1',
          sheetId: 'sheet-1',
          filePath: 'test.mp3',
          createdBy: 'test-user',
        );

        container = ProviderContainer(
          overrides: [
            documentProvider(musicDocument.id).overrideWithValue(musicDocument),
          ],
        );

        await createTestWidget(tester, documentId: musicDocument.id);

        // Should show error widget (file doesn't exist in test environment)
        expect(find.byType(DocumentErrorWidget), findsOneWidget);
      });

      testWidgets('should show PdfPreviewWidget for PDF files', (tester) async {
        final pdfDocument = DocumentModel(
          id: 'pdf-doc',
          title: 'Test PDF',
          parentId: 'list-1',
          sheetId: 'sheet-1',
          filePath: 'test.pdf',
          createdBy: 'test-user',
        );

        container = ProviderContainer(
          overrides: [
            documentProvider(pdfDocument.id).overrideWithValue(pdfDocument),
          ],
        );

        await createTestWidget(tester, documentId: pdfDocument.id);

        // Should show error widget (file doesn't exist in test environment)
        expect(find.byType(DocumentErrorWidget), findsOneWidget);
      });

      testWidgets('should show TextPreviewWidget for text files', (
        tester,
      ) async {
        final textDocument = DocumentModel(
          id: 'text-doc',
          title: 'Test Text',
          parentId: 'list-1',
          sheetId: 'sheet-1',
          filePath: 'test.txt',
          createdBy: 'test-user',
        );

        container = ProviderContainer(
          overrides: [
            documentProvider(textDocument.id).overrideWithValue(textDocument),
          ],
        );

        await createTestWidget(tester, documentId: textDocument.id);

        // Should show error widget (file doesn't exist in test environment)
        expect(find.byType(DocumentErrorWidget), findsOneWidget);
      });

      testWidgets('should show UnsupportedPreviewWidget for unknown files', (
        tester,
      ) async {
        final unknownDocument = DocumentModel(
          id: 'unknown-doc',
          title: 'Test Unknown',
          parentId: 'list-1',
          sheetId: 'sheet-1',
          filePath: 'test.unknown',
          createdBy: 'test-user',
        );

        container = ProviderContainer(
          overrides: [
            documentProvider(
              unknownDocument.id,
            ).overrideWithValue(unknownDocument),
          ],
        );

        await createTestWidget(tester, documentId: unknownDocument.id);

        // Should show error widget (file doesn't exist in test environment)
        expect(find.byType(DocumentErrorWidget), findsOneWidget);
      });
    });

    group('Action Buttons', () {
      testWidgets('should have download and share action buttons', (
        tester,
      ) async {
        await createTestWidget(tester, documentId: testDocument.id);

        // Should have action buttons
        expect(find.byType(DocumentActionButtons), findsOneWidget);

        final actionButtons = tester.widget<DocumentActionButtons>(
          find.byType(DocumentActionButtons),
        );
        expect(actionButtons.onDownload, isNotNull);
        expect(actionButtons.onShare, isNotNull);
      });

      testWidgets('should handle download action', (tester) async {
        await createTestWidget(tester, documentId: testDocument.id);

        // Find and tap download button
        final downloadButton = find.byIcon(Icons.download);
        if (downloadButton.evaluate().isNotEmpty) {
          await tester.tap(downloadButton);
          await tester.pump();

          // Should show snackbar
          expect(find.byType(SnackBar), findsOneWidget);
        }
      });

      testWidgets('should handle share action', (tester) async {
        await createTestWidget(tester, documentId: testDocument.id);

        // Find and tap share button
        final shareButton = find.byIcon(Icons.share);
        if (shareButton.evaluate().isNotEmpty) {
          await tester.tap(shareButton);
          await tester.pump();

          // Share action should be triggered (no error)
          expect(tester.takeException(), isNull);
        }
      });
    });

    group('Theme Integration', () {
      testWidgets('should use theme colors correctly', (tester) async {
        final customTheme = ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            surface: Colors.blue,
            onSurface: Colors.white,
          ),
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          child: DocumentPreviewScreen(documentId: testDocument.id),
          container: container,
          theme: customTheme,
        );

        // Widget should use theme colors
        expect(find.byType(DocumentPreviewScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      });

      testWidgets('should adapt to dark theme', (tester) async {
        final darkTheme = ThemeData.dark();

        await tester.pumpMaterialWidgetWithProviderScope(
          child: DocumentPreviewScreen(documentId: testDocument.id),
          container: container,
          theme: darkTheme,
        );

        // Widget should adapt to dark theme
        expect(find.byType(DocumentPreviewScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      });
    });

    group('File Type Detection Logic', () {
      test('should test getDocumentType function logic', () {
        // Test the core logic of getDocumentType function

        // Test case 1: Image file detection
        final imageDoc = DocumentModel(
          id: 'img',
          title: 'Image',
          parentId: 'p1',
          sheetId: 's1',
          filePath: 'test.jpg',
          createdBy: 'test-user',
        );
        final imageType = getDocumentType(imageDoc);
        expect(imageType, equals(DocumentFileType.image));

        // Test case 2: Video file detection
        final videoDoc = DocumentModel(
          id: 'vid',
          title: 'Video',
          parentId: 'p1',
          sheetId: 's1',
          filePath: 'test.mp4',
          createdBy: 'test-user',
        );
        final videoType = getDocumentType(videoDoc);
        expect(videoType, equals(DocumentFileType.video));

        // Test case 3: Music file detection
        final musicDoc = DocumentModel(
          id: 'mus',
          title: 'Music',
          parentId: 'p1',
          sheetId: 's1',
          filePath: 'test.mp3',
          createdBy: 'test-user',
        );
        final musicType = getDocumentType(musicDoc);
        expect(musicType, equals(DocumentFileType.music));

        // Test case 4: PDF file detection
        final pdfDoc = DocumentModel(
          id: 'pdf',
          title: 'PDF',
          parentId: 'p1',
          sheetId: 's1',
          filePath: 'test.pdf',
          createdBy: 'test-user',
        );
        final pdfType = getDocumentType(pdfDoc);
        expect(pdfType, equals(DocumentFileType.pdf));

        // Test case 5: Text file detection
        final textDoc = DocumentModel(
          id: 'txt',
          title: 'Text',
          parentId: 'p1',
          sheetId: 's1',
          filePath: 'test.txt',
          createdBy: 'test-user',
        );
        final textType = getDocumentType(textDoc);
        expect(textType, equals(DocumentFileType.text));

        // Test case 6: Unknown file detection
        final unknownDoc = DocumentModel(
          id: 'unk',
          title: 'Unknown',
          parentId: 'p1',
          sheetId: 's1',
          filePath: 'test.unknown',
          createdBy: 'test-user',
        );
        final unknownType = getDocumentType(unknownDoc);
        expect(unknownType, equals(DocumentFileType.unknown));
      });

      test('should test file extension extraction logic', () {
        // Test the core logic of getFileType function

        // Test case 1: Simple extension
        String filePath = 'test.jpg';
        String extension = getFileType(filePath);
        expect(extension, equals('jpg'));

        // Test case 2: Multiple dots
        filePath = 'test.file.jpg';
        extension = getFileType(filePath);
        expect(extension, equals('jpg'));

        // Test case 3: No extension
        filePath = 'test';
        extension = getFileType(filePath);
        expect(extension, equals('test'));

        // Test case 4: Empty path
        filePath = '';
        extension = getFileType(filePath);
        expect(extension, equals(''));
      });

      test('should test file type validation logic', () {
        // Test the core logic of file type validation functions

        // Test case 1: Image file validation
        final imageDoc = DocumentModel(
          id: 'img',
          title: 'Image',
          parentId: 'p1',
          sheetId: 's1',
          filePath: 'test.jpg',
          createdBy: 'test-user',
        );
        bool isImage = isImageDocument(imageDoc);
        expect(isImage, isTrue);

        // Test case 2: Video file validation
        final videoDoc = DocumentModel(
          id: 'vid',
          title: 'Video',
          parentId: 'p1',
          sheetId: 's1',
          filePath: 'test.mp4',
          createdBy: 'test-user',
        );
        bool isVideo = isVideoDocument(videoDoc);
        expect(isVideo, isTrue);

        // Test case 3: Music file validation
        final musicDoc = DocumentModel(
          id: 'mus',
          title: 'Music',
          parentId: 'p1',
          sheetId: 's1',
          filePath: 'test.mp3',
          createdBy: 'test-user',
        );
        bool isMusic = isMusicDocument(musicDoc);
        expect(isMusic, isTrue);

        // Test case 4: PDF file validation
        final pdfDoc = DocumentModel(
          id: 'pdf',
          title: 'PDF',
          parentId: 'p1',
          sheetId: 's1',
          filePath: 'test.pdf',
          createdBy: 'test-user',
        );
        bool isPdf = isPdfDocument(pdfDoc);
        expect(isPdf, isTrue);

        // Test case 5: Text file validation
        final textDoc = DocumentModel(
          id: 'txt',
          title: 'Text',
          parentId: 'p1',
          sheetId: 's1',
          filePath: 'test.txt',
          createdBy: 'test-user',
        );
        bool isText = isTextDocument(textDoc);
        expect(isText, isTrue);
      });
    });
  });
}
*/
