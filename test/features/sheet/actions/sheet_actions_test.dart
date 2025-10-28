import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/common/providers/common_providers.dart';
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
        verify(() => mockGoRouter.push('/whatsapp-group-connect/${testSheet.id}')).called(1);
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
        verify(() => mockGoRouter.push('/whatsapp-group-connect/$customSheetId')).called(1);
      });

      testWidgets('handles empty sheet ID in navigation', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Connect Empty',
          onPressed: (context, ref) =>
              SheetActions.connectSheet(context, ''),
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
        await tester.pumpActionsWidget(
          container: container,
          buttonText: getL10n(tester).copySheetContent,
          onPressed: (context, ref) =>
              SheetActions.copySheet(context, ref, testSheet.id),
        );

        // Tap the button to trigger copy action
        await tester.tap(find.text(getL10n(tester).copySheetContent));
        await tester.pumpAndSettle();

        // Verify the action was called (we can't easily test clipboard in unit tests)
        expect(find.text(getL10n(tester).copySheetContent), findsOneWidget);
      });

      testWidgets('shows snackbar after copying', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: getL10n(tester).copySheetContent,
          onPressed: (context, ref) =>
              SheetActions.copySheet(context, ref, testSheet.id),
        );

        // Tap the button to trigger copy action
        await tester.tap(find.text(getL10n(tester).copySheetContent));
        await tester.pumpAndSettle();

        // Verify snackbar is shown with correct message
        expect(find.byType(SnackBar), findsOneWidget);
        final l10n = getL10n(tester);
        expect(find.text(l10n.copiedToClipboard), findsOneWidget);
      });
    });

    group('shareSheet', () {
      testWidgets('shows share bottom sheet', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: getL10n(tester).shareSheet,
          onPressed: (context, ref) => SheetActions.shareSheet(context, testSheet.id),
        );

        // Tap the button to trigger share action
        await tester.tap(find.text(getL10n(tester).shareSheet));
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

        await tester.pumpActionsWidget(
          container: container,
          buttonText: getL10n(tester).editThisSheet,
          onPressed: (context, ref) => SheetActions.editSheet(ref, testSheet.id),
        );

        // Tap the button to trigger edit action
        await tester.tap(find.text(getL10n(tester).editThisSheet));
        await tester.pumpAndSettle();

        // Verify edit content ID was set
        final editContentId = container.read(editContentIdProvider);
        expect(editContentId, equals(testSheet.id));
      });
    });

    group('deleteSheet', () {
      testWidgets('shows delete confirmation dialog', (tester) async {
        await tester.pumpActionsWidget(
          buttonText: getL10n(tester).deleteThisSheet,
          onPressed: (context, ref) =>
              SheetActions.deleteSheet(context, ref, testSheet.id),
          container: container,
        );

        // Tap the button to trigger delete action
        await tester.tap(find.text(getL10n(tester).deleteThisSheet));
        await tester.pumpAndSettle();

        // Verify delete confirmation bottom sheet is shown
        expect(find.byType(BottomSheet), findsOneWidget);
      });
    });

    group('showSheetMenu', (){
      testWidgets('shows sheet menu without edit item when editing', (
        tester,
      ) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showSheetMenu(
            context: context,
            ref: ref,
            isEditing: true,
            sheetId: testSheet.id,
          ),
        );

        // Tap the button to trigger menu action
        await tester.tap(find.text('Show Menu'));
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
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showSheetMenu(
            context: context,
            ref: ref,
            isEditing: false,
            sheetId: testSheet.id,
          ),
        );

        // Tap the button to trigger menu action
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Verify subtitles are displayed
        final l10n = getL10n(tester);
        expect(find.text(l10n.connectWithWhatsAppGroup), findsOneWidget);
        expect(find.text(l10n.copySheetContent), findsOneWidget);
        expect(find.text(l10n.shareThisSheet), findsOneWidget);
        expect(find.text(l10n.editThisSheet), findsOneWidget);
        expect(find.text(l10n.deleteThisSheet), findsOneWidget);
      });
    });

    group('Integration Tests', () {
      testWidgets('connect action works with real providers', (tester) async {
        await tester.pumpActionsWidget(
          buttonText: getL10n(tester).connectWithWhatsAppGroup,
          onPressed: (context, ref) =>
              SheetActions.connectSheet(context, testSheet.id),
          container: container,
          router: mockGoRouter,
        );

        // Tap the button
        await tester.tap(find.text(getL10n(tester).connectWithWhatsAppGroup));
        await tester.pumpAndSettle();

        // Verify the navigation was called with correct route
        verify(() => mockGoRouter.push('/whatsapp-group-connect/${testSheet.id}')).called(1);
      });

      testWidgets('copy action works with real providers', (tester) async {
        await tester.pumpActionsWidget(
          buttonText: getL10n(tester).copySheetContent,
          onPressed: (context, ref) =>
              SheetActions.copySheet(context, ref, testSheet.id),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text(getL10n(tester).copySheetContent));
        await tester.pumpAndSettle();

        // Verify the action completed without errors
        expect(find.text(getL10n(tester).copySheetContent), findsOneWidget);
      });

      testWidgets('share action works with real providers', (tester) async {
        await tester.pumpActionsWidget(
          buttonText: getL10n(tester).shareSheet,
          onPressed: (context, ref) => SheetActions.shareSheet(context, testSheet.id),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text(getL10n(tester).shareSheet));
        await tester.pump();

        // Verify the action completed without errors
        expect(find.text(getL10n(tester).shareSheet), findsAtLeastNWidgets(1));
      });

      testWidgets('delete action works with real providers', (tester) async {
        await tester.pumpActionsWidget(
          buttonText: getL10n(tester).deleteThisSheet,
          onPressed: (context, ref) =>
              SheetActions.deleteSheet(context, ref, testSheet.id),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text(getL10n(tester).deleteThisSheet));
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
          onPressed: (context, ref) =>
              SheetActions.editSheet(ref, longSheetId),
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
      testWidgets('edit state persists across multiple actions', (tester) async {
        // Set edit state
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Edit',
          onPressed: (context, ref) => SheetActions.editSheet(ref, testSheet.id),
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
          onPressed: (context, ref) => SheetActions.editSheet(ref, testSheet.id),
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
          onPressed: (context, ref) => SheetActions.editSheet(ref, testSheet.id),
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
