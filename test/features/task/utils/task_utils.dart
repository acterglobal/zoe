import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/task/models/task_model.dart';

TaskModel getTaskByIndex(ProviderContainer container, {int index = 0}) {
  final taskList = container.read(taskListProvider);
  if (taskList.isEmpty) fail('Task list is empty');
  if (index < 0 || index >= taskList.length) {
    fail('Task index is out of bounds');
  }
  return taskList[index];
}
