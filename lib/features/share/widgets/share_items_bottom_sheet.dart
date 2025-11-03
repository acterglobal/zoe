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

class ShareItemsBottomSheet extends ConsumerWidget {
  final String parentId;
  final bool isSheet;

  const ShareItemsBottomSheet({
    super.key,
    required this.parentId,
    required this.isSheet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentText = isSheet
        ? ShareUtils.getSheetShareMessage(ref: ref, parentId: parentId)
        : _getContentShareMessage(ref);

    return MaxWidthWidget(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _getShareTitle(context, ref),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          if (isSheet)
            SheetSharePreviewWidget(
              parentId: parentId,
              contentText: contentText,
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

  String _getShareTitle(BuildContext context, WidgetRef ref) {
    if (isSheet) return L10n.of(context).shareSheet;
    final content = ref.watch(contentProvider(parentId));
    return switch (content?.type) {
      ContentType.text => L10n.of(context).shareText,
      ContentType.event => L10n.of(context).shareEvent,
      ContentType.list => () {
        final listModel = ref.watch(listItemProvider(parentId));
        return switch (listModel?.listType) {
          ContentType.task => L10n.of(context).shareTaskList,
          ContentType.bullet => L10n.of(context).shareBulletList,
          _ => L10n.of(context).share,
        };
      }(),
      ContentType.task => L10n.of(context).shareTask,
      ContentType.bullet => L10n.of(context).shareBullet,
      ContentType.poll => L10n.of(context).sharePoll,
      _ => L10n.of(context).share,
    };
  }

  String _getContentShareMessage(WidgetRef ref) {
    final content = ref.watch(contentProvider(parentId));
    if (content == null) return '';
    switch (content.type) {
      case ContentType.text:
        return ShareUtils.getTextContentShareMessage(
          ref: ref,
          parentId: parentId,
        );
      case ContentType.event:
        return ShareUtils.getEventContentShareMessage(
          ref: ref,
          parentId: parentId,
        );
      case ContentType.list:
        return ShareUtils.getListContentShareMessage(
          ref: ref,
          parentId: parentId,
        );
      case ContentType.task:
        return ShareUtils.getTaskContentShareMessage(
          ref: ref,
          parentId: parentId,
        );
      case ContentType.bullet:
        return ShareUtils.getBulletContentShareMessage(
          ref: ref,
          parentId: parentId,
        );
      case ContentType.poll:
        return ShareUtils.getPollContentShareMessage(
          ref: ref,
          parentId: parentId,
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
    return ZoePrimaryButton(
      onPressed: () =>
          CommonUtils.shareText(contentText, subject: L10n.of(context).share),
      icon: Icons.share_rounded,
      text: L10n.of(context).share,
    );
  }
}
