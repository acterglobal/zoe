import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/content_menu_button.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/paper_sheet_background_widget.dart';
import 'package:zoe/common/widgets/quill_editor/widgets/quill_editor_positioned_toolbar_widget.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/zoe_sheet_floating_actoin_button.dart';
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
    final editContentId = ref.watch(editContentIdProvider);
    final isEditing = editContentId == pollId;
    final poll = ref.watch(pollProvider(pollId));

    return NotebookPaperBackgroundWidget(
      child: poll != null
          ? _buildDataPollWidget(context, ref, poll, isEditing)
          : _buildEmptyPollWidget(context),
    );
  }

  Widget _buildEmptyPollWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(automaticallyImplyLeading: false, title: ZoeAppBar()),
      body: Center(
        child: EmptyStateWidget(
          message: L10n.of(context).pollNotFound,
          icon: Icons.poll_outlined,
        ),
      ),
    );
  }

  Widget _buildDataPollWidget(
    BuildContext context,
    WidgetRef ref,
    PollModel poll,
    bool isEditing,
  ) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: ZoeAppBar(actions: [ContentMenuButton(parentId: pollId)]),
      ),
      body: MaxWidthWidget(
        child: Column(
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
      floatingActionButton: ZoeSheetFloatingActionButton(
        parentId: pollId,
        sheetId: poll.sheetId,
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
          GestureDetector(
            onLongPress: () =>
                ref.read(editContentIdProvider.notifier).state = pollId,
            child: PollWidget(pollId: pollId),
          ),
          const SizedBox(height: 16),
          ContentWidget(parentId: pollId, sheetId: poll.sheetId),
        ],
      ),
    );
  }
}
