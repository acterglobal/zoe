import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/widgets/poll_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class PollListWidget extends ConsumerWidget {
  final ProviderBase<List<PollModel>> pollsProvider;
  final bool isEditing;
  final int? maxItems;

  const PollListWidget({
    super.key,
    required this.pollsProvider,
    required this.isEditing,
    this.maxItems,
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
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final poll = polls[index];
        return maxItems != null
            ? Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 6,
                  ),
                  child: PollWidget(pollId: poll.id, isEditing: false),
                ),
              )
            : PollWidget(pollId: poll.id, isEditing: isEditing);
      },
    );
  }
}
