import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/contents/todos/data/todos_content_list.dart';
import 'package:zoey/features/contents/todos/models/todos_content_model.dart';

final todosContentItemProvider = Provider.family<TodosContentModel, String>((
  ref,
  String id,
) {
  return todosContentList.firstWhere((element) => element.id == id);
});
