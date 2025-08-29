import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:zoe/features/link/models/link_model.dart';
import 'package:zoe/features/link/widgets/link_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class LinkListWidget extends ConsumerWidget {
  final ProviderBase<List<LinkModel>> linksProvider;
  final bool isEditing;
  final int? maxItems;

  const LinkListWidget({
    super.key,
    required this.linksProvider,
    required this.isEditing,
    this.maxItems,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final links = ref.watch(linksProvider);
    if (links.isEmpty) {
      return EmptyStateWidget(message: L10n.of(context).noLinksFound);
    }

    final itemCount = maxItems != null
        ? min(maxItems!, links.length)
        : links.length;

    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final link = links[index];
        return maxItems != null
            ? Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  child: LinkWidget(
                    key: Key(link.id),
                    linkId: link.id,
                    isEditing: false,
                  ),
                ),
              )
            : LinkWidget(
                key: ValueKey(link.id),
                linkId: link.id,
                isEditing: isEditing,
              );
      },
    );
  }
}
