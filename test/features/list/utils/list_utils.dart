import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/list/models/list_model.dart';
import 'package:zoe/features/list/providers/list_providers.dart';

ListModel getListByIndex(ProviderContainer container, {int index = 0}) {
  final listList = container.read(listsProvider);
  if (listList.isEmpty) fail('List list is empty');
  if (index < 0 || index >= listList.length) {
    fail('List index is out of bounds');
  }
  return listList[index];
}

