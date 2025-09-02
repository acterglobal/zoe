import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/widgets/poll_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class PollListWidget extends ConsumerWidget {
  final ProviderBase<List<PollModel>> pollsProvider;
  final bool isEditing;
  final int? maxItems;
  final bool shrinkWrap;
  final bool showCardView;

  const PollListWidget({
    super.key,
    required this.pollsProvider,
    required this.isEditing,
    this.maxItems,
    this.shrinkWrap = true,
    this.showCardView = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final polls = ref.watch(pollsProvider);
    if (polls.isEmpty) {
      return EmptyStateWidget(message: L10n.of(context).noPollsFound);
    }

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
}
