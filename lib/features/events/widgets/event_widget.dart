import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/display_sheet_name_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_close_button_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/events/actions/event_actions.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/features/events/utils/event_utils.dart';
import 'package:zoe/features/events/widgets/event_date_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class EventWidget extends ConsumerWidget {
  final String eventId;
  final EdgeInsetsGeometry? margin;
  final bool showSheetName;

  const EventWidget({
    super.key,
    required this.eventId,
    this.margin,
    this.showSheetName = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = ref.watch(eventProvider(eventId));
    if (event == null) return const SizedBox.shrink();

    final isEditing = ref.watch(editContentIdProvider) == eventId;
    return GestureDetector(
      onTap: () => context.push(
        AppRoutes.eventDetail.route.replaceAll(':eventId', eventId),
      ),
      child: Card(
        margin: margin ?? const EdgeInsets.symmetric(vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: _buildEventContent(context, ref, event, isEditing),
        ),
      ),
    );
  }

  Widget _buildEventContent(
    BuildContext context,
    WidgetRef ref,
    EventModel event,
    bool isEditing,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EventDateWidget(event: event),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildEventTitle(
                      context,
                      ref,
                      event.title,
                      isEditing,
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (isEditing) _buildEventActions(context, ref, event),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (showSheetName) ...[
                    DisplaySheetNameWidget(sheetId: event.sheetId),
                  ],
                  _buildEventDates(context, ref, event),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventTitle(
    BuildContext context,
    WidgetRef ref,
    String title,
    bool isEditing,
  ) {
    return ZoeInlineTextEditWidget(
      hintText: L10n.of(context).eventName,
      isEditing: isEditing,
      text: title,
      textStyle: Theme.of(context).textTheme.bodyMedium,
      onTextChanged: (value) =>
          ref.read(eventListProvider.notifier).updateEventTitle(eventId, value),
      onTapText: () => context.push(
        AppRoutes.eventDetail.route.replaceAll(':eventId', eventId),
      ),
      onTapLongPressText: showSheetName
          ? null
          : () => showEventMenu(
              context: context,
              ref: ref,
              isEditing: isEditing,
              eventId: eventId,
            ),
    );
  }

  Widget _buildEventDates(
    BuildContext context,
    WidgetRef ref,
    EventModel event,
  ) {
    return Text(
      EventUtils.formatEventDateAndTime(context, event),
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  Widget _buildEventActions(
    BuildContext context,
    WidgetRef ref,
    EventModel event,
  ) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.push(
            AppRoutes.eventDetail.route.replaceAll(':eventId', event.id),
          ),
          child: Icon(
            Icons.edit,
            size: 16,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
        const SizedBox(width: 6),
        ZoeCloseButtonWidget(
          onTap: () =>
              ref.read(eventListProvider.notifier).deleteEvent(event.id),
        ),
      ],
    );
  }
}
