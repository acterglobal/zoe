import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/link/models/link_model.dart';
import 'package:zoe/features/link/widgets/link_widget.dart';
import 'package:zoe/features/quick-search/widgets/quick_search_tab_section_header_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class LinkListWidget extends ConsumerWidget {
  final ProviderListenable<List<LinkModel>> linksProvider;
  final bool isEditing;
  final int? maxItems;
  final bool shrinkWrap;
  final bool showCardView;
  final Widget emptyState;
  final bool showSectionHeader;

  const LinkListWidget({
    super.key,
    required this.linksProvider,
    required this.isEditing,
    this.maxItems,
    this.shrinkWrap = true,
    this.showCardView = true,
    this.emptyState = const SizedBox.shrink(),
    this.showSectionHeader = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final links = ref.watch(linksProvider);
    if (links.isEmpty) {
      return emptyState;
    }

    if (showSectionHeader) {
      return Column(
        children: [
          _buildSectionHeader(context),
          const SizedBox(height: 16),
          _buildLinkList(context, ref, links),
        ],
      );
    }

    return _buildLinkList(context, ref, links);
  }

  Widget _buildLinkList(BuildContext context, WidgetRef ref, List<LinkModel> links) {

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

  Widget _buildSectionHeader(BuildContext context) {
    return QuickSearchTabSectionHeaderWidget(
      title: L10n.of(context).links,
      icon: Icons.link_rounded,
      onTap: () => context.push(AppRoutes.linksList.route),
      color: Colors.blueAccent,
    );
  }
}
