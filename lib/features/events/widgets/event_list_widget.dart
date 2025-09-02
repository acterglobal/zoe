import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/widgets/event_widget.dart';
import 'package:zoe/features/quick-search/widgets/quick_search_tab_section_header_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class EventListWidget extends ConsumerWidget {
  final ProviderBase<List<EventModel>> eventsProvider;
  final bool isEditing;
  final int? maxItems;
  final bool shrinkWrap;
  final Widget emptyState;
  final bool showSectionHeader;

  const EventListWidget({
    super.key,
    required this.eventsProvider,
    required this.isEditing,
    this.maxItems,
    this.shrinkWrap = true,
    this.emptyState = const SizedBox.shrink(),
    this.showSectionHeader = false,

  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventsProvider);
    if (events.isEmpty) {
      return emptyState;
    }

    if (showSectionHeader) {
      return Column(
        children: [
          _buildSectionHeader(context),
          const SizedBox(height: 16),
          _buildEventList(context, ref, events),
        ],
      );
    }

    return _buildEventList(context, ref, events);
  }

  Widget _buildEventList(BuildContext context, WidgetRef ref, List<EventModel> events) {

    final itemCount = maxItems != null
        ? min(maxItems!, events.length)
        : events.length;

    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final event = events[index];
        return EventWidget(
            key: ValueKey(event.id),
            eventsId: event.id,
            isEditing: isEditing,
          );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return QuickSearchTabSectionHeaderWidget(
      title: L10n.of(context).events,
      icon: Icons.event_rounded,
      onTap: () => context.push(AppRoutes.eventsList.route),
      color: AppColors.secondaryColor,
    );
  }
}
