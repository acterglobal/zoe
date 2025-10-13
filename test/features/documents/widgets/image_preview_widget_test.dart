import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/widgets/image_preview_widget.dart';
import 'package:zoe/features/documents/widgets/document_error_widget.dart';
import 'package:zoe/features/documents/data/document_data.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('ImagePreviewWidget Tests', () {
    late ProviderContainer container;
    late DocumentModel testDocument;

    setUp(() {
      container = ProviderContainer.test();
      
      // Use existing document from document_data.dart
      testDocument = documentList.first;
    });

    testWidgets('renders image preview widget', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: ImagePreviewWidget(document: testDocument),
        ),
        container: container,
      );

      expect(find.byType(ImagePreviewWidget), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(GlassyContainer), findsOneWidget);
    });

    testWidgets('renders image container with correct properties', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: ImagePreviewWidget(document: testDocument),
        ),
        container: container,
      );

      // Should render GlassyContainer with correct properties
      final glassyContainer = tester.widget<GlassyContainer>(find.byType(GlassyContainer));
      expect(glassyContainer.width, equals(double.infinity));
      expect(glassyContainer.borderRadius, equals(BorderRadius.circular(20)));
      expect(glassyContainer.padding, equals(const EdgeInsets.all(8)));
      expect(glassyContainer.margin, equals(const EdgeInsets.all(16)));
    });

    testWidgets('renders ClipRRect with correct border radius', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: ImagePreviewWidget(document: testDocument),
        ),
        container: container,
      );

      // Should render ClipRRect with correct border radius
      final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clipRRect.borderRadius, equals(BorderRadius.circular(16)));
    });

    testWidgets('renders Image.file with correct properties', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: ImagePreviewWidget(document: testDocument),
        ),
        container: container,
      );

      // Should render Image.file with correct properties
      final imageFile = tester.widget<Image>(find.byType(Image));
      expect(imageFile.image, isA<FileImage>());
      expect(imageFile.fit, equals(BoxFit.contain));
    });

    testWidgets('renders image widget structure correctly', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: ImagePreviewWidget(document: testDocument),
        ),
        container: container,
      );

      // Should render the complete widget structure
      expect(find.byType(ImagePreviewWidget), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(GlassyContainer), findsOneWidget);
      expect(find.byType(ClipRRect), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      
      // Should not show error widget for valid documents
      expect(find.byType(DocumentErrorWidget), findsNothing);
    });

    testWidgets('handles different document types', (tester) async {
      // Test with different image document types
      final imageDocuments = documentList.where((doc) => 
        doc.filePath.toLowerCase().contains('.jpg') ||
        doc.filePath.toLowerCase().contains('.jpeg') ||
        doc.filePath.toLowerCase().contains('.png') ||
        doc.filePath.toLowerCase().contains('.gif')
      ).take(2);

      for (final doc in imageDocuments) {
        await tester.pumpMaterialWidgetWithProviderScope(
          child: Scaffold(
            body: ImagePreviewWidget(document: doc),
          ),
          container: container,
        );

        expect(find.byType(ImagePreviewWidget), findsOneWidget);
        expect(find.byType(GlassyContainer), findsOneWidget);
      }
    });


    testWidgets('handles document constructor correctly', (tester) async {
      // This test ensures the widget constructor works correctly
      expect(() => ImagePreviewWidget(document: testDocument), returnsNormally);
      
      // Verify the widget can be instantiated
      final widget = ImagePreviewWidget(document: testDocument);
      expect(widget.document, equals(testDocument));
    });
  });
}
