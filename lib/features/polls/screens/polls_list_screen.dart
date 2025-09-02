import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_glassy_tab_widget.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/polls/utils/poll_utils.dart';
import 'package:zoe/features/polls/widgets/poll_list_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class PollsListScreen extends ConsumerStatefulWidget {
  const PollsListScreen({super.key});

  @override
  ConsumerState<PollsListScreen> createState() => _PollsListScreenState();
}

class _PollsListScreenState extends ConsumerState<PollsListScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild UI when tab changes
    });
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(searchValueProvider.notifier).state = '',
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: ZoeAppBar(title: L10n.of(context).polls),
      bottom: ZoeGlassyTabWidget(
        tabTexts: [
          PollStatus.draft.name,
          PollStatus.active.name,
          PollStatus.completed.name,
        ],
        selectedIndex: _tabController.index,
        onTabChanged: (index) => _tabController.animateTo(index),
        height: 45,
        margin: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Column(
        children: [
          MaxWidthWidget(
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
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNotActivePollsTab(),
                _buildActivePollsTab(),
                _buildCompletedPollsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotActivePollsTab() {
    return MaxWidthWidget(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: PollListWidget(
        pollsProvider: notActivePollListProvider,
        isEditing: false,
        shrinkWrap: false,
        emptyState: EmptyStateWidget(message: L10n.of(context).noPollsFound),
      ),
    );
  }

  Widget _buildActivePollsTab() {
    return MaxWidthWidget(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: PollListWidget(
        pollsProvider: activePollListProvider,
        isEditing: false,
        shrinkWrap: false,
        emptyState: EmptyStateWidget(message: L10n.of(context).noPollsFound),
      ),
    );
  }

  Widget _buildCompletedPollsTab() {
    return MaxWidthWidget(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: PollListWidget(
        pollsProvider: completedPollListProvider,
        isEditing: false,
        shrinkWrap: false,
        emptyState: EmptyStateWidget(message: L10n.of(context).noPollsFound),
      ),
    );
  }
}
