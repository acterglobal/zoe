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
    final secondaryColor =
        sheet?.theme?.secondary ?? theme.colorScheme.secondary;

    return SliverAppBar(
      expandedHeight: 200,
      collapsedHeight: kToolbarHeight,
      automaticallyImplyLeading: false,
      title: _buildTitle(context, ref, hasCoverImage),
      elevation: 0,
      pinned: true,
      backgroundColor: theme.colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        background: _buildFlexibleBackground(
          context,
          hasCoverImage,
          coverImageUrl,
          primaryColor,
          secondaryColor,
          ref,
        ),
      ),
    );
  }

  Widget _buildFlexibleBackground(
    BuildContext context,
    bool hasCoverImage,
    String? coverImageUrl,
    Color primaryColor,
    Color secondaryColor,
    WidgetRef ref,
  ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        hasCoverImage
            ? ZoeNetworkLocalImageView(
                imageUrl: coverImageUrl!,
                borderRadius: 0,
                fit: BoxFit.cover,
                placeholderIconSize: 120,
              )
            : _buildColorGradient(primaryColor, secondaryColor),
        if (isEditing) _buildCoverImageAction(ref, hasCoverImage),
      ],
    );
  }

  Widget _buildColorGradient(Color primary, Color secondary) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildCoverImageAction(WidgetRef ref, bool hasCoverImage) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: ContentMenuButton(
        icon: Icons.photo_library,
        onTap: (context) => SheetActions.addOrUpdateCoverImage(
          context,
          ref,
          sheetId,
          hasCoverImage,
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
