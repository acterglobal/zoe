import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/providers/service_providers.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/task/widgets/task_item_widget.dart';
import 'package:zoe/features/task/widgets/task_list_widget.dart';
import '../../../test-utils/mock_preferences.dart';
import '../../../test-utils/test_utils.dart';
import '../utils/task_utils.dart';

void main() {
  late ProviderContainer container;
  late MockPreferencesService mockPreferencesService;

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
  });

  Future<void> pumpTaskListWidget({
    required WidgetTester tester,
    required ProviderContainer container,
    required String listId,
    bool isEditing = false,
    bool isWrapMediaQuery = false,
  }) async {
    // Create the screen
    final screen = TaskListWidget(
      tasksProvider: taskByParentProvider(listId),
      isEditing: isEditing,
    );

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
  }

  group('Task List Widget', () {
    const testSheetId = 'sheet-1';
    const testListId = 'list-tasks-1';
    const nonExistentParentId = 'non-existent-parent-id';

    group('Basic Rendering', () {
      testWidgets('displays task list when tasks exist', (tester) async {
        await pumpTaskListWidget(
          tester: tester,
          container: container,
          listId: testListId,
        );

        // Verify ListView is displayed
        expect(find.byType(ListView), findsOneWidget);

        final testTasks = container.read(taskByParentProvider(testListId));

        // Verify task items are displayed (including off-screen ones)
        expect(
          find.byType(TaskWidget, skipOffstage: false),
          findsNWidgets(testTasks.length),
        );

        // Verify task titles are displayed (including off-screen ones)
        for (final task in testTasks) {
          expect(find.text(task.title, skipOffstage: false), findsOneWidget);
        }
      });

      testWidgets('returns empty widget when no tasks exist', (tester) async {
        // Use a different parent ID that has no tasks
        const emptyParentId = 'empty-parent-id';

        await pumpTaskListWidget(
          tester: tester,
          container: container,
          listId: emptyParentId,
        );

        // Should return SizedBox.shrink() when no tasks
        expect(find.byType(ListView), findsNothing);
        expect(find.byType(TaskWidget), findsNothing);
      });

      testWidgets('displays tasks in correct order', (tester) async {
        await pumpTaskListWidget(
          tester: tester,
          container: container,
          listId: testListId,
        );

        // Get all task item widgets (including off-screen ones)
        final taskItems = tester
            .widgetList<TaskWidget>(
              find.byType(TaskWidget, skipOffstage: false),
            )
            .toList();

        final testTasks = container.read(taskByParentProvider(testListId));

        // Verify tasks are in correct order (by orderIndex)
        for (int i = 0; i < testTasks.length; i++) {
          expect(taskItems[i].taskId, equals(testTasks[i].id));
        }
      });
    });

    group('Editing Mode', () {
      testWidgets('passes isEditing true to task items when editing', (
        tester,
      ) async {
        await pumpTaskListWidget(
          tester: tester,
          container: container,
          listId: testListId,
          isEditing: true,
        );

        // Verify all task items receive isEditing: true
        final taskItems = tester
            .widgetList<TaskWidget>(find.byType(TaskWidget))
            .toList();

        for (final taskItem in taskItems) {
          expect(taskItem.isEditing, isTrue);
        }
      });

      testWidgets('passes isEditing false to task items when not editing', (
        tester,
      ) async {
        await pumpTaskListWidget(
          tester: tester,
          container: container,
          listId: testListId,
        );

        // Verify all task items receive isEditing: false
        final taskItems = tester
            .widgetList<TaskWidget>(find.byType(TaskWidget))
            .toList();

        for (final taskItem in taskItems) {
          expect(taskItem.isEditing, isFalse);
        }
      });
    });

    group('ListView Configuration', () {
      testWidgets('has correct ListView properties', (tester) async {
        await pumpTaskListWidget(
          tester: tester,
          container: container,
          listId: testListId,
        );

        final listView = tester.widget<ListView>(find.byType(ListView));

        // Verify ListView properties
        expect(listView.shrinkWrap, isTrue);
        expect(listView.physics, isA<NeverScrollableScrollPhysics>());
      });
    });

    group('Item Builder', () {
      testWidgets('creates correct number of items', (tester) async {
        await pumpTaskListWidget(
          tester: tester,
          container: container,
          listId: testListId,
        );

        // Get the test tasks
        final testTasks = container.read(taskByParentProvider(testListId));

        // Verify correct number of task items
        expect(
          find.byType(TaskWidget, skipOffstage: false),
          findsNWidgets(testTasks.length),
        );
      });

      testWidgets('uses correct keys for task items', (tester) async {
        await pumpTaskListWidget(
          tester: tester,
          container: container,
          listId: testListId,
        );

        // Get the test tasks
        final testTasks = container.read(taskByParentProvider(testListId));

        // Verify each task item has the correct ValueKey
        for (int i = 0; i < testTasks.length; i++) {
          final expectedKey = ValueKey(testTasks[i].id);
          expect(find.byKey(expectedKey, skipOffstage: false), findsOneWidget);
        }
      });
    });

    group('Provider Integration', () {
      testWidgets('watches taskByParentProvider correctly', (tester) async {
        final newTaskTitle = 'New Task';

        await pumpTaskListWidget(
          tester: tester,
          container: container,
          listId: testListId,
        );

        // Get the initial test tasks
        final initialTasks = container.read(taskByParentProvider(testListId));

        // Verify initial tasks are displayed
        expect(
          find.byType(TaskWidget, skipOffstage: false),
          findsNWidgets(initialTasks.length),
        );

        // Add a new task
        container
            .read(taskListProvider.notifier)
            .addTask(
              title: newTaskTitle,
              parentId: testListId,
              sheetId: testSheetId,
            );
        await tester.pumpAndSettle();

        // Get the updated tasks
        final updatedTasks = container.read(taskByParentProvider(testListId));

        // Verify new task is displayed
        expect(
          find.byType(TaskWidget, skipOffstage: false),
          findsNWidgets(updatedTasks.length),
        );
        expect(find.text(newTaskTitle, skipOffstage: false), findsOneWidget);
      });

      testWidgets('updates when tasks are modified', (tester) async {
        // Get the first task
        final testFirstTask = getTaskByIndex(container);
        final taskId = testFirstTask.id;
        final parentId = testFirstTask.parentId;
        final originalTitle = testFirstTask.title;
        final updatedTitle = 'Updated Title';

        await pumpTaskListWidget(
          tester: tester,
          container: container,
          listId: parentId,
        );

        // Get the test tasks
        final testTasks = container.read(taskByParentProvider(parentId));

        // Verify the test tasks are not empty
        expect(testTasks.isNotEmpty, isTrue);

        // Update a task title
        container
            .read(taskListProvider.notifier)
            .updateTaskTitle(taskId, updatedTitle);
        await tester.pumpAndSettle();

        // Verify updated title is displayed
        expect(find.text(updatedTitle, skipOffstage: false), findsOneWidget);
        expect(find.text(originalTitle, skipOffstage: false), findsNothing);
      });

      testWidgets('updates when tasks are deleted', (tester) async {
        // Get the first task
        final testFirstTask = getTaskByIndex(container);
        final parentId = testFirstTask.parentId;
        final taskId = testFirstTask.id;

        await pumpTaskListWidget(
          tester: tester,
          container: container,
          listId: parentId,
        );

        // Get the test tasks
        final testTasks = container.read(taskByParentProvider(parentId));

        // Verify the test tasks are not empty
        expect(testTasks.isNotEmpty, isTrue);

        // Delete a task
        container.read(taskListProvider.notifier).deleteTask(taskId);
        await tester.pump();

        // Verify task is removed
        expect(
          find.byType(TaskWidget, skipOffstage: false),
          findsNWidgets(testTasks.length - 1),
        );
        expect(
          find.text(testFirstTask.title, skipOffstage: false),
          findsNothing,
        );
      });
    });

    group('Different Parent IDs', () {
      testWidgets('displays tasks for specific parent ID only', (tester) async {
        // Define constants for different parent ID and task title
        const differentParentId = 'different-parent-id-1';
        final differentParentTaskTitle = 'Different Parent Task 1';

        // Add a task for a different parent
        await container
            .read(taskListProvider.notifier)
            .addTask(
              title: differentParentTaskTitle,
              parentId: differentParentId,
              sheetId: testSheetId,
            );

        await pumpTaskListWidget(
          tester: tester,
          container: container,
          listId: testListId,
        );

        // Get the test tasks
        final testTasks = container.read(taskByParentProvider(testListId));

        // Should only show tasks for testListId
        expect(
          find.byType(TaskWidget, skipOffstage: false),
          findsNWidgets(testTasks.length),
        );
        expect(find.text(differentParentTaskTitle), findsNothing);
        expect(
          find.text(testTasks.last.title, skipOffstage: false),
          findsOneWidget,
        );
      });

      testWidgets('displays tasks for different parent when parentId changes', (
        tester,
      ) async {
        // Define constants for different parent ID and task title
        const differentParentId = 'different-parent-id-2';
        final differentParentTaskTitle = 'Different Parent Task 2';

        // Add a task for a different parent
        await container
            .read(taskListProvider.notifier)
            .addTask(
              title: differentParentTaskTitle,
              parentId: differentParentId,
              sheetId: testSheetId,
            );

        await pumpTaskListWidget(
          tester: tester,
          container: container,
          listId: differentParentId,
        );

        // Get the original test tasks (for testListId)
        final testTasks = container.read(taskByParentProvider(testListId));
        expect(testTasks.isNotEmpty, isTrue);

        // Should show tasks for differentParentId
        expect(find.byType(TaskWidget, skipOffstage: false), findsNWidgets(1));
        expect(find.text(differentParentTaskTitle), findsOneWidget);
        // Should not show tasks from the original parent
        expect(find.text(testTasks.last.title), findsNothing);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles empty task list gracefully', (tester) async {
        await pumpTaskListWidget(
          tester: tester,
          container: container,
          listId: nonExistentParentId,
        );

        // Should return empty widget
        expect(find.byType(ListView), findsNothing);
        expect(find.byType(TaskWidget), findsNothing);
        expect(find.byType(SizedBox), findsOneWidget);
      });

      testWidgets('handles single task correctly', (tester) async {
        const singleTaskTitle = 'Single Task';

        container = ProviderContainer.test(
          overrides: [
            taskListProvider.overrideWithValue([
              TaskModel(
                id: '1',
                title: singleTaskTitle,
                parentId: testListId,
                sheetId: testSheetId,
                dueDate: DateTime.now(),
                isCompleted: false,
                assignedUsers: [],
              ),
            ]),
          ],
        );

        await pumpTaskListWidget(
          tester: tester,
          container: container,
          listId: testListId,
        );

        // Should display single task
        expect(find.byType(TaskWidget), findsOneWidget);
        expect(find.text(singleTaskTitle), findsOneWidget);
      });

      testWidgets('handles large number of tasks efficiently', (tester) async {
        // Add a Many tasks
        await container
            .read(taskListProvider.notifier)
            .addTask(
              title: 'Test Task',
              parentId: testListId,
              sheetId: testSheetId,
            );

        await container
            .read(taskListProvider.notifier)
            .addTask(
              title: 'Test Task 2',
              parentId: testListId,
              sheetId: testSheetId,
            );

        await container
            .read(taskListProvider.notifier)
            .addTask(
              title: 'Test Task 3',
              parentId: testListId,
              sheetId: testSheetId,
            );

        await pumpTaskListWidget(
          tester: tester,
          container: container,
          listId: testListId,
          isWrapMediaQuery: true,
        );

        // Get the test tasks
        final testTasks = container.read(taskByParentProvider(testListId));

        // Verify that the ListView is displayed and can handle the data
        expect(find.byType(ListView), findsOneWidget);

        // Verify that we don't have more rendered tasks than total tasks
        final renderedTasks = find.byType(TaskWidget, skipOffstage: false);
        final renderedCount = renderedTasks.evaluate().length;
        expect(renderedCount, lessThanOrEqualTo(testTasks.length));
      });
    });

    group('Widget Properties', () {
      testWidgets('has correct key when provided', (tester) async {
        const key = Key('test-list-key');

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: TaskListWidget(
            key: key,
            tasksProvider: taskByParentProvider(testListId),
            isEditing: false,
          ),
        );

        expect(find.byKey(key), findsOneWidget);
      });

      testWidgets('has correct key when not provided', (tester) async {
        await pumpTaskListWidget(
          tester: tester,
          container: container,
          listId: testListId,
        );

        // Should still find the widget
        expect(find.byType(TaskListWidget), findsOneWidget);
      });
    });
  });
}
