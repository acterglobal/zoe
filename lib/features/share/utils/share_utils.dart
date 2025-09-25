import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/utils/date_time_utils.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/features/list/providers/list_providers.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/text/providers/text_providers.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

class ShareUtils {
  static final String _linkPrefixUrl = 'https://hellozoe.app';

  static String getLinkPrefixUrl(String endpoint) {
    return '🔗 $_linkPrefixUrl/$endpoint';
  }

  // Sheet
  static String getSheetShareMessage({
    required WidgetRef ref,
    required String parentId,
  }) {
    final buffer = StringBuffer();
    final sheet = ref.watch(sheetProvider(parentId));
    if (sheet == null) return buffer.toString();

    final emoji = sheet.emoji;
    final title = sheet.title;
    final description = sheet.description?.plainText;

    // Emoji and title
    buffer.write('$emoji $title');

    // Description
    if (description != null && description.isNotEmpty) {
      buffer.write('\n\n$description');
    }

    // Link
    final link = getLinkPrefixUrl('sheet/$parentId');
    buffer.write('\n\n$link');
    return buffer.toString();
  }

  // Text
  static String getTextContentShareMessage({
    required WidgetRef ref,
    required String parentId,
  }) {
    final buffer = StringBuffer();
    final textModel = ref.watch(textProvider(parentId));
    if (textModel == null) return buffer.toString();

    final emoji = textModel.emoji;
    final title = textModel.title;
    final description = textModel.description?.plainText;

    // Emoji
    if (emoji != null) buffer.write('$emoji ');

    // Title
    buffer.write(title);

    // Description
    if (description != null && description.isNotEmpty) {
      buffer.write('\n\n$description');
    }

    // Link
    final link = getLinkPrefixUrl('text-block/$parentId');
    buffer.write('\n\n$link');
    return buffer.toString();
  }

  // Event
  static String getEventContentShareMessage({
    required WidgetRef ref,
    required String parentId,
  }) {
    final buffer = StringBuffer();
    final eventModel = ref.watch(eventProvider(parentId));
    if (eventModel == null) return buffer.toString();

    final emoji = eventModel.emoji;
    final title = eventModel.title;
    final description = eventModel.description?.plainText;
    final startDate = eventModel.startDate;
    final endDate = eventModel.endDate;

    // Emoji
    if (emoji != null) buffer.write('$emoji ');

    // Title
    buffer.write(title);

    // Description
    if (description != null && description.isNotEmpty) {
      buffer.write('\n\n$description');
    }

    // Start date
    final startDateString = DateTimeUtils.formatDateTime(startDate);
    buffer.write('\n\n🕓 Start\n$startDateString');
    
    // End date
    final endDateString = DateTimeUtils.formatDateTime(endDate);
    buffer.write('\n\n🕓 End\n$endDateString');

    // Link
    final link = getLinkPrefixUrl('event/$parentId');
    buffer.write('\n\n$link');
    return buffer.toString();
  }

  // List
  static String getListContentShareMessage({
    required WidgetRef ref,
    required String parentId,
  }) {
    final buffer = StringBuffer();
    final listModel = ref.watch(listItemProvider(parentId));
    if (listModel == null) return buffer.toString();

    final emoji = listModel.emoji;
    final title = listModel.title;
    final description = listModel.description?.plainText;

    // Emoji
    if (emoji != null) buffer.write('$emoji ');

    // Title
    buffer.write(title);

    // Description
    if (description != null && description.isNotEmpty) {
      buffer.write('\n\n$description');
    }

    switch (listModel.listType) {
      case ContentType.task:
        final tasks = ref.watch(taskByParentProvider(listModel.id));
        if (tasks.isNotEmpty) buffer.write('\n');
        for (final task in tasks) {
          buffer.write('\n☑️ ${task.title}');
        }
        break;
      case ContentType.bullet:
        final bullets = ref.watch(bulletListByParentProvider(listModel.id));
        if (bullets.isNotEmpty) buffer.write('\n');
        for (final bullet in bullets) {
          buffer.write('\n🔹 ${bullet.title}');
        }
        break;
      default:
        break;
    }

    // Link
    final link = getLinkPrefixUrl('list/$parentId');
    buffer.write('\n\n$link');
    return buffer.toString();
  }

  // Task
  static String getTaskContentShareMessage({
    required WidgetRef ref,
    required String parentId,
  }) {
    final buffer = StringBuffer();
    final taskModel = ref.watch(taskProvider(parentId));
    if (taskModel == null) return buffer.toString();

    final emoji = taskModel.emoji ?? '💻';
    final title = taskModel.title;
    final description = taskModel.description?.plainText;
    final dueDate = taskModel.dueDate;
    final assignedUsers = taskModel.assignedUsers;

    // Emoji and title
    buffer.write('$emoji $title');

    // Description
    if (description != null && description.isNotEmpty) {
      buffer.write('\n\n$description');
    }

    // Due date
    final dueDateString = DateTimeUtils.formatDate(dueDate);
    buffer.write('\n\n🕒 Due: $dueDateString');

    // Assigned users
    if (assignedUsers.isNotEmpty) {
      final users = assignedUsers.map((userId) {
        final user = ref.watch(getUserByIdProvider(userId));
        return user?.name ?? '';
      }).toList();
      buffer.write('\n\n👥 Assigned: ${users.join(', ')}');
    }

    // Link
    final link = getLinkPrefixUrl('task/$parentId');
    buffer.write('\n\n$link');
    return buffer.toString();
  }

  // Bullet
  static String getBulletContentShareMessage({
    required WidgetRef ref,
    required String parentId,
  }) {
    final buffer = StringBuffer();
    final bulletModel = ref.watch(bulletProvider(parentId));
    if (bulletModel == null) return buffer.toString();

    final emoji = bulletModel.emoji ?? '🔹';
    final title = bulletModel.title;
    final description = bulletModel.description?.plainText;

    // Emoji and title
    buffer.write('$emoji $title');

    // Description
    if (description != null && description.isNotEmpty) {
      buffer.write('\n\n$description');
    }

    // Link
    final link = getLinkPrefixUrl('bullet/$parentId');
    buffer.write('\n\n$link');
    return buffer.toString();
  }

  // Poll
  static String getPollContentShareMessage({
    required WidgetRef ref,
    required String parentId,
  }) {
    final buffer = StringBuffer();
    final pollModel = ref.watch(pollProvider(parentId));
    if (pollModel == null) return buffer.toString();
    final emoji = pollModel.emoji;
    final title = pollModel.title;
    final options = pollModel.options;

    // Emoji
    if (emoji != null) buffer.write('$emoji ');

    // Title
    buffer.write(title);

    // Poll options
    buffer.write('\n\n${options.map((e) => '🔘 ${e.title}').join('\n')}');

    // Link
    final link = getLinkPrefixUrl('poll/$parentId');
    buffer.write('\n\n$link');
    return buffer.toString();
  }
}
