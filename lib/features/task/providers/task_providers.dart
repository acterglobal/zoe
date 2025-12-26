import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/common/actions/firestore_actions.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/date_time_utils.dart';
import 'package:zoe/common/utils/firebase_utils.dart';
import 'package:zoe/core/constants/firestore_constants.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

part 'task_providers.g.dart';

/// Main task list provider with all task management functionality
@Riverpod(keepAlive: true)
class TaskList extends _$TaskList {
  StreamSubscription? _subscription;

  CollectionReference<Map<String, dynamic>> get collection =>
      ref.read(firestoreProvider).collection(FirestoreCollections.tasks);

  @override
  List<TaskModel> build() {
    _subscription?.cancel();
    _subscription = null;

    final sheetIds = ref.watch(listOfSheetIdsProvider);
    Query<Map<String, dynamic>> query = collection;
    if (sheetIds.isNotEmpty) {
      query = query.where(
        whereInFilter(FirestoreFieldConstants.sheetId, sheetIds),
      );
    }

    _subscription = query.snapshots().listen(
      (snapshot) {
        state = snapshot.docs
            .map((doc) => TaskModel.fromJson(doc.data()))
            .toList();
      },
      /*onError: (error, stackTrace) => runFirestoreOperation(
        ref,
        () => Error.throwWithStackTrace(error, stackTrace),
      ),*/
    );

    ref.onDispose(() => _subscription?.cancel());
    return [];
  }

  Future<void> addTask({
    String title = '',
    required String parentId,
    required String sheetId,
    int? orderIndex,
  }) async {
    final userId = ref.read(currentUserProvider)?.id;
    if (userId == null) return;

    // Single pass optimization: collect parent tasks and determine new orderIndex
    int newOrderIndex;
    Map<String, TaskModel> tasksToUpdate = {};

    if (orderIndex == null) {
      // Find max orderIndex for this parent in a single pass
      int maxOrderIndex = -1;
      for (final task in state) {
        if (task.parentId == parentId && task.orderIndex > maxOrderIndex) {
          maxOrderIndex = task.orderIndex;
        }
      }
      newOrderIndex = maxOrderIndex + 1;
    } else {
      // Collect tasks that need orderIndex updates in a single pass
      newOrderIndex = orderIndex;
      for (final task in state) {
        if (task.parentId == parentId && task.orderIndex >= orderIndex) {
          tasksToUpdate[task.id] = task.copyWith(
            orderIndex: task.orderIndex + 1,
          );
        }
      }
    }

    // Create the new task
    final newTask = TaskModel(
      parentId: parentId,
      title: title,
      sheetId: sheetId,
      orderIndex: newOrderIndex,
      dueDate: DateTime.now(),
      isCompleted: false,
      createdBy: userId,
      assignedUsers: [],
    );

    // Persist to Firebase
    await runFirestoreOperation(ref, () async {
      final batch = ref.read(firestoreProvider).batch();
      // Add the new Task
      batch.set(collection.doc(newTask.id), newTask.toJson());

      // Update orderIndex for affected tasks
      for (final entry in tasksToUpdate.entries) {
        batch.update(collection.doc(entry.key), {
          FirestoreFieldConstants.orderIndex: entry.value.orderIndex,
          FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();

      // Set the focus to the new task
      ref.read(taskFocusProvider.notifier).state = newTask.id;
    });
  }

  Future<void> deleteTask(String taskId) async {
    // Get the focus task id (previous or next)
    final focusTaskId = getFocusTaskId(taskId);
    // Persist to Firebase
    await runFirestoreOperation(ref, () async {
      await collection.doc(taskId).delete();
      // Set the focus to the focus task
      ref.read(taskFocusProvider.notifier).state = focusTaskId;
    });
  }

  Future<void> updateTaskTitle(String taskId, String title) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(taskId).update({
        FirestoreFieldConstants.title: title,
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> updateTaskDescription(
    String taskId,
    Description description,
  ) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(taskId).update({
        FirestoreFieldConstants.description: {
          FirestoreFieldConstants.plainText: description.plainText,
          FirestoreFieldConstants.htmlText: description.htmlText,
        },
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> updateTaskCompletion(String taskId, bool isCompleted) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(taskId).update({
        FirestoreFieldConstants.isCompleted: isCompleted,
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> updateTaskDueDate(String taskId, DateTime dueDate) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(taskId).update({
        FirestoreFieldConstants.dueDate: Timestamp.fromDate(dueDate),
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> updateTaskOrderIndex(String taskId, int orderIndex) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(taskId).update({
        FirestoreFieldConstants.orderIndex: orderIndex,
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> updateTaskAssignees(String taskId, FieldValue fieldValue) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(taskId).update({
        FirestoreFieldConstants.assignedUsers: fieldValue,
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  void addAssignee(String taskId, String userId) =>
      updateTaskAssignees(taskId, FieldValue.arrayUnion([userId]));

  void removeAssignee(String taskId, String userId) =>
      updateTaskAssignees(taskId, FieldValue.arrayRemove([userId]));

  String? getFocusTaskId(String taskId) {
    // Get the task for the parent from current state
    final task = state.where((t) => t.id == taskId).firstOrNull;
    if (task == null) return null;
    final parentId = task.parentId;

    // Get the parent task list from current state
    final parentTasks = state.where((t) => t.parentId == parentId).toList()
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    // Get the current task index
    final currentTaskIndex = parentTasks.indexOf(task);

    // If the current task is the first task, try to return the next task
    if (currentTaskIndex <= 0) {
      // Check if there's a next task available
      if (currentTaskIndex < parentTasks.length - 1) {
        // Return the next task id
        return parentTasks[currentTaskIndex + 1].id;
      }
      return null;
    }

    // Return the previous task id
    return parentTasks[currentTaskIndex - 1].id;
  }
}

/// Provider for today's tasks (filtered by membership)
@riverpod
List<TaskModel> todaysTasks(Ref ref) {
  final tasks = ref.watch(taskListProvider);
  final todayTasks = tasks.where((task) => task.dueDate.isToday).toList();
  todayTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  return todayTasks;
}

/// Provider for upcoming tasks (filtered by membership)
@riverpod
List<TaskModel> upcomingTasks(Ref ref) {
  final tasks = ref.watch(taskListProvider);
  final upcomingTasks = tasks.where((task) {
    return task.dueDate.isAfter(DateTime.now()) && !task.dueDate.isToday;
  }).toList();
  upcomingTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  return upcomingTasks;
}

/// Provider for past due tasks (filtered by membership)
@riverpod
List<TaskModel> pastDueTasks(Ref ref) {
  final tasks = ref.watch(taskListProvider);
  final pastDueTasks = tasks.where((task) {
    return task.dueDate.isBefore(DateTime.now()) && !task.dueDate.isToday;
  }).toList();
  pastDueTasks.sort((a, b) => b.dueDate.compareTo(a.dueDate));
  return pastDueTasks;
}

/// Provider for all tasks combined
@riverpod
List<TaskModel> allTasks(Ref ref) {
  final todayTasks = ref.watch(todaysTasksProvider);
  final upcomingTasks = ref.watch(upcomingTasksProvider);
  final pastDueTasks = ref.watch(pastDueTasksProvider);
  return [...todayTasks, ...upcomingTasks, ...pastDueTasks];
}

/// Provider for searching tasks
@riverpod
List<TaskModel> taskListSearch(Ref ref) {
  final searchValue = ref.watch(searchValueProvider);
  final tasks = ref.watch(taskListProvider);

  if (searchValue.isEmpty) return tasks;
  return tasks
      .where(
        (task) => task.title.toLowerCase().contains(searchValue.toLowerCase()),
      )
      .toList();
}

/// Provider for a single task by ID
@riverpod
TaskModel? task(Ref ref, String taskId) {
  final taskList = ref.watch(taskListProvider);
  return taskList.where((t) => t.id == taskId).firstOrNull;
}

/// Provider for tasks filtered by parent ID
@riverpod
List<TaskModel> taskByParent(Ref ref, String parentId) {
  final taskList = ref.watch(taskListProvider);
  final filteredTasks = taskList.where((t) => t.parentId == parentId).toList();
  filteredTasks.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
  return filteredTasks;
}

/// Provider for list of users assigned to a task
@riverpod
List<String> listOfUsersByTaskId(Ref ref, String taskId) {
  final taskList = ref.watch(taskListProvider);
  return taskList.where((t) => t.id == taskId).firstOrNull?.assignedUsers ?? [];
}

/// Provider for task focus management
@Riverpod(keepAlive: true)
class TaskFocus extends _$TaskFocus {
  @override
  String? build() => null;
}

/// Provider for completed tasks count (filtered by membership)
@riverpod
int completedTasksCount(Ref ref) {
  final tasks = ref.watch(taskListProvider);
  return tasks.where((task) => task.isCompleted).length;
}

/// Provider for tasks due today count
@riverpod
int tasksDueTodayCount(Ref ref) {
  final todayTasks = ref.watch(todaysTasksProvider);
  return todayTasks.length;
}

/// Provider for overdue tasks count (filtered by membership)
@riverpod
int overdueTasksCount(Ref ref) {
  final pastDueTasks = ref.watch(pastDueTasksProvider);
  return pastDueTasks.length;
}
