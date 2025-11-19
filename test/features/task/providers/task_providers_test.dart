import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/data/tasks.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/providers/service_providers.dart';
import 'package:zoe/common/utils/date_time_utils.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import '../../../test-utils/mock_searchValue.dart';
import '../../../test-utils/mock_preferences.dart';
import '../../users/utils/users_utils.dart';
import '../utils/task_utils.dart';

void main() {
  group('Task Providers Tests', () {
    late ProviderContainer container;
    late TaskModel testTask;
    late String testUserId;
    late MockPreferencesService mockPreferencesService;

    setUp(() async {
      // Create mock preferences service
      mockPreferencesService = await mockGetLoginUserId();

      testUserId = getUserByIndex(
        ProviderContainer.test(
          overrides: [
            searchValueProvider.overrideWith(MockSearchValue.new),
            preferencesServiceProvider.overrideWithValue(
              mockPreferencesService,
            ),
          ],
        ),
      ).id;

      container = ProviderContainer.test(
        overrides: [
          searchValueProvider.overrideWith(MockSearchValue.new),
          preferencesServiceProvider.overrideWithValue(mockPreferencesService),
          loggedInUserProvider.overrideWithValue(AsyncValue.data(testUserId)),
        ],
      );

      testTask = getTaskByIndex(container);
    });

    group('TaskList Provider', () {
      test('initial state contains all tasks', () {
        final taskList = container.read(taskListProvider);
        expect(taskList, equals(tasks));
        expect(taskList.length, equals(tasks.length));
      });

      test('addTask adds new task to list', () async {
        const title = 'New Task';
        const parentId = 'list-tasks-1';
        const sheetId = 'sheet-1';

        final initialLength = container.read(taskListProvider).length;

        await container
            .read(taskListProvider.notifier)
            .addTask(title: title, parentId: parentId, sheetId: sheetId);

        final updatedList = container.read(taskListProvider);
        expect(updatedList.length, equals(initialLength + 1));
        expect(updatedList.last.title, equals(title));
        expect(updatedList.last.parentId, equals(parentId));
        expect(updatedList.last.sheetId, equals(sheetId));
        expect(updatedList.last.isCompleted, equals(false));
      });

      test(
        'addTask with orderIndex inserts task at specified position',
        () async {
          const title = 'Task with order';
          const parentId = 'list-tasks-1';
          const sheetId = 'sheet-1';
          const orderIndex = 0;

          await container
              .read(taskListProvider.notifier)
              .addTask(
                title: title,
                parentId: parentId,
                sheetId: sheetId,
                orderIndex: orderIndex,
              );

          final updatedList = container.read(taskListProvider);
          final addedTask = updatedList.firstWhere((t) => t.title == title);
          expect(addedTask.orderIndex, equals(orderIndex));
        },
      );

      test('deleteTask removes task from list', () {
        final initialLength = container.read(taskListProvider).length;

        container.read(taskListProvider.notifier).deleteTask(testTask.id);

        final updatedList = container.read(taskListProvider);
        expect(updatedList.length, equals(initialLength - 1));
        expect(updatedList.any((t) => t.id == testTask.id), isFalse);
      });

      test('deleteTask does nothing for non-existent task', () {
        final initialLength = container.read(taskListProvider).length;

        container.read(taskListProvider.notifier).deleteTask('non-existent-id');

        final updatedList = container.read(taskListProvider);
        expect(updatedList.length, equals(initialLength));
      });

      test('toggleTaskCompletion toggles task completion status', () {
        final initialStatus = testTask.isCompleted;

        container
            .read(taskListProvider.notifier)
            .toggleTaskCompletion(testTask.id);

        final updatedTask = container.read(taskProvider(testTask.id));
        expect(updatedTask?.isCompleted, equals(!initialStatus));
      });

      test('updateTaskTitle updates task title', () {
        const newTitle = 'Updated Task Title';

        container
            .read(taskListProvider.notifier)
            .updateTaskTitle(testTask.id, newTitle);

        final updatedTask = container.read(taskProvider(testTask.id));
        expect(updatedTask?.title, equals(newTitle));
      });

      test('updateTaskDescription updates task description', () {
        final newDescription = (
          plainText: 'Updated description',
          htmlText: '<p>Updated description</p>',
        );

        container
            .read(taskListProvider.notifier)
            .updateTaskDescription(testTask.id, newDescription);

        final updatedTask = container.read(taskProvider(testTask.id));
        expect(updatedTask?.description, equals(newDescription));
      });

      test('updateTaskCompletion updates task completion status', () {
        final newStatus = !testTask.isCompleted;

        container
            .read(taskListProvider.notifier)
            .updateTaskCompletion(testTask.id, newStatus);

        final updatedTask = container.read(taskProvider(testTask.id));
        expect(updatedTask?.isCompleted, equals(newStatus));
      });

      test('updateTaskDueDate updates task due date', () {
        final newDueDate = DateTime.now().add(const Duration(days: 7));

        container
            .read(taskListProvider.notifier)
            .updateTaskDueDate(testTask.id, newDueDate);

        final updatedTask = container.read(taskProvider(testTask.id));
        expect(updatedTask?.dueDate, equals(newDueDate));
      });

      test('updateTaskOrderIndex updates task order index', () {
        const newOrderIndex = 999;

        container
            .read(taskListProvider.notifier)
            .updateTaskOrderIndex(testTask.id, newOrderIndex);

        final updatedTask = container.read(taskProvider(testTask.id));
        expect(updatedTask?.orderIndex, equals(newOrderIndex));
      });

      test('updateTaskAssignees updates task assignees', () {
        final testUser2 = getUserByIndex(container, index: 1);
        final newAssignees = [testUserId, testUser2.id];

        container
            .read(taskListProvider.notifier)
            .updateTaskAssignees(testTask.id, newAssignees);

        final updatedTask = container.read(taskProvider(testTask.id));
        expect(updatedTask?.assignedUsers, equals(newAssignees));
      });

      test('addAssignee adds user to task assignees', () {
        final testUser2 = getUserByIndex(container, index: 1);
        final initialAssignees = List<String>.from(testTask.assignedUsers);

        container
            .read(taskListProvider.notifier)
            .addAssignee(testTask.id, testUser2.id);

        final updatedTask = container.read(taskProvider(testTask.id));
        expect(
          updatedTask?.assignedUsers.length,
          equals(initialAssignees.length + 1),
        );
        expect(updatedTask?.assignedUsers.contains(testUser2.id), isTrue);
      });

      test('removeAssignee removes user from task assignees', () {
        final initialAssignees = List<String>.from(testTask.assignedUsers);
        if (initialAssignees.isEmpty) {
          // Add a user first if none exist
          final testUser2 = getUserByIndex(container, index: 1);
          container
              .read(taskListProvider.notifier)
              .addAssignee(testTask.id, testUser2.id);
          initialAssignees.add(testUser2.id);
        }

        final assigneeToRemove = initialAssignees.first;

        container
            .read(taskListProvider.notifier)
            .removeAssignee(testTask.id, assigneeToRemove);

        final updatedTask = container.read(taskProvider(testTask.id));
        expect(
          updatedTask?.assignedUsers.length,
          equals(initialAssignees.length - 1),
        );
        expect(updatedTask?.assignedUsers.contains(assigneeToRemove), isFalse);
      });

      test('removeAssignee does nothing if user is not assigned', () {
        final initialAssignees = List<String>.from(testTask.assignedUsers);
        final nonExistentUserId = 'non-existent-user';

        container
            .read(taskListProvider.notifier)
            .removeAssignee(testTask.id, nonExistentUserId);

        final updatedTask = container.read(taskProvider(testTask.id));
        expect(
          updatedTask?.assignedUsers.length,
          equals(initialAssignees.length),
        );
      });

      test('getFocusTaskId returns next task when deleting first task', () async {
        final parentId = testTask.parentId;
        final sheetId = testTask.sheetId;

        // Ensure we have at least 2 tasks with the same parent
        var parentTasks = container
            .read(taskListProvider)
            .where((t) => t.parentId == parentId)
            .toList()
          ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

        // Add tasks if needed
        while (parentTasks.length < 2) {
          await container.read(taskListProvider.notifier).addTask(
            title: 'Setup Task ${parentTasks.length}',
            parentId: parentId,
            sheetId: sheetId,
          );
          // Refresh the list after adding
          parentTasks = container
              .read(taskListProvider)
              .where((t) => t.parentId == parentId)
              .toList()
            ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
        }

        final firstTask = parentTasks.first;
        final nextTask = parentTasks[1];

        final focusTaskId = container
            .read(taskListProvider.notifier)
            .getFocusTaskId(firstTask.id);

        expect(focusTaskId, equals(nextTask.id));
      });

      test(
        'getFocusTaskId returns previous task when deleting middle task',
        () async {
          final parentId = testTask.parentId;
          final sheetId = testTask.sheetId;

          // Ensure we have at least 3 tasks with the same parent
          var parentTasks = container
              .read(taskListProvider)
              .where((t) => t.parentId == parentId)
              .toList()
            ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

          // Add tasks if needed
          while (parentTasks.length < 3) {
            await container.read(taskListProvider.notifier).addTask(
              title: 'Setup Task ${parentTasks.length}',
              parentId: parentId,
              sheetId: sheetId,
            );
            // Refresh the list after adding
            parentTasks = container
                .read(taskListProvider)
                .where((t) => t.parentId == parentId)
                .toList()
              ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
          }

          final middleTask = parentTasks[1];
          final previousTask = parentTasks[0];

          final focusTaskId = container
              .read(taskListProvider.notifier)
              .getFocusTaskId(middleTask.id);

          expect(focusTaskId, equals(previousTask.id));
        },
      );

      test('getFocusTaskId returns previous task when deleting last task', () async {
        final parentId = testTask.parentId;
        final sheetId = testTask.sheetId;

        // Ensure we have at least 2 tasks with the same parent
        var parentTasks = container
            .read(taskListProvider)
            .where((t) => t.parentId == parentId)
            .toList()
          ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

        // Add tasks if needed
        while (parentTasks.length < 2) {
          await container.read(taskListProvider.notifier).addTask(
            title: 'Setup Task ${parentTasks.length}',
            parentId: parentId,
            sheetId: sheetId,
          );
          // Refresh the list after adding
          parentTasks = container
              .read(taskListProvider)
              .where((t) => t.parentId == parentId)
              .toList()
            ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
        }

        final lastTask = parentTasks.last;
        final previousTask = parentTasks[parentTasks.length - 2];

        final focusTaskId = container
            .read(taskListProvider.notifier)
            .getFocusTaskId(lastTask.id);

        expect(focusTaskId, equals(previousTask.id));
      });
    });

    group('tasksList Provider', () {
      test('returns tasks filtered by logged-in user membership', () {
        final tasksList = container.read(tasksListProvider);
        final allTasks = container.read(taskListProvider);

        // Get tasks that the test user's sheets contain
        final userTasks = allTasks.where((t) {
          final sheet = container.read(sheetProvider(t.sheetId));
          return sheet?.users.contains(testUserId) == true;
        }).toList();

        expect(tasksList.length, equals(userTasks.length));
      });

      test('returns empty list when no user is logged in', () {
        final containerWithoutUser = ProviderContainer.test(
          overrides: [
            searchValueProvider.overrideWith(MockSearchValue.new),
            preferencesServiceProvider.overrideWithValue(
              mockPreferencesService,
            ),
            loggedInUserProvider.overrideWithValue(const AsyncValue.data(null)),
          ],
        );

        final tasksList = containerWithoutUser.read(tasksListProvider);
        expect(tasksList, isEmpty);
      });
    });

    group('todaysTasks Provider', () {
      test('returns only tasks due today', () {
        final todaysTasks = container.read(todaysTasksProvider);

        for (final task in todaysTasks) {
          expect(task.dueDate.isToday, isTrue);
        }
      });

      test('returns tasks sorted by due date', () {
        final todaysTasks = container.read(todaysTasksProvider);

        for (int i = 0; i < todaysTasks.length - 1; i++) {
          expect(
            todaysTasks[i].dueDate.compareTo(todaysTasks[i + 1].dueDate),
            lessThanOrEqualTo(0),
          );
        }
      });
    });

    group('upcomingTasks Provider', () {
      test('returns only upcoming tasks', () {
        final upcomingTasks = container.read(upcomingTasksProvider);

        for (final task in upcomingTasks) {
          expect(task.dueDate.isAfter(DateTime.now()), isTrue);
          expect(task.dueDate.isToday, isFalse);
        }
      });

      test('returns tasks sorted by due date', () {
        final upcomingTasks = container.read(upcomingTasksProvider);

        for (int i = 0; i < upcomingTasks.length - 1; i++) {
          expect(
            upcomingTasks[i].dueDate.compareTo(upcomingTasks[i + 1].dueDate),
            lessThanOrEqualTo(0),
          );
        }
      });
    });

    group('pastDueTasks Provider', () {
      void createPastDueTask() {
        final pastDate = DateTime.now().subtract(const Duration(days: 1));
        container
            .read(taskListProvider.notifier)
            .updateTaskDueDate(testTask.id, pastDate);
      }

      test('returns only past due tasks', () {
        // Create a past-due task by updating an existing task's due date
        createPastDueTask();

        final pastDueTasks = container.read(pastDueTasksProvider);

        // Verify that at least one past-due task exists
        expect(pastDueTasks.isNotEmpty, isTrue);

        // Verify that the updated task is included in past-due tasks
        final updatedTask = pastDueTasks.firstWhere(
          (task) => task.id == testTask.id,
          orElse: () => throw Exception(
              'Updated past-due task with id "${testTask.id}" not found'),
        );
        expect(updatedTask.dueDate.isBefore(DateTime.now()), isTrue);
        expect(updatedTask.dueDate.isToday, isFalse);

        // Verify all returned tasks are past due
        for (final task in pastDueTasks) {
          expect(task.dueDate.isBefore(DateTime.now()), isTrue);
          expect(task.dueDate.isToday, isFalse);
        }
      });

      test('returns tasks sorted by due date (descending)', () {
        // Create a past-due task by updating an existing task's due date
        createPastDueTask();

        final pastDueTasks = container.read(pastDueTasksProvider);

        // Only test sorting if there are at least 2 tasks
        if (pastDueTasks.length > 1) {
          for (int i = 0; i < pastDueTasks.length - 1; i++) {
            expect(
              pastDueTasks[i].dueDate.compareTo(pastDueTasks[i + 1].dueDate),
              greaterThanOrEqualTo(0),
            );
          }
        }
      });
    });

    group('allTasks Provider', () {
      test('returns all tasks combined from today, upcoming, and past', () {
        final allTasks = container.read(allTasksProvider);
        final todaysTasks = container.read(todaysTasksProvider);
        final upcomingTasks = container.read(upcomingTasksProvider);
        final pastDueTasks = container.read(pastDueTasksProvider);

        expect(
          allTasks.length,
          equals(
            todaysTasks.length + upcomingTasks.length + pastDueTasks.length,
          ),
        );
      });
    });

    group('taskListSearch Provider', () {

      final searchTerm = testTask.title.substring(0, testTask.title.length < 5 ? testTask.title.length : 5).toUpperCase();

      test('returns all tasks when search is empty', () {
        container.read(searchValueProvider.notifier).update('');

        final searchResults = container.read(taskListSearchProvider);
        // taskListSearchProvider filters by logged-in user membership
        final tasksList = container.read(tasksListProvider);

        expect(searchResults.length, equals(tasksList.length));
      });

      test('filters tasks by title when search has value', () {
       
        container.read(searchValueProvider.notifier).update(searchTerm);

        final searchResults = container.read(taskListSearchProvider);

        for (final task in searchResults) {
          expect(task.title.toLowerCase().contains(searchTerm), isTrue);
        }
      });

      test('search is case insensitive', () {
        container.read(searchValueProvider.notifier).update(searchTerm);

        final searchResults = container.read(taskListSearchProvider);

        final lowerSearchTerm = searchTerm.toLowerCase();
        for (final task in searchResults) {
          expect(task.title.toLowerCase().contains(lowerSearchTerm), isTrue);
        }
      });

      test('returns empty list when no matches found', () {
        container
            .read(searchValueProvider.notifier)
            .update('nonexistent-search-term-xyz123');

        final searchResults = container.read(taskListSearchProvider);

        expect(searchResults, isEmpty);
      });
    });

    group('task Provider', () {
      test('returns task when ID exists', () {
        final task = container.read(taskProvider(testTask.id));

        expect(task, isNotNull);
        expect(task!.id, equals(testTask.id));
        expect(task.title, equals(testTask.title));
      });

      test('returns null when ID does not exist', () {
        final task = container.read(taskProvider('non-existent-id'));

        expect(task, isNull);
      });

      test('updates when task list changes', () {
        final initialTask = container.read(taskProvider(testTask.id));
        expect(initialTask, isNotNull);

        container
            .read(taskListProvider.notifier)
            .updateTaskTitle(testTask.id, 'Updated Title');

        final updatedTask = container.read(taskProvider(testTask.id));
        expect(updatedTask?.title, equals('Updated Title'));
        expect(updatedTask?.id, equals(testTask.id));
      });
    });

    group('taskByParent Provider', () {
      test('returns tasks filtered by parent ID', () {
        final parentTasks = container.read(
          taskByParentProvider(testTask.parentId),
        );

        for (final task in parentTasks) {
          expect(task.parentId, equals(testTask.parentId));
        }
      });

      test('returns tasks sorted by orderIndex', () {
        final parentTasks = container.read(
          taskByParentProvider(testTask.parentId),
        );

        for (int i = 0; i < parentTasks.length - 1; i++) {
          expect(
            parentTasks[i].orderIndex.compareTo(parentTasks[i + 1].orderIndex),
            lessThanOrEqualTo(0),
          );
        }
      });

      test('returns empty list for non-existent parent', () {
        final parentTasks = container.read(
          taskByParentProvider('non-existent-parent-id'),
        );

        expect(parentTasks, isEmpty);
      });
    });

    group('listOfUsersByTaskId Provider', () {
      test('returns users list when task exists', () {
        final users = container.read(listOfUsersByTaskIdProvider(testTask.id));

        expect(users, isA<List<String>>());
        expect(users, equals(testTask.assignedUsers));
      });

      test('returns empty list when task does not exist', () {
        final users = container.read(
          listOfUsersByTaskIdProvider('non-existent-id'),
        );

        expect(users, isEmpty);
      });

      test('updates when task assignees change', () {
        final initialUsers = container.read(
          listOfUsersByTaskIdProvider(testTask.id),
        );
        final testUser2 = getUserByIndex(container, index: 1);

        container
            .read(taskListProvider.notifier)
            .addAssignee(testTask.id, testUser2.id);

        final updatedUsers = container.read(
          listOfUsersByTaskIdProvider(testTask.id),
        );
        expect(updatedUsers.length, equals(initialUsers.length + 1));
        expect(updatedUsers.contains(testUser2.id), isTrue);
      });
    });

    group('TaskFocus Provider', () {
      test('initial state is null', () {
        final focusTaskId = container.read(taskFocusProvider);

        expect(focusTaskId, isNull);
      });

      test('can be updated with task ID', () {
        container.read(taskFocusProvider.notifier).state = testTask.id;

        final focusTaskId = container.read(taskFocusProvider);
        expect(focusTaskId, equals(testTask.id));
      });

      test('can be cleared to null', () {
        container.read(taskFocusProvider.notifier).state = testTask.id;
        container.read(taskFocusProvider.notifier).state = null;

        final focusTaskId = container.read(taskFocusProvider);
        expect(focusTaskId, isNull);
      });
    });

    group('completedTasksCount Provider', () {
      test('returns count of completed tasks', () {
        final completedCount = container.read(completedTasksCountProvider);
        final tasksList = container.read(tasksListProvider);

        final expectedCount = tasksList.where((t) => t.isCompleted).length;

        expect(completedCount, equals(expectedCount));
      });

      test('updates when task completion status changes', () {
        final initialCount = container.read(completedTasksCountProvider);
        final initialStatus = testTask.isCompleted;

        container
            .read(taskListProvider.notifier)
            .updateTaskCompletion(testTask.id, !initialStatus);

        final updatedCount = container.read(completedTasksCountProvider);

        if (initialStatus) {
          // Task was completed, now incomplete - count should decrease
          expect(updatedCount, equals(initialCount - 1));
        } else {
          // Task was incomplete, now completed - count should increase
          expect(updatedCount, equals(initialCount + 1));
        }
      });
    });

    group('tasksDueTodayCount Provider', () {
      test('returns count of tasks due today', () {
        final dueTodayCount = container.read(tasksDueTodayCountProvider);
        final todaysTasks = container.read(todaysTasksProvider);

        expect(dueTodayCount, equals(todaysTasks.length));
      });

      test('updates when task due date changes to today', () {
        final initialCount = container.read(tasksDueTodayCountProvider);
        final wasAlreadyDueToday = testTask.dueDate.isToday;

        // Update task due date to today
        container
            .read(taskListProvider.notifier)
            .updateTaskDueDate(testTask.id, DateTime.now());

        final updatedCount = container.read(tasksDueTodayCountProvider);

        if (wasAlreadyDueToday) {
          expect(updatedCount, equals(initialCount));
        } else {
          expect(updatedCount, equals(initialCount + 1));
        }
      });
    });

    group('overdueTasksCount Provider', () {
      test('returns count of overdue tasks', () {
        final overdueCount = container.read(overdueTasksCountProvider);
        final pastDueTasks = container.read(pastDueTasksProvider);

        expect(overdueCount, equals(pastDueTasks.length));
      });

      test('updates when task becomes overdue', () {
        final initialCount = container.read(overdueTasksCountProvider);
        final wasAlreadyOverdue = testTask.dueDate.isBefore(DateTime.now()) && !testTask.dueDate.isToday;

        // Update task due date to past
        final pastDate = DateTime.now().subtract(const Duration(days: 1));
        container
            .read(taskListProvider.notifier)
            .updateTaskDueDate(testTask.id, pastDate);

        final updatedCount = container.read(overdueTasksCountProvider);

        if (wasAlreadyOverdue) {
          expect(updatedCount, equals(initialCount));
        } else {
          expect(updatedCount, equals(initialCount + 1));
        }
      });
    });
  });
}
