import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_glassy_tab_widget.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/documents/widgets/document_list_widget.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/features/events/widgets/event_list_widget.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/polls/widgets/poll_list_widget.dart';
import 'package:zoe/features/quick-search/models/quick_search_filters.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/widgets/sheet_list_widget.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/task/widgets/task_list_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class QuickSearchScreen extends ConsumerStatefulWidget {
  const QuickSearchScreen({super.key});

  @override
  ConsumerState<QuickSearchScreen> createState() => _QuickSearchScreenState();
}

class _QuickSearchScreenState extends ConsumerState<QuickSearchScreen> {
  final TextEditingController searchController = TextEditingController();
  ValueNotifier<QuickSearchFilters> quickSearchFilters =
      ValueNotifier<QuickSearchFilters>(QuickSearchFilters.all);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.invalidate(searchValueProvider),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: ZoeAppBar(title: L10n.of(context).search),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: MaxWidthWidget(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            ZoeSearchBarWidget(
              controller: searchController,
              onChanged: (value) =>
                  ref.read(searchValueProvider.notifier).update(value),
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder(
              valueListenable: quickSearchFilters,
              builder: (context, filter, child) => _buildFilterTabs(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: quickSearchFilters,
                builder: (context, filter, child) => _buildSearchSections(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    final lang = L10n.of(context);
    final tabTexts = [
      lang.all,
      lang.sheets,
      lang.events,
      lang.tasks,
      // lang.links,
      lang.documents,
      lang.polls,
    ];

    return ZoeGlassyTabWidget(
      tabTexts: tabTexts,
      selectedIndex: QuickSearchFilters.values.indexOf(
        quickSearchFilters.value,
      ),
      onTabChanged: (index) {
        quickSearchFilters.value = QuickSearchFilters.values[index];
      },
      height: 45,
      margin: const EdgeInsets.symmetric(vertical: 4),
      borderRadius: 20,
    );
  }

  Widget _buildSearchSections() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (quickSearchFilters.value == QuickSearchFilters.all ||
              quickSearchFilters.value == QuickSearchFilters.sheets)
            SheetListWidget(
              sheetsProvider: sheetListSearchProvider,
              maxItems: 3,
              shrinkWrap: true,
              showSectionHeader: true,
            ),
          if (quickSearchFilters.value == QuickSearchFilters.all ||
              quickSearchFilters.value == QuickSearchFilters.events)
            EventListWidget(
              eventsProvider: eventListSearchProvider,
              isEditing: false,
              maxItems: 3,
              showSectionHeader: true,
            ),
          if (quickSearchFilters.value == QuickSearchFilters.all ||
              quickSearchFilters.value == QuickSearchFilters.tasks) ...[
            const SizedBox(height: 16),
            TaskListWidget(
              tasksProvider: taskListSearchProvider,
              isEditing: false,
              maxItems: 3,
              showSectionHeader: true,
            ),
          ],
          /*if (quickSearchFilters.value == QuickSearchFilters.all ||
              quickSearchFilters.value == QuickSearchFilters.links) ...[
            const SizedBox(height: 16),
            LinkListWidget(
              linksProvider: linkListSearchProvider,
              isEditing: false,
              maxItems: 3,
              showSectionHeader: true,
            ),
          ],*/
          if (quickSearchFilters.value == QuickSearchFilters.all ||
              quickSearchFilters.value == QuickSearchFilters.documents) ...[
            const SizedBox(height: 10),
            DocumentListWidget(
              documentsProvider: documentListSearchProvider,
              isEditing: false,
              maxItems: 3,
              isVertical: true,
              showSectionHeader: true,
            ),
          ],
          if (quickSearchFilters.value == QuickSearchFilters.all ||
              quickSearchFilters.value == QuickSearchFilters.polls) ...[
            const SizedBox(height: 16),
            PollListWidget(
              pollsProvider: pollListSearchProvider,
              isEditing: false,
              maxItems: 3,
              showSectionHeader: true,
            ),
          ],
        ],
      ),
    );
  }
}
