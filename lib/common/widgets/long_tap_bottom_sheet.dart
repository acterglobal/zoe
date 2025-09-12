import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/option_button_widget.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/list/models/list_model.dart';
import 'package:zoe/features/sheet/actions/delete_sheet.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/content/providers/content_providers.dart';
import 'package:zoe/features/content/providers/content_menu_providers.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import 'package:zoe/features/text/providers/text_providers.dart';
import 'package:zoe/features/events/providers/events_proivder.dart';
import 'package:zoe/features/list/providers/list_providers.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/link/providers/link_providers.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

void showLongTapBottomSheet(
  BuildContext context, {
  String? contentId,
  String? sheetId,
  bool isDetailScreen = false,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => LongTapBottomSheetWidget(
      contentId: contentId,
      sheetId: sheetId,
      isDetailScreen: isDetailScreen,
    ),
  );
}

class LongTapBottomSheetWidget extends ConsumerWidget {
  final String? contentId;
  final String? sheetId;
  final bool isDetailScreen;

  const LongTapBottomSheetWidget({
    super.key,
    this.contentId,
    this.sheetId,
    this.isDetailScreen = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    // Determine if we're working with content or sheet
    if (contentId != null) {
      return _buildContentBottomSheet(context, ref, theme, l10n);
    } else if (sheetId != null) {
      return _buildSheetBottomSheet(context, ref, theme, l10n);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildContentBottomSheet(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    L10n l10n,
  ) {
    // Get content from provider
    final content = ref.watch(contentProvider(contentId!));
    if (content == null) return const SizedBox.shrink();

    return _buildBottomSheetContent(
      context,
      theme,
      l10n,
      title: _getContentTypeDisplayName(content.type, l10n, content),
      subtitle: content.title.isNotEmpty ? content.title : l10n.untitled,
      editIcon: _getContentTypeIcon(content.type, content),
      editTitle: _getEditContentTitle(content.type, l10n, content),
      onEdit: () {
        Navigator.of(context).pop();
        _handleEditContent(ref, content);
      },
      onCopy: () {
        Navigator.of(context).pop();
        _handleCopyTitle(context, content.title, l10n);
      },
      onDelete: () {
        Navigator.of(context).pop();
        _handleDeleteContent(context, ref, content);
      },
    );
  }

  Widget _buildSheetBottomSheet(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    L10n l10n,
  ) {
    // Get sheet from provider
    final sheet = ref.watch(sheetProvider(sheetId!));
    if (sheet == null) return const SizedBox.shrink();

    return _buildBottomSheetContent(
      context,
      theme,
      l10n,
      title: l10n.sheet,
      subtitle: sheet.title.isNotEmpty ? sheet.title : l10n.untitled,
      editIcon: Icons.edit_rounded,
      editTitle: l10n.editSheet,
      onEdit: () {
        Navigator.of(context).pop();
        _handleEditSheet(ref, sheet);
      },
      onCopy: () {
        Navigator.of(context).pop();
        _handleCopyTitle(context, sheet.title, l10n);
      },
      onDelete: () {
        Navigator.of(context).pop();
        _handleDeleteSheet(context, ref, sheet);
      },
    );
  }

  Widget _buildBottomSheetContent(
    BuildContext context,
    ThemeData theme,
    L10n l10n, {
    required String title,
    required String subtitle,
    required IconData editIcon,
    required String editTitle,
    required VoidCallback onEdit,
    required VoidCallback onCopy,
    required VoidCallback onDelete,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 32),

          // Edit
          OptionButtonWidget(
            icon: editIcon,
            title: editTitle,
            subtitle: sheetId != null
                ? l10n.editSheetSubtitle
                : l10n.editContentSubtitle,
            color: theme.colorScheme.primary,
            onTap: onEdit,
          ),
          const SizedBox(height: 16),

          // Copy Title
          OptionButtonWidget(
            icon: Icons.copy_rounded,
            title: l10n.copyTitle,
            subtitle: l10n.copyTitleSubtitle,
            color: theme.colorScheme.secondary,
            onTap: onCopy,
          ),
          const SizedBox(height: 16),

          // Delete
          OptionButtonWidget(
            icon: Icons.delete_rounded,
            title: sheetId != null
                ? l10n.deleteSheetButton
                : l10n.deleteContent,
            subtitle: sheetId != null
                ? l10n.deleteSheetSubtitle
                : l10n.deleteContentSubtitle,
            color: theme.colorScheme.error,
            onTap: onDelete,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  String _getContentTypeDisplayName(
    ContentType type,
    L10n l10n, [
    ContentModel? content,
  ]) {
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

  IconData _getContentTypeIcon(ContentType type, [ContentModel? content]) {
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

  String _getEditContentTitle(
    ContentType type,
    L10n l10n, [
    ContentModel? content,
  ]) {
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

  /// Handle edit content action - activate edit mode
  void _handleEditContent(WidgetRef ref, ContentModel content) {
    ref.read(editContentIdProvider.notifier).state = content.id;
  }

  /// Handle copy title action - copy to clipboard and show feedback
  void _handleCopyTitle(BuildContext context, String title, L10n l10n) {
    if (title.isEmpty) return;
    Clipboard.setData(ClipboardData(text: title));
    CommonUtils.showSnackBar(context, l10n.copyTitleToClipboard);
  }

  /// Handle delete content action - delete from appropriate provider
  void _handleDeleteContent(
    BuildContext context,
    WidgetRef ref,
    ContentModel content,
  ) {
    switch (content.type) {
      case ContentType.text:
        ref.read(textListProvider.notifier).deleteText(content.id);
        break;
      case ContentType.event:
        ref.read(eventListProvider.notifier).deleteEvent(content.id);
        break;
      case ContentType.list:
        ref.read(listsrovider.notifier).deleteList(content.id);
        break;
      case ContentType.task:
        ref.read(taskListProvider.notifier).deleteTask(content.id);
        break;
      case ContentType.bullet:
        ref.read(bulletListProvider.notifier).deleteBullet(content.id);
        break;
      case ContentType.link:
        ref.read(linkListProvider.notifier).deleteLink(content.id);
        break;
      case ContentType.document:
        ref.read(documentListProvider.notifier).deleteDocument(content.id);
        break;
      case ContentType.poll:
        ref.read(pollListProvider.notifier).deletePoll(content.id);
        break;
    }

    if (isDetailScreen) Navigator.of(context).pop();
    // Clear edit mode if this content was being edited
    final editContentId = ref.read(editContentIdProvider);
    if (editContentId == content.id) {
      ref.read(editContentIdProvider.notifier).state = null;
    }
  }

  /// Handle edit sheet action - activate edit mode
  void _handleEditSheet(WidgetRef ref, SheetModel sheet) {
    ref.read(editContentIdProvider.notifier).state = sheet.id;
  }

  /// Handle delete sheet action - delete from sheet provider
  void _handleDeleteSheet(
    BuildContext context,
    WidgetRef ref,
    SheetModel sheet,
  ) {
    showDeleteSheetConfirmation(context, ref, sheet.id);
    // Clear edit mode if this sheet was being edited
    final editContentId = ref.read(editContentIdProvider);
    if (editContentId == sheet.id) {
      ref.read(editContentIdProvider.notifier).state = null;
    }
  }
}
