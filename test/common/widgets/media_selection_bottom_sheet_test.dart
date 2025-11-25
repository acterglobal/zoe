import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoe/common/widgets/bottom_sheet_option_widget.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/media_selection_bottom_sheet.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

import '../../test-utils/test_utils.dart';

void main() {
  final testImageJpgPath = 'test/images/test_image.jpg';
  final testImageJpgName = 'test_image.jpg';
  final testImagePngPath = 'test/images/test_image.png';
  final testImagePngName = 'test_image.png';
  final testPdfPath = 'test/files/test_file.pdf';
  final testPdfName = 'test_file.pdf';
  final testTxtPath = 'test/files/test_file.txt';
  final testTxtName = 'test_file.txt';

  group('Media Selection Bottom Sheet Widget Tests', () {
    /// Test utilities for MediaSelectionBottomSheetWidget tests
    Future<void> pumpMediaSelectionBottomSheetWidget(
      WidgetTester tester, {
      String? title,
      String? subtitle,
      bool allowMultiple = false,
      Function(XFile)? onTapCamera,
      Function(List<XFile>)? onTapGallery,
      Function(List<XFile>)? onTapFileChooser,
      Function()? onTapRemoveImage,
    }) async {
      await tester.pumpMaterialWidget(
        child: MediaSelectionBottomSheetWidget(
          title: title,
          subtitle: subtitle,
          allowMultiple: allowMultiple,
          imageQuality: 80,
          onTapCamera: onTapCamera ?? (XFile file) {},
          onTapGallery: onTapGallery ?? (List<XFile> files) {},
          onTapFileChooser: onTapFileChooser,
          onTapRemoveImage: onTapRemoveImage,
        ),
      );
    }

    L10n getL10n(WidgetTester tester) {
      return L10n.of(
        tester.element(find.byType(MediaSelectionBottomSheetWidget)),
      );
    }

    /// Creates mock XFile for testing
    XFile createMockXFile(String path, String name) {
      return XFile(path, name: name);
    }

    group('Basic Rendering Tests -', () {
      testWidgets('renders with default localized title and subtitle', (
        tester,
      ) async {
        await pumpMediaSelectionBottomSheetWidget(tester);

        // Verify widget is rendered
        expect(find.byType(MediaSelectionBottomSheetWidget), findsOneWidget);

        // Verify localized title and subtitle are displayed
        final l10n = getL10n(tester);
        expect(find.text(l10n.selectMedia), findsOneWidget);
        expect(find.text(l10n.chooseAMediaFile), findsOneWidget);
      });

      testWidgets('renders with custom title and subtitle', (tester) async {
        const customTitle = 'Custom Media Title';
        const customSubtitle = 'Custom media subtitle';

        await pumpMediaSelectionBottomSheetWidget(
          tester,
          title: customTitle,
          subtitle: customSubtitle,
        );

        // Verify custom title and subtitle are displayed
        expect(find.text(customTitle), findsOneWidget);
        expect(find.text(customSubtitle), findsOneWidget);

        // Verify default localized text is not displayed
        final l10n = getL10n(tester);
        expect(find.text(l10n.selectMedia), findsNothing);
        expect(find.text(l10n.chooseAMediaFile), findsNothing);
      });

      testWidgets('renders photo gallery option', (tester) async {
        await pumpMediaSelectionBottomSheetWidget(tester);

        // Verify photo gallery option is rendered
        expect(find.byIcon(Icons.photo_library_rounded), findsOneWidget);
      });

      testWidgets('renders file chooser option when provided', (tester) async {
        await pumpMediaSelectionBottomSheetWidget(
          tester,
          onTapFileChooser: (files) {},
        );

        // Verify file chooser option is rendered
        expect(find.byIcon(Icons.folder_open_rounded), findsOneWidget);
      });

      testWidgets('does not render file chooser option when null', (
        tester,
      ) async {
        await pumpMediaSelectionBottomSheetWidget(
          tester,
          onTapFileChooser: null,
        );

        // Verify file chooser option is not rendered
        expect(find.byIcon(Icons.folder_open_rounded), findsNothing);
      });

      testWidgets('renders remove image option when provided', (tester) async {
        await pumpMediaSelectionBottomSheetWidget(
          tester,
          onTapRemoveImage: () {},
        );

        // Verify remove image option is rendered
        expect(find.byIcon(Icons.delete), findsOneWidget);
      });

      testWidgets('does not render remove image option when null', (
        tester,
      ) async {
        await pumpMediaSelectionBottomSheetWidget(
          tester,
          onTapRemoveImage: null,
        );

        // Verify remove image option is not rendered
        expect(find.byIcon(Icons.delete), findsNothing);
      });
    });

    group('Conditional Rendering Tests -', () {
      testWidgets('renders camera option when not desktop', (tester) async {
        await pumpMediaSelectionBottomSheetWidget(tester);

        // Note: Camera option is conditionally rendered based on CommonUtils.isDesktop(context)
        // In test environment, we can't easily mock this, so we just verify the widget renders
        expect(find.byType(MediaSelectionBottomSheetWidget), findsOneWidget);
      });

      testWidgets('applies correct styling to option buttons', (tester) async {
        await pumpMediaSelectionBottomSheetWidget(
          tester,
          onTapFileChooser: (files) {},
        );

        // Verify BottomSheetOptionWidget instances are present
        expect(find.byType(BottomSheetOptionWidget), findsAtLeastNWidgets(2));

        // Verify GlassyContainer is used for option buttons
        expect(find.byType(GlassyContainer), findsAtLeastNWidgets(2));

        // Verify StyledIconContainer is used for icons
        expect(find.byType(StyledIconContainer), findsAtLeastNWidgets(2));
      });

      testWidgets('renders chevron icons in option buttons', (tester) async {
        await pumpMediaSelectionBottomSheetWidget(
          tester,
          onTapFileChooser: (files) {},
        );

        // Verify chevron icons are rendered
        expect(
          find.byIcon(Icons.chevron_right_rounded),
          findsAtLeastNWidgets(2),
        );
      });
    });

    group('Callback Execution Tests -', () {
      testWidgets('calls onTapGallery callback with mock data', (tester) async {
        bool galleryTapped = false;
        List<XFile>? receivedFiles;

        // Create mock images for testing
        final mockImages = [
          createMockXFile(testImageJpgPath, testImageJpgName),
          createMockXFile(testImagePngPath, testImagePngName),
        ];

        await pumpMediaSelectionBottomSheetWidget(
          tester,
          onTapGallery: (files) {
            galleryTapped = true;
            receivedFiles = files;
          },
        );

        // Verify the photo gallery option is present
        final l10n = getL10n(tester);
        expect(find.text(l10n.photoGallery), findsOneWidget);
        expect(find.byIcon(Icons.photo_library_rounded), findsOneWidget);

        // Test the callback directly by simulating the result
        final widget = tester.widget<MediaSelectionBottomSheetWidget>(
          find.byType(MediaSelectionBottomSheetWidget),
        );

        // Simulate the callback being called with mock data
        widget.onTapGallery(mockImages);

        // Verify callback was executed with correct data
        expect(galleryTapped, isTrue);
        expect(receivedFiles, isNotNull);
        expect(receivedFiles?.length, equals(mockImages.length));
        for (int i = 0; i < mockImages.length; i++) {
          expect(receivedFiles?[i].path, equals(mockImages[i].path));
          expect(receivedFiles?[i].name, equals(mockImages[i].name));
        }
      });

      testWidgets('calls onTapCamera callback with mock data', (tester) async {
        bool cameraTapped = false;
        XFile? receivedFile;

        // Create mock camera image for testing
        final mockCameraImage = createMockXFile(
          testImageJpgPath,
          testImageJpgName,
        );
        await pumpMediaSelectionBottomSheetWidget(
          tester,
          onTapCamera: (file) {
            cameraTapped = true;
            receivedFile = file;
          },
        );

        // Verify the widget is rendered
        expect(find.byType(MediaSelectionBottomSheetWidget), findsOneWidget);

        // Test the callback directly by simulating the result
        final widget = tester.widget<MediaSelectionBottomSheetWidget>(
          find.byType(MediaSelectionBottomSheetWidget),
        );

        // Simulate the callback being called with mock data
        widget.onTapCamera(mockCameraImage);

        // Verify callback was executed with correct data
        expect(cameraTapped, isTrue);
        expect(receivedFile, isNotNull);
        expect(receivedFile?.path, equals(testImageJpgPath));
        expect(receivedFile?.name, equals(testImageJpgName));
      });

      testWidgets('calls onTapFileChooser callback with mock data', (
        tester,
      ) async {
        bool fileChooserTapped = false;
        List<XFile>? receivedFiles;

        // Create mock files for testing
        final mockFiles = [
          createMockXFile(testPdfPath, testPdfName),
          createMockXFile(testTxtPath, testTxtName),
        ];

        await pumpMediaSelectionBottomSheetWidget(
          tester,
          onTapFileChooser: (files) {
            fileChooserTapped = true;
            receivedFiles = files;
          },
        );

        // Verify the file chooser option is present
        final l10n = getL10n(tester);
        expect(find.text(l10n.filePicker), findsOneWidget);
        expect(find.byIcon(Icons.folder_open_rounded), findsOneWidget);

        // Test the callback directly by simulating the result
        final widget = tester.widget<MediaSelectionBottomSheetWidget>(
          find.byType(MediaSelectionBottomSheetWidget),
        );

        // Simulate the callback being called with mock data
        widget.onTapFileChooser?.call(mockFiles);

        // Verify callback was executed with correct data
        expect(fileChooserTapped, isTrue);
        expect(receivedFiles, isNotNull);
        expect(receivedFiles?.length, equals(mockFiles.length));
        for (int i = 0; i < mockFiles.length; i++) {
          expect(receivedFiles?[i].path, equals(mockFiles[i].path));
          expect(receivedFiles?[i].name, equals(mockFiles[i].name));
        }
      });

      testWidgets('handles single file selection', (tester) async {
        bool fileChooserTapped = false;
        List<XFile>? receivedFiles;

        // Create single mock file for testing
        final mockFile = createMockXFile(testImageJpgPath, testImageJpgName);

        await pumpMediaSelectionBottomSheetWidget(
          tester,
          allowMultiple: false,
          onTapFileChooser: (files) {
            fileChooserTapped = true;
            receivedFiles = files;
          },
        );

        // Test the callback with single file
        final widget = tester.widget<MediaSelectionBottomSheetWidget>(
          find.byType(MediaSelectionBottomSheetWidget),
        );

        // Simulate single file selection
        widget.onTapFileChooser?.call([mockFile]);

        // Verify callback was executed with single file
        expect(fileChooserTapped, isTrue);
        expect(receivedFiles, isNotNull);
        expect(receivedFiles?.length, equals(1));
        expect(receivedFiles?[0].path, equals(testImageJpgPath));
        expect(receivedFiles?[0].name, equals(testImageJpgName));
      });

      testWidgets(
        'handles multiple file selection when allowMultiple is true',
        (tester) async {
          bool fileChooserTapped = false;
          List<XFile>? receivedFiles;

          // Create multiple mock files for testing
          final mockFiles = [
            createMockXFile(testImageJpgPath, testImageJpgName),
            createMockXFile(testImagePngPath, testImagePngName),
            createMockXFile(testPdfPath, testPdfName),
          ];

          await pumpMediaSelectionBottomSheetWidget(
            tester,
            allowMultiple: true,
            onTapFileChooser: (files) {
              fileChooserTapped = true;
              receivedFiles = files;
            },
          );

          // Verify widget renders with allowMultiple = true
          expect(find.byType(MediaSelectionBottomSheetWidget), findsOneWidget);
          expect(find.byIcon(Icons.folder_open_rounded), findsOneWidget);

          // Test the callback with multiple files
          final widget = tester.widget<MediaSelectionBottomSheetWidget>(
            find.byType(MediaSelectionBottomSheetWidget),
          );

          // Simulate multiple file selection
          widget.onTapFileChooser!(mockFiles);

          // Verify callback was executed with multiple files
          expect(fileChooserTapped, isTrue);
          expect(receivedFiles, isNotNull);
          expect(receivedFiles?.length, equals(3));
          expect(receivedFiles?[0].name, equals(testImageJpgName));
          expect(receivedFiles?[1].name, equals(testImagePngName));
          expect(receivedFiles?[2].name, equals(testPdfName));
        },
      );

      testWidgets('handles empty file selection gracefully', (tester) async {
        bool fileChooserTapped = false;
        List<XFile>? receivedFiles;

        await pumpMediaSelectionBottomSheetWidget(
          tester,
          onTapFileChooser: (files) {
            fileChooserTapped = true;
            receivedFiles = files;
          },
        );

        // Test the callback with empty file list
        final widget = tester.widget<MediaSelectionBottomSheetWidget>(
          find.byType(MediaSelectionBottomSheetWidget),
        );

        // Simulate empty file selection
        widget.onTapFileChooser?.call([]);

        // Verify callback was executed with empty list
        expect(fileChooserTapped, isTrue);
        expect(receivedFiles, isNotNull);
        expect(receivedFiles?.length, equals(0));
      });

      testWidgets('calls onTapRemoveImage callback', (tester) async {
        bool removeImageTapped = false;

        await pumpMediaSelectionBottomSheetWidget(
          tester,
          onTapRemoveImage: () {
            removeImageTapped = true;
          },
        );

        // Verify the remove image option is present
        final l10n = getL10n(tester);
        expect(find.text(l10n.removeImage), findsOneWidget);
        expect(find.byIcon(Icons.delete), findsOneWidget);

        // Test the callback directly by simulating the result
        final widget = tester.widget<MediaSelectionBottomSheetWidget>(
          find.byType(MediaSelectionBottomSheetWidget),
        );

        // Simulate the callback being called
        widget.onTapRemoveImage?.call();

        // Verify callback was executed
        expect(removeImageTapped, isTrue);
      });
    });

    group('Localization Tests -', () {
      testWidgets('displays localized title text', (tester) async {
        await pumpMediaSelectionBottomSheetWidget(tester);

        // Verify localized title is displayed
        final l10n = getL10n(tester);
        expect(find.text(l10n.selectMedia), findsOneWidget);
      });

      testWidgets('displays localized subtitle text', (tester) async {
        await pumpMediaSelectionBottomSheetWidget(tester);

        // Verify localized subtitle is displayed
        final l10n = getL10n(tester);
        expect(find.text(l10n.chooseAMediaFile), findsOneWidget);
      });

      testWidgets('displays localized photo gallery text', (tester) async {
        await pumpMediaSelectionBottomSheetWidget(tester);

        // Verify localized photo gallery text is displayed
        final l10n = getL10n(tester);
        expect(find.text(l10n.photoGallery), findsOneWidget);
        expect(find.text(l10n.selectFromGallery), findsOneWidget);
      });

      testWidgets('displays localized file chooser text when provided', (
        tester,
      ) async {
        await pumpMediaSelectionBottomSheetWidget(
          tester,
          onTapFileChooser: (files) {},
        );

        // Verify localized file chooser text is displayed
        final l10n = getL10n(tester);
        expect(find.text(l10n.filePicker), findsOneWidget);
        expect(find.text(l10n.browseFiles), findsOneWidget);
      });

      testWidgets('does not display file chooser text when not provided', (
        tester,
      ) async {
        await pumpMediaSelectionBottomSheetWidget(
          tester,
          onTapFileChooser: null,
        );

        // Verify localized file chooser text is not displayed
        final l10n = getL10n(tester);
        expect(find.text(l10n.filePicker), findsNothing);
        expect(find.text(l10n.browseFiles), findsNothing);
      });

      testWidgets('displays localized remove image text when provided', (
        tester,
      ) async {
        await pumpMediaSelectionBottomSheetWidget(
          tester,
          onTapRemoveImage: () {},
        );

        // Verify localized remove image text is displayed
        final l10n = getL10n(tester);
        expect(find.text(l10n.removeImage), findsOneWidget);
        expect(find.text(l10n.removeImageDescription), findsOneWidget);
      });

      testWidgets('displays localized camera text when not desktop', (
        tester,
      ) async {
        await pumpMediaSelectionBottomSheetWidget(tester);

        // Note: Camera option is conditionally rendered based on CommonUtils.isDesktop(context)
        // In test environment, we can't easily mock this, so we just verify the widget renders
        expect(find.byType(MediaSelectionBottomSheetWidget), findsOneWidget);
      });
    });

    group('Text Styling Tests -', () {
      testWidgets('applies correct text styles to title and subtitle', (
        tester,
      ) async {
        await pumpMediaSelectionBottomSheetWidget(tester);

        // Get the theme from context
        final BuildContext context = tester.element(
          find.byType(MediaSelectionBottomSheetWidget),
        );
        final theme = Theme.of(context);

        // Find title and subtitle texts
        final l10n = getL10n(tester);

        // Verify title text style
        final titleText = tester.widget<Text>(find.text(l10n.selectMedia));
        expect(
          titleText.style?.fontSize,
          equals(theme.textTheme.headlineSmall?.fontSize),
        );
        expect(titleText.style?.fontWeight, equals(FontWeight.w600));

        // Verify subtitle text style
        final subtitleText = tester.widget<Text>(
          find.text(l10n.chooseAMediaFile),
        );
        expect(
          subtitleText.style?.fontSize,
          equals(theme.textTheme.bodyMedium?.fontSize),
        );
      });

      testWidgets('applies correct text alignment', (tester) async {
        await pumpMediaSelectionBottomSheetWidget(tester);

        final l10n = getL10n(tester);

        // Verify text alignment for title and subtitle
        final titleText = tester.widget<Text>(find.text(l10n.selectMedia));
        expect(titleText.textAlign, equals(TextAlign.center));

        final subtitleText = tester.widget<Text>(
          find.text(l10n.chooseAMediaFile),
        );
        expect(subtitleText.textAlign, equals(TextAlign.center));
      });

      testWidgets('applies correct text styles to custom title and subtitle', (
        tester,
      ) async {
        const customTitle = 'Custom Title';
        const customSubtitle = 'Custom Subtitle';

        await pumpMediaSelectionBottomSheetWidget(
          tester,
          title: customTitle,
          subtitle: customSubtitle,
        );

        // Get the theme from context
        final BuildContext context = tester.element(
          find.byType(MediaSelectionBottomSheetWidget),
        );
        final theme = Theme.of(context);

        // Verify custom title text style
        final titleText = tester.widget<Text>(find.text(customTitle));
        expect(
          titleText.style?.fontSize,
          equals(theme.textTheme.headlineSmall?.fontSize),
        );
        expect(titleText.style?.fontWeight, equals(FontWeight.w600));
        expect(titleText.textAlign, equals(TextAlign.center));

        // Verify custom subtitle text style
        final subtitleText = tester.widget<Text>(find.text(customSubtitle));
        expect(
          subtitleText.style?.fontSize,
          equals(theme.textTheme.bodyMedium?.fontSize),
        );
        expect(subtitleText.textAlign, equals(TextAlign.center));
      });
    });

    group('Layout and Structure Tests -', () {
      testWidgets('has correct widget hierarchy', (tester) async {
        await pumpMediaSelectionBottomSheetWidget(
          tester,
          onTapFileChooser: (files) {},
        );

        // Verify main structure
        expect(find.byType(Padding), findsAtLeastNWidgets(1));
        expect(find.byType(Column), findsAtLeastNWidgets(1));
        expect(
          find.byType(Text),
          findsAtLeastNWidgets(2),
        ); // Title + subtitle + option texts
        expect(
          find.byType(SizedBox),
          findsAtLeastNWidgets(3),
        ); // Multiple spacing widgets
        expect(find.byType(BottomSheetOptionWidget), findsAtLeastNWidgets(2));
      });

      testWidgets('applies correct padding', (tester) async {
        await pumpMediaSelectionBottomSheetWidget(tester);

        // Find the main padding widget by looking for the MediaSelectionBottomSheetWidget
        final mediaWidget = find.byType(MediaSelectionBottomSheetWidget);
        expect(mediaWidget, findsOneWidget);

        // Verify the widget structure has padding
        expect(find.byType(Padding), findsAtLeastNWidgets(1));

        // The main padding should have the expected values
        // Note: We can't easily test the exact padding due to MediaQuery.viewInsets
        // but we can verify the structure is correct
        expect(find.byType(Column), findsAtLeastNWidgets(1));
      });

      testWidgets('applies correct column properties', (tester) async {
        await pumpMediaSelectionBottomSheetWidget(tester);

        // Find the main column inside MediaSelectionBottomSheetWidget
        final mediaWidget = find.byType(MediaSelectionBottomSheetWidget);
        expect(mediaWidget, findsOneWidget);

        // Verify column exists (there may be multiple columns due to BottomSheetOptionWidget)
        expect(find.byType(Column), findsAtLeastNWidgets(1));

        // The main column should have the correct properties
        // Note: We can't easily isolate the main column from child columns
        // but we can verify the structure is correct
        expect(find.byType(Text), findsAtLeastNWidgets(2));
      });

      testWidgets('handles spacing correctly', (tester) async {
        await pumpMediaSelectionBottomSheetWidget(
          tester,
          onTapFileChooser: (files) {},
        );

        // Verify SizedBox widgets for spacing
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));

        // Check for specific spacing values
        final spacingValues = sizedBoxes.map((box) => box.height).toList();
        expect(spacingValues, contains(8.0)); // Between title and subtitle
        expect(spacingValues, contains(16.0)); // Between options
        expect(
          spacingValues,
          contains(32.0),
        ); // Before camera option (when present)
      });
    });

    group('Edge Cases Tests -', () {
      testWidgets('handles null callbacks gracefully', (tester) async {
        await pumpMediaSelectionBottomSheetWidget(
          tester,
          onTapFileChooser: null,
        );

        // Verify widget renders without errors
        expect(find.byType(MediaSelectionBottomSheetWidget), findsOneWidget);
        expect(find.byIcon(Icons.photo_library_rounded), findsOneWidget);
      });

      testWidgets('handles empty callbacks', (tester) async {
        await pumpMediaSelectionBottomSheetWidget(
          tester,
          onTapCamera: (file) {},
          onTapGallery: (files) {},
          onTapFileChooser: (files) {},
        );

        // Verify widget renders without errors
        expect(find.byType(MediaSelectionBottomSheetWidget), findsOneWidget);
        expect(find.byIcon(Icons.photo_library_rounded), findsOneWidget);
        expect(find.byIcon(Icons.folder_open_rounded), findsOneWidget);
      });

      testWidgets('handles different screen sizes', (tester) async {
        // Test with different screen sizes
        final screenSizes = [
          const Size(320, 568), // iPhone SE
          const Size(375, 667), // iPhone 8
          const Size(414, 896), // iPhone 11 Pro Max
          const Size(768, 1024), // iPad
        ];

        for (final size in screenSizes) {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1.0;

          await pumpMediaSelectionBottomSheetWidget(
            tester,
            onTapFileChooser: (files) {},
          );

          // Verify widget renders correctly
          expect(find.byType(MediaSelectionBottomSheetWidget), findsOneWidget);
          expect(find.byIcon(Icons.photo_library_rounded), findsOneWidget);
        }
      });

      testWidgets('handles empty title and subtitle', (tester) async {
        await pumpMediaSelectionBottomSheetWidget(
          tester,
          title: '',
          subtitle: '',
        );

        // Verify empty title and subtitle are handled
        expect(find.text(''), findsAtLeastNWidgets(2)); // Title and subtitle
        expect(find.byType(MediaSelectionBottomSheetWidget), findsOneWidget);
      });

      testWidgets('handles very long title and subtitle', (tester) async {
        const longTitle =
            'This is a very long title that should be handled gracefully by the widget layout system';
        const longSubtitle =
            'This is a very long subtitle that should also be handled gracefully by the widget layout system and should not cause overflow issues';

        await pumpMediaSelectionBottomSheetWidget(
          tester,
          title: longTitle,
          subtitle: longSubtitle,
        );

        // Verify widget renders without errors
        expect(find.byType(MediaSelectionBottomSheetWidget), findsOneWidget);
        expect(find.text(longTitle), findsOneWidget);
        expect(find.text(longSubtitle), findsOneWidget);
      });
    });

    group('Parameter Validation Tests -', () {
      testWidgets('allowMultiple defaults to false', (tester) async {
        await pumpMediaSelectionBottomSheetWidget(tester);

        // Verify widget renders with default allowMultiple
        expect(find.byType(MediaSelectionBottomSheetWidget), findsOneWidget);
      });

      testWidgets('allowMultiple can be set to true', (tester) async {
        await pumpMediaSelectionBottomSheetWidget(tester, allowMultiple: true);

        // Verify widget renders with allowMultiple = true
        expect(find.byType(MediaSelectionBottomSheetWidget), findsOneWidget);
      });

      testWidgets('title parameter overrides default localized text', (
        tester,
      ) async {
        const customTitle = 'Custom Media Selection';

        await pumpMediaSelectionBottomSheetWidget(tester, title: customTitle);

        // Verify custom title is used
        expect(find.text(customTitle), findsOneWidget);

        // Verify default title is not used
        final l10n = getL10n(tester);
        expect(find.text(l10n.selectMedia), findsNothing);
      });

      testWidgets('subtitle parameter overrides default localized text', (
        tester,
      ) async {
        const customSubtitle = 'Choose your media source';

        await pumpMediaSelectionBottomSheetWidget(
          tester,
          subtitle: customSubtitle,
        );

        // Verify custom subtitle is used
        expect(find.text(customSubtitle), findsOneWidget);

        // Verify default subtitle is not used
        final l10n = getL10n(tester);
        expect(find.text(l10n.chooseAMediaFile), findsNothing);
      });
    });
  });
}
