import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/widgets/sheet_list_item_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class SheetListWidget extends ConsumerWidget {
  final bool shrinkWrap;
  const SheetListWidget({super.key, this.shrinkWrap = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheetList = ref.watch(sheetListSearchProvider);
    if (sheetList.isEmpty) {
      return EmptyStateWidget(message: L10n.of(context).noSheetsFound);
    }

    return ListView.builder(
      shrinkWrap: shrinkWrap,
      itemCount: sheetList.length,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      itemBuilder: (context, index) {
        final sheet = sheetList[index];
        return SheetListItemWidget(sheetId: sheet.id);
      },
    );
  }
}
