import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/models/base_content_model.dart';
import 'package:zoey/features/content/providers/content_list_providers.dart';
import 'package:zoey/features/events/widgets/event_widget.dart';
import 'package:zoey/features/list/widgets/list_widget.dart';
import 'package:zoey/features/text/widgets/text_content_widget.dart';

class ContentWidget extends ConsumerWidget {
  final String sheetId;
  const ContentWidget({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Watch the content list provider
    final contentList = ref.watch(contentBySheetIdProvider(sheetId));
    if (contentList.isEmpty) return const SizedBox.shrink();

    /// Build the content list
    return ListView.builder(
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
    );
  }
}
