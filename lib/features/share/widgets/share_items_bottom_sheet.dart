import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/content/providers/content_providers.dart';
import 'package:zoe/features/list/providers/list_providers.dart';
import 'package:zoe/features/share/utils/share_utils.dart';
import 'package:zoe/features/share/widgets/sheet_share_preview_widget.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/widgets/sheet_avatar_widget.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

void showShareItemsBottomSheet({
  required BuildContext context,
  required String parentId,
  bool isSheet = false,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) =>
        ShareItemsBottomSheet(parentId: parentId, isSheet: isSheet),
  );
}

class ShareItemsBottomSheet extends ConsumerStatefulWidget {
  final String parentId;
  final bool isSheet;

  const ShareItemsBottomSheet({
    super.key,
    required this.parentId,
    required this.isSheet,
  });

  @override
  ConsumerState<ShareItemsBottomSheet> createState() =>
      _ShareItemsBottomSheetState();
}

class _ShareItemsBottomSheetState extends ConsumerState<ShareItemsBottomSheet> {
  String _userMessage = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contentText = widget.isSheet
        ? _getSheetShareMessage(ref)
        : _getContentShareMessage(ref);

    return MaxWidthWidget(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
      ),
      isScrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.isSheet
              ? _getSheetInfo(context, ref)
              : Text(
                  _getShareTitle(context, ref),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
          const SizedBox(height: 20),
          if (widget.isSheet)
            SheetSharePreviewWidget(
              parentId: widget.parentId,
              contentText: contentText,
              onMessageChanged: (message) {
                setState(() {
                  _userMessage = message;
                });
              },
            )
          else
            _buildContentPreview(context, contentText),
          const SizedBox(height: 20),
          _buildShareButton(context, contentText),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _getSheetInfo(BuildContext context, WidgetRef ref) {
    final sheet = ref.watch(sheetProvider(widget.parentId));
    if (sheet == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SheetAvatarWidget(sheetId: sheet.id, padding: const EdgeInsets.all(8)),
        const SizedBox(height: 8),
        Text(sheet.title, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  String _getShareTitle(BuildContext context, WidgetRef ref) {
    final content = ref.watch(contentProvider(widget.parentId));
    final l10n = L10n.of(context);
    return switch (content?.type) {
      ContentType.text => l10n.shareText,
      ContentType.event => l10n.shareEvent,
      ContentType.list => () {
        final listModel = ref.watch(listItemProvider(widget.parentId));
        return switch (listModel?.listType) {
          ContentType.task => l10n.shareTaskList,
          ContentType.bullet => l10n.shareBulletList,
          _ => l10n.share,
        };
      }(),
      ContentType.task => l10n.shareTask,
      ContentType.bullet => l10n.shareBullet,
      ContentType.poll => l10n.sharePoll,
      _ => l10n.share,
    };
  }

  String _getSheetShareMessage(WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final currentUser = currentUserAsync.value;
    final userName = currentUser?.name ?? '';
    return ShareUtils.getSheetShareMessage(
      ref: ref,
      parentId: widget.parentId,
      userName: userName.isNotEmpty ? userName : null,
      userMessage: _userMessage.trim().isNotEmpty ? _userMessage : null,
    );
  }

  String _getContentShareMessage(WidgetRef ref) {
    final content = ref.watch(contentProvider(widget.parentId));
    if (content == null) return '';
    switch (content.type) {
      case ContentType.text:
        return ShareUtils.getTextContentShareMessage(
          ref: ref,
          parentId: widget.parentId,
        );
      case ContentType.event:
        return ShareUtils.getEventContentShareMessage(
          ref: ref,
          parentId: widget.parentId,
        );
      case ContentType.list:
        return ShareUtils.getListContentShareMessage(
          ref: ref,
          parentId: widget.parentId,
        );
      case ContentType.task:
        return ShareUtils.getTaskContentShareMessage(
          ref: ref,
          parentId: widget.parentId,
        );
      case ContentType.bullet:
        return ShareUtils.getBulletContentShareMessage(
          ref: ref,
          parentId: widget.parentId,
        );
      case ContentType.poll:
        return ShareUtils.getPollContentShareMessage(
          ref: ref,
          parentId: widget.parentId,
        );
      case ContentType.document:
      case ContentType.link:
        return '';
    }
  }

  Widget _buildContentPreview(BuildContext context, String contentText) {
    return GlassyContainer(
      padding: const EdgeInsets.all(16),
      blurRadius: 0,
      borderRadius: BorderRadius.circular(12),
      child: SingleChildScrollView(
        child: Text(contentText, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }

  Widget _buildShareButton(BuildContext context, String contentText) {
    final l10n = L10n.of(context);
    return ZoePrimaryButton(
      onPressed: () async {
        if (widget.isSheet) {
          final currentUser = await ref.read(currentUserProvider.future);
          if (currentUser != null) {
            final userName = currentUser.name;
            ref
                .read(sheetListProvider.notifier)
                .updateSheetShareInfo(
                  sheetId: widget.parentId,
                  sharedBy: userName,
                  message: _userMessage.trim().isNotEmpty
                      ? _userMessage.trim()
                      : null,
                );
          }
        }
        CommonUtils.shareText(contentText, subject: l10n.share);
      },
      icon: Icons.share_rounded,
      text: l10n.share,
    );
  }
}
