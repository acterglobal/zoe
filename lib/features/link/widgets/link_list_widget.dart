import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/link/providers/link_providers.dart';
import 'package:zoey/features/link/widgets/link_widget.dart';

class LinkListWidget extends ConsumerWidget {
  final String parentId;
  final bool isEditing;

  const LinkListWidget({
    super.key,
    required this.parentId,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final links = ref.watch(linkByParentProvider(parentId));
    if (links.isEmpty) return const SizedBox.shrink();

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: links.length,
      itemBuilder: (context, index) {
        final link = links[index];
        return Padding(
          padding: const EdgeInsets.only(left: 24),
          child: LinkWidget(
            key: ValueKey(link.id),
            linkId: link.id,
            isEditing: isEditing,
          ),
        );
      },
    );
  }
}
