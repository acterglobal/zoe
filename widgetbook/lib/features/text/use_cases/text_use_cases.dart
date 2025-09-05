import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/features/home/zoe_preview_widget.dart';
import 'package:zoe/features/text/models/text_model.dart';
import 'package:zoe/features/text/screens/text_block_details_screen.dart';
import '../mock_text_providers.dart';

@widgetbook.UseCase(name: 'Text Block Details Screen', type: TextBlockDetailsScreen)
Widget buildTextBlockDetailsScreenUseCase(BuildContext context) {
  final textBlockId = context.knobs.string(
    label: 'Text Block ID',
    initialValue: 'text-1',
  );

  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Sample Text Block',
  );

  final content = context.knobs.string(
    label: 'Content',
    initialValue: 'This is a sample text block content.',
  );

  final emoji = context.knobs.string(
    label: 'Emoji',
    initialValue: '📝',
  );

  final textBlock = TextModel(
    id: textBlockId,
    title: title,
          description: (plainText: content, htmlText: content),
    emoji: emoji,
    parentId: 'list-1',
    sheetId: 'sheet-1',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  return ProviderScope(
    overrides: [
      mockTextListProvider.overrideWith((ref) => MockTextNotifier(ref)..setTexts([textBlock])),
    ],
    child: ZoePreview(
      child: TextBlockDetailsScreen(textBlockId: textBlockId),
    ),
  );
}

@widgetbook.UseCase(name: 'Text Block List', type: Widget)
Widget buildTextBlockListUseCase(BuildContext context) {
  final parentId = context.knobs.string(
    label: 'Parent ID',
    initialValue: 'list-1',
  );

  final textCount = context.knobs.int.input(
    label: 'Number of Text Blocks',
    initialValue: 3,
  );

  final texts = List.generate(textCount, (index) {
    return TextModel(
      id: 'text-$index',
      title: context.knobs.string(
        label: 'Text ${index + 1} Title',
        initialValue: 'Text Block ${index + 1}',
      ),
      description: (
        plainText: context.knobs.string(
          label: 'Text ${index + 1} Content',
          initialValue: 'This is text block ${index + 1} content.',
        ),
        htmlText: context.knobs.string(
          label: 'Text ${index + 1} HTML Content',
          initialValue: 'This is text block ${index + 1} content.',
        ),
      ),
      emoji: context.knobs.string(
        label: 'Text ${index + 1} Emoji',
        initialValue: '📝',
      ),
      parentId: parentId,
      sheetId: 'sheet-1',
      createdAt: DateTime.now().subtract(Duration(days: index)),
      updatedAt: DateTime.now(),
    );
  });

  return ProviderScope(
    overrides: [
      mockTextListProvider.overrideWith((ref) => MockTextNotifier(ref)..setTexts(texts)),
    ],
    child: ZoePreview(
      child: Column(
        children: [
          Text('Text Blocks', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Consumer(
            builder: (context, ref, _) {
              final textBlocks = ref.watch(mockTextByParentProvider(parentId));
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: textBlocks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final text = textBlocks[index];
                  return ListTile(
                    leading: Text(text.emoji ?? '📝'),
                    title: Text(text.title),
                    subtitle: Text(text.description?.plainText ?? ''),
                    onTap: () {},
                  );
                },
              );
            },
          ),
        ],
      ),
    ),
  );
}
