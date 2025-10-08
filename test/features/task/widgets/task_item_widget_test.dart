import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/common/models/user_display_type.dart';
import 'package:zoe/common/widgets/toolkit/zoe_close_button_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_chip_widget.dart';
import 'package:zoe/features/task/widgets/task_assignee_header_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_stacked_avatars_widget.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/task/widgets/task_checkbox_widget.dart';
import 'package:zoe/features/task/widgets/task_item_widget.dart';
import 'package:zoe/common/providers/service_providers.dart';
import '../../../test-utils/mock_gorouter.dart';
import '../../../test-utils/mock_preferences.dart';
import '../../../test-utils/test_utils.dart';
import '../utils/task_utils.dart';

void main() {
  late ProviderContainer container;
  late MockPreferencesService mockPreferencesService;
  late TaskModel testTaskModel;
  const nonExistentTaskId = 'non-existent-task-id';

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Create mock preferences service
    mockPreferencesService = await mockGetLoginUserId();

    // Create the container with mock
    container = ProviderContainer.test(
      overrides: [
        preferencesServiceProvider.overrideWithValue(mockPreferencesService),
      ],
    );

    // Get the test task
    testTaskModel = getTaskByIndex(container);
  });

  // Pump task item widget
  Future<void> pumpTaskItemWidget({
    required WidgetTester tester,
    required ProviderContainer container,
    required String taskId,
    bool isEditing = false,
    ZoeUserDisplayType userDisplayType = ZoeUserDisplayType.stackedAvatars,
    GoRouter? router,
  }) async {
    await tester.pumpMaterialWidgetWithProviderScope(
      child: TaskWidget(
        taskId: taskId,
        isEditing: isEditing,
        userDisplayType: userDisplayType,
      ),
      container: container,
      router: router,
    );
    await tester.pumpAndSettle();
  }

  group('Task Item Widget', () {
    group('Basic Rendering with Test Task', () {
      testWidgets('displays task item when task exists', (tester) async {
        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: testTaskModel.id,
        );

        // Verify main components are present
        expect(find.byType(TaskWidget), findsOneWidget);
        expect(find.text(testTaskModel.title), findsOneWidget);
        expect(find.byType(ZoeInlineTextEditWidget), findsOneWidget);
        expect(find.byType(TaskCheckboxWidget), findsOneWidget);
      });

      testWidgets('returns empty widget when task does not exist', (
        tester,
      ) async {
        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: nonExistentTaskId,
        );

        // Should return SizedBox.shrink() when task is null
        expect(find.byType(TaskWidget), findsOneWidget);
        expect(find.text(testTaskModel.title), findsNothing);
        expect(find.byType(ZoeInlineTextEditWidget), findsNothing);
      });
    });

    group('Text Editing', () {
      testWidgets('displays title in read-only mode when not editing', (
        tester,
      ) async {
        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: testTaskModel.id,
        );

        final textEditWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget),
        );
        expect(textEditWidget.isEditing, isFalse);
        expect(textEditWidget.text, equals(testTaskModel.title));
      });

      testWidgets('displays title in edit mode when editing', (tester) async {
        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: testTaskModel.id,
          isEditing: true,
        );

        final textEditWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget),
        );
        expect(textEditWidget.isEditing, isTrue);
        expect(textEditWidget.text, equals(testTaskModel.title));
      });

      testWidgets('has correct text input action', (tester) async {
        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: testTaskModel.id,
        );

        final textEditWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget),
        );
        expect(textEditWidget.textInputAction, equals(TextInputAction.next));
      });

      testWidgets('focuses when task is focused', (tester) async {
        // Set focus to the test task
        container = ProviderContainer.test(
          overrides: [taskFocusProvider.overrideWithValue(testTaskModel.id)],
        );

        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: testTaskModel.id,
        );

        final textEditWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget),
        );
        expect(textEditWidget.autoFocus, isTrue);
      });

      testWidgets('does not focus when task is not focused', (tester) async {
        // Set focus to a different task
        container = ProviderContainer.test(
          overrides: [taskFocusProvider.overrideWithValue(nonExistentTaskId)],
        );

        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: testTaskModel.id,
        );

        final textEditWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget),
        );
        expect(textEditWidget.autoFocus, isFalse);
      });
    });

    group('Text Editing Callbacks', () {
      testWidgets('calls updateTaskTitle on text change', (tester) async {
        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: testTaskModel.id,
          isEditing: true,
        );

        // Find the TextField widget (which is shown when isEditing is true)
        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);

        // Simulate text change by entering text into the TextField
        const newTitle = 'Updated Title';
        await tester.enterText(textField, newTitle);

        // wait for provider to process the update
        await tester.pumpAndSettle();

        // Verify the task title is updated in the provider
        final updatedTask = container.read(taskProvider(testTaskModel.id));
        expect(updatedTask?.title, equals(newTitle));
      });

      testWidgets('adds new task on enter press', (tester) async {
        final parentId = testTaskModel.parentId;

        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: testTaskModel.id,
          isEditing: true,
        );

        // Find the TextField widget
        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);

        // Get initial task count
        final initialTasks = container.read(taskByParentProvider(parentId));
        final initialCount = initialTasks.length;

        // Trigger the onEnterPressed callback directly
        final textEditWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget),
        );
        textEditWidget.onEnterPressed?.call();

        // Wait for the async addTask operation to complete
        await tester.pumpAndSettle();

        // Verify new task is added
        final updatedTasks = container.read(taskByParentProvider(parentId));
        expect(updatedTasks.length, equals(initialCount + 1));

        // Verify new task has correct properties
        final newTask = updatedTasks.last;
        expect(newTask.parentId, equals(testTaskModel.parentId));
        expect(newTask.sheetId, equals(testTaskModel.sheetId));
        expect(newTask.orderIndex, greaterThan(testTaskModel.orderIndex));
      });

      testWidgets('deletes task on backspace with empty text', (tester) async {
        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: testTaskModel.id,
          isEditing: true,
        );

        // Find the TextField widget
        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);

        // Clear the text field first to make it empty
        await tester.enterText(textField, '');
        await tester.pump();

        // Verify task is deleted
        final updatedTask = container.read(taskProvider(testTaskModel.id));
        expect(updatedTask, isNull);
      });
    });

    group('Navigation', () {
      testWidgets('navigates to task detail on text tap', (tester) async {
        final mockRouter = await mockAnyPushGoRouter();

        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: testTaskModel.id,
          router: mockRouter,
        );

        final textEditWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget),
        );

        // Simulate text tap
        textEditWidget.onTapText?.call();
        await tester.pumpAndSettle();

        // Verify that the router.push method was called with the correct path
        verify(() => mockRouter.push('/task/${testTaskModel.id}')).called(1);
      });
    });

    group('Edit Mode Actions', () {
      testWidgets('shows action buttons when in edit mode', (tester) async {
        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: testTaskModel.id,
          isEditing: true,
        );

        // Verify edit and delete buttons are shown
        expect(find.byIcon(Icons.edit), findsOneWidget);
        expect(find.byType(ZoeCloseButtonWidget), findsOneWidget);
      });

      testWidgets('hides action buttons when not in edit mode', (tester) async {
        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: testTaskModel.id,
          isEditing: false,
        );

        // Verify edit and delete buttons are hidden
        expect(find.byIcon(Icons.edit), findsNothing);
        expect(find.byType(ZoeCloseButtonWidget), findsNothing);
      });

      testWidgets('navigates to task detail on edit button tap', (
        tester,
      ) async {
        final mockRouter = await mockAnyPushGoRouter();

        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: testTaskModel.id,
          isEditing: true,
          router: mockRouter,
        );

        // Tap the edit button
        await tester.tap(find.byIcon(Icons.edit));
        await tester.pumpAndSettle();

        // Verify that the router.push method was called with the correct path
        verify(() => mockRouter.push('/task/${testTaskModel.id}')).called(1);
      });

      testWidgets('deletes task on close button tap', (tester) async {
        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: testTaskModel.id,
          isEditing: true,
        );

        // Tap the close button
        await tester.tap(find.byType(ZoeCloseButtonWidget));
        await tester.pumpAndSettle();

        // Verify task is deleted
        final updatedBullet = container.read(taskProvider(testTaskModel.id));
        expect(updatedBullet, isNull);
      });
    });

    group('User Display - Stacked Avatars', () {
      testWidgets(
        'displays stacked avatars when userDisplayType is stackedAvatars',
        (tester) async {
          await pumpTaskItemWidget(
            tester: tester,
            container: container,
            taskId: testTaskModel.id,
          );

          // Should show stacked avatars widget
          expect(find.byType(ZoeStackedAvatarsWidget), findsOneWidget);
          expect(find.byType(ZoeUserChipWidget), findsNothing);
          expect(find.byType(TaskAssigneeHeaderWidget), findsNothing);
        },
      );
    });

    group('Layout Structure', () {
      testWidgets('has correct main row structure', (tester) async {
        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: testTaskModel.id,
        );

        // Verify main row structure with checkbox, content, and actions
        expect(find.byType(Row), findsAtLeastNWidgets(1));

        // Verify checkbox is present
        expect(find.byType(TaskCheckboxWidget), findsOneWidget);

        // Verify expanded content column
        expect(find.byType(Expanded), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
      });

      testWidgets('has correct content column structure', (tester) async {
        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: testTaskModel.id,
        );

        // Verify content column structure
        final column = tester.widget<Column>(find.byType(Column));
        expect(column.crossAxisAlignment, equals(CrossAxisAlignment.start));

        // Verify title row
        expect(find.byType(ZoeInlineTextEditWidget), findsOneWidget);

        // Verify due date (there might be multiple icons)
        expect(find.byType(Icon), findsAtLeastNWidgets(1));
        expect(find.byType(Text), findsAtLeastNWidgets(1));
      });

      testWidgets('shows user display in row when showInRow is true', (
        tester,
      ) async {
        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: testTaskModel.id,
        );

        // Verify user display is shown in the title row
        expect(find.byType(ZoeStackedAvatarsWidget), findsOneWidget);
      });

      testWidgets('shows action buttons when in editing mode', (tester) async {
        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: testTaskModel.id,
          isEditing: true,
        );

        // Verify action buttons are present
        expect(find.byType(ZoeCloseButtonWidget), findsOneWidget);
        expect(
          find.byType(Icon),
          findsAtLeastNWidgets(2),
        ); // Due date icon + edit icon
      });

      testWidgets('hides action buttons when not in editing mode', (
        tester,
      ) async {
        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: testTaskModel.id,
          isEditing: false,
        );

        // Verify action buttons are hidden
        expect(find.byType(ZoeCloseButtonWidget), findsNothing);
        // There should be at least one icon (due date icon)
        expect(find.byType(Icon), findsAtLeastNWidgets(1));
      });
    });

    group('Edge Cases', () {
      testWidgets('handles empty task title', (tester) async {
        final emptyTitleTask = TaskModel(
          id: testTaskModel.id,
          title: '', // Empty title
          parentId: testTaskModel.parentId,
          sheetId: testTaskModel.sheetId,
          dueDate: DateTime.now(),
          isCompleted: false,
          assignedUsers: [],
        );

        container = ProviderContainer.test(
          overrides: [
            taskProvider(emptyTitleTask.id).overrideWithValue(emptyTitleTask),
          ],
        );

        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: emptyTitleTask.id,
        );

        // Should still display the widget without errors
        expect(find.byType(ZoeInlineTextEditWidget), findsOneWidget);
        final textEditWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget),
        );
        expect(textEditWidget.text, equals(''));
      });

      testWidgets('handles different task IDs correctly', (tester) async {
        const differentTaskId = 'different-task-id';
        const differentTitle = 'Different Title';

        final differentTask = TaskModel(
          id: differentTaskId,
          title: differentTitle,
          parentId: testTaskModel.parentId,
          sheetId: testTaskModel.sheetId,
          orderIndex: 1,
          dueDate: DateTime.now(),
          isCompleted: false,
          assignedUsers: [],
        );

        container = ProviderContainer.test(
          overrides: [
            taskProvider(differentTaskId).overrideWithValue(differentTask),
          ],
        );

        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: differentTaskId,
        );

        // Verify correct task data is displayed
        expect(find.text(differentTitle), findsOneWidget);
      });

      testWidgets('handles missing assigned users gracefully', (tester) async {
        container = ProviderContainer.test(
          overrides: [
            taskProvider(
              testTaskModel.id,
            ).overrideWithValue(testTaskModel.copyWith(assignedUsers: [])),
          ],
        );

        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: testTaskModel.id,
        );

        // Should not crash and should hide user display
        expect(find.byType(ZoeStackedAvatarsWidget), findsNothing);
        expect(find.text(testTaskModel.title), findsOneWidget);
      });
    });

    group('Provider Integration', () {
      testWidgets('watches task provider correctly', (tester) async {
        final originalTitle = testTaskModel.title;
        final updatedTitle = 'Updated Title';

        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: testTaskModel.id,
        );

        // Verify task data is displayed
        expect(find.text(testTaskModel.title), findsOneWidget);

        // Update task title through provider
        container
            .read(taskListProvider.notifier)
            .updateTaskTitle(testTaskModel.id, updatedTitle);
        await tester.pump();

        // Verify updated title is displayed
        expect(find.text(updatedTitle), findsOneWidget);
        expect(find.text(originalTitle), findsNothing);
      });

      testWidgets('watches focus provider correctly', (tester) async {
        // Test when task is not focused
        container.read(taskFocusProvider.notifier).state =
            'different-task-id';

        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: testTaskModel.id,
        );

        var textEditWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget),
        );
        expect(textEditWidget.autoFocus, isFalse);

        // Test when task is focused - use the actual task ID
        container.read(taskFocusProvider.notifier).state = testTaskModel.id;
        await pumpTaskItemWidget(
          tester: tester,
          container: container,
          taskId: testTaskModel.id,
        );

        textEditWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget),
        );
        expect(textEditWidget.autoFocus, isTrue);
      });
    });
  });
}
