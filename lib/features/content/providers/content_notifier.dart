import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/models/content_model.dart';
import 'package:zoey/features/text/data/text_list.dart';
import 'package:zoey/features/events/data/event_list.dart';
import 'package:zoey/features/list/data/lists.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';
import 'package:zoey/features/text/models/text_model.dart';
import 'package:zoey/features/events/models/events_model.dart';
import 'package:zoey/features/list/models/list_model.dart';

class ContentListNotifier extends StateNotifier<List<ContentModel>> {
  ContentListNotifier() : super([]) {
    _loadAllContent();
  }

  void _loadAllContent() {
    final allContent = <ContentModel>[...textList, ...eventList, ...lists];
    state = allContent;
  }

  void addContent(ContentModel content) {
    state = [...state, content];
  }

  void deleteContent(String contentId) {
    state = state.where((c) => c.id != contentId).toList();
  }

  void updateContentTitle(String contentId, String title) {
    state = [
      for (final content in state)
        if (content.id == contentId)
          _copyWithTitle(content, title)
        else
          content,
    ];
  }

  void updateContentDescription(String contentId, Description description) {
    state = [
      for (final content in state)
        if (content.id == contentId)
          _copyWithDescription(content, description)
        else
          content,
    ];
  }

  void updateContentEmoji(String contentId, String emoji) {
    state = [
      for (final content in state)
        if (content.id == contentId)
          _copyWithEmoji(content, emoji)
        else
          content,
    ];
  }

  ContentModel _copyWithTitle(ContentModel content, String title) {
    switch (content.type) {
      case ContentType.text:
        return (content as TextModel).copyWith(title: title);
      case ContentType.event:
        return (content as EventModel).copyWith(title: title);
      case ContentType.list:
        return (content as ListModel).copyWith(title: title);
    }
  }

  ContentModel _copyWithDescription(
    ContentModel content,
    Description description,
  ) {
    switch (content.type) {
      case ContentType.text:
        return (content as TextModel).copyWith(description: description);
      case ContentType.event:
        return (content as EventModel).copyWith(description: description);
      case ContentType.list:
        return (content as ListModel).copyWith(description: description);
    }
  }

  ContentModel _copyWithEmoji(ContentModel content, String emoji) {
    switch (content.type) {
      case ContentType.text:
        return (content as TextModel).copyWith(emoji: emoji);
      case ContentType.event:
        return (content as EventModel).copyWith(emoji: emoji);
      case ContentType.list:
        return (content as ListModel).copyWith(emoji: emoji);
    }
  }
}
