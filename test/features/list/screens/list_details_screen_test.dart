// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:zoe/common/providers/common_providers.dart';
// import 'package:zoe/features/list/models/list_model.dart';
// import 'package:zoe/features/list/providers/list_providers.dart';
// import 'package:zoe/features/list/screens/list_details_screen.dart';
// import 'package:zoe/features/content/widgets/content_widget.dart';
// import 'package:zoe/common/widgets/state_widgets/empty_state_widget.dart';
// import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
// import 'package:zoe/common/widgets/emoji_widget.dart';
// import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
// import 'package:zoe/common/widgets/toolkit/zoe_html_inline_text_widget.dart';
// import 'package:zoe/common/widgets/content_menu_button.dart';
// import 'package:zoe/common/widgets/floating_action_button_wrapper.dart';
// import 'package:zoe/common/widgets/paper_sheet_background_widget.dart';
// import 'package:zoe/common/widgets/max_width_widget.dart';
// import '../../../test-utils/test_utils.dart';
// import '../utils/list_utils.dart';
//
// void main() {
//   group('ListDetailsScreen', () {
//     late ProviderContainer container;
//     late ListModel testList;
//
//     setUp(() {
//       container = ProviderContainer.test(
//         overrides: [
//           editContentIdProvider.overrideWith((ref) => null),
//         ],
//       );
//       testList = getListByIndex(container);
//       container = ProviderContainer.test(
//         overrides: [
//           listItemProvider(testList.id).overrideWith((ref) => testList),
//         ],
//       );
//     });
//
//     Future<ProviderContainer> pumpScreen(
//       WidgetTester tester, {
//       required String listId,
//       bool isEditing = false,
//     }) async {
//       final overrides = [
//         editContentIdProvider.overrideWith((ref) => isEditing ? listId : null),
//       ];
//
//       final scoped = ProviderContainer(overrides: overrides);
//
//       await tester.pumpMaterialWidgetWithProviderScope(
//         container: scoped,
//         child: ListDetailsScreen(listId: listId),
//       );
//
//       return scoped;
//     }
//
//     group('Screen Rendering', () {
//       testWidgets('renders screen with valid list ID', (tester) async {
//         await pumpScreen(tester, listId: testList.id);
//
//         expect(find.byType(ListDetailsScreen), findsOneWidget);
//         expect(find.byType(ZoeAppBar), findsOneWidget);
//       });
//
//       testWidgets('renders empty state for non-existent list ID', (
//         tester,
//       ) async {
//         await pumpScreen(tester, listId: 'non-existent-id');
//
//         expect(find.byType(EmptyStateWidget), findsOneWidget);
//         expect(
//           find.text(
//             WidgetTesterExtension.getL10n(
//               tester,
//               byType: EmptyStateWidget,
//             ).listNotFound,
//           ),
//           findsOneWidget,
//         );
//       });
//
//       testWidgets('renders app bar with menu button', (tester) async {
//         await pumpScreen(tester, listId: testList.id);
//
//         expect(find.byType(ZoeAppBar), findsOneWidget);
//         expect(find.byType(ContentMenuButton), findsOneWidget);
//       });
//
//       testWidgets('renders floating action button', (tester) async {
//         await pumpScreen(tester, listId: testList.id);
//
//         expect(find.byType(FloatingActionButtonWrapper), findsOneWidget);
//       });
//     });
//
//     group('List Header', () {
//       testWidgets('displays list emoji', (tester) async {
//         await pumpScreen(tester, listId: testList.id);
//
//         expect(find.byType(EmojiWidget), findsOneWidget);
//       });
//
//       testWidgets('displays list title', (tester) async {
//         await pumpScreen(tester, listId: testList.id);
//
//         expect(find.text(testList.title), findsOneWidget);
//       });
//
//       testWidgets('displays list description', (tester) async {
//         await pumpScreen(tester, listId: testList.id);
//
//         expect(find.byType(ZoeHtmlTextEditWidget), findsOneWidget);
//       });
//
//       testWidgets('shows correct hint text for title', (tester) async {
//         await pumpScreen(tester, listId: testList.id);
//
//         final titleWidgets = tester.widgetList<ZoeInlineTextEditWidget>(
//           find.byType(ZoeInlineTextEditWidget),
//         );
//         expect(
//           titleWidgets.any(
//             (widget) =>
//                 widget.hintText ==
//                 WidgetTesterExtension.getL10n(
//                   tester,
//                   byType: ListDetailsScreen,
//                 ).title,
//           ),
//           isTrue,
//         );
//       });
//
//       testWidgets('shows correct hint text for description', (tester) async {
//         await pumpScreen(tester, listId: testList.id);
//
//         final descriptionWidget = tester.widget<ZoeHtmlTextEditWidget>(
//           find.byType(ZoeHtmlTextEditWidget),
//         );
//         expect(
//           descriptionWidget.hintText,
//           equals(
//             WidgetTesterExtension.getL10n(
//               tester,
//               byType: ListDetailsScreen,
//             ).addADescription,
//           ),
//         );
//       });
//     });
//
//     group('Content Widget', () {
//       testWidgets('renders content widget with correct parent ID', (
//         tester,
//       ) async {
//         await pumpScreen(tester, listId: testList.id);
//
//         expect(find.byType(ContentWidget), findsOneWidget);
//
//         final contentWidget = tester.widget<ContentWidget>(
//           find.byType(ContentWidget),
//         );
//         expect(contentWidget.parentId, equals(testList.id));
//         expect(contentWidget.sheetId, equals(testList.sheetId));
//       });
//     });
//
//     group('Edit Mode Functionality', () {
//       testWidgets('shows editing state when isEditing is true', (tester) async {
//         await pumpScreen(tester, listId: testList.id, isEditing: true);
//
//         // Check that the screen renders in editing mode
//         expect(find.byType(ListDetailsScreen), findsOneWidget);
//
//         // Verify that edit mode is passed to child widgets
//         final titleWidgets = tester.widgetList<ZoeInlineTextEditWidget>(
//           find.byType(ZoeInlineTextEditWidget),
//         );
//         final descriptionWidgets = tester.widgetList<ZoeHtmlTextEditWidget>(
//           find.byType(ZoeHtmlTextEditWidget),
//         );
//
//         // At least one title widget should be in editing mode
//         expect(titleWidgets.any((widget) => widget.isEditing == true), isTrue);
//         // At least one description widget should be in editing mode
//         expect(
//           descriptionWidgets.any((widget) => widget.isEditing == true),
//           isTrue,
//         );
//       });
//
//       testWidgets('shows non-editing state when isEditing is false', (
//         tester,
//       ) async {
//         await pumpScreen(tester, listId: testList.id, isEditing: false);
//
//         // Check that the screen renders in non-editing mode
//         expect(find.byType(ListDetailsScreen), findsOneWidget);
//
//         // Verify that edit mode is passed to child widgets
//         final titleWidgets = tester.widgetList<ZoeInlineTextEditWidget>(
//           find.byType(ZoeInlineTextEditWidget),
//         );
//         final descriptionWidgets = tester.widgetList<ZoeHtmlTextEditWidget>(
//           find.byType(ZoeHtmlTextEditWidget),
//         );
//
//         // At least one title widget should be in non-editing mode
//         expect(titleWidgets.any((widget) => widget.isEditing == false), isTrue);
//         // At least one description widget should be in non-editing mode
//         expect(
//           descriptionWidgets.any((widget) => widget.isEditing == false),
//           isTrue,
//         );
//       });
//
//       testWidgets('edit mode changes when provider state changes', (
//         tester,
//       ) async {
//         final container = await pumpScreen(
//           tester,
//           listId: testList.id,
//           isEditing: false,
//         );
//
//         // Initially should be in non-editing mode
//         final initialTitleWidgets = tester.widgetList<ZoeInlineTextEditWidget>(
//           find.byType(ZoeInlineTextEditWidget),
//         );
//         expect(
//           initialTitleWidgets.any((widget) => widget.isEditing == false),
//           isTrue,
//         );
//
//         // Change to editing mode
//         container.read(editContentIdProvider.notifier).state = testList.id;
//         await tester.pump();
//
//         // Should now be in editing mode
//         final updatedTitleWidgets = tester.widgetList<ZoeInlineTextEditWidget>(
//           find.byType(ZoeInlineTextEditWidget),
//         );
//         expect(
//           updatedTitleWidgets.any((widget) => widget.isEditing == true),
//           isTrue,
//         );
//       });
//     });
//
//     group('Menu Integration', () {
//       testWidgets('menu button is present', (tester) async {
//         await pumpScreen(tester, listId: testList.id);
//
//         expect(find.byType(ContentMenuButton), findsOneWidget);
//       });
//     });
//
//     group('Error Handling', () {
//       testWidgets('handles null list gracefully', (tester) async {
//         await pumpScreen(tester, listId: 'non-existent-id');
//
//         expect(find.byType(EmptyStateWidget), findsOneWidget);
//       });
//
//       testWidgets('shows correct error message for non-existent list', (
//         tester,
//       ) async {
//         await pumpScreen(tester, listId: 'non-existent-id');
//
//         expect(
//           find.text(
//             WidgetTesterExtension.getL10n(
//               tester,
//               byType: EmptyStateWidget,
//             ).listNotFound,
//           ),
//           findsOneWidget,
//         );
//       });
//     });
//
//     group('Widget Integration', () {
//       testWidgets('all required widgets are present', (tester) async {
//         await pumpScreen(tester, listId: testList.id);
//
//         // Check for all major widgets
//         expect(find.byType(NotebookPaperBackgroundWidget), findsOneWidget);
//         expect(find.byType(ZoeAppBar), findsOneWidget);
//         expect(find.byType(ContentMenuButton), findsOneWidget);
//         expect(find.byType(MaxWidthWidget), findsOneWidget);
//         expect(find.byType(EmojiWidget), findsOneWidget);
//         expect(find.byType(ZoeInlineTextEditWidget), findsAtLeastNWidgets(1));
//         expect(find.byType(ZoeHtmlTextEditWidget), findsOneWidget);
//         expect(find.byType(ContentWidget), findsOneWidget);
//         expect(find.byType(FloatingActionButtonWrapper), findsOneWidget);
//       });
//
//       testWidgets('widgets have correct properties', (tester) async {
//         await pumpScreen(tester, listId: testList.id);
//
//         // Check EmojiWidget properties
//         final emojiWidget = tester.widget<EmojiWidget>(
//           find.byType(EmojiWidget),
//         );
//         expect(emojiWidget.emoji, equals(testList.emoji ?? '🔸'));
//         expect(emojiWidget.size, equals(36));
//
//         // Check FloatingActionButtonWrapper properties
//         final fabWidget = tester.widget<FloatingActionButtonWrapper>(
//           find.byType(FloatingActionButtonWrapper),
//         );
//         expect(fabWidget.parentId, equals(testList.id));
//         expect(fabWidget.sheetId, equals(testList.sheetId));
//       });
//     });
//
//     group('State Management', () {
//       testWidgets('reacts to provider changes', (tester) async {
//         final container = await pumpScreen(tester, listId: testList.id);
//
//         // Update the list title
//         container
//             .read(listsProvider.notifier)
//             .updateListTitle(testList.id, 'Updated Title');
//
//         await tester.pump();
//
//         // The screen should reflect the change
//         expect(find.text('Updated Title'), findsOneWidget);
//       });
//     });
//   });
// }
