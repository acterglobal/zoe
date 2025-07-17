import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/state/sheet_state_manager.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/app_bar/sheet_detail_app_bar.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/header/sheet_page_header.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/content/sheet_content_blocks.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/add_block/sheet_add_block.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/blocks/whatsapp_integration_bottomsheet.dart';

class SheetDetailScreen extends ConsumerStatefulWidget {
  final String? sheetId;

  const SheetDetailScreen({super.key, this.sheetId});

  @override
  ConsumerState<SheetDetailScreen> createState() => _SheetDetailScreenState();
}

class _SheetDetailScreenState extends ConsumerState<SheetDetailScreen> {
  late SheetStateManager _stateManager;

  @override
  void initState() {
    super.initState();
    _stateManager = SheetStateManager(ref: ref, sheetId: widget.sheetId);
    _stateManager.initialize();
  }

  @override
  void dispose() {
    _stateManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  /// Builds the app bar
  PreferredSizeWidget _buildAppBar() {
    return SheetDetailAppBar(
      currentSheet: _stateManager.currentSheet,
      isEditing: _stateManager.isEditing,
      hasBeenSaved: _stateManager.hasBeenSaved,
      sheetId: widget.sheetId,
      onEditSaveToggle: _handleEditSaveToggle,
      onWhatsAppTap: _showWhatsAppIntegration,
    );
  }

  /// Builds the main body
  Widget _buildBody() {
    return GestureDetector(
      onTap: _handleBodyTap,
      child: SingleChildScrollView(
        padding: _getBodyPadding(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPageHeader(),
            _getHeaderSpacing(),
            _buildContentBlocks(),
            _buildAddBlockArea(),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }

  /// Builds the page header
  Widget _buildPageHeader() {
    return SheetPageHeader(
      currentSheet: _stateManager.currentSheet,
      isEditing: _stateManager.isEditing,
      titleController: _stateManager.titleController,
      descriptionController: _stateManager.descriptionController,
      onTitleChanged: _handleTitleChange,
      onDescriptionChanged: _handleDescriptionChange,
      onEmojiTap: _handleEmojiTap,
    );
  }

  /// Builds the content blocks
  Widget _buildContentBlocks() {
    return SheetContentBlocks(
      currentSheet: _stateManager.currentSheet,
      isEditing: _stateManager.isEditing,
      onReorder: _handleContentBlockReorder,
      onUpdate: _handleContentBlockUpdate,
      onDelete: _handleContentBlockDelete,
    );
  }

  /// Builds the add block area
  Widget _buildAddBlockArea() {
    return SheetAddBlock(
      isEditing: _stateManager.isEditing,
      showAddMenu: _stateManager.showAddMenu,
      onTriggerTap: _handleAddBlockTriggerTap,
      onAddBlock: _handleAddContentBlock,
    );
  }

  /// Gets responsive padding for the body
  EdgeInsets _getBodyPadding() {
    final isWideScreen = MediaQuery.of(context).size.width > 600;
    final horizontalPadding = isWideScreen ? 32.0 : 16.0;
    return EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 100);
  }

  /// Gets responsive spacing after header
  Widget _getHeaderSpacing() {
    final isWideScreen = MediaQuery.of(context).size.width > 600;
    return SizedBox(height: isWideScreen ? 48 : 32);
  }

  // Event Handlers

  /// Handles edit/save toggle
  void _handleEditSaveToggle() {
    setState(() {
      _stateManager.toggleEditSave();
    });
  }

  /// Handles body tap to hide add menu
  void _handleBodyTap() {
    if (_stateManager.showAddMenu) {
      setState(() {
        _stateManager.hideAddMenu();
      });
    }
  }

  /// Handles emoji tap
  void _handleEmojiTap() {
    setState(() {
      _stateManager.handleEmojiTap();
    });
  }

  /// Handles title changes
  void _handleTitleChange(String value) {
    _stateManager.handleTitleChange(value);
  }

  /// Handles description changes
  void _handleDescriptionChange(String value) {
    _stateManager.handleDescriptionChange(value);
  }

  /// Handles content block reordering
  void _handleContentBlockReorder(int oldIndex, int newIndex) {
    setState(() {
      _stateManager.handleContentBlockReorder(oldIndex, newIndex);
    });
  }

  /// Handles content block updates
  void _handleContentBlockUpdate(String blockId, updatedBlock) {
    setState(() {
      _stateManager.handleContentBlockUpdate(blockId, updatedBlock);
    });
  }

  /// Handles content block deletion
  void _handleContentBlockDelete(String blockId) {
    setState(() {
      _stateManager.handleContentBlockDelete(blockId);
    });
  }

  /// Handles add block trigger tap
  void _handleAddBlockTriggerTap() {
    setState(() {
      _stateManager.toggleAddMenu();
    });
  }

  /// Handles adding a new content block
  void _handleAddContentBlock(type) {
    setState(() {
      _stateManager.addContentBlock(type);
    });
  }

  /// Shows WhatsApp integration bottom sheet
  void _showWhatsAppIntegration() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WhatsAppIntegrationBottomSheet(
        currentSheet: _stateManager.currentSheet,
        onConnectionChanged: (isConnected) {
          setState(() {
            _stateManager.handleWhatsAppConnectionChange(isConnected);
          });
        },
      ),
    );
  }
}
