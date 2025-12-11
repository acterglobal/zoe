import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/text/models/text_model.dart';
import 'package:zoe/features/text/providers/text_providers.dart';

TextModel getTextByIndex(ProviderContainer container, {int index = 0}) {
  final textList = container.read(textListProvider);
  if (textList.isEmpty) fail('Text list is empty');
  if (index < 0 || index >= textList.length) {
    fail('Text index is out of bounds');
  }
  return textList[index];
}
