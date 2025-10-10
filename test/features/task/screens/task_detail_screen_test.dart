import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/models/user_chip_type.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/content_menu_button.dart';
import 'package:zoe/common/widgets/floating_action_button_wrapper.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/paper_sheet_background_widget.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_html_inline_text_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_popup_menu_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_chip_widget.dart';
import 'package:zoe/features/content/widgets/add_content_bottom_sheet.dart';
import 'package:zoe/features/content/widgets/content_widget.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/task/screens/task_detail_screen.dart';
import 'package:zoe/features/task/widgets/task_assignees_widget.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import '../../../test-utils/test_utils.dart';
import '../utils/task_utils.dart';

void main() {
  late ProviderContainer container;
  const nonExistentTaskId = 'non-existent-id';
  late TaskModel testTask;

  setUp(() {
    // Create the container
    container = ProviderContainer.test();

    // Get the test task
    testTask = getTaskByIndex(container);
  });

  // Pump task detail screen
  Future<void> pumpTaskDetailScreen({
    required WidgetTester tester,
    required ProviderContainer container,
    required String taskId,
    bool isWrapMediaQuery = false,
  }) async {
    // Create the screen
    final screen = TaskDetailScreen(taskId: taskId);

    // Wrap the screen in a MediaQuery if needed
    final child = isWrapMediaQuery
        ? MediaQuery(
            data: const MediaQueryData(size: Size(1080, 1920)),
            child: screen,
          )
        : screen;

    // Pump the screen
    await tester.pumpMaterialWidgetWithProviderScope(
      child: child,
      container: container,
    );
    await tester.pump(const Duration(milliseconds: 100));
  }

  group('Task Detail Screen', () {
    group('Empty State', () {
      testWidgets('displays empty state when task does not exist', (
        tester,
      ) async {
        await pumpTaskDetailScreen(
          tester: tester,
          container: container,
          taskId: nonExistentTaskId,
        );

        // Verify empty state is shown
        expect(find.byType(EmptyStateWidget), findsOneWidget);
        expect(find.byIcon(Icons.task_alt_outlined), findsOneWidget);
        expect(find.text('Task not found'), findsOneWidget);
      });

      testWidgets('displays app bar in empty state', (tester) async {
        await pumpTaskDetailScreen(
          tester: tester,
          container: container,
          taskId: nonExistentTaskId,
        );

        // Verify app bar is present
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(ZoeAppBar), findsOneWidget);
      });
    });

    group('Data State', () {
      testWidgets('displays task data when task exists', (tester) async {
        // Pump the screen
        await pumpTaskDetailScreen(
          tester: tester,
          container: container,
          taskId: testTask.id,
        );

        // Verify main components are present
        expect(find.byType(NotebookPaperBackgroundWidget), findsOneWidget);
        expect(find.byType(Scaffold), findsAtLeastNWidgets(2));
        expect(find.byType(MaxWidthWidget), findsOneWidget);
        expect(find.byType(ContentMenuButton), findsOneWidget);
      });

      testWidgets('displays floating action button', (tester) async {
        // Pump the screen
        await pumpTaskDetailScreen(
          tester: tester,
          container: container,
          taskId: testTask.id,
        );

        // Verify floating action button wrapper
        expect(find.byType(FloatingActionButtonWrapper), findsOneWidget);
      });

      testWidgets('displays task title in read-only mode', (tester) async {
        // Pump the screen
        await pumpTaskDetailScreen(
          tester: tester,
          container: container,
          taskId: testTask.id,
        );

        // Verify title is displayed
        expect(find.text(testTask.title), findsOneWidget);
        expect(find.byType(ZoeInlineTextEditWidget), findsOneWidget);

        // Verify it's in read-only mode (not editing)
        final titleWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget),
        );
        expect(titleWidget.isEditing, isFalse);
      });

      testWidgets('displays task title in edit mode when editing', (
        tester,
      ) async {
        container = ProviderContainer.test(
          overrides: [editContentIdProvider.overrideWith((ref) => testTask.id)],
        );

        // Pump the screen
        await pumpTaskDetailScreen(
          tester: tester,
          container: container,
          taskId: testTask.id,
        );

        // Wait for the screen to settle
        await tester.pump(const Duration(milliseconds: 100));

        // Verify title is in edit mode
        final titleWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget),
        );
        expect(titleWidget.isEditing, isTrue);
      });

      testWidgets('displays task description editor', (tester) async {
        // Pump the screen
        await pumpTaskDetailScreen(
          tester: tester,
          container: container,
          taskId: testTask.id,
        );

        // Verify description editor is present
        expect(find.byType(ZoeHtmlTextEditWidget), findsOneWidget);
      });

      testWidgets('displays content widget with correct parameters', (
        tester,
      ) async {
        // Pump the screen
        await pumpTaskDetailScreen(
          tester: tester,
          container: container,
          taskId: testTask.id,
        );

        // Verify content widget
        expect(find.byType(ContentWidget), findsOneWidget);
        final contentWidget = tester.widget<ContentWidget>(
          find.byType(ContentWidget),
        );
        expect(contentWidget.parentId, equals(testTask.id));
        expect(contentWidget.sheetId, equals(testTask.sheetId));
      });

      testWidgets('displays assigned users information section', (
        tester,
      ) async {
        // Pump the screen
        await pumpTaskDetailScreen(
          tester: tester,
          container: container,
          taskId: testTask.id,
        );

        // Verify user display components
        expect(find.byType(TaskAssigneesWidget), findsOneWidget);
        expect(
          find.byType(ZoeUserChipWidget),
          findsNWidgets(testTask.assignedUsers.length),
        );

        for (var userId in testTask.assignedUsers) {
          final testUser = container.read(getUserByIdProvider(userId));
          expect(find.text(testUser?.name ?? ''), findsOneWidget);
        }
      });

      testWidgets('displays no assigned users when no assigned users', (
        tester,
      ) async {
        container = ProviderContainer.test(
          overrides: [
            taskProvider(
              testTask.id,
            ).overrideWith((ref) => testTask.copyWith(assignedUsers: [])),
          ],
        );

        // Pump the screen
        await pumpTaskDetailScreen(
          tester: tester,
          container: container,
          taskId: testTask.id,
        );

        // Verify user section is hidden
        final infoIconFinder = find.byIcon(Icons.info_outline_rounded);
        expect(infoIconFinder, findsOneWidget);
        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: TaskAssigneesWidget,
        );
        expect(find.text(l10n.noAssigneesYet), findsOneWidget);
        expect(find.byType(ZoeUserChipWidget), findsNothing);
      });

      testWidgets('displays correct user chip type', (tester) async {
        final assignedUsers = testTask.assignedUsers;

        // Pump the screen
        await pumpTaskDetailScreen(
          tester: tester,
          container: container,
          taskId: testTask.id,
        );

        // Wait for async providers and rebuilds
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        final userChipFinder = find.byType(ZoeUserChipWidget);
        expect(userChipFinder, findsNWidgets(assignedUsers.length));

        for (var i = 0; i < assignedUsers.length; i++) {
          final userId = assignedUsers[i];
          final userChipWidget = tester.widget<ZoeUserChipWidget>(
            userChipFinder.at(i),
          );
          final testUser = container.read(getUserByIdProvider(userId));
          expect(userChipWidget.user, equals(testUser));
          expect(
            userChipWidget.type,
            equals(ZoeUserChipType.userNameWithAvatarChip),
          );
        }
      });
    });

    group('Interaction Tap Tests', () {
      testWidgets('menu button is tappable', (tester) async {
        // Pump the screen
        await pumpTaskDetailScreen(
          tester: tester,
          container: container,
          taskId: testTask.id,
        );

        // Verify menu button exists and can be tapped
        final menuButton = find.byType(ContentMenuButton);
        expect(menuButton, findsOneWidget);

        // Tap the menu button
        await tester.tap(menuButton);
        await tester.pump(const Duration(milliseconds: 100));

        // Verify popup menu is shown with menu items
        expect(find.byType(PopupMenuItem<ZoePopupMenuItem>), findsWidgets);
      });

      testWidgets('floating action button has correct parameters', (
        tester,
      ) async {
        // Pump the screen
        await pumpTaskDetailScreen(
          tester: tester,
          container: container,
          taskId: testTask.id,
        );

        // Verify floating action button wrapper
        final fab = tester.widget<FloatingActionButtonWrapper>(
          find.byType(FloatingActionButtonWrapper),
        );
        expect(fab.parentId, equals(testTask.id));
        expect(fab.sheetId, equals(testTask.sheetId));
      });

      testWidgets(
        'floating action button on tap shows add content bottom sheet',
        (tester) async {
          // Pump the screen
          await pumpTaskDetailScreen(
            tester: tester,
            container: container,
            taskId: testTask.id,
          );

          // Verify floating action button wrapper
          final fab = find.byType(FloatingActionButtonWrapper);
          expect(fab, findsOneWidget);

          // Tap the floating action button
          await tester.tap(fab);
          await tester.pump(const Duration(milliseconds: 100));

          // Verify add content bottom sheet is shown
          expect(find.byType(AddContentBottomSheet), findsOneWidget);
        },
      );

      testWidgets(
        'floating action button on tap shows add content bottom sheet and add text content',
        (tester) async {
          // Pump the screen
          await pumpTaskDetailScreen(
            tester: tester,
            container: container,
            taskId: testTask.id,
            isWrapMediaQuery: true,
          );

          // Verify floating action button wrapper
          final fab = find.byType(FloatingActionButtonWrapper);
          expect(fab, findsOneWidget);

          // Tap the floating action button
          await tester.ensureVisible(fab);
          await tester.tap(fab);
          await tester.pump(const Duration(milliseconds: 100));

          // Verify add content bottom sheet is shown
          expect(find.byType(AddContentBottomSheet), findsOneWidget);

          // Tap the add text content option
          final textContentIcon = find.byIcon(Icons.text_fields);
          await tester.ensureVisible(textContentIcon);
          await tester.tap(textContentIcon, warnIfMissed: false);
          await tester.pump(const Duration(milliseconds: 100));

          // Verify text content is added
          expect(find.byType(ZoeInlineTextEditWidget), findsOneWidget);
          expect(find.byType(ZoeHtmlTextEditWidget), findsOneWidget);
        },
      );
    });
  });
}
