import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/whatsapp/utils/image_utils.dart';
import 'package:zoe/features/whatsapp/widgets/enable_invites_bottom_sheet.dart';
import 'package:zoe/features/whatsapp/widgets/guide_step_widget.dart';
import 'package:zoe/features/whatsapp/widgets/important_note_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

import '../../../test-utils/test_utils.dart';

void main() {
  group('EnableInvitesBottomSheet', () {
    testWidgets('renders all components correctly', (tester) async {
      await tester.pumpMaterialWidget(
        child: const EnableInvitesBottomSheet(),
      );
      await tester.pumpAndSettle();

      // Get localized strings
      final l10n = L10n.of(tester.element(find.byType(EnableInvitesBottomSheet)));

      // Verify title
      expect(find.text(l10n.enableInvites), findsOneWidget);

      // Find main column inside SingleChildScrollView
      final mainColumn = find.descendant(
        of: find.byType(SingleChildScrollView),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Column &&
              widget.mainAxisSize == MainAxisSize.min &&
              widget.crossAxisAlignment == CrossAxisAlignment.center,
        ),
      );
      expect(mainColumn, findsOneWidget);

      // Verify spacing SizedBoxes directly under main Column
      final spacers = find.descendant(
        of: mainColumn,
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is SizedBox &&
              (widget.height == 10.0 ||
                  widget.height == 15.0 ||
                  widget.height == 30.0),
        ),
      );
      expect(spacers, findsNWidgets(4)); 

      // Verify GuideStepWidgets
      final guideSteps = find.byType(GuideStepWidget);
      expect(guideSteps, findsNWidgets(2));

      // Verify first guide step
      final firstGuideStep = tester.widget<GuideStepWidget>(
        find.byType(GuideStepWidget).first,
      );
      expect(firstGuideStep.stepNumber, 1);
      expect(firstGuideStep.title, l10n.groupPermissions);
      expect(firstGuideStep.description, l10n.navigateToGroupPermissionsDescription);
      expect(firstGuideStep.imagePath, ImageUtils.permissonIosLight);

      // Verify second guide step
      final secondGuideStep = tester.widget<GuideStepWidget>(
        find.byType(GuideStepWidget).at(1),
      );
      expect(secondGuideStep.stepNumber, 2);
      expect(secondGuideStep.title, l10n.enableInviteViaOption);
      expect(secondGuideStep.description, l10n.enableInviteViaOptionDescription);
      expect(secondGuideStep.imagePath, ImageUtils.inviteLinkIosLight);

      // Verify ImportantNoteWidget
      final importantNote = find.byType(ImportantNoteWidget);
      expect(importantNote, findsOneWidget);
      
      final importantNoteWidget = tester.widget<ImportantNoteWidget>(importantNote);
      expect(importantNoteWidget.title, l10n.importantNote);
      expect(importantNoteWidget.message, l10n.importantNoteDescription);
      expect(importantNoteWidget.icon, Icons.admin_panel_settings_outlined);

      // Verify layout structure
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('shows as modal bottom sheet', (tester) async {
      await tester.pumpMaterialWidget(
        child: Builder(
          builder: (context) => TextButton(
            onPressed: () => showEnableInvitesBottomSheet(context),
            child: const Text('Show Sheet'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap button to show sheet
      await tester.tap(find.text('Show Sheet'));
      await tester.pumpAndSettle();

      // Verify bottom sheet is shown
      expect(find.byType(EnableInvitesBottomSheet), findsOneWidget);

      // Verify bottom sheet properties
      final bottomSheet = find.byType(Material).evaluate().last.widget as Material;
      expect(bottomSheet.shape, isA<RoundedRectangleBorder>());
    
    });

    testWidgets('handles scrolling with long content', (tester) async {
      // Set a small screen size to force scrolling
      tester.binding.window.physicalSizeTestValue = const Size(400, 400);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpMaterialWidget(
        child: const EnableInvitesBottomSheet(),
      );
      await tester.pumpAndSettle();

      // Verify initial scroll position
      final scrollView = find.byType(SingleChildScrollView);
      expect(scrollView, findsOneWidget);
      expect(
        tester.getTopLeft(find.byType(ImportantNoteWidget)).dy,
        greaterThan(400), // Should be below the visible area
      );

      // Scroll to the bottom
      await tester.dragFrom(
        tester.getCenter(scrollView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();

      // Verify ImportantNoteWidget is now visible
      expect(
        tester.getTopLeft(find.byType(ImportantNoteWidget)).dy,
        lessThan(400),
      );
    });
  });
}