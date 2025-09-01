import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_glassy_tab_widget.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/documents/widgets/document_list_widget.dart';
import 'package:zoe/features/events/providers/events_proivder.dart';
import 'package:zoe/features/events/widgets/event_list_widget.dart';
import 'package:zoe/features/link/providers/link_providers.dart';
import 'package:zoe/features/link/widgets/link_list_widget.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/polls/widgets/poll_list_widget.dart';
import 'package:zoe/features/quick-search/models/quick_search_filters.dart';
import 'package:zoe/features/quick-search/widgets/quick_search_tab_section_header_widget.dart';
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
                  ref.read(searchValueProvider.notifier).state = value,
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
      lang.links,
      lang.documents,
      lang.polls,
    ];

    return ZoeGlassyTabWidget(
      tabTexts: tabTexts,
      selectedIndex: QuickSearchFilters.values.indexOf(quickSearchFilters.value),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuickSearchTabSectionHeaderWidget(
                  title: L10n.of(context).sheets,
                  icon: Icons.article_rounded,
                  onTap: () => context.push(AppRoutes.sheetsList.route),
                  color: AppColors.primaryColor,
                ),
                const SizedBox(height: 16),
                SheetListWidget(
                  maxItems: 5,
                  shrinkWrap: true,
                ),
                const SizedBox(height: 8),
              ],
            ),
          if (quickSearchFilters.value == QuickSearchFilters.all ||
              quickSearchFilters.value == QuickSearchFilters.events)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuickSearchTabSectionHeaderWidget(
                  title: L10n.of(context).events,
                  icon: Icons.event_rounded,
                  onTap: () => context.push(AppRoutes.eventsList.route),
                  color: AppColors.secondaryColor,
                ),
                const SizedBox(height: 8),
                EventListWidget(
                  eventsProvider: eventListSearchProvider,
                  isEditing: false,
                  maxItems: 5,
                ),
                const SizedBox(height: 16),
              ],
            ),
          if (quickSearchFilters.value == QuickSearchFilters.all ||
              quickSearchFilters.value == QuickSearchFilters.tasks)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuickSearchTabSectionHeaderWidget(
                  title: L10n.of(context).tasks,
                  icon: Icons.task_alt_rounded,
                  onTap: () => context.push(AppRoutes.tasksList.route),
                  color: AppColors.successColor,
                ),
                const SizedBox(height: 8),
                TaskListWidget(
                  tasksProvider: taskListSearchProvider,
                  isEditing: false,
                  maxItems: 5,
                ),
                const SizedBox(height: 8),
              ],
            ),
          if (quickSearchFilters.value == QuickSearchFilters.all ||
              quickSearchFilters.value == QuickSearchFilters.links)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuickSearchTabSectionHeaderWidget(
                  title: L10n.of(context).links,
                  icon: Icons.link_rounded,
                  onTap: () => context.push(AppRoutes.linksList.route),
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 16),
                LinkListWidget(
                  linksProvider: linkListSearchProvider,
                  isEditing: false,
                  maxItems: 5,
                ),
                const SizedBox(height: 8),
              ],
            ),
          if (quickSearchFilters.value == QuickSearchFilters.all ||
              quickSearchFilters.value == QuickSearchFilters.documents)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuickSearchTabSectionHeaderWidget(
                  title: L10n.of(context).documents,
                  icon: Icons.insert_drive_file_rounded,
                  onTap: () => context.push(AppRoutes.documentsList.route),
                  color: AppColors.brightOrangeColor,
                ),
                const SizedBox(height: 16),
                DocumentListWidget(
                  documentsProvider: documentListSearchProvider,
                  isEditing: false,
                  maxItems: 5,
                ),
                const SizedBox(height: 8),
              ],
            ),
          if (quickSearchFilters.value == QuickSearchFilters.all ||
              quickSearchFilters.value == QuickSearchFilters.polls)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuickSearchTabSectionHeaderWidget(
                  title: L10n.of(context).polls,
                  icon: Icons.poll_rounded,
                  onTap: () => context.push(AppRoutes.pollsList.route),
                  color: AppColors.brightMagentaColor,
                ),
                const SizedBox(height: 8),
                PollListWidget(
                  pollsProvider: pollListSearchProvider,
                  isEditing: false,
                  maxItems: 5,
                ),
                const SizedBox(height: 16),
              ],
            ),
        ],
      ),
    );
  }
}