import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/quick-search/widgets/quick_search_tab_section_header_widget.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/widgets/sheet_list_item_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class SheetListWidget extends ConsumerWidget {
  final ProviderListenable<List<SheetModel>> sheetsProvider;
  final bool shrinkWrap;
  final bool isCompact;
  final int? maxItems;
  final Widget emptyState;
  final bool showSectionHeader;

  const SheetListWidget({
    super.key,
    required this.sheetsProvider,
    this.shrinkWrap = false,
    this.isCompact = false,
    this.maxItems,
    this.emptyState = const SizedBox.shrink(),
    this.showSectionHeader = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheetList = ref.watch(sheetsProvider);
    if (sheetList.isEmpty) {
      return emptyState;
    }

    if (showSectionHeader) {
      return Column(
        children: [
          _buildSectionHeader(context),
          const SizedBox(height: 16),
          _buildSheetList(context, ref, sheetList),
        ],
      );
    }

    return _buildSheetList(context, ref, sheetList);
  }

  Widget _buildSheetList(BuildContext context, WidgetRef ref, List<SheetModel> sheetList) {

    final itemCount = maxItems != null
        ? min(maxItems!, sheetList.length)
        : sheetList.length;

    return ListView.builder(
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      itemBuilder: (context, index) {
        final sheet = sheetList[index];
        return SheetListItemWidget(sheetId: sheet.id, isCompact: isCompact);
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return QuickSearchTabSectionHeaderWidget(
      title: L10n.of(context).sheets,
      icon: Icons.article_rounded,
      onTap: () => context.push(AppRoutes.sheetsList.route),
      color: AppColors.primaryColor,
    );
  }
}
