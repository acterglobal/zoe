import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/content_menu_button.dart';
import 'package:zoe/common/widgets/long_tap_bottom_sheet.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/paper_sheet_background_widget.dart';
import 'package:zoe/common/widgets/quill_editor/widgets/quill_editor_positioned_toolbar_widget.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_html_inline_text_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/common/widgets/zoe_sheet_floating_actoin_button.dart';
import 'package:zoe/features/content/providers/content_menu_providers.dart';
import 'package:zoe/features/content/widgets/content_widget.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/providers/events_proivder.dart';
import 'package:zoe/features/events/widgets/event_details_additional_fields.dart';
import 'package:zoe/features/events/widgets/event_rsvp_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class EventDetailScreen extends ConsumerWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = ref.watch(eventProvider(eventId));
    final editContentId = ref.watch(editContentIdProvider);
    final isEditing = editContentId == eventId;
    return NotebookPaperBackgroundWidget(
      child: event != null
          ? _buildDataEventWidget(context, ref, event, isEditing)
          : _buildEmptyEventWidget(context),
    );
  }

  Widget _buildEmptyEventWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(automaticallyImplyLeading: false, title: ZoeAppBar()),
      body: Center(
        child: EmptyStateWidget(
          message: L10n.of(context).eventNotFound,
          icon: Icons.event_outlined,
        ),
      ),
    );
  }

  Widget _buildDataEventWidget(
    BuildContext context,
    WidgetRef ref,
    EventModel event,
    bool isEditing,
  ) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: ZoeAppBar(actions: [ContentMenuButton(parentId: eventId)]),
      ),
      body: MaxWidthWidget(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  _buildBody(context, ref, event, isEditing),
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
        parentId: eventId,
        sheetId: event.sheetId,
      ),
    );
  }

  /// Builds the main body
  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    EventModel event,
    bool isEditing,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEventHeader(context, ref, event, isEditing),
          const SizedBox(height: 16),
          EventRsvpWidget(eventId: eventId),
          const SizedBox(height: 16),
          ContentWidget(parentId: eventId, sheetId: event.sheetId),
        ],
      ),
    );
  }

  /// Builds the header
  Widget _buildEventHeader(
    BuildContext context,
    WidgetRef ref,
    EventModel event,
    bool isEditing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ZoeInlineTextEditWidget(
                hintText: L10n.of(context).title,
                isEditing: isEditing,
                text: event.title,
                textStyle: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.2,
                ),
                onTextChanged: (value) => ref
                    .read(eventListProvider.notifier)
                    .updateEventTitle(eventId, value),
                onLongTapText: () =>
                    showLongTapBottomSheet(context, contentId: eventId),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ZoeHtmlTextEditWidget(
          hintText: L10n.of(context).addADescription,
          isEditing: isEditing,
          description: event.description,
          textStyle: Theme.of(context).textTheme.bodyLarge,
          editorId: 'event-description-$eventId',
          // Add unique editor ID
          onContentChanged: (description) => Future.microtask(
            () => ref
                .read(eventListProvider.notifier)
                .updateEventDescription(eventId, description),
          ),
        ),
        const SizedBox(height: 16),
        EventDetailsAdditionalFields(event: event, isEditing: isEditing),
      ],
    );
  }
}
