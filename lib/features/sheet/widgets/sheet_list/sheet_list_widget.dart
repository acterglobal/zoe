import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/providers/sheet_list_provider.dart';
import 'package:zoey/features/sheet/widgets/sheet_list/sheet_list_item_widget.dart';

class SheetListWidget extends ConsumerWidget {
  final bool shrinkWrap;
  const SheetListWidget({super.key, this.shrinkWrap = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheets = ref.watch(sheetListProvider);
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      itemCount: sheets.length,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      itemBuilder: (context, index) {
        final sheet = sheets[index];
        return SheetListItemWidget(sheet: sheet);
      },
    );
  }
}
