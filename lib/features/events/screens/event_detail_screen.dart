import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/widgets/edit_view_toggle_button.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/features/content/providers/content_menu_providers.dart';
import 'package:zoey/features/content/widgets/content_widget.dart';
import 'package:zoey/features/events/models/events_model.dart';
import 'package:zoey/features/events/providers/events_proivder.dart';

class EventDetailScreen extends ConsumerWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = ref.watch(eventProvider(eventId));
    if (event == null) return const Center(child: Text('Event not found'));
    return Scaffold(
      appBar: AppBar(
        actions: [EditViewToggleButton(), const SizedBox(width: 12)],
      ),
      body: _buildBody(context, ref, event),
    );
  }

  /// Builds the main body
  Widget _buildBody(BuildContext context, WidgetRef ref, EventModel event) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEventHeader(context, ref, event),
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
  ) {
    final isEditing = ref.watch(isEditValueProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ZoeInlineTextEditWidget(
                hintText: 'Title',
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
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ZoeInlineTextEditWidget(
          hintText: 'Add a description',
          isEditing: isEditing,
          text: event.description?.plainText,
          textStyle: Theme.of(context).textTheme.bodyLarge,
          onTextChanged: (value) =>
              ref.read(eventListProvider.notifier).updateEventDescription(
                eventId,
                (plainText: value, htmlText: null),
              ),
        ),
      ],
    );
  }
}
