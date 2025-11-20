import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/content_menu_button.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_network_local_image_view.dart';
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

    final theme = Theme.of(context);
    
    // Use sheet theme if available, otherwise fall back to app theme
    final primaryColor = sheet?.theme?.primary ?? theme.colorScheme.primary;
    final secondaryColor = sheet?.theme?.secondary ?? theme.colorScheme.secondary;

    return SliverAppBar(
      expandedHeight: hasCoverImage ? 200 : 120,
      collapsedHeight: kToolbarHeight,
      automaticallyImplyLeading: false,
      title: _buildTitle(context, ref, hasCoverImage),
      elevation: 0,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      flexibleSpace: hasCoverImage
          ? FlexibleSpaceBar(
              background: ZoeNetworkLocalImageView(
                imageUrl: coverImageUrl,
                fit: BoxFit.cover,
                borderRadius: 0,
                placeholderIconSize: 120,
              ),
            )
          : FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryColor, secondaryColor],
                  ),
                ),
              ),
            ),
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
}
