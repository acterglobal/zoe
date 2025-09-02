import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/widgets/poll_widget.dart';
import 'package:zoe/features/quick-search/widgets/quick_search_tab_section_header_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';
  
class PollListWidget extends ConsumerWidget {
  final ProviderBase<List<PollModel>> pollsProvider;
  final bool isEditing;
  final int? maxItems;
  final bool shrinkWrap;
  final bool showCardView;
  final Widget emptyState;
  final bool showSectionHeader;

  const PollListWidget({
    super.key,
    required this.pollsProvider,
    required this.isEditing,
    this.maxItems,
    this.shrinkWrap = true,
    this.showCardView = true,
    this.emptyState = const SizedBox.shrink(),
    this.showSectionHeader = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allPolls = ref.watch(pollsProvider);
    final searchValue = ref.watch(searchValueProvider);

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
      return emptyState;
    }

    if (showSectionHeader) {
      return Column(
        children: [
          _buildSectionHeader(context),
          const SizedBox(height: 16),
          _buildPollList(context, ref, polls),
        ],
      );
    }

    return _buildPollList(context, ref, polls);
  }

  Widget _buildPollList(BuildContext context, WidgetRef ref, List<PollModel> polls) {

    final itemCount = maxItems != null
        ? min(maxItems!, polls.length)
        : polls.length;

    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final poll = polls[index];
        return showCardView
            ? GlassyContainer(
                borderRadius: BorderRadius.circular(12),
                borderOpacity: 0.05,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                child: PollWidget(
                  key: Key(poll.id),
                  pollId: poll.id,
                  isEditing: false,
                ),
              )
            : PollWidget(pollId: poll.id, isEditing: isEditing);
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return QuickSearchTabSectionHeaderWidget(
      title: L10n.of(context).polls,
      icon: Icons.poll_rounded,
      onTap: () => context.push(AppRoutes.pollsList.route),
      color: AppColors.brightMagentaColor,
    );
  }
}
