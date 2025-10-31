// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Main task list provider with all task management functionality

@ProviderFor(TaskList)
const taskListProvider = TaskListProvider._();

/// Main task list provider with all task management functionality
final class TaskListProvider
    extends $NotifierProvider<TaskList, List<TaskModel>> {
  /// Main task list provider with all task management functionality
  const TaskListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskListHash();

  @$internal
  @override
  TaskList create() => TaskList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TaskModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TaskModel>>(value),
    );
  }
}

String _$taskListHash() => r'4d24ff92eee39945a3b1bcc09988d898ebc8fb8a';

/// Main task list provider with all task management functionality

abstract class _$TaskList extends $Notifier<List<TaskModel>> {
  List<TaskModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<TaskModel>, List<TaskModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<TaskModel>, List<TaskModel>>,
              List<TaskModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for tasks filtered by membership (current user must be a member of the sheet)

@ProviderFor(memberTasks)
const memberTasksProvider = MemberTasksProvider._();

/// Provider for tasks filtered by membership (current user must be a member of the sheet)

final class MemberTasksProvider
    extends
        $FunctionalProvider<List<TaskModel>, List<TaskModel>, List<TaskModel>>
    with $Provider<List<TaskModel>> {
  /// Provider for tasks filtered by membership (current user must be a member of the sheet)
  const MemberTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memberTasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memberTasksHash();

  @$internal
  @override
  $ProviderElement<List<TaskModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<TaskModel> create(Ref ref) {
    return memberTasks(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TaskModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TaskModel>>(value),
    );
  }
}

String _$memberTasksHash() => r'5de714210cce89740d478e34b80126c68f322894';

/// Provider for today's tasks (filtered by membership)

@ProviderFor(todaysTasks)
const todaysTasksProvider = TodaysTasksProvider._();

/// Provider for today's tasks (filtered by membership)

final class TodaysTasksProvider
    extends
        $FunctionalProvider<List<TaskModel>, List<TaskModel>, List<TaskModel>>
    with $Provider<List<TaskModel>> {
  /// Provider for today's tasks (filtered by membership)
  const TodaysTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todaysTasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todaysTasksHash();

  @$internal
  @override
  $ProviderElement<List<TaskModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<TaskModel> create(Ref ref) {
    return todaysTasks(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TaskModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TaskModel>>(value),
    );
  }
}

String _$todaysTasksHash() => r'ad5ac0441503f0198158c907ec17b16d9a29bb4e';

/// Provider for upcoming tasks (filtered by membership)

@ProviderFor(upcomingTasks)
const upcomingTasksProvider = UpcomingTasksProvider._();

/// Provider for upcoming tasks (filtered by membership)

final class UpcomingTasksProvider
    extends
        $FunctionalProvider<List<TaskModel>, List<TaskModel>, List<TaskModel>>
    with $Provider<List<TaskModel>> {
  /// Provider for upcoming tasks (filtered by membership)
  const UpcomingTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'upcomingTasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$upcomingTasksHash();

  @$internal
  @override
  $ProviderElement<List<TaskModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<TaskModel> create(Ref ref) {
    return upcomingTasks(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TaskModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TaskModel>>(value),
    );
  }
}

String _$upcomingTasksHash() => r'29b5f80ccde1209761ced3559cae983cab46dc80';

/// Provider for past due tasks (filtered by membership)

@ProviderFor(pastDueTasks)
const pastDueTasksProvider = PastDueTasksProvider._();

/// Provider for past due tasks (filtered by membership)

final class PastDueTasksProvider
    extends
        $FunctionalProvider<List<TaskModel>, List<TaskModel>, List<TaskModel>>
    with $Provider<List<TaskModel>> {
  /// Provider for past due tasks (filtered by membership)
  const PastDueTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pastDueTasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pastDueTasksHash();

  @$internal
  @override
  $ProviderElement<List<TaskModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<TaskModel> create(Ref ref) {
    return pastDueTasks(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TaskModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TaskModel>>(value),
    );
  }
}

String _$pastDueTasksHash() => r'7db8c130b8d9b57e13dce7ab2554f5c174fd9031';

/// Provider for all tasks combined

@ProviderFor(allTasks)
const allTasksProvider = AllTasksProvider._();

/// Provider for all tasks combined

final class AllTasksProvider
    extends
        $FunctionalProvider<List<TaskModel>, List<TaskModel>, List<TaskModel>>
    with $Provider<List<TaskModel>> {
  /// Provider for all tasks combined
  const AllTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allTasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allTasksHash();

  @$internal
  @override
  $ProviderElement<List<TaskModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<TaskModel> create(Ref ref) {
    return allTasks(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TaskModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TaskModel>>(value),
    );
  }
}

String _$allTasksHash() => r'd1062653783a5cad785d8b14e3a712f4956aebf5';

/// Provider for searching tasks

@ProviderFor(taskListSearch)
const taskListSearchProvider = TaskListSearchProvider._();

/// Provider for searching tasks

final class TaskListSearchProvider
    extends
        $FunctionalProvider<List<TaskModel>, List<TaskModel>, List<TaskModel>>
    with $Provider<List<TaskModel>> {
  /// Provider for searching tasks
  const TaskListSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskListSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskListSearchHash();

  @$internal
  @override
  $ProviderElement<List<TaskModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<TaskModel> create(Ref ref) {
    return taskListSearch(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TaskModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TaskModel>>(value),
    );
  }
}

String _$taskListSearchHash() => r'c756a3e2a5707482adb7eaaf4b9a5f0688c0d08b';

/// Provider for a single task by ID

@ProviderFor(task)
const taskProvider = TaskFamily._();

/// Provider for a single task by ID

final class TaskProvider
    extends $FunctionalProvider<TaskModel?, TaskModel?, TaskModel?>
    with $Provider<TaskModel?> {
  /// Provider for a single task by ID
  const TaskProvider._({
    required TaskFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'taskProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskHash();

  @override
  String toString() {
    return r'taskProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<TaskModel?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TaskModel? create(Ref ref) {
    final argument = this.argument as String;
    return task(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskModel?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TaskProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskHash() => r'5be8116f63802bf34f9d796142905ef43967ce2f';

/// Provider for a single task by ID

final class TaskFamily extends $Family
    with $FunctionalFamilyOverride<TaskModel?, String> {
  const TaskFamily._()
    : super(
        retry: null,
        name: r'taskProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for a single task by ID

  TaskProvider call(String taskId) =>
      TaskProvider._(argument: taskId, from: this);

  @override
  String toString() => r'taskProvider';
}

/// Provider for tasks filtered by parent ID

@ProviderFor(taskByParent)
const taskByParentProvider = TaskByParentFamily._();

/// Provider for tasks filtered by parent ID

final class TaskByParentProvider
    extends
        $FunctionalProvider<List<TaskModel>, List<TaskModel>, List<TaskModel>>
    with $Provider<List<TaskModel>> {
  /// Provider for tasks filtered by parent ID
  const TaskByParentProvider._({
    required TaskByParentFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'taskByParentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskByParentHash();

  @override
  String toString() {
    return r'taskByParentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<TaskModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<TaskModel> create(Ref ref) {
    final argument = this.argument as String;
    return taskByParent(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TaskModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TaskModel>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TaskByParentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskByParentHash() => r'2c2bd02a723c6c005437ff764585cee6d496ec0a';

/// Provider for tasks filtered by parent ID

final class TaskByParentFamily extends $Family
    with $FunctionalFamilyOverride<List<TaskModel>, String> {
  const TaskByParentFamily._()
    : super(
        retry: null,
        name: r'taskByParentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for tasks filtered by parent ID

  TaskByParentProvider call(String parentId) =>
      TaskByParentProvider._(argument: parentId, from: this);

  @override
  String toString() => r'taskByParentProvider';
}

/// Provider for list of users assigned to a task

@ProviderFor(listOfUsersByTaskId)
const listOfUsersByTaskIdProvider = ListOfUsersByTaskIdFamily._();

/// Provider for list of users assigned to a task

final class ListOfUsersByTaskIdProvider
    extends $FunctionalProvider<List<String>, List<String>, List<String>>
    with $Provider<List<String>> {
  /// Provider for list of users assigned to a task
  const ListOfUsersByTaskIdProvider._({
    required ListOfUsersByTaskIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'listOfUsersByTaskIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$listOfUsersByTaskIdHash();

  @override
  String toString() {
    return r'listOfUsersByTaskIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<String> create(Ref ref) {
    final argument = this.argument as String;
    return listOfUsersByTaskId(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ListOfUsersByTaskIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$listOfUsersByTaskIdHash() =>
    r'accd80202f99add661be3bad380a81d21c37babf';

/// Provider for list of users assigned to a task

final class ListOfUsersByTaskIdFamily extends $Family
    with $FunctionalFamilyOverride<List<String>, String> {
  const ListOfUsersByTaskIdFamily._()
    : super(
        retry: null,
        name: r'listOfUsersByTaskIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for list of users assigned to a task

  ListOfUsersByTaskIdProvider call(String taskId) =>
      ListOfUsersByTaskIdProvider._(argument: taskId, from: this);

  @override
  String toString() => r'listOfUsersByTaskIdProvider';
}

/// Provider for task focus management

@ProviderFor(TaskFocus)
const taskFocusProvider = TaskFocusProvider._();

/// Provider for task focus management
final class TaskFocusProvider extends $NotifierProvider<TaskFocus, String?> {
  /// Provider for task focus management
  const TaskFocusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskFocusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskFocusHash();

  @$internal
  @override
  TaskFocus create() => TaskFocus();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$taskFocusHash() => r'd251c36c1f7a0197a6e575113cd6b99bc5df17bb';

/// Provider for task focus management

abstract class _$TaskFocus extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for completed tasks count (filtered by membership)

@ProviderFor(completedTasksCount)
const completedTasksCountProvider = CompletedTasksCountProvider._();

/// Provider for completed tasks count (filtered by membership)

final class CompletedTasksCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Provider for completed tasks count (filtered by membership)
  const CompletedTasksCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'completedTasksCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$completedTasksCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return completedTasksCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$completedTasksCountHash() =>
    r'8d258a957df0e97f90b8822d13a21d1bb9bb00c7';

/// Provider for tasks due today count

@ProviderFor(tasksDueTodayCount)
const tasksDueTodayCountProvider = TasksDueTodayCountProvider._();

/// Provider for tasks due today count

final class TasksDueTodayCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Provider for tasks due today count
  const TasksDueTodayCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tasksDueTodayCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tasksDueTodayCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return tasksDueTodayCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$tasksDueTodayCountHash() =>
    r'df4c44cb2699bcae846c05363e23e5ced64abe00';

/// Provider for overdue tasks count (filtered by membership)

@ProviderFor(overdueTasksCount)
const overdueTasksCountProvider = OverdueTasksCountProvider._();

/// Provider for overdue tasks count (filtered by membership)

final class OverdueTasksCountProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Provider for overdue tasks count (filtered by membership)
  const OverdueTasksCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overdueTasksCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overdueTasksCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return overdueTasksCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$overdueTasksCountHash() => r'94c8260f83dccf3bcc233a7a48fb34f5c87beca0';
