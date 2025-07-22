import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/models/base_content_model.dart';
import 'package:zoey/features/content/providers/content_list_providers.dart';
import 'package:zoey/features/content/providers/content_menu_providers.dart';
import 'package:zoey/features/content/utils/content_utils.dart';
import 'package:zoey/features/content/widgets/add_content_widget.dart';
import 'package:zoey/features/events/widgets/event_widget.dart';
import 'package:zoey/features/list/widgets/list_widget.dart';
import 'package:zoey/features/text/widgets/text_content_widget.dart';

class ContentWidget extends ConsumerWidget {
  final String parentId;
  final String sheetId;
  const ContentWidget({
    super.key,
    required this.parentId,
    required this.sheetId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Watch the content list provider
    final contentList = ref.watch(contentByParentIdProvider(parentId));

    /// Build the content list
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: contentList.length,
          itemBuilder: (context, index) {
            final contentId = contentList[index].id;
            return switch (contentList[index].type) {
              ContentType.text => TextContentWidget(textContentId: contentId),
              ContentType.event => EventWidget(eventsId: contentId),
              ContentType.list => ListWidget(listId: contentId),
            };
          },
        ),
        AddContentWidget(
          isEditing: ref.watch(toogleContentEditProvider),
          onTapText: () => addNewTextContent(ref, parentId, sheetId),
          onTapEvent: () => addNewEventContent(ref, parentId, sheetId),
          onTapBulletedList: () =>
              addNewBulletedListContent(ref, parentId, sheetId),
          onTapToDoList: () => addNewTaskListContent(ref, parentId, sheetId),
        ),
        const SizedBox(height: 200),
      ],
    );
  }
}
