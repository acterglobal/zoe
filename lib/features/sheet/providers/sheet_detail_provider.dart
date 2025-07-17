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

/// State class for sheet detail
class SheetDetailState {
  final ZoeSheetModel sheet;
  final bool isEditing;
  final bool hasBeenSaved;
  final bool showAddMenu;
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  SheetDetailState({
    required this.sheet,
    required this.isEditing,
    required this.hasBeenSaved,
    required this.showAddMenu,
    required this.titleController,
    required this.descriptionController,
  });

  SheetDetailState copyWith({
    ZoeSheetModel? sheet,
    bool? isEditing,
    bool? hasBeenSaved,
    bool? showAddMenu,
    TextEditingController? titleController,
    TextEditingController? descriptionController,
  }) {
    return SheetDetailState(
      sheet: sheet ?? this.sheet,
      isEditing: isEditing ?? this.isEditing,
      hasBeenSaved: hasBeenSaved ?? this.hasBeenSaved,
      showAddMenu: showAddMenu ?? this.showAddMenu,
      titleController: titleController ?? this.titleController,
      descriptionController:
          descriptionController ?? this.descriptionController,
    );
  }
}

/// Notifier for sheet detail state
class SheetDetailNotifier extends StateNotifier<SheetDetailState> {
  final Ref ref;
  final String? sheetId;

  SheetDetailNotifier({required this.ref, required this.sheetId})
    : super(_createInitialState(ref, sheetId));

  /// Create initial state based on sheetId
  static SheetDetailState _createInitialState(Ref ref, String? sheetId) {
    ZoeSheetModel sheet;
    bool isEditing;
    bool hasBeenSaved;

    if (sheetId == null || sheetId == 'new') {
      sheet = ZoeSheetModel(title: 'Untitled', description: '', emoji: '📄');
      isEditing = true;
      hasBeenSaved = false;
    } else {
      final sheetListNotifier = ref.read(sheetListProvider.notifier);
      final existingSheet = sheetListNotifier.getSheetById(sheetId);

      if (existingSheet != null) {
        sheet = existingSheet;
        isEditing = false;
        hasBeenSaved = true;
      } else {
        sheet = ZoeSheetModel(
          title: 'Sheet Not Found',
          description: 'The requested sheet could not be found.',
        );
        isEditing = false;
        hasBeenSaved = false;
      }
    }

    return SheetDetailState(
      sheet: sheet,
      isEditing: isEditing,
      hasBeenSaved: hasBeenSaved,
      showAddMenu: false,
      titleController: TextEditingController(text: sheet.title),
      descriptionController: TextEditingController(text: sheet.description),
    );
  }

  /// Dispose controllers when notifier is disposed
  @override
  void dispose() {
    state.titleController.dispose();
    state.descriptionController.dispose();
    super.dispose();
  }

  /// Toggle edit/save mode
  void toggleEditSave() {
    if (state.isEditing) {
      _savePage();
      state = state.copyWith(isEditing: false, showAddMenu: false);
    } else {
      state = state.copyWith(isEditing: true);
    }
  }

  /// Update sheet emoji
  void updateEmoji() {
    final newEmoji = getNextEmoji(state.sheet.emoji);
    state = state.copyWith(sheet: state.sheet.copyWith(emoji: newEmoji));
  }

  /// Update sheet title
  void updateTitle(String value) {
    final newTitle = value.trim().isEmpty ? 'Untitled' : value;
    state = state.copyWith(sheet: state.sheet.copyWith(title: newTitle));
  }

  /// Update sheet description
  void updateDescription(String value) {
    state = state.copyWith(sheet: state.sheet.copyWith(description: value));
  }

  /// Reorder content blocks
  void reorderContentBlocks(int oldIndex, int newIndex) {
    final updatedSheet = state.sheet.copyWith();
    updatedSheet.reorderContentBlocks(oldIndex, newIndex);
    state = state.copyWith(sheet: updatedSheet);
  }

  /// Update content block
  void updateContentBlock(String blockId, ContentBlockModel updatedBlock) {
    final updatedSheet = state.sheet.copyWith();
    updatedSheet.updateContentBlock(blockId, updatedBlock);
    state = state.copyWith(sheet: updatedSheet);
  }

  /// Delete content block
  void deleteContentBlock(String blockId) {
    final updatedSheet = state.sheet.copyWith();
    updatedSheet.removeContentBlock(blockId);
    state = state.copyWith(sheet: updatedSheet);
  }

  /// Toggle add menu
  void toggleAddMenu() {
    state = state.copyWith(showAddMenu: !state.showAddMenu);
  }

  /// Hide add menu
  void hideAddMenu() {
    state = state.copyWith(showAddMenu: false);
  }

  /// Add content block
  void addContentBlock(ContentBlockType type) {
    final newBlock = _createContentBlock(type);
    final updatedSheet = state.sheet.copyWith();
    updatedSheet.addContentBlock(newBlock);
    state = state.copyWith(sheet: updatedSheet, showAddMenu: false);
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
    final updatedSheet = state.sheet.copyWith(
      title: state.titleController.text.trim().isEmpty
          ? 'Untitled'
          : state.titleController.text.trim(),
      description: state.descriptionController.text.trim(),
    );

    final sheetListNotifier = ref.read(sheetListProvider.notifier);

    if (!state.hasBeenSaved) {
      sheetListNotifier.addSheet(updatedSheet);
      state = state.copyWith(sheet: updatedSheet, hasBeenSaved: true);
    } else {
      sheetListNotifier.updateSheet(updatedSheet);
      state = state.copyWith(sheet: updatedSheet);
    }
  }
}

/// Provider for sheet detail state
final sheetDetailProvider =
    StateNotifierProvider.family<
      SheetDetailNotifier,
      SheetDetailState,
      String?
    >((ref, sheetId) => SheetDetailNotifier(ref: ref, sheetId: sheetId));

/// Convenience providers for specific parts of the state
final sheetProvider = Provider.family<ZoeSheetModel, String?>((ref, sheetId) {
  return ref.watch(sheetDetailProvider(sheetId)).sheet;
});

final isEditingProvider = Provider.family<bool, String?>((ref, sheetId) {
  return ref.watch(sheetDetailProvider(sheetId)).isEditing;
});

final showAddMenuProvider = Provider.family<bool, String?>((ref, sheetId) {
  return ref.watch(sheetDetailProvider(sheetId)).showAddMenu;
});

final hasBeenSavedProvider = Provider.family<bool, String?>((ref, sheetId) {
  return ref.watch(sheetDetailProvider(sheetId)).hasBeenSaved;
});

final titleControllerProvider = Provider.family<TextEditingController, String?>(
  (ref, sheetId) {
    return ref.watch(sheetDetailProvider(sheetId)).titleController;
  },
);

final descriptionControllerProvider =
    Provider.family<TextEditingController, String?>((ref, sheetId) {
      return ref.watch(sheetDetailProvider(sheetId)).descriptionController;
    });
