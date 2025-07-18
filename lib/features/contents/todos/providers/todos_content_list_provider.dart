import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/contents/todos/data/todos_content_list.dart';
import 'package:zoey/features/contents/todos/models/todos_content_model.dart';

final todosContentListProvider = Provider<List<TodosContentModel>>((ref) {
  return todosContentList;
});
