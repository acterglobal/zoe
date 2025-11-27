import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/floating_action_button_wrapper.dart';
import 'package:zoe/common/widgets/paper_sheet_background_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_html_inline_text_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/common/widgets/quill_editor/widgets/quill_editor_positioned_toolbar_widget.dart';
import 'package:zoe/features/content/widgets/content_widget.dart';
import 'package:zoe/features/sheet/actions/sheet_actions.dart';
import 'package:zoe/features/sheet/actions/sheet_data_updates.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/widgets/sheet_app_bar.dart';
import 'package:zoe/features/sheet/widgets/sheet_avatar_widget.dart';
import 'package:zoe/features/users/widgets/user_list_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class SheetDetailScreen extends ConsumerWidget {
  final String sheetId;

  const SheetDetailScreen({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(editContentIdProvider) == sheetId;
    final sheet = ref.watch(sheetProvider(sheetId));
    final userSelectedThemeColor =
        sheet?.theme?.primary ?? Theme.of(context).colorScheme.primary;
    final userSelectedSecondaryThemeColor =
        sheet?.theme?.secondary ?? Theme.of(context).colorScheme.secondary;

    return NotebookPaperBackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            _buildSliverBody(context, ref, isEditing, userSelectedThemeColor),
            buildQuillEditorPositionedToolbar(
              context,
              ref,
              isEditing: isEditing,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButtonWrapper(
          parentId: sheetId,
          sheetId: sheetId,
          primaryColor: userSelectedThemeColor,
          secondaryColor: userSelectedSecondaryThemeColor,
        ),
      ),
    );
  }

  /// Builds the sliver body
  Widget _buildSliverBody(
    BuildContext context,
    WidgetRef ref,
    bool isEditing,
    Color userSelectedThemeColor,
  ) {
    return CustomScrollView(
      slivers: [
        SheetAppBar(sheetId: sheetId, isEditing: isEditing),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 10),
              _buildSheetHeader(
                context,
                ref,
                isEditing,
                userSelectedThemeColor,
              ),
              const SizedBox(height: 16),
              ContentWidget(
                parentId: sheetId,
                sheetId: sheetId,
                showSheetName: false,
              ),
            ]),
          ),
        ),
      ],
    );
  }

  /// Builds the header
  Widget _buildSheetHeader(
    BuildContext context,
    WidgetRef ref,
    bool isEditing,
    Color userSelectedThemeColor,
  ) {
    final sheet = ref.watch(sheetProvider(sheetId));
    if (sheet == null) return const SizedBox.shrink();
    final usersInSheet = ref.watch(listOfUsersBySheetIdProvider(sheetId));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SheetAvatarWidget(
              sheetId: sheetId,
              isWithBackground: false,
              padding: EdgeInsets.only(top: 3, right: 6),
              iconSize: 40,
              imageSize: 46,
              emojiSize: 32,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: ZoeInlineTextEditWidget(
                hintText: L10n.of(context).title,
                isEditing: isEditing,
                text: sheet.title,
                textStyle: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.2,
                ),
                onTextChanged: (value) => Future.microtask(
                  () => updateSheetTitle(ref, sheetId, value),
                ),
                onTapLongPressText: () => showSheetMenu(
                  context: context,
                  ref: ref,
                  isEditing: isEditing,
                  sheetId: sheetId,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (usersInSheet.isNotEmpty) ...[
          _buildUsersCountWidget(
            context,
            usersInSheet,
            ref,
            userSelectedThemeColor,
          ),
          const SizedBox(height: 8),
        ],
        ZoeHtmlTextEditWidget(
          hintText: L10n.of(context).addADescription,
          isEditing: isEditing,
          description: sheet.description,
          textStyle: Theme.of(context).textTheme.bodyLarge,
          editorId: 'sheet-description-$sheetId',
          onContentChanged: (description) => Future.microtask(
            () => updateSheetDescription(ref, sheetId, description),
          ),
        ),
      ],
    );
  }

  /// users count widget
  Widget _buildUsersCountWidget(
    BuildContext context,
    List<String> usersInSheet,
    WidgetRef ref,
    Color userSelectedThemeColor,
  ) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final userCount = usersInSheet.length;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => UserListWidget(
            userIdList: listOfUsersBySheetIdProvider(sheetId),
            title: l10n.usersInSheet,
            iconColor: userSelectedThemeColor,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: userSelectedThemeColor.withValues(alpha: 0.1),
          border: Border.all(
            color: userSelectedThemeColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_rounded, size: 16, color: userSelectedThemeColor),
            const SizedBox(width: 6),
            Text(
              '$userCount ${userCount == 1 ? l10n.user : l10n.users}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: userSelectedThemeColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
              color: userSelectedThemeColor,
            ),
          ],
        ),
      ),
    );
  }
}
