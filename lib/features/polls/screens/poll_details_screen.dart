import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/edit_view_toggle_button.dart';
import 'package:zoe/common/widgets/paper_sheet_background_widget.dart';
import 'package:zoe/common/widgets/quill_editor/widgets/quill_editor_positioned_toolbar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/features/content/providers/content_menu_providers.dart';
import 'package:zoe/features/content/widgets/content_widget.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/polls/widgets/poll_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class PollDetailsScreen extends ConsumerWidget {
  final String pollId;

  const PollDetailsScreen({super.key, required this.pollId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(isEditValueProvider(pollId));
    final poll = ref.watch(pollProvider(pollId));
    if (poll == null) {
      return Center(child: Text(L10n.of(context).pollNotFound));
    }
    return NotebookPaperBackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: ZoeAppBar(actions: [EditViewToggleButton(parentId: pollId)]),
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  _buildBody(context, ref, poll, isEditing),
                  buildQuillEditorPositionedToolbar(
                    context,
                    ref,
                    isEditing: isEditing,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the main body
  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    PollModel poll,
    bool isEditing,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          PollWidget(pollId: pollId, isEditing: isEditing),
          const SizedBox(height: 16),
          ContentWidget(parentId: pollId, sheetId: poll.sheetId),
        ],
      ),
    );
  }
}
