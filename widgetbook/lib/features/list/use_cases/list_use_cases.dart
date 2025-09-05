import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/features/home/zoe_preview_widget.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/list/models/list_model.dart';
import 'package:zoe/features/list/screens/list_details_screen.dart';
import '../mock_list_providers.dart';

@widgetbook.UseCase(name: 'List Details Screen', type: ListDetailsScreen)
Widget buildListDetailsScreenUseCase(BuildContext context) {
  final listId = context.knobs.string(
    label: 'List ID',
    initialValue: 'list-1',
  );

  final title = context.knobs.string(
    label: 'List Title',
    initialValue: 'Sample List',
  );

  final emoji = context.knobs.string(
    label: 'List Emoji',
    initialValue: '📝',
  );

  final description = context.knobs.string(
    label: 'List Description',
    initialValue: 'This is a sample list description',
  );

  final listType = context.knobs.object.dropdown(
    label: 'List Type',
    options: ContentType.values,
    initialOption: ContentType.text,
    labelBuilder: (type) => type.name,
  );

  final orderIndex = context.knobs.int.slider(
    label: 'Order Index',
    min: 0,
    max: 10,
    initialValue: 0,
  );

  final list = ListModel(
    id: listId,
    title: title,
    emoji: emoji,
    description: (plainText: description, htmlText: description),
    listType: listType,
    orderIndex: orderIndex,
    parentId: 'sheet-1',
    sheetId: 'sheet-1',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  return ProviderScope(
    overrides: [
      mockListsProvider.overrideWith(
        (ref) => MockListNotifier(ref)..setLists([list]),
      ),
    ],
    child: ZoePreview(child: ListDetailsScreen(listId: listId)),
  );
}
