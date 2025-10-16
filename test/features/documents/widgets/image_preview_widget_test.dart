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
  group('🖼️ ImagePreviewWidget', () {
    late ProviderContainer container;
    late DocumentModel testDocument;

    setUp(() {
      container = ProviderContainer.test();
      testDocument = documentList.first;
    });

    Widget buildTestWidget(DocumentModel doc) {
      return Scaffold(body: ImagePreviewWidget(document: doc));
    }

    Future<void> pumpImagePreview(WidgetTester tester, DocumentModel doc) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: buildTestWidget(doc),
        container: container,
      );
    }

    group('Basic Rendering', () {
      testWidgets('renders successfully', (tester) async {
        await pumpImagePreview(tester, testDocument);

        expect(find.byType(ImagePreviewWidget), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(GlassyContainer), findsOneWidget);
      });

      testWidgets('renders widget hierarchy correctly', (tester) async {
        await pumpImagePreview(tester, testDocument);

        expect(find.byType(ImagePreviewWidget), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(GlassyContainer), findsOneWidget);
        expect(find.byType(ClipRRect), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
        expect(find.byType(DocumentErrorWidget), findsNothing);
      });
    });

    group('Widget Properties', () {
      testWidgets('has correct GlassyContainer properties', (tester) async {
        await pumpImagePreview(tester, testDocument);

        final glassyContainer =
            tester.widget<GlassyContainer>(find.byType(GlassyContainer));

        expect(glassyContainer.width, equals(double.infinity));
        expect(glassyContainer.borderRadius, BorderRadius.circular(20));
        expect(glassyContainer.padding, const EdgeInsets.all(8));
        expect(glassyContainer.margin, const EdgeInsets.all(16));
      });

      testWidgets('ClipRRect uses correct border radius', (tester) async {
        await pumpImagePreview(tester, testDocument);

        final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
        expect(clipRRect.borderRadius, BorderRadius.circular(16));
      });

      testWidgets('Image.file uses correct properties', (tester) async {
        await pumpImagePreview(tester, testDocument);

        final imageFile = tester.widget<Image>(find.byType(Image));
        expect(imageFile.image, isA<FileImage>());
        expect(imageFile.fit, BoxFit.contain);
      });
    });

    group('Document Type Handling', () {
      testWidgets('renders supported image file types', (tester) async {
        final imageDocs = documentList.where((doc) {
          final path = doc.filePath.toLowerCase();
          return path.endsWith('.jpg') ||
              path.endsWith('.jpeg') ||
              path.endsWith('.png') ||
              path.endsWith('.gif');
        }).take(2);

        for (final doc in imageDocs) {
          await pumpImagePreview(tester, doc);

          expect(find.byType(ImagePreviewWidget), findsOneWidget);
          expect(find.byType(GlassyContainer), findsOneWidget);
        }
      });
    });

    group('Constructor', () {
      test('creates widget successfully', () {
        expect(() => ImagePreviewWidget(document: testDocument), returnsNormally);
        final widget = ImagePreviewWidget(document: testDocument);
        expect(widget.document, testDocument);
      });
    });
  });
}
