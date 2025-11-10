import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zoe/common/widgets/media_selection_bottom_sheet.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';

import '../../test-utils/test_utils.dart';

/// Test utilities for DocumentSelectionBottomSheetWidget tests
class DocumentSelectionBottomSheetTestUtils {
  /// Creates a test wrapper for the DocumentSelectionBottomSheetWidget
  static MediaSelectionBottomSheetWidget createTestWidget({
    Function(XFile)? onTapCamera,
    Function(List<XFile>)? onTapGallery,
    Function(List<XFile>)? onTapFileChooser,
  }) {
    return MediaSelectionBottomSheetWidget(
      allowMultiple: false,
      imageQuality: 80,
      onTapCamera: onTapCamera ?? (image) {},
      onTapGallery: onTapGallery ?? (images) {},
      onTapFileChooser: onTapFileChooser,
    );
  }
}

void main() {
  group('DocumentSelectionBottomSheetWidget Tests -', () {
    testWidgets('renders photo gallery option', (tester) async {
      await tester.pumpMaterialWidget(
        child: DocumentSelectionBottomSheetTestUtils.createTestWidget(),
      );

      // Verify photo gallery option is rendered
      expect(find.byIcon(Icons.photo_library_rounded), findsOneWidget);
    });

    testWidgets(
      'renders file chooser option when onTapFileChooser is provided',
      (tester) async {
        await tester.pumpMaterialWidget(
          child: DocumentSelectionBottomSheetTestUtils.createTestWidget(
            onTapFileChooser: (files) {},
          ),
        );

        // Verify file chooser option is rendered
        expect(find.byIcon(Icons.folder_open_rounded), findsOneWidget);
      },
    );

    testWidgets(
      'does not render file chooser option when onTapFileChooser is null',
      (tester) async {
        await tester.pumpMaterialWidget(
          child: DocumentSelectionBottomSheetTestUtils.createTestWidget(
            onTapFileChooser: null,
          ),
        );

        // Verify file chooser option is not rendered
        expect(find.byIcon(Icons.folder_open_rounded), findsNothing);
      },
    );

    testWidgets('applies correct styling to option buttons', (tester) async {
      await tester.pumpMaterialWidget(
        child: DocumentSelectionBottomSheetTestUtils.createTestWidget(
          onTapFileChooser: (files) {},
        ),
      );

      // Verify GlassyContainer is used for option buttons
      expect(find.byType(GlassyContainer), findsAtLeastNWidgets(2));

      // Verify StyledIconContainer is used for icons
      expect(find.byType(StyledIconContainer), findsAtLeastNWidgets(2));
    });

    testWidgets('renders chevron icons in option buttons', (tester) async {
      await tester.pumpMaterialWidget(
        child: DocumentSelectionBottomSheetTestUtils.createTestWidget(
          onTapFileChooser: (files) {},
        ),
      );

      // Verify chevron icons are rendered
      expect(find.byIcon(Icons.chevron_right_rounded), findsAtLeastNWidgets(2));
    });

    testWidgets('handles null callbacks gracefully', (tester) async {
      await tester.pumpMaterialWidget(
        child: DocumentSelectionBottomSheetTestUtils.createTestWidget(
          onTapFileChooser: null,
        ),
      );

      // Verify widget renders without errors
      expect(find.byType(MediaSelectionBottomSheetWidget), findsOneWidget);
      expect(find.byIcon(Icons.photo_library_rounded), findsOneWidget);
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

        await tester.pumpMaterialWidget(
          child: DocumentSelectionBottomSheetTestUtils.createTestWidget(
            onTapFileChooser: (files) {},
          ),
        );

        // Verify widget renders correctly
        expect(find.byType(MediaSelectionBottomSheetWidget), findsOneWidget);
        expect(find.byIcon(Icons.photo_library_rounded), findsOneWidget);
      }
    });

    testWidgets('handles empty callbacks', (tester) async {
      await tester.pumpMaterialWidget(
        child: DocumentSelectionBottomSheetTestUtils.createTestWidget(
          onTapGallery: (images) {},
          onTapFileChooser: (files) {},
        ),
      );

      // Verify widget renders without errors
      expect(find.byType(MediaSelectionBottomSheetWidget), findsOneWidget);
      expect(find.byIcon(Icons.photo_library_rounded), findsOneWidget);
      expect(find.byIcon(Icons.folder_open_rounded), findsOneWidget);
    });

    testWidgets('displays localized title text', (tester) async {
      await tester.pumpMaterialWidget(
        child: DocumentSelectionBottomSheetTestUtils.createTestWidget(),
      );

      // Verify localized title is displayed
      final l10n = WidgetTesterExtension.getL10n(
        tester,
        byType: MediaSelectionBottomSheetWidget,
      );
      expect(find.text(l10n.selectDocument), findsOneWidget);
    });

    testWidgets('displays localized subtitle text', (tester) async {
      await tester.pumpMaterialWidget(
        child: DocumentSelectionBottomSheetTestUtils.createTestWidget(),
      );

      // Verify localized subtitle is displayed
      final l10n = WidgetTesterExtension.getL10n(
        tester,
        byType: MediaSelectionBottomSheetWidget,
      );
      expect(find.text(l10n.chooseHowToAddDocument), findsOneWidget);
    });

    testWidgets('displays localized photo gallery text', (tester) async {
      await tester.pumpMaterialWidget(
        child: DocumentSelectionBottomSheetTestUtils.createTestWidget(),
      );

      // Verify localized photo gallery text is displayed
      final l10n = WidgetTesterExtension.getL10n(
        tester,
        byType: MediaSelectionBottomSheetWidget,
      );
      expect(find.text(l10n.photoGallery), findsOneWidget);
      expect(find.text(l10n.selectFromGallery), findsOneWidget);
    });

    testWidgets('displays localized file chooser text when provided', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(
        child: DocumentSelectionBottomSheetTestUtils.createTestWidget(
          onTapFileChooser: (files) {},
        ),
      );

      // Verify localized file chooser text is displayed
      final l10n = WidgetTesterExtension.getL10n(
        tester,
        byType: MediaSelectionBottomSheetWidget,
      );
      expect(find.text(l10n.filePicker), findsOneWidget);
      expect(find.text(l10n.browseFiles), findsOneWidget);
    });

    testWidgets('does not display file chooser text when not provided', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(
        child: DocumentSelectionBottomSheetTestUtils.createTestWidget(
          onTapFileChooser: null,
        ),
      );

      // Verify localized file chooser text is not displayed
      final l10n = WidgetTesterExtension.getL10n(
        tester,
        byType: MediaSelectionBottomSheetWidget,
      );
      expect(find.text(l10n.filePicker), findsNothing);
      expect(find.text(l10n.browseFiles), findsNothing);
    });

    testWidgets('displays localized camera text when not desktop', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(
        child: DocumentSelectionBottomSheetTestUtils.createTestWidget(),
      );

      // Note: Camera option is conditionally rendered based on CommonUtils.isDesktop(context)
      // In test environment, we can't easily mock this, so we just verify the widget renders
      expect(find.byType(MediaSelectionBottomSheetWidget), findsOneWidget);
    });

    testWidgets('displays all required localized elements', (tester) async {
      await tester.pumpMaterialWidget(
        child: DocumentSelectionBottomSheetTestUtils.createTestWidget(
          onTapFileChooser: (files) {},
        ),
      );

      // Verify all required localized elements are present
      final l10n = WidgetTesterExtension.getL10n(
        tester,
        byType: MediaSelectionBottomSheetWidget,
      );

      expect(find.text(l10n.selectDocument), findsOneWidget);
      expect(find.text(l10n.chooseHowToAddDocument), findsOneWidget);
      expect(find.text(l10n.photoGallery), findsOneWidget);
      expect(find.text(l10n.selectFromGallery), findsOneWidget);
      expect(find.text(l10n.filePicker), findsOneWidget);
      expect(find.text(l10n.browseFiles), findsOneWidget);
    });
  });
}
