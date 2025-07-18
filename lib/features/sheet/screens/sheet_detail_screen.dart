import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/add_content_menu.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/sheet_detail_app_bar.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/sheet_description_widget.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/sheet_contents.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/sheet_title_widget.dart';

class SheetDetailScreen extends ConsumerWidget {
  final String? sheetId;

  const SheetDetailScreen({super.key, this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: SheetDetailAppBar(sheetId: sheetId),
      body: _buildBody(context, ref),
    );
  }

  /// Builds the main body
  Widget _buildBody(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, ref),
          const SizedBox(height: 16),
          SheetContents(sheetId: sheetId),
          _buildAddContentArea(context, ref),
          const SizedBox(height: 200),
        ],
      ),
    );
  }

  /// Builds the header
  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () =>
                  ref.read(sheetDetailProvider(sheetId).notifier).updateEmoji(),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  ref.watch(sheetProvider(sheetId)).emoji ?? '📄',
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(child: SheetTitleWidget(sheetId: sheetId)),
          ],
        ),
        const SizedBox(height: 16),
        SheetDescriptionWidget(sheetId: sheetId),
      ],
    );
  }

  /// Builds the add content area
  Widget _buildAddContentArea(BuildContext context, WidgetRef ref) {
    final showAddMenu = ref.watch(sheetDetailProvider(sheetId)).showAddMenu;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () =>
              ref.read(sheetDetailProvider(sheetId).notifier).toggleAddMenu(),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Row(
              children: [
                Icon(showAddMenu ? Icons.close : Icons.add, size: 20),
                const SizedBox(width: 8),
                Text(showAddMenu ? 'Cancel' : 'Add content'),
              ],
            ),
          ),
        ),
        if (showAddMenu) AddContentMenu(sheetId: sheetId),
      ],
    );
  }
}
