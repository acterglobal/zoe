import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/models/content_block/content_block.dart';
import 'package:zoey/features/sheet/models/content_block/event_block_model.dart';
import 'package:zoey/features/sheet/models/content_block/list_block_model.dart';
import 'package:zoey/features/sheet/models/content_block/text_block_model.dart';
import 'package:zoey/features/sheet/models/content_block/todo_block_model.dart';
import 'package:zoey/features/sheet/models/zoe_sheet_model.dart';
import 'package:zoey/features/sheet/providers/sheet_list_provider.dart';
import 'package:zoey/features/sheet/actions/sheet_actions.dart';

/// State manager for sheet detail operations
class SheetStateManager {
  final WidgetRef ref;
  final String? sheetId;

  late ZoeSheetModel _currentSheet;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isEditing = false;
  bool _hasBeenSaved = false;
  bool _showAddMenu = false;

  SheetStateManager({required this.ref, required this.sheetId});

  // Getters
  ZoeSheetModel get currentSheet => _currentSheet;
  TextEditingController get titleController => _titleController;
  TextEditingController get descriptionController => _descriptionController;
  bool get isEditing => _isEditing;
  bool get hasBeenSaved => _hasBeenSaved;
  bool get showAddMenu => _showAddMenu;

  /// Initialize the sheet state
  void initialize() {
    if (sheetId == null || sheetId == 'new') {
      _currentSheet = ZoeSheetModel(
        title: 'Untitled',
        description: '',
        emoji: '📄',
      );
      _isEditing = true;
      _hasBeenSaved = false;
    } else {
      final sheetListNotifier = ref.read(sheetListProvider.notifier);
      final existingSheet = sheetListNotifier.getSheetById(sheetId!);

      if (existingSheet != null) {
        _currentSheet = existingSheet;
        _isEditing = false;
        _hasBeenSaved = true;
      } else {
        _currentSheet = ZoeSheetModel(
          title: 'Sheet Not Found',
          description: 'The requested sheet could not be found.',
        );
        _isEditing = false;
        _hasBeenSaved = false;
      }
    }

    _titleController = TextEditingController(text: _currentSheet.title);
    _descriptionController = TextEditingController(
      text: _currentSheet.description,
    );
  }

  /// Dispose controllers
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
  }

  /// Toggle edit/save mode
  void toggleEditSave() {
    if (_isEditing) {
      _savePage();
      _isEditing = false;
      _showAddMenu = false;
    } else {
      _isEditing = true;
    }
  }

  /// Handle emoji tap
  void handleEmojiTap() {
    _currentSheet = _currentSheet.copyWith(
      emoji: getNextEmoji(_currentSheet.emoji),
    );
  }

  /// Handle title change
  void handleTitleChange(String value) {
    _currentSheet = _currentSheet.copyWith(
      title: value.trim().isEmpty ? 'Untitled' : value,
    );
  }

  /// Handle description change
  void handleDescriptionChange(String value) {
    _currentSheet = _currentSheet.copyWith(description: value);
  }

  /// Handle content block reorder
  void handleContentBlockReorder(int oldIndex, int newIndex) {
    _currentSheet.reorderContentBlocks(oldIndex, newIndex);
  }

  /// Handle content block update
  void handleContentBlockUpdate(
    String blockId,
    ContentBlockModel updatedBlock,
  ) {
    _currentSheet.updateContentBlock(blockId, updatedBlock);
  }

  /// Handle content block delete
  void handleContentBlockDelete(String blockId) {
    _currentSheet.removeContentBlock(blockId);
  }

  /// Toggle add menu
  void toggleAddMenu() {
    _showAddMenu = !_showAddMenu;
  }

  /// Hide add menu
  void hideAddMenu() {
    _showAddMenu = false;
  }

  /// Add content block
  void addContentBlock(ContentBlockType type) {
    final newBlock = _createContentBlock(type);
    _currentSheet.addContentBlock(newBlock);
    _showAddMenu = false;
  }

  /// Handle WhatsApp connection change
  void handleWhatsAppConnectionChange(bool isConnected) {
    _currentSheet = _currentSheet.copyWith(isWhatsAppConnected: isConnected);

    if (_hasBeenSaved) {
      final sheetListNotifier = ref.read(sheetListProvider.notifier);
      sheetListNotifier.updateSheet(_currentSheet);
    }
  }

  /// Create content block based on type
  ContentBlockModel _createContentBlock(ContentBlockType type) {
    switch (type) {
      case ContentBlockType.todo:
        return TodoBlockModel(
          title: 'To-do',
          items: [TodoItem(text: '')],
        );
      case ContentBlockType.event:
        return EventBlockModel(
          title: 'Events',
          events: [EventItem(title: '', startTime: DateTime.now())],
        );
      case ContentBlockType.list:
        return ListBlockModel(title: 'List', items: ['']);
      case ContentBlockType.text:
        return TextBlockModel(title: 'Text Block', content: '');
    }
  }

  /// Save the current sheet
  void _savePage() {
    final updatedSheet = _currentSheet.copyWith(
      title: _titleController.text.trim().isEmpty
          ? 'Untitled'
          : _titleController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    final sheetListNotifier = ref.read(sheetListProvider.notifier);

    if (!_hasBeenSaved) {
      sheetListNotifier.addSheet(updatedSheet);
      _hasBeenSaved = true;
    } else {
      sheetListNotifier.updateSheet(updatedSheet);
    }

    _currentSheet = updatedSheet;
  }
}
