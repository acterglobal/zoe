import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/features/home/zoe_preview_widget.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/screens/sheet_list_screen.dart';
import 'package:zoe/features/sheet/widgets/sheet_list_widget.dart';
import '../mock_sheet_providers.dart';

@widgetbook.UseCase(name: 'Sheet List Screen', type: SheetListScreen)
Widget buildSheetListScreenUseCase(BuildContext context) {
  final sheetCount = context.knobs.int.input(
    label: 'Number of Sheets',
    initialValue: 3,
    description: 'Number of sheets to display',
  );

  final sheets = List.generate(sheetCount, (index) {
    return SheetModel(
      id: 'sheet-$index',
      title: context.knobs.string(
        label: 'Sheet ${index + 1} Title',
        initialValue: 'Sheet ${index + 1}',
        description: 'Title for sheet ${index + 1}',
      ),
      emoji: context.knobs.string(
        label: 'Sheet ${index + 1} Emoji',
        initialValue: '📄',
        description: 'Emoji for sheet ${index + 1}',
      ),
      description: (
        plainText: context.knobs.string(
          label: 'Sheet ${index + 1} Description',
          initialValue: 'Description for sheet ${index + 1}',
          description: 'Description for sheet ${index + 1}',
        ),
        htmlText: context.knobs.string(
          label: 'Sheet ${index + 1} HTML Description',
          initialValue: 'Description for sheet ${index + 1}',
          description: 'HTML Description for sheet ${index + 1}',
        ),
      ),
      createdBy: 'user-1',
      users: ['user-1', 'user-2'],
      createdAt: DateTime.now().subtract(Duration(days: index)),
      updatedAt: DateTime.now(),
    );
  });

  return ProviderScope(
    overrides: [
      mockSheetListProvider.overrideWith(
        (ref) => MockSheetNotifier(ref)..setSheets(sheets),
      ),
    ],
    child: ZoePreview(child: SheetListScreen()),
  );
}

@widgetbook.UseCase(name: 'Sheet List Widget', type: SheetListWidget)
Widget buildSheetListWidgetUseCase(BuildContext context) {
  final sheetCount = context.knobs.int.input(
    label: 'Number of Sheets',
    initialValue: 3,
    description: 'Number of sheets to display',
  );

  final shrinkWrap = context.knobs.boolean(
    label: 'Shrink Wrap',
    initialValue: true,
  );

  final isCompact = context.knobs.boolean(
    label: 'Is Compact',
    initialValue: false,
  );

  final maxItems = context.knobs.int.slider(
    label: 'Max Items',
    initialValue: 3,
    min: 1,
    max: 10,
  );

  final sheets = List.generate(sheetCount, (index) {
    return SheetModel(
      id: 'sheet-$index',
      title: context.knobs.string(
        label: 'Sheet ${index + 1} Title',
        initialValue: 'Sheet ${index + 1}',
        description: 'Title for sheet ${index + 1}',
      ),
      emoji: context.knobs.string(
        label: 'Sheet ${index + 1} Emoji',
        initialValue: '📄',
        description: 'Emoji for sheet ${index + 1}',
      ),
      description: (
        plainText: context.knobs.string(
          label: 'Sheet ${index + 1} Description',
          initialValue: 'Description for sheet ${index + 1}',
          description: 'Description for sheet ${index + 1}',
        ),
        htmlText: context.knobs.string(
          label: 'Sheet ${index + 1} HTML Description',
          initialValue: 'Description for sheet ${index + 1}',
          description: 'HTML Description for sheet ${index + 1}',
        ),
      ),
      createdBy: 'user-1',
      users: ['user-1', 'user-2'],
      createdAt: DateTime.now().subtract(Duration(days: index)),
      updatedAt: DateTime.now(),
    );
  });

  return ProviderScope(
    overrides: [
      mockSheetListProvider.overrideWith(
        (ref) => MockSheetNotifier(ref)..setSheets(sheets),
      ),
    ],
    child: ZoePreview(
      child: SheetListWidget(
        shrinkWrap: shrinkWrap,
        isCompact: isCompact,
        maxItems: maxItems,
      ),
    ),
  );
}
