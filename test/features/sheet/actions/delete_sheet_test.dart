import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/sheet/actions/delete_sheet.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/widgets/sheet_avatar_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import 'package:zoe/l10n/generated/l10n_en.dart';
import '../../../test-utils/test_utils.dart';
import '../utils/sheet_utils.dart';

void main() {
  group('Delete Sheet Tests', () {
    late ProviderContainer container;
    late SheetModel testSheet;

    // Create a static L10n instance for use before pumping widgets
    final L10n staticL10n = L10nEn();

    setUp(() {
      container = ProviderContainer.test();
      testSheet = getSheetByIndex(container);
    });

    // Helper function to get L10n strings in tests
    L10n getL10n(WidgetTester tester) {
      try {
        return WidgetTesterExtension.getL10n(tester, byType: Consumer);
      } catch (e) {
        // If widget tree hasn't been built yet, return the static instance
        return staticL10n;
      }
    }

    group('showDeleteSheetConfirmation', () {
      testWidgets('shows delete confirmation bottom sheet for valid sheet', (
        tester,
      ) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: getL10n(tester).deleteSheetButton,
          onPressed: (context, ref) =>
              showDeleteSheetConfirmation(context, ref, testSheet.id),
        );

        // Tap the button to trigger delete confirmation
        await tester.tap(find.text(getL10n(tester).deleteSheetButton));
        await tester.pumpAndSettle();

        // Verify delete confirmation bottom sheet is shown
        expect(find.byType(DeleteSheetBottomSheet), findsOneWidget);
      });

      testWidgets('displays correct sheet information in bottom sheet', (
        tester,
      ) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: getL10n(tester).deleteSheetButton,
          onPressed: (context, ref) =>
              showDeleteSheetConfirmation(context, ref, testSheet.id),
        );

        // Tap the button to trigger delete confirmation
        await tester.tap(find.text(getL10n(tester).deleteSheetButton));
        await tester.pumpAndSettle();

        // Verify sheet information is displayed
        expect(find.text(testSheet.title), findsOneWidget);

        final l10n = getL10n(tester);
        expect(find.text(l10n.sheet), findsOneWidget);
      });

      testWidgets('displays correct L10n strings in bottom sheet', (
        tester,
      ) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: getL10n(tester).deleteSheetButton,
          onPressed: (context, ref) =>
              showDeleteSheetConfirmation(context, ref, testSheet.id),
        );

        // Tap the button to trigger delete confirmation
        await tester.tap(find.byType(ElevatedButton).first);
        await tester.pumpAndSettle();

        // Verify L10n strings are displayed
        final l10n = getL10n(tester);
        expect(find.text(l10n.deleteSheetButton), findsAtLeastNWidgets(1));
        expect(find.text(l10n.thisActionCannotBeUndone), findsOneWidget);
        expect(
          find.byType(ElevatedButton),
          findsAtLeastNWidgets(1),
        ); // Delete button exists
        expect(find.text(l10n.cancel), findsOneWidget);
      });

      testWidgets('does not show bottom sheet for non-existent sheet', (
        tester,
      ) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Delete Non-existent',
          onPressed: (context, ref) =>
              showDeleteSheetConfirmation(context, ref, 'non-existent-id'),
        );

        // Tap the button to trigger delete confirmation
        await tester.tap(find.text('Delete Non-existent'));
        await tester.pumpAndSettle();

        // Verify no bottom sheet is shown
        expect(find.byType(DeleteSheetBottomSheet), findsNothing);
      });

      testWidgets('handles empty sheet ID gracefully', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Delete Empty',
          onPressed: (context, ref) =>
              showDeleteSheetConfirmation(context, ref, ''),
        );

        // Tap the button to trigger delete confirmation
        await tester.tap(find.text('Delete Empty'));
        await tester.pumpAndSettle();

        expect(find.byType(DeleteSheetBottomSheet), findsNothing);
      });
    });

    group('DeleteSheetBottomSheet Widget', () {
      testWidgets('renders all UI elements correctly', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: getL10n(tester).deleteSheetButton,
          onPressed: (context, ref) =>
              showDeleteSheetConfirmation(context, ref, testSheet.id),
        );

        // Tap the button to trigger delete confirmation
        await tester.tap(find.text(getL10n(tester).deleteSheetButton));
        await tester.pumpAndSettle();

        // Verify all UI elements are present
        expect(
          find.byType(Container),
          findsAtLeastNWidgets(1),
        ); // Main container
        expect(find.byType(SafeArea), findsOneWidget);
        expect(find.byType(Column), findsAtLeastNWidgets(1));
        expect(
          find.byType(Icon),
          findsAtLeastNWidgets(2),
        ); // Delete icon and info icon
        expect(
          find.byType(ElevatedButton),
          findsAtLeastNWidgets(1),
        ); // Delete button
        expect(find.byType(TextButton), findsOneWidget); // Cancel button
        expect(find.byType(Row), findsAtLeastNWidgets(1)); // Sheet info row
      });

      testWidgets('displays warning icon and message', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: getL10n(tester).deleteSheetButton,
          onPressed: (context, ref) =>
              showDeleteSheetConfirmation(context, ref, testSheet.id),
        );

        // Tap the button to trigger delete confirmation
        await tester.tap(find.text(getL10n(tester).deleteSheetButton));
        await tester.pumpAndSettle();

        // Verify warning elements
        expect(
          find.byIcon(Icons.delete_outline_rounded),
          findsAtLeastNWidgets(1),
        );
        expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);

        final l10n = getL10n(tester);
        expect(find.text(l10n.thisActionCannotBeUndone), findsOneWidget);
      });

      testWidgets('displays sheet info card with emoji and title', (
        tester,
      ) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: getL10n(tester).deleteSheetButton,
          onPressed: (context, ref) =>
              showDeleteSheetConfirmation(context, ref, testSheet.id),
        );

        // Tap the button to trigger delete confirmation
        await tester.tap(find.text(getL10n(tester).deleteSheetButton));
        await tester.pumpAndSettle();

        // Verify sheet info is displayed
        expect(find.text(testSheet.title), findsOneWidget);
        expect(find.byType(SheetAvatarWidget), findsOneWidget);

        final l10n = getL10n(tester);
        expect(find.text(l10n.sheet), findsOneWidget);
      });

      testWidgets('handles long sheet titles with ellipsis', (tester) async {
        // Create a sheet with a very long title
        final longTitleSheet = testSheet.copyWith(
          title: 'A' * 100, // Very long title
        );

        container = ProviderContainer.test(
          overrides: [
            sheetProvider(
              longTitleSheet.id,
            ).overrideWith((ref) => longTitleSheet),
          ],
        );

        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Delete Long Title',
          onPressed: (context, ref) =>
              showDeleteSheetConfirmation(context, ref, longTitleSheet.id),
        );

        // Tap the button to trigger delete confirmation
        await tester.tap(find.text('Delete Long Title'));
        await tester.pumpAndSettle();

        // Verify the long title is displayed (with ellipsis)
        expect(find.text(longTitleSheet.title), findsOneWidget);
      });

      testWidgets('handles special characters in sheet title', (tester) async {
        // Create a sheet with special characters in title
        final specialTitleSheet = testSheet.copyWith(
          title: r'Sheet with @#$%^&*()_+-=[]{}|;:,.<>?',
        );

        container = ProviderContainer.test(
          overrides: [
            sheetProvider(
              specialTitleSheet.id,
            ).overrideWith((ref) => specialTitleSheet),
          ],
        );

        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Delete Special',
          onPressed: (context, ref) =>
              showDeleteSheetConfirmation(context, ref, specialTitleSheet.id),
        );

        // Tap the button to trigger delete confirmation
        await tester.tap(find.text('Delete Special'));
        await tester.pumpAndSettle();

        // Verify the special title is displayed
        expect(find.text(specialTitleSheet.title), findsOneWidget);
      });
    });

    group('Delete Confirmation Actions', () {
      testWidgets('cancel button closes bottom sheet', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: getL10n(tester).deleteSheetButton,
          onPressed: (context, ref) =>
              showDeleteSheetConfirmation(context, ref, testSheet.id),
        );

        // Tap the button to trigger delete confirmation
        await tester.tap(find.text(getL10n(tester).deleteSheetButton));
        await tester.pumpAndSettle();

        // Verify bottom sheet is shown
        expect(find.byType(DeleteSheetBottomSheet), findsOneWidget);

        // Tap cancel button
        final l10n = getL10n(tester);
        await tester.tap(find.text(l10n.cancel));
        await tester.pumpAndSettle();

        // Verify bottom sheet is closed
        expect(find.byType(DeleteSheetBottomSheet), findsNothing);
      });

      testWidgets('delete button removes sheet from provider', (tester) async {
        // Verify sheet exists initially
        final initialSheets = container.read(sheetListProvider);
        expect(initialSheets.any((sheet) => sheet.id == testSheet.id), isTrue);

        await tester.pumpActionsWidget(
          container: container,
          buttonText: getL10n(tester).deleteSheetButton,
          onPressed: (context, ref) =>
              showDeleteSheetConfirmation(context, ref, testSheet.id),
        );

        // Tap the button to trigger delete confirmation
        await tester.tap(find.text(getL10n(tester).deleteSheetButton));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(ElevatedButton).last);
        await tester.pumpAndSettle();

        // Verify sheet was deleted from provider
        final updatedSheets = container.read(sheetListProvider);
        expect(updatedSheets.any((sheet) => sheet.id == testSheet.id), isFalse);
        expect(updatedSheets.length, equals(initialSheets.length - 1));
      });

      testWidgets('delete button closes bottom sheet after deletion', (
        tester,
      ) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: getL10n(tester).deleteSheetButton,
          onPressed: (context, ref) =>
              showDeleteSheetConfirmation(context, ref, testSheet.id),
        );

        // Tap the button to trigger delete confirmation
        await tester.tap(find.text(getL10n(tester).deleteSheetButton));
        await tester.pumpAndSettle();

        // Verify bottom sheet is shown
        expect(find.byType(DeleteSheetBottomSheet), findsOneWidget);

        // Tap delete button
        await tester.tap(find.byType(ElevatedButton).last);
        await tester.pumpAndSettle();

        // Verify bottom sheet is closed
        expect(find.byType(DeleteSheetBottomSheet), findsNothing);
      });
    });

    group('Integration Tests', () {
      testWidgets('delete confirmation works with real providers', (
        tester,
      ) async {
        // Verify sheet exists initially
        final initialSheets = container.read(sheetListProvider);
        expect(initialSheets.any((sheet) => sheet.id == testSheet.id), isTrue);

        await tester.pumpActionsWidget(
          container: container,
          buttonText: getL10n(tester).delete,
          onPressed: (context, ref) =>
              showDeleteSheetConfirmation(context, ref, testSheet.id),
        );

        // Tap the button to trigger delete confirmation
        await tester.tap(find.text(getL10n(tester).delete));
        await tester.pumpAndSettle();

        // Verify bottom sheet is shown
        expect(find.byType(DeleteSheetBottomSheet), findsOneWidget);

        // Tap delete button
        await tester.tap(find.byType(ElevatedButton).last);
        await tester.pumpAndSettle();

        // Verify sheet was deleted and bottom sheet closed
        final updatedSheets = container.read(sheetListProvider);
        expect(updatedSheets.any((sheet) => sheet.id == testSheet.id), isFalse);
        expect(find.byType(DeleteSheetBottomSheet), findsNothing);
      });

      testWidgets('onConfirm callback specifically calls deleteSheet method', (
        tester,
      ) async {
        // Get initial state to verify the sheet exists
        final initialSheets = container.read(sheetListProvider);
        final initialCount = initialSheets.length;
        expect(initialSheets.any((sheet) => sheet.id == testSheet.id), isTrue);

        await tester.pumpActionsWidget(
          container: container,
          buttonText: getL10n(tester).deleteSheetButton,
          onPressed: (context, ref) =>
              showDeleteSheetConfirmation(context, ref, testSheet.id),
        );

        // Tap the button to trigger delete confirmation
        await tester.tap(find.text(getL10n(tester).deleteSheetButton));
        await tester.pumpAndSettle();

        // Verify bottom sheet is shown
        expect(find.byType(DeleteSheetBottomSheet), findsOneWidget);

        // Tap delete button to trigger onConfirm callback
        await tester.tap(find.byType(ElevatedButton).last);
        await tester.pumpAndSettle();

        // Verify that deleteSheet method was called by checking the state change
        final updatedSheets = container.read(sheetListProvider);
        expect(updatedSheets.length, equals(initialCount - 1));
        expect(updatedSheets.any((sheet) => sheet.id == testSheet.id), isFalse);

        // Verify bottom sheet is closed
        expect(find.byType(DeleteSheetBottomSheet), findsNothing);
      });
    });
  });
}
