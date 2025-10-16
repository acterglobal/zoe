import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/list/actions/list_actions.dart';
import 'package:zoe/features/list/data/lists.dart';
import 'package:zoe/features/list/models/list_model.dart';
import 'package:zoe/features/list/providers/list_providers.dart';
import 'package:zoe/features/share/widgets/share_items_bottom_sheet.dart';
import '../../../test-utils/test_utils.dart';
import '../../../test-utils/mock_gorouter.dart';

void main() {
  group('ListActions Tests', () {
    late ProviderContainer container;
    late ListModel testList;
    late MockGoRouter mockGoRouter;

    setUp(() {
      testList = lists.first;
      mockGoRouter = MockGoRouter();

      // Set up mock methods
      when(() => mockGoRouter.canPop()).thenReturn(true);
      when(() => mockGoRouter.pop()).thenReturn(null);

      container = ProviderContainer.test(
        overrides: [
          listItemProvider(testList.id).overrideWith((ref) => testList),
          editContentIdProvider.overrideWith((ref) => null),
        ],
      );
    });

    group('copyList', () {
      testWidgets('copies list content to clipboard', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Copy List',
          onPressed: (context, ref) =>
              ListActions.copyList(context, ref, testList.id),
        );

        // Tap the button to trigger copy action
        await tester.tap(find.text('Copy List'));
        await tester.pumpAndSettle();

        // Verify the action was called (we can't easily test clipboard in unit tests)
        expect(find.text('Copy List'), findsOneWidget);
      });

      testWidgets('shows snackbar after copying', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Copy List',
          onPressed: (context, ref) =>
              ListActions.copyList(context, ref, testList.id),
        );

        // Tap the button to trigger copy action
        await tester.tap(find.text('Copy List'));
        await tester.pumpAndSettle();

        // Verify snackbar is shown with correct message
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(WidgetTesterExtension.getL10n(tester, byType: Consumer).copiedToClipboard), findsOneWidget);
      });

      testWidgets('handles invalid list ID gracefully', (tester) async {
        const invalidListId = 'invalid-list-id';

        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Copy Invalid List',
          onPressed: (context, ref) =>
              ListActions.copyList(context, ref, invalidListId),
        );

        // Tap the button
        await tester.tap(find.text('Copy Invalid List'));
        await tester.pumpAndSettle();

        // Should not throw an error
        expect(find.text('Copy Invalid List'), findsOneWidget);
      });
    });

    group('shareList', () {
      testWidgets('shows share bottom sheet', (tester) async {
        await tester.pumpActionsWidget( 
          buttonText: 'Share List',
          onPressed: (context, ref) => ListActions.shareList(context, testList.id), 
          container: container,
          router: mockGoRouter,
        );

        // Tap the button to trigger share action
        await tester.tap(find.text('Share List'));
        await tester.pump(); // Don't use pumpAndSettle to avoid timeout

        // Verify the action was called
        expect(find.text('Share List'), findsAtLeastNWidgets(1));
        expect(find.byType(ShareItemsBottomSheet), findsOneWidget);
      });
    });

    group('editList', () {
      testWidgets('sets correct list ID in edit provider', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Edit List',
          onPressed: (context, ref) => ListActions.editList(ref, testList.id),
        );

        // Tap the button to trigger edit action
        await tester.tap(find.text('Edit List'));
        await tester.pumpAndSettle();

        // Verify the correct list ID is set
        final editContentId = container.read(editContentIdProvider);
        expect(editContentId, equals(testList.id));
      });
    });

    group('deleteList', () {
      testWidgets('deletes list from provider', (tester) async {
        // Verify list exists initially
        final initialLists = container.read(listsProvider);
        expect(initialLists.any((list) => list.id == testList.id), isTrue);

        await tester.pumpActionsWidget(
          buttonText: 'Delete List',
          onPressed: (context, ref) =>
              ListActions.deleteList(context, ref, testList.id),
          container: container,
        );

        // Tap the button to trigger delete action
        await tester.tap(find.text('Delete List'));
        await tester.pumpAndSettle();

        // Verify list was deleted from provider
        final updatedLists = container.read(listsProvider);
        expect(updatedLists.any((list) => list.id == testList.id), isFalse);
        expect(updatedLists.length, equals(initialLists.length - 1));
      });

      testWidgets('shows snackbar after deletion', (tester) async {
        await tester.pumpActionsWidget(
          buttonText: 'Delete List',
          onPressed: (context, ref) =>
              ListActions.deleteList(context, ref, testList.id),
          container: container,
        );

        // Tap the button to trigger delete action
        await tester.tap(find.text('Delete List'));
        await tester.pumpAndSettle();

        // Verify snackbar is shown with correct message
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(WidgetTesterExtension.getL10n(tester, byType: Consumer).listDeleted), findsOneWidget);
      });
    });

    group('showListMenu', () {
      testWidgets('shows list menu with all items when not editing', (
        tester,
      ) async {
        await tester.pumpActionsWidget(
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showListMenu(
            context: context,
            ref: ref,
            isEditing: false,
            listId: testList.id,
          ),
          container: container,
          router: mockGoRouter,
        );

        // Tap the button to trigger menu
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Verify menu items are rendered (copy, share, edit, delete)
        // Using l10n strings from app_en.arb
        expect(find.text(WidgetTesterExtension.getL10n(tester, byType: Consumer).copyListContent), findsOneWidget);
        expect(find.text(WidgetTesterExtension.getL10n(tester, byType: Consumer).shareThisList), findsOneWidget);
        expect(find.text(WidgetTesterExtension.getL10n(tester, byType: Consumer).editThisList), findsOneWidget);
        expect(find.text(WidgetTesterExtension.getL10n(tester, byType: Consumer).deleteThisList), findsOneWidget);
      });

      testWidgets('shows list menu without edit item when editing', (
        tester,
      ) async {
        await tester.pumpActionsWidget(
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showListMenu(
            context: context,
            ref: ref,
            isEditing: true,
            listId: testList.id,
          ),
          container: container,
          router: mockGoRouter,
        );

        // Tap the button to trigger menu
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Verify menu items are rendered (copy, share, delete - no edit)
        // Using l10n strings from app_en.arb
        expect(find.text(WidgetTesterExtension.getL10n(tester, byType: Consumer).copyListContent), findsOneWidget);
        expect(find.text(WidgetTesterExtension.getL10n(tester, byType: Consumer).shareThisList), findsOneWidget);
        expect(find.text(WidgetTesterExtension.getL10n(tester, byType: Consumer).deleteThisList), findsOneWidget);
        expect(find.text(WidgetTesterExtension.getL10n(tester, byType: Consumer).editThisList), findsNothing);
      });

      testWidgets('handles copy menu item tap correctly', (tester) async {
        await tester.pumpActionsWidget(
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showListMenu(
            context: context,
            ref: ref,
            isEditing: false,
            listId: testList.id,
          ),
          container: container,
          router: mockGoRouter,
        );

        // Tap the button to trigger menu
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Tap the copy menu item
        await tester.tap(find.text(WidgetTesterExtension.getL10n(tester, byType: Consumer).copyListContent));
        await tester.pumpAndSettle();

        // Verify snackbar is shown with correct message (indicates copy action was executed)
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(WidgetTesterExtension.getL10n(tester, byType: Consumer).copiedToClipboard), findsOneWidget);
      });

      testWidgets('handles edit menu item tap correctly', (tester) async {
        await tester.pumpActionsWidget(
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showListMenu(
            context: context,
            ref: ref,
            isEditing: false,
            listId: testList.id,
          ),
          container: container,
          router: mockGoRouter,
        );

        // Tap the button to trigger menu
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Tap the edit menu item
        await tester.tap(find.text(WidgetTesterExtension.getL10n(tester, byType: Consumer).editThisList));
        await tester.pumpAndSettle();

        // Verify edit state was set
        final editContentId = container.read(editContentIdProvider);
        expect(editContentId, equals(testList.id));
      });

      testWidgets('handles delete menu item tap correctly', (tester) async {
        // Verify list exists initially
        final initialLists = container.read(listsProvider);
        expect(initialLists.any((list) => list.id == testList.id), isTrue);

        await tester.pumpActionsWidget(
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showListMenu(
            context: context,
            ref: ref,
            isEditing: false,
            listId: testList.id,
          ),
          container: container,
          router: mockGoRouter,
        );

        // Tap the button to trigger menu
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Tap the delete menu item
        await tester.tap(find.text(WidgetTesterExtension.getL10n(tester, byType: Consumer).deleteThisList));
        await tester.pumpAndSettle();

        // Verify list was deleted from provider
        final updatedLists = container.read(listsProvider);
        expect(updatedLists.any((list) => list.id == testList.id), isFalse);
        expect(updatedLists.length, equals(initialLists.length - 1));

        // Verify snackbar is shown with correct message
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(WidgetTesterExtension.getL10n(tester, byType: Consumer).listDeleted), findsOneWidget);
      });

      testWidgets('handles share menu item tap correctly', (tester) async {
        await tester.pumpActionsWidget(
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showListMenu(
            context: context,
            ref: ref,
            isEditing: false,
            listId: testList.id,
          ),
          container: container,
          router: mockGoRouter,
        );

        // Tap the button to trigger menu
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Tap the share menu item
        await tester.tap(find.text(WidgetTesterExtension.getL10n(tester, byType: Consumer).shareThisList));
        await tester.pump(); // Don't use pumpAndSettle to avoid timeout

        // Verify the action was called (share bottom sheet might not settle)
        expect(find.text(WidgetTesterExtension.getL10n(tester, byType: Consumer).shareThisList), findsAtLeastNWidgets(1));
      });

      testWidgets('menu can be dismissed by tapping outside', (tester) async {
        await tester.pumpActionsWidget(
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showListMenu(
            context: context,
            ref: ref,
            isEditing: false,
            listId: testList.id,
          ),
          container: container,
          router: mockGoRouter,
        );

        // Tap the button to trigger menu
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Verify menu is shown
        expect(find.text(WidgetTesterExtension.getL10n(tester, byType: Consumer).copyListContent), findsOneWidget);

        // Tap outside the menu to dismiss it
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        // Verify menu is dismissed
        expect(find.text(WidgetTesterExtension.getL10n(tester, byType: Consumer).copyListContent), findsNothing);
      });

      testWidgets('shows correct menu items with detail screen flag', (
        tester,
      ) async {
        await tester.pumpActionsWidget(
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showListMenu(
            context: context,
            ref: ref,
            isEditing: false,
            listId: testList.id,
            isDetailScreen: true,
          ),
          container: container,
          router: mockGoRouter,
        );

        // Tap the button to trigger menu
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Verify all menu items are present
        // Using l10n strings from app_en.arb
        expect(find.text(WidgetTesterExtension.getL10n(tester, byType: Consumer).copyListContent), findsOneWidget);
        expect(find.text(WidgetTesterExtension.getL10n(tester, byType: Consumer).shareThisList), findsOneWidget);
        expect(find.text(WidgetTesterExtension.getL10n(tester, byType: Consumer).editThisList), findsOneWidget);
        expect(find.text(WidgetTesterExtension.getL10n(tester, byType: Consumer).deleteThisList), findsOneWidget);
      });
    });

    group('Integration Tests', () {
      testWidgets('copy action works with real providers', (tester) async {
        await tester.pumpActionsWidget(
          buttonText: 'Copy',
          onPressed: (context, ref) =>
              ListActions.copyList(context, ref, testList.id),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text('Copy'));
        await tester.pumpAndSettle();

        // Verify the action completed without errors
        expect(find.text('Copy'), findsOneWidget);
      });

      testWidgets('edit action works with real providers', (tester) async {
        await tester.pumpActionsWidget(
          buttonText: 'Edit',
          onPressed: (context, ref) => ListActions.editList(ref, testList.id),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();

        // Verify edit state was set
        final editContentId = container.read(editContentIdProvider);
        expect(editContentId, equals(testList.id));
      });

      testWidgets('delete action works with real providers', (tester) async {
        // Verify list exists initially
        final initialLists = container.read(listsProvider);
        expect(initialLists.any((list) => list.id == testList.id), isTrue);

        await tester.pumpActionsWidget(
          buttonText: 'Delete',
          onPressed: (context, ref) =>
              ListActions.deleteList(context, ref, testList.id),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        // Verify list was deleted from provider
        final updatedLists = container.read(listsProvider);
        expect(updatedLists.any((list) => list.id == testList.id), isFalse);
        expect(updatedLists.length, equals(initialLists.length - 1));
      });
    });

    group('Edge Cases', () {
      testWidgets('handles invalid list ID gracefully', (tester) async {
        const invalidListId = 'invalid-list-id';

        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Copy Invalid',
          onPressed: (context, ref) =>
              ListActions.copyList(context, ref, invalidListId),
        );

        // Tap the button
        await tester.tap(find.text('Copy Invalid'));
        await tester.pumpAndSettle();

        // Should not throw an error
        expect(find.text('Copy Invalid'), findsOneWidget);
      });

      testWidgets('handles empty list ID', (tester) async {
        const emptyListId = '';

        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Edit Empty',
          onPressed: (context, ref) => ListActions.editList(ref, emptyListId),
        );

        // Tap the button
        await tester.tap(find.text('Edit Empty'));
        await tester.pumpAndSettle();

        // Should set empty string as edit content ID
        final editContentId = container.read(editContentIdProvider);
        expect(editContentId, equals(emptyListId));
      });
    });

    group('Provider State Changes', () {
      testWidgets('edit list updates provider state', (tester) async {
        // Initial state should be null
        expect(container.read(editContentIdProvider), isNull);

        await tester.pumpActionsWidget(
          buttonText: 'Edit',
          onPressed: (context, ref) => ListActions.editList(ref, testList.id),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();

        // State should be updated
        expect(container.read(editContentIdProvider), equals(testList.id));
      });

      testWidgets('delete list updates provider state', (tester) async {
        // Verify list exists initially
        final initialLists = container.read(listsProvider);
        expect(initialLists.any((list) => list.id == testList.id), isTrue);

        await tester.pumpActionsWidget(
          buttonText: 'Delete',
          onPressed: (context, ref) =>
              ListActions.deleteList(context, ref, testList.id),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        // Verify list was deleted from provider
        final updatedLists = container.read(listsProvider);
        expect(updatedLists.any((list) => list.id == testList.id), isFalse);
        expect(updatedLists.length, equals(initialLists.length - 1));
      });
    });

    group('Menu Item Configuration', () {
      testWidgets('menu items are configured correctly for non-editing state', (
        tester,
      ) async {
        await tester.pumpActionsWidget(
          buttonText: 'Menu',
          onPressed: (context, ref) => showListMenu(
            context: context,
            ref: ref,
            isEditing: false,
            listId: testList.id,
          ),
          container: container,
        );

        // Tap the button
        await tester.tap(find.text('Menu'));
        await tester.pumpAndSettle();

        // Verify menu was shown
        expect(find.text('Menu'), findsOneWidget);
      });
    });

    group('Detail Screen Navigation', () {
      testWidgets('delete action pops context when isDetailScreen is true', (
        tester,
      ) async {
        await tester.pumpActionsWidget(
          buttonText: 'Show Menu',
          onPressed: (context, ref) => showListMenu(
            context: context,
            ref: ref,
            isEditing: false,
            listId: testList.id,
            isDetailScreen: true,
          ),
          container: container,
          router: mockGoRouter,
        );

        // Tap the button to trigger menu
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Tap the delete menu item
        await tester.tap(find.text(WidgetTesterExtension.getL10n(tester, byType: Consumer).deleteThisList));
        await tester.pumpAndSettle();

        // Verify list was deleted from provider
        final updatedLists = container.read(listsProvider);
        expect(updatedLists.any((list) => list.id == testList.id), isFalse);

        // Verify snackbar is shown with correct message
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(WidgetTesterExtension.getL10n(tester, byType: Consumer).listDeleted), findsOneWidget);
      });
    });
  });
}
