import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/block/model/block_model.dart';
import 'package:zoey/features/sheet/models/zoe_sheet_model.dart';
import 'package:zoey/features/sheet/providers/sheet_list_provider.dart';
import 'package:zoey/features/sheet/actions/sheet_actions.dart';
import 'package:zoey/features/text_block/models/text_block_model.dart';
import 'package:zoey/features/todos/models/todos_content_model.dart';
import 'package:zoey/features/events/models/events_content_model.dart';
import 'package:zoey/features/list_block/models/list_block_model.dart';
import 'package:zoey/features/text_block/providers/text_block_list_provider.dart';
import 'package:zoey/features/todos/providers/todos_content_list_provider.dart';
import 'package:zoey/features/events/providers/events_content_list_provider.dart';
import 'package:zoey/features/list_block/providers/list_block_list_provider.dart';
import 'package:uuid/uuid.dart';

/// State class for sheet detail
class SheetDetailState {
  final ZoeSheetModel sheet;
  final bool isEditing;
  final bool showAddMenu;

  SheetDetailState({
    required this.sheet,
    required this.isEditing,
    required this.showAddMenu,
  });

  SheetDetailState copyWith({
    ZoeSheetModel? sheet,
    bool? isEditing,
    bool? showAddMenu,
    TextEditingController? titleController,
    TextEditingController? descriptionController,
  }) {
    return SheetDetailState(
      sheet: sheet ?? this.sheet,
      isEditing: isEditing ?? this.isEditing,
      showAddMenu: showAddMenu ?? this.showAddMenu,
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

    if (sheetId == null || sheetId == 'new') {
      sheet = ZoeSheetModel(title: 'Untitled', description: '', emoji: '📄');
      isEditing = true;
    } else {
      final sheetListNotifier = ref.read(sheetListProvider.notifier);
      final existingSheet = sheetListNotifier.getSheetById(sheetId);

      if (existingSheet != null) {
        sheet = existingSheet;
        isEditing = false;
      } else {
        sheet = ZoeSheetModel(
          title: 'Sheet Not Found',
          description: 'The requested sheet could not be found.',
        );
        isEditing = false;
      }
    }

    return SheetDetailState(
      sheet: sheet,
      isEditing: isEditing,
      showAddMenu: false,
    );
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

  /// Reorder content
  void reorderContent(int oldIndex, int newIndex) {
    final updatedSheet = state.sheet.copyWith();
    updatedSheet.reorderContent(oldIndex, newIndex);
    state = state.copyWith(sheet: updatedSheet);
  }

  /// Delete content by ID
  void deleteBlock(String blockId) {
    final updatedSheet = state.sheet.copyWith();
    updatedSheet.removeContentId(blockId);
    state = state.copyWith(sheet: updatedSheet);

    // Also remove from the appropriate content list provider
    if (blockId.startsWith('text-')) {
      ref.read(textBlockListProvider.notifier).removeBlock(blockId);
    } else if (blockId.startsWith('todos-')) {
      ref.read(todosContentListProvider.notifier).removeContent(blockId);
    } else if (blockId.startsWith('events-')) {
      ref.read(eventsContentListProvider.notifier).removeContent(blockId);
    } else if (blockId.startsWith('list-')) {
      ref.read(listBlockListProvider.notifier).removeBlock(blockId);
    }
  }

  /// Toggle add menu
  void toggleAddMenu() {
    state = state.copyWith(showAddMenu: !state.showAddMenu);
  }

  /// Hide add menu
  void hideAddMenu() {
    state = state.copyWith(showAddMenu: false);
  }

  /// Add content by type
  void addContent(BlockType type) {
    final contentId = _createContent(type);
    final updatedSheet = state.sheet.copyWith();
    updatedSheet.addContentId(contentId);
    state = state.copyWith(sheet: updatedSheet, showAddMenu: false);
  }

  /// Create content and return its ID
  String _createContent(BlockType type) {
    final contentId = const Uuid().v4();

    // Use correct prefixes that match the content detection logic
    String prefix;
    switch (type) {
      case BlockType.todo:
        prefix = 'todos';
        break;
      case BlockType.event:
        prefix = 'events';
        break;
      case BlockType.list:
        prefix = 'list';
        break;
      case BlockType.text:
        prefix = 'text';
        break;
    }

    final formattedId = '$prefix-$contentId';

    // Create actual content using StateNotifier providers
    switch (type) {
      case BlockType.todo:
        final newTodo = TodosContentModel(
          parentId: state.sheet.id,
          id: formattedId,
          title: 'To-do',
          items: [TodoItem(title: '')],
        );
        ref.read(todosContentListProvider.notifier).addContent(newTodo);
        break;
      case BlockType.event:
        final newEvent = EventsContentModel(
          parentId: state.sheet.id,
          id: formattedId,
          title: 'Events',
          events: [EventItem(title: '')],
        );
        ref.read(eventsContentListProvider.notifier).addContent(newEvent);
        break;
      case BlockType.list:
        final newBullets = ListBlockModel(
          parentId: state.sheet.id,
          id: formattedId,
          title: 'List',
        );
        ref.read(listBlockListProvider.notifier).addBlock(newBullets);
        break;
      case BlockType.text:
        final newText = TextBlockModel(
          parentId: state.sheet.id,
          id: formattedId,
          title: 'Text Block',
          plainTextDescription: '',
          htmlDescription: '',
        );
        ref.read(textBlockListProvider.notifier).addBlock(newText);
        break;
    }

    return formattedId;
  }

  /// Save the current sheet
  void _savePage() {
    final updatedSheet = state.sheet.copyWith(
      title: state.sheet.title.trim().isEmpty
          ? 'Untitled'
          : state.sheet.title.trim(),
      description: state.sheet.description.trim(),
    );

    final sheetListNotifier = ref.read(sheetListProvider.notifier);

    if (sheetId == null || sheetId == 'new') {
      sheetListNotifier.addSheet(updatedSheet);
    } else {
      sheetListNotifier.updateSheet(updatedSheet);
    }

    state = state.copyWith(sheet: updatedSheet);
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
