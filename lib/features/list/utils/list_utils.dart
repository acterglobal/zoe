import 'package:flutter/material.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class ListUtils {
  static String getListType(BuildContext context, ContentType listType) {
    switch (listType) {
      case ContentType.bullet:
        return L10n.of(context).bulletList;
      case ContentType.task:
        return L10n.of(context).taskList;
      case ContentType.document:
        return L10n.of(context).documentList;
      case ContentType.text:
      case ContentType.event:
      case ContentType.link:
      case ContentType.poll:
      case ContentType.list:
        return L10n.of(context).list;
    }
  }
}
