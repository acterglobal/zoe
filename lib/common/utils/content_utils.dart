import 'package:flutter/material.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/list/models/list_model.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class ContentUtils {
  static String getContentTypeDisplayTitle({
    required BuildContext context,
    required ContentType type,
    ContentModel? content,
  }) {
    final l10n = L10n.of(context);

    switch (type) {
      case ContentType.text:
        return l10n.text;
      case ContentType.event:
        return l10n.event;
      case ContentType.list:
        if (content is ListModel) {
          if (content.listType == ContentType.task) {
            return l10n.taskList;
          } else if (content.listType == ContentType.bullet) {
            return l10n.bulletList;
          } else if (content.listType == ContentType.document) {
            return l10n.documentList;
          }
        }
        return l10n.list;
      case ContentType.task:
        return l10n.task;
      case ContentType.bullet:
        return l10n.bullet;
      case ContentType.link:
        return l10n.link;
      case ContentType.document:
        return l10n.document;
      case ContentType.poll:
        return l10n.poll;
    }
  }

  static IconData getContentTypeIcon({
    required BuildContext context,
    required ContentType type,
    ContentModel? content,
  }) {
    switch (type) {
      case ContentType.text:
        return Icons.text_fields_rounded;
      case ContentType.event:
        return Icons.event_rounded;
      case ContentType.list:
        if (content is ListModel) {
          if (content.listType == ContentType.task) {
            return Icons.task_alt_rounded;
          } else if (content.listType == ContentType.bullet) {
            return Icons.format_list_bulleted_rounded;
          } else if (content.listType == ContentType.document) {
            return Icons.description_rounded;
          }
        }
        return Icons.list_rounded;
      case ContentType.task:
        return Icons.task_alt_rounded;
      case ContentType.bullet:
        return Icons.format_list_bulleted_rounded;
      case ContentType.link:
        return Icons.link_rounded;
      case ContentType.document:
        return Icons.description_rounded;
      case ContentType.poll:
        return Icons.poll_rounded;
    }
  }

  static String getEditContentTitle({
    required BuildContext context,
    required ContentType type,
    ContentModel? content,
  }) {
    final l10n = L10n.of(context);

    switch (type) {
      case ContentType.text:
        return l10n.editText;
      case ContentType.event:
        return l10n.editEvent;
      case ContentType.list:
        if (content is ListModel) {
          if (content.listType == ContentType.task) {
            return l10n.editTaskList;
          } else if (content.listType == ContentType.bullet) {
            return l10n.editBulletList;
          } else if (content.listType == ContentType.document) {
            return l10n.editDocumentList;
          }
        }
        return l10n.editList;
      case ContentType.task:
        return l10n.editTask;
      case ContentType.bullet:
        return l10n.editBullet;
      case ContentType.link:
        return l10n.editLink;
      case ContentType.document:
        return l10n.editDocument;
      case ContentType.poll:
        return l10n.editPoll;
    }
  }
}
