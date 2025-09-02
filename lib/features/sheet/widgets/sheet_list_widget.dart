import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/widgets/sheet_list_item_widget.dart';

class SheetListWidget extends ConsumerWidget {
  final bool shrinkWrap;
  final bool isCompact;
  final int? maxItems;
  final Widget emptyState;

  const SheetListWidget({
    super.key,
    this.shrinkWrap = false,
    this.isCompact = false,
    this.maxItems,
    this.emptyState = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheetList = ref.watch(sheetListSearchProvider);
    if (sheetList.isEmpty) {
      return emptyState;
    }

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
}
