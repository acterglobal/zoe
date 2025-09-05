import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/features/home/zoe_preview_widget.dart';
import 'package:zoe/features/link/models/link_model.dart';
import 'package:zoe/features/link/screens/links_list_screen.dart';
import 'package:zoe/features/link/widgets/link_list_widget.dart';
import 'package:zoe/features/link/widgets/link_widget.dart';
import '../mock_link_providers.dart';

@widgetbook.UseCase(name: 'Link List Screen', type: LinkListWidget)
Widget buildLinkListScreenUseCase(BuildContext context) {
  final linkCount = context.knobs.int.input(
    label: 'Number of Links',
    initialValue: 3,
  );

  final isEditing = context.knobs.boolean(
    label: 'Is Editing',
    initialValue: false,
  );

  final maxItems = context.knobs.int.input(
    label: 'Max Items',
    initialValue: 3,
  );

  final links = List.generate(linkCount, (index) {
    return LinkModel(
      id: 'link-$index',
      title: context.knobs.string(
        label: 'Link ${index + 1} Title',
        initialValue: 'Link ${index + 1}',
      ),
      url: context.knobs.string(
        label: 'Link ${index + 1} URL',
        initialValue: 'https://example.com/${index + 1}',
      ),
      parentId: 'list-1',
      sheetId: 'sheet-1',
      createdAt: DateTime.now().subtract(Duration(days: index)),
      updatedAt: DateTime.now(),
    );
  });

  return ProviderScope(
    overrides: [
      mockLinkListProvider.overrideWith((ref) => MockLinkNotifier()..setLinks(links)),
    ],
    child: ZoePreview(
      child: LinkListWidget(
        linksProvider: mockLinkListProvider,
        isEditing: isEditing,
        shrinkWrap: true,
        maxItems: maxItems,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Link Widget', type: LinkWidget)
Widget buildLinkWidgetUseCase(BuildContext context) {
  final linkId = context.knobs.string(
    label: 'Link ID',
    initialValue: 'link-1',
  );

  final link = LinkModel(
    id: linkId,
    title: context.knobs.string(
      label: 'Link Title',
      initialValue: 'Sample Link',
    ),
    url: context.knobs.string(
      label: 'Link URL',
      initialValue: 'https://example.com',
    ),
    parentId: 'list-1',
    sheetId: 'sheet-1',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  return ProviderScope(
    overrides: [
      mockLinkListProvider.overrideWith((ref) => MockLinkNotifier()..setLinks([link])),
    ],
    child: ZoePreview(
      child: LinkWidget(
        linkId: linkId,
        isEditing: context.knobs.boolean(
          label: 'Is Editing',
          initialValue: false,
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Links List Screen', type: LinksListScreen)
Widget buildLinksListScreenUseCase(BuildContext context) {
  final links = List.generate(5, (index) {
    return LinkModel(
      id: 'link-$index',
      title: 'Link ${index + 1}',
      url: 'https://example.com/${index + 1}',
      parentId: 'list-1',
      sheetId: 'sheet-1',
      createdAt: DateTime.now().subtract(Duration(days: index)),
      updatedAt: DateTime.now(),
    );
  });

  return ProviderScope(
    overrides: [
      mockLinkListProvider.overrideWith((ref) => MockLinkNotifier()..setLinks(links)),
    ],
    child: ZoePreview(
      child: LinksListScreen(),
    ),
  );
}
