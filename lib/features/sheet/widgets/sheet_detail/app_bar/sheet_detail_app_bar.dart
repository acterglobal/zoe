import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoey/core/routing/app_routes.dart';
import 'package:zoey/features/sheet/models/zoe_sheet_model.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/app_bar/edit_save_button_widget.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/app_bar/sheet_more_menu_widget.dart';

/// App bar widget for sheet detail screen
class SheetDetailAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final ZoeSheetModel currentSheet;
  final bool isEditing;
  final String? sheetId;
  final VoidCallback onEditSaveToggle;

  const SheetDetailAppBar({
    super.key,
    required this.currentSheet,
    required this.isEditing,
    required this.sheetId,
    required this.onEditSaveToggle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leading: _buildBackButton(context),
      actions: [
        EditSaveButtonWidget(isEditing: isEditing, onPressed: onEditSaveToggle),
        SheetMoreMenuWidget(currentSheet: currentSheet, sheetId: sheetId),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_rounded,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      onPressed: () => context.go(AppRoutes.home.route),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
