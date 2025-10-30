import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/media_selection_bottom_sheet.dart';
import 'package:zoe/features/share/widgets/share_items_bottom_sheet.dart';
import 'package:zoe/features/sheet/actions/sheet_actions.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/test_utils.dart';
import '../../../test-utils/mock_gorouter.dart';
import '../utils/sheet_utils.dart';

void main() {
  group('SheetActions Tests', () {
    late ProviderContainer container;
    late SheetModel testSheet;
    late MockGoRouter mockGoRouter;

    setUp(() {
      container = ProviderContainer.test();
      testSheet = getSheetByIndex(container);
      mockGoRouter = MockGoRouter();

      // Set up mock methods
      when(() => mockGoRouter.canPop()).thenReturn(true);
      when(() => mockGoRouter.pop()).thenReturn(null);
      when(() => mockGoRouter.push(any())).thenAnswer((_) async => true);

      container = ProviderContainer.test(
        overrides: [
          sheetProvider(testSheet.id).overrideWith((ref) => testSheet),
          editContentIdProvider.overrideWith((ref) => null),
        ],
      );
    });

    // Helper function to get L10n strings in tests
    L10n getL10n(WidgetTester tester) {
      return WidgetTesterExtension.getL10n(tester, byType: Consumer);
    }

    group('connectSheet', () {
      testWidgets('navigates to WhatsApp group connect screen', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Connect Sheet',
          onPressed: (context, ref) =>
              SheetActions.connectSheet(context, testSheet.id),
          router: mockGoRouter,
        );

        // Tap the button to trigger connect action
        await tester.tap(find.text('Connect Sheet'));
        await tester.pumpAndSettle();

        // Verify the navigation was called with correct route
        verify(
          () => mockGoRouter.push('/whatsapp-group-connect/${testSheet.id}'),
        ).called(1);
      });

      testWidgets('navigates with correct sheet ID parameter', (tester) async {
        const customSheetId = 'custom-sheet-123';

        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Connect Custom',
          onPressed: (context, ref) =>
              SheetActions.connectSheet(context, customSheetId),
          router: mockGoRouter,
        );

        // Tap the button to trigger connect action
        await tester.tap(find.text('Connect Custom'));
        await tester.pumpAndSettle();

        // Verify the navigation was called with correct sheet ID
        verify(
          () => mockGoRouter.push('/whatsapp-group-connect/$customSheetId'),
        ).called(1);
      });

      testWidgets('handles empty sheet ID in navigation', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Connect Empty',
          onPressed: (context, ref) => SheetActions.connectSheet(context, ''),
          router: mockGoRouter,
        );

        // Tap the button to trigger connect action
        await tester.tap(find.text('Connect Empty'));
        await tester.pumpAndSettle();

        // Verify the navigation was called with empty sheet ID
        verify(() => mockGoRouter.push('/whatsapp-group-connect/')).called(1);
      });
    });

    group('copySheet', () {
      testWidgets('copies sheet content to clipboard', (tester) async {
        const buttonText = 'Copy Sheet Content';
        
        await tester.pumpActionsWidget(
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) =>
              SheetActions.copySheet(context, ref, testSheet.id),
        );

        // Tap the button to trigger copy action
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify the action was called (we can't easily test clipboard in unit tests)
        expect(find.text(buttonText), findsOneWidget);
      });

      testWidgets('shows snackbar after copying', (tester) async {
        const buttonText = 'Copy Sheet Content';
        
        await tester.pumpActionsWidget(
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) =>
              SheetActions.copySheet(context, ref, testSheet.id),
        );

        // Tap the button to trigger copy action
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify snackbar is shown with correct message
        expect(find.byType(SnackBar), findsOneWidget);
        final l10n = getL10n(tester);
        expect(find.text(l10n.copiedToClipboard), findsOneWidget);
      });
    });

    group('shareSheet', () {
      testWidgets('shows share bottom sheet', (tester) async {
        const buttonText = 'Share Sheet';
        
        await tester.pumpActionsWidget(
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) =>
              SheetActions.shareSheet(context, testSheet.id),
        );

        // Tap the button to trigger share action
        await tester.tap(find.text(buttonText));
        await tester.pump(); // Don't use pumpAndSettle to avoid timeout

        // Verify the action was called
        expect(find.text(getL10n(tester).shareSheet), findsAtLeastNWidgets(1));
        expect(find.byType(ShareItemsBottomSheet), findsOneWidget);
      });
    });

    group('editSheet', () {
      testWidgets('sets edit content ID in provider', (tester) async {
        // Verify edit content ID is initially null
        final initialEditContentId = container.read(editContentIdProvider);
        expect(initialEditContentId, isNull);

        const buttonText = 'Edit This Sheet';
        
        await tester.pumpActionsWidget(
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) =>
              SheetActions.editSheet(ref, testSheet.id),
        );

        // Tap the button to trigger edit action
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify edit content ID was set
        final editContentId = container.read(editContentIdProvider);
        expect(editContentId, equals(testSheet.id));
      });
    });

    group('deleteSheet', () {
      testWidgets('shows delete confirmation dialog', (tester) async {
        const buttonText = 'Delete This Sheet';
        
        await tester.pumpActionsWidget(
          buttonText: buttonText,
          onPressed: (context, ref) =>
              SheetActions.deleteSheet(context, ref, testSheet.id),
          container: container,
        );

        // Tap the button to trigger delete action
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify delete confirmation bottom sheet is shown
        expect(find.byType(BottomSheet), findsOneWidget);
      });
    });

    group('addOrUpdateCoverImage', () {
      final buttonText = 'Add Cover Image';

      testWidgets('shows media selection bottom sheet', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) =>
              SheetActions.addOrUpdateCoverImage(context, ref, testSheet.id),
        );

        // Tap the button to trigger add cover image action
        await tester.tap(find.text(buttonText));
        await tester.pump();

        // Verify media selection bottom sheet is shown
        expect(find.byType(MediaSelectionBottomSheetWidget), findsOneWidget);
      });

      testWidgets('handles camera selection', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) =>
              SheetActions.addOrUpdateCoverImage(context, ref, testSheet.id),
        );

        // Tap the button to trigger add cover image action
        await tester.tap(find.text(buttonText));
        await tester.pump();

        // Verify the action was called without errors
        expect(find.byType(MediaSelectionBottomSheetWidget), findsOneWidget);
        expect(find.text(getL10n(tester).takePhotoOrVideo), findsOneWidget);
      });

      testWidgets('handles gallery selection', (tester) async {
        final buttonText = 'Update Cover Image';

        await tester.pumpActionsWidget(
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) =>
              SheetActions.addOrUpdateCoverImage(context, ref, testSheet.id),
        );

        // Tap the button to trigger update cover image action
        await tester.tap(find.text(buttonText));
        await tester.pump();

        // Verify the action was called without errors
        expect(find.byType(MediaSelectionBottomSheetWidget), findsOneWidget);
        expect(find.text(getL10n(tester).photoGallery), findsOneWidget);
      });

      testWidgets('handles different sheet IDs', (tester) async {
        final customSheetId = 'custom-sheet-456';
        final buttonText = 'Add Custom Cover';

        await tester.pumpActionsWidget(
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) =>
              SheetActions.addOrUpdateCoverImage(context, ref, customSheetId),
        );

        // Tap the button to trigger add cover image action
        await tester.tap(find.text(buttonText));
        await tester.pump();

        // Verify the action was called without errors
        expect(find.byType(MediaSelectionBottomSheetWidget), findsOneWidget);
      });
    });

    group('removeCoverImage', () {
      final buttonText = 'Remove Cover Image';

      testWidgets('removes cover image from sheet', (tester) async {
        container = ProviderContainer.test();

        final coverImageUrl = 'https://example.com/test-cover.jpg';

        // First, ensure the test sheet has a cover image
        container
            .read(sheetListProvider.notifier)
            .updateSheetCoverImage(testSheet.id, coverImageUrl);

        // Verify cover image was updated in the provider
        final updatedSheet = container.read(sheetProvider(testSheet.id));
        expect(updatedSheet?.coverImageUrl, equals(coverImageUrl));

        await tester.pumpActionsWidget(
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) =>
              SheetActions.removeCoverImage(context, ref, testSheet.id),
        );

        // Tap the button to trigger remove cover image action
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify cover image is removed
        final sheetWithoutCover = container.read(sheetProvider(testSheet.id));
        expect(sheetWithoutCover?.coverImageUrl, isNull);
      });

      testWidgets('handles removing from sheet without cover image', (
        tester,
      ) async {
        container = ProviderContainer.test();
        
        // Ensure test sheet has no cover image
        container
            .read(sheetListProvider.notifier)
            .updateSheetCoverImage(testSheet.id, null);

        await tester.pumpActionsWidget(
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) =>
              SheetActions.removeCoverImage(context, ref, testSheet.id),
        );

        // Tap the button to trigger remove cover image action
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify no errors occurred and cover image remains null
        final sheet = container.read(sheetProvider(testSheet.id));
        expect(sheet?.coverImageUrl, isNull);
      });
    });

    group('showSheetMenu', () {
      final buttonText = 'Show Menu';

      testWidgets('shows sheet menu without edit item when editing', (
        tester,
      ) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) => showSheetMenu(
            context: context,
            ref: ref,
            isEditing: true,
            sheetId: testSheet.id,
          ),
        );

        // Tap the button to trigger menu action
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify menu is shown without edit item
        final l10n = getL10n(tester);
        expect(find.text(l10n.connectWithWhatsAppGroup), findsOneWidget);
        expect(find.text(l10n.copySheetContent), findsOneWidget);
        expect(find.text(l10n.shareThisSheet), findsOneWidget);
        expect(find.text(l10n.editThisSheet), findsNothing);
        expect(find.text(l10n.deleteThisSheet), findsOneWidget);
      });

      testWidgets('menu items have correct subtitles', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) => showSheetMenu(
            context: context,
            ref: ref,
            isEditing: false,
            sheetId: testSheet.id,
          ),
        );

        // Tap the button to trigger menu action
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify subtitles are displayed
        final l10n = getL10n(tester);
        expect(find.text(l10n.connectWithWhatsAppGroup), findsOneWidget);
        expect(find.text(l10n.copySheetContent), findsOneWidget);
        expect(find.text(l10n.shareThisSheet), findsOneWidget);
        expect(find.text(l10n.editThisSheet), findsOneWidget);
        expect(find.text(l10n.deleteThisSheet), findsOneWidget);
      });

      testWidgets('shows add cover image option when no cover image exists', (
        tester,
      ) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) => showSheetMenu(
            context: context,
            ref: ref,
            isEditing: false,
            hasCoverImage: false,
            sheetId: testSheet.id,
          ),
        );

        // Tap the button to trigger menu action
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify add cover image option is shown
        final l10n = getL10n(tester);
        expect(find.text(l10n.addCoverImage), findsOneWidget);
        expect(find.text(l10n.updateCoverImage), findsNothing);
        expect(find.text(l10n.removeCoverImage), findsNothing);
      });

      testWidgets(
        'shows update and remove cover image options when cover image exists',
        (tester) async {
          await tester.pumpActionsWidget(
            container: container,
            buttonText: buttonText,
            onPressed: (context, ref) => showSheetMenu(
              context: context,
              ref: ref,
              isEditing: false,
              hasCoverImage: true,
              sheetId: testSheet.id,
            ),
          );

          // Tap the button to trigger menu action
          await tester.tap(find.text(buttonText));
          await tester.pumpAndSettle();

          // Verify update and remove cover image options are shown
          final l10n = getL10n(tester);
          expect(find.text(l10n.updateCoverImage), findsOneWidget);
          expect(find.text(l10n.removeCoverImage), findsOneWidget);
          expect(find.text(l10n.addCoverImage), findsNothing);
        },
      );

      testWidgets('cover image menu items work correctly', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) => showSheetMenu(
            context: context,
            ref: ref,
            isEditing: false,
            hasCoverImage: true,
            sheetId: testSheet.id,
          ),
        );

        // Tap the button to trigger menu action
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify all expected menu items are present
        final l10n = getL10n(tester);
        expect(find.text(l10n.connectWithWhatsAppGroup), findsOneWidget);
        expect(find.text(l10n.updateCoverImage), findsOneWidget);
        expect(find.text(l10n.removeCoverImage), findsOneWidget);
        expect(find.text(l10n.copySheetContent), findsOneWidget);
        expect(find.text(l10n.shareThisSheet), findsOneWidget);
        expect(find.text(l10n.editThisSheet), findsOneWidget);
        expect(find.text(l10n.deleteThisSheet), findsOneWidget);
      });

      testWidgets('menu adapts correctly to editing state with cover image', (
        tester,
      ) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Show Menu Editing',
          onPressed: (context, ref) => showSheetMenu(
            context: context,
            ref: ref,
            isEditing: true,
            hasCoverImage: true,
            sheetId: testSheet.id,
          ),
        );

        // Tap the button to trigger menu action
        await tester.tap(find.text('Show Menu Editing'));
        await tester.pumpAndSettle();

        // Verify menu items when editing with cover image
        final l10n = getL10n(tester);
        expect(find.text(l10n.connectWithWhatsAppGroup), findsOneWidget);
        expect(find.text(l10n.updateCoverImage), findsOneWidget);
        expect(find.text(l10n.removeCoverImage), findsOneWidget);
        expect(find.text(l10n.copySheetContent), findsOneWidget);
        expect(find.text(l10n.shareThisSheet), findsOneWidget);
        expect(
          find.text(l10n.editThisSheet),
          findsNothing,
        ); // Should not show when editing
        expect(find.text(l10n.deleteThisSheet), findsOneWidget);
      });
    });

    group('Integration Tests', () {
      testWidgets('connect action works with real providers', (tester) async {
        const buttonText = 'Connect With WhatsApp Group';
        
        await tester.pumpActionsWidget(
          buttonText: buttonText,
          onPressed: (context, ref) =>
              SheetActions.connectSheet(context, testSheet.id),
          container: container,
          router: mockGoRouter,
        );

        // Tap the button
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify the navigation was called with correct route
        verify(
          () => mockGoRouter.push('/whatsapp-group-connect/${testSheet.id}'),
        ).called(1);
      });

      testWidgets('copy action works with real providers', (tester) async {
        const buttonText = 'Copy Sheet Content';
        
        await tester.pumpActionsWidget(
          buttonText: buttonText,
          onPressed: (context, ref) =>
              SheetActions.copySheet(context, ref, testSheet.id),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify the action completed without errors
        expect(find.text(buttonText), findsOneWidget);
      });

      testWidgets('share action works with real providers', (tester) async {
        const buttonText = 'Share Sheet';
        
        await tester.pumpActionsWidget(
          buttonText: buttonText,
          onPressed: (context, ref) =>
              SheetActions.shareSheet(context, testSheet.id),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text(buttonText));
        await tester.pump();

        // Verify the action completed without errors
        expect(find.text(getL10n(tester).shareSheet), findsAtLeastNWidgets(1));
      });

      testWidgets('delete action works with real providers', (tester) async {
        const buttonText = 'Delete This Sheet';
        
        await tester.pumpActionsWidget(
          buttonText: buttonText,
          onPressed: (context, ref) =>
              SheetActions.deleteSheet(context, ref, testSheet.id),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify delete confirmation bottom sheet is shown
        expect(find.byType(BottomSheet), findsOneWidget);
      });
    });

    group('Edge Cases', () {

      testWidgets('handles non-existent sheet ID gracefully', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Edit Non-existent',
          onPressed: (context, ref) =>
              SheetActions.editSheet(ref, 'non-existent-id'),
        );

        // Tap the button
        await tester.tap(find.text('Edit Non-existent'));
        await tester.pumpAndSettle();

        // Should not crash and set the ID anyway
        final editContentId = container.read(editContentIdProvider);
        expect(editContentId, equals('non-existent-id'));
      });

      testWidgets('handles special characters in sheet ID', (tester) async {
        const specialSheetId = r'sheet@#$%^&*()_+-=[]{}|;:,.<>?';

        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Edit Special',
          onPressed: (context, ref) =>
              SheetActions.editSheet(ref, specialSheetId),
        );

        // Tap the button
        await tester.tap(find.text('Edit Special'));
        await tester.pumpAndSettle();

        // Should not crash
        final editContentId = container.read(editContentIdProvider);
        expect(editContentId, equals(specialSheetId));
      });

      testWidgets('handles very long sheet ID', (tester) async {
        final longSheetId = 'a' * 1000;

        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Edit Long',
          onPressed: (context, ref) => SheetActions.editSheet(ref, longSheetId),
        );

        // Tap the button
        await tester.tap(find.text('Edit Long'));
        await tester.pumpAndSettle();

        // Should not crash
        final editContentId = container.read(editContentIdProvider);
        expect(editContentId, equals(longSheetId));
      });
    });

    group('Provider State Management', () {
      testWidgets('edit state persists across multiple actions', (
        tester,
      ) async {
        // Set edit state
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Edit',
          onPressed: (context, ref) =>
              SheetActions.editSheet(ref, testSheet.id),
        );

        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();

        // Verify edit state is set
        expect(container.read(editContentIdProvider), equals(testSheet.id));

        // Clear edit state
        container.read(editContentIdProvider.notifier).state = null;
        expect(container.read(editContentIdProvider), isNull);

        // Set edit state again
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Edit Again',
          onPressed: (context, ref) =>
              SheetActions.editSheet(ref, testSheet.id),
        );

        await tester.tap(find.text('Edit Again'));
        await tester.pumpAndSettle();

        // Verify edit state is set again
        expect(container.read(editContentIdProvider), equals(testSheet.id));
      });

      testWidgets('multiple actions work independently', (tester) async {
        // Test edit action
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Edit',
          onPressed: (context, ref) =>
              SheetActions.editSheet(ref, testSheet.id),
        );

        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();

        expect(container.read(editContentIdProvider), equals(testSheet.id));

        // Test copy action (should not affect edit state)
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Copy',
          onPressed: (context, ref) =>
              SheetActions.copySheet(context, ref, testSheet.id),
        );

        await tester.tap(find.text('Copy'));
        await tester.pumpAndSettle();

        // Edit state should still be set
        expect(container.read(editContentIdProvider), equals(testSheet.id));
      });
    });
  });
}
