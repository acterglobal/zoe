import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/link/models/link_model.dart';
import 'package:zoe/features/link/widgets/link_widget.dart';

class LinkListWidget extends ConsumerWidget {
  final ProviderBase<List<LinkModel>> linksProvider;
  final bool isEditing;
  final int? maxItems;
  final bool shrinkWrap;
  final bool showCardView;
  final Widget emptyState;

  const LinkListWidget({
    super.key,
    required this.linksProvider,
    required this.isEditing,
    this.maxItems,
    this.shrinkWrap = true,
    this.showCardView = true,
    this.emptyState = const SizedBox.shrink(),

  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final links = ref.watch(linksProvider);
    if (links.isEmpty) {
      return emptyState;
    }

    final itemCount = maxItems != null
        ? min(maxItems!, links.length)
        : links.length;

    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final link = links[index];
        return showCardView
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
