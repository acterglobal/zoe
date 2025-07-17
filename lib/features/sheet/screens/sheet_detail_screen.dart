import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/app_bar/sheet_detail_app_bar.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/header/sheet_page_header.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/content/sheet_content_blocks.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/add_block/sheet_add_block.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/blocks/whatsapp_integration_bottomsheet.dart';

class SheetDetailScreen extends ConsumerWidget {
  final String? sheetId;

  const SheetDetailScreen({super.key, this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: _buildAppBar(context, ref),
      body: _buildBody(context, ref),
    );
  }

  /// Builds the app bar
  PreferredSizeWidget _buildAppBar(BuildContext context, WidgetRef ref) {
    final currentSheet = ref.watch(sheetProvider(sheetId));
    final isEditing = ref.watch(isEditingProvider(sheetId));
    final hasBeenSaved = ref.watch(hasBeenSavedProvider(sheetId));

    return SheetDetailAppBar(
      currentSheet: currentSheet,
      isEditing: isEditing,
      hasBeenSaved: hasBeenSaved,
      sheetId: sheetId,
      onEditSaveToggle: () =>
          ref.read(sheetDetailProvider(sheetId).notifier).toggleEditSave(),
      onWhatsAppTap: () => _showWhatsAppIntegration(context, ref),
    );
  }

  /// Builds the main body
  Widget _buildBody(BuildContext context, WidgetRef ref) {
    final showAddMenu = ref.watch(showAddMenuProvider(sheetId));

    return GestureDetector(
      onTap: () => _handleBodyTap(ref, showAddMenu),
      child: SingleChildScrollView(
        padding: _getBodyPadding(context),
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

  /// Gets responsive padding for the body
  EdgeInsets _getBodyPadding(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;
    final horizontalPadding = isWideScreen ? 32.0 : 16.0;
    return EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 100);
  }

  /// Gets responsive spacing after header
  Widget _getHeaderSpacing(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;
    return SizedBox(height: isWideScreen ? 48 : 32);
  }

  /// Handles body tap to hide add menu
  void _handleBodyTap(WidgetRef ref, bool showAddMenu) {
    if (showAddMenu) {
      ref.read(sheetDetailProvider(sheetId).notifier).hideAddMenu();
    }
  }

  /// Shows WhatsApp integration bottom sheet
  void _showWhatsAppIntegration(BuildContext context, WidgetRef ref) {
    final currentSheet = ref.read(sheetProvider(sheetId));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WhatsAppIntegrationBottomSheet(
        currentSheet: currentSheet,
        onConnectionChanged: (isConnected) {
          ref
              .read(sheetDetailProvider(sheetId).notifier)
              .updateWhatsAppConnection(isConnected);
        },
      ),
    );
  }
}
