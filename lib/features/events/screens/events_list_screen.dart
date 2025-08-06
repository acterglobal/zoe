import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/providers/common_providers.dart';
import 'package:zoey/common/widgets/max_width_widget.dart';
import 'package:zoey/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:zoey/features/events/providers/events_proivder.dart';
import 'package:zoey/features/events/widgets/event_widget.dart';
import 'package:zoey/l10n/generated/l10n.dart';

class EventsListScreen extends ConsumerStatefulWidget {
  const EventsListScreen({super.key});

  @override
  ConsumerState<EventsListScreen> createState() => _EventsListScreenState();
}

class _EventsListScreenState extends ConsumerState<EventsListScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(searchValueProvider.notifier).state = '',
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MaxWidthWidget(
          padding: const EdgeInsets.symmetric(horizontal: 16),    
          child: Column(
            children: [
              const SizedBox(height: 16),
              ZoeAppBar(title: L10n.of(context).events),
              const SizedBox(height: 16),
              ZoeSearchBarWidget(
                controller: searchController,
                onChanged: (value) =>
                    ref.read(searchValueProvider.notifier).state = value,
              ),
              const SizedBox(height: 16),
              Expanded(child: _buildEventList(context, ref)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventList(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventListSearchProvider);
    if (events.isEmpty) {
      return EmptyStateWidget(message: L10n.of(context).noEventsFound);
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: events.length,
      padding: const EdgeInsets.only(bottom: 30),
      itemBuilder: (context, index) {
        final event = events[index];
        return EventWidget(
          key: Key(event.id),
          eventsId: event.id,
          isEditing: false,
          margin: const EdgeInsets.only(top: 4, bottom: 4),
        );
      },
    );
  }
}
