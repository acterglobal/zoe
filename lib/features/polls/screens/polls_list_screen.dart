import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_glassy_tab_widget.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/polls/utils/poll_utils.dart';
import 'package:zoe/features/polls/widgets/poll_widget.dart';
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
      child: _buildPollList(context, ref, notActivePollListProvider, false),
    );
  }

  Widget _buildActivePollsTab() {
    return MaxWidthWidget(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _buildPollList(context, ref, activePollListProvider, true),
    );
  }

  Widget _buildCompletedPollsTab() {
    return MaxWidthWidget(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _buildPollList(context, ref, completedPollListProvider, false),
    );
  }

  Widget _buildPollList(
    BuildContext context,
    WidgetRef ref,
    Provider<List<PollModel>> pollProvider,
    bool isStartedTab,
  ) {
    final allPolls = ref.watch(pollProvider);
    final searchValue = ref.watch(searchValueProvider);

    // Filter polls based on search value
    final polls = searchValue.isEmpty
        ? allPolls
        : allPolls
              .where(
                (poll) => poll.question.toLowerCase().contains(
                  searchValue.toLowerCase(),
                ),
              )
              .toList();

    if (polls.isEmpty) {
      return EmptyStateWidget(message: L10n.of(context).noPollsFound);
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: polls.length,
      padding: const EdgeInsets.only(bottom: 30),
      itemBuilder: (context, index) {
        final poll = polls[index];
        return _buildPollItem(context, poll);
      },
    );
  }

  Widget _buildPollItem(BuildContext context, PollModel poll) {
    return GlassyContainer(
      borderRadius: BorderRadius.circular(12),
      borderOpacity: 0.05,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: PollWidget(key: Key(poll.id), pollId: poll.id, isEditing: false),
    );
  }
}
