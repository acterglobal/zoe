import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/link/models/link_model.dart';
import 'package:zoe/features/link/providers/link_providers.dart';

LinkModel getLinkByIndex(ProviderContainer container, {int index = 0}) {
  final linkList = container.read(linkListProvider);
  if (linkList.isEmpty) fail('Link list is empty');
  if (index < 0 || index >= linkList.length) {
    fail('Link index is out of bounds');
  }
  return linkList[index];
}

