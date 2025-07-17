import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';
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
      appBar: SheetDetailAppBar(sheetId: sheetId ?? 'new'),
      body: _buildBody(context, ref),
    );
  }

  /// Builds the main body
  Widget _buildBody(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPageHeader(context, ref),
          _getHeaderSpacing(context),
          _buildContentBlocks(context, ref),
          _buildAddBlockArea(context, ref),
          const SizedBox(height: 200),
        ],
      ),
    );
  }

  /// Builds the page header
  Widget _buildPageHeader(BuildContext context, WidgetRef ref) {
    final currentSheet = ref.watch(sheetProvider(sheetId));
    final isEditing = ref.watch(isEditingProvider(sheetId));
    final titleController = ref.watch(titleControllerProvider(sheetId));
    final descriptionController = ref.watch(
      descriptionControllerProvider(sheetId),
    );

    return SheetPageHeader(
      currentSheet: currentSheet,
      isEditing: isEditing,
      titleController: titleController,
      descriptionController: descriptionController,
      onTitleChanged: (value) =>
          ref.read(sheetDetailProvider(sheetId).notifier).updateTitle(value),
      onDescriptionChanged: (value) => ref
          .read(sheetDetailProvider(sheetId).notifier)
          .updateDescription(value),
      onEmojiTap: () =>
          ref.read(sheetDetailProvider(sheetId).notifier).updateEmoji(),
    );
  }

  /// Builds the content blocks
  Widget _buildContentBlocks(BuildContext context, WidgetRef ref) {
    final currentSheet = ref.watch(sheetProvider(sheetId));
    final isEditing = ref.watch(isEditingProvider(sheetId));

    return SheetContentBlocks(
      currentSheet: currentSheet,
      isEditing: isEditing,
      onReorder: (oldIndex, newIndex) => ref
          .read(sheetDetailProvider(sheetId).notifier)
          .reorderContentBlocks(oldIndex, newIndex),
      onUpdate: (blockId, updatedBlock) => ref
          .read(sheetDetailProvider(sheetId).notifier)
          .updateContentBlock(blockId, updatedBlock),
      onDelete: (blockId) => ref
          .read(sheetDetailProvider(sheetId).notifier)
          .deleteContentBlock(blockId),
    );
  }

  /// Builds the add block area
  Widget _buildAddBlockArea(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(isEditingProvider(sheetId));
    final showAddMenu = ref.watch(showAddMenuProvider(sheetId));

    return SheetAddBlock(
      isEditing: isEditing,
      showAddMenu: showAddMenu,
      onTriggerTap: () =>
          ref.read(sheetDetailProvider(sheetId).notifier).toggleAddMenu(),
      onAddBlock: (type) =>
          ref.read(sheetDetailProvider(sheetId).notifier).addContentBlock(type),
    );
  }

  /// Gets responsive spacing after header
  Widget _getHeaderSpacing(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;
    return SizedBox(height: isWideScreen ? 48 : 32);
  }
}
