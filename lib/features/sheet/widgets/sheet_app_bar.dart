import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/content_menu_button.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/features/sheet/actions/sheet_actions.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';

class SheetAppBar extends ConsumerWidget {
  final String sheetId;
  final bool isEditing;

  const SheetAppBar({
    super.key,
    required this.sheetId,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheet = ref.watch(sheetProvider(sheetId));
    final coverImageUrl = sheet?.coverImageUrl;
    final hasCoverImage = coverImageUrl != null && coverImageUrl.isNotEmpty;
    final isNetworkImage = coverImageUrl?.startsWith('http') ?? false;

    return SliverAppBar(
      expandedHeight: hasCoverImage ? 200 : kToolbarHeight,
      collapsedHeight: kToolbarHeight,
      automaticallyImplyLeading: false,
      title: _buildTitle(context, ref, hasCoverImage),
      elevation: 0,
      flexibleSpace: hasCoverImage
          ? FlexibleSpaceBar(
              background: isNetworkImage
                  ? _buildNetworkCoverImage(coverImageUrl)
                  : _buildFileCoverImage(coverImageUrl),
            )
          : null,
    );
  }

  Widget _buildTitle(BuildContext context, WidgetRef ref, bool hasCoverImage) {
    return ZoeAppBar(
      actions: [
        const SizedBox(width: 10),
        ContentMenuButton(
          onTap: (context) => showSheetMenu(
            context: context,
            ref: ref,
            hasCoverImage: hasCoverImage,
            isEditing: isEditing,
            sheetId: sheetId,
          ),
        ),
      ],
    );
  }

  Widget _buildFileCoverImage(String coverImageUrl) {
    return Image.file(
      File(coverImageUrl),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.broken_image_rounded, size: 80),
    );
  }

  Widget _buildNetworkCoverImage(String coverImageUrl) {
    return CachedNetworkImage(
      imageUrl: coverImageUrl,
      fit: BoxFit.cover,
      placeholder: (_, _) => const Center(child: CircularProgressIndicator()),
      errorWidget: (_, _, _) =>
          const Icon(Icons.broken_image_rounded, size: 80),
    );
  }
}
