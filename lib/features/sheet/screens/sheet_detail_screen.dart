import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/app_bar/sheet_detail_app_bar.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/header/sheet_page_header.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/content/sheet_content_blocks.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/add_block/sheet_add_block.dart';

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
          SheetPageHeader(sheetId: sheetId),
          const SizedBox(height: 16),
          SheetContentBlocks(sheetId: sheetId),
          SheetAddBlock(sheetId: sheetId),
          const SizedBox(height: 200),
        ],
      ),
    );
  }
}
