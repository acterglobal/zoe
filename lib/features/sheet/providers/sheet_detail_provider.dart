import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/models/content_block.dart';
import 'package:zoey/features/sheet/models/zoe_sheet_model.dart';
import 'package:zoey/features/sheet/providers/sheet_list_provider.dart';
import 'package:zoey/features/sheet/actions/sheet_actions.dart';
import 'package:zoey/features/text/models/text_content_model.dart';
import 'package:zoey/features/todos/models/todos_content_model.dart';
import 'package:zoey/features/events/models/events_content_model.dart';
import 'package:zoey/features/bullet-lists/models/bullets_content_model.dart';
import 'package:zoey/features/text/data/text_content_list.dart';
import 'package:zoey/features/todos/data/todos_content_list.dart';
import 'package:zoey/features/events/data/events_content_list.dart';
import 'package:zoey/features/bullet-lists/data/bullets_content_list.dart';
import 'package:uuid/uuid.dart';

/// State class for sheet detail
class SheetDetailState {
  final ZoeSheetModel sheet;
  final bool isEditing;
  final bool showAddMenu;
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  SheetDetailState({
    required this.sheet,
    required this.isEditing,
    required this.showAddMenu,
    required this.titleController,
    required this.descriptionController,
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

  /// Reorder content
  void reorderContent(int oldIndex, int newIndex) {
    final updatedSheet = state.sheet.copyWith();
    updatedSheet.reorderContent(oldIndex, newIndex);
    state = state.copyWith(sheet: updatedSheet);
  }

  /// Delete content by ID
  void deleteContent(String contentId) {
    final updatedSheet = state.sheet.copyWith();
    updatedSheet.removeContentId(contentId);
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

  /// Add content by type
  void addContent(ContentType type) {
    final contentId = _createContent(type);
    final updatedSheet = state.sheet.copyWith();
    updatedSheet.addContentId(contentId);
    state = state.copyWith(sheet: updatedSheet, showAddMenu: false);
  }

  /// Create content and return its ID
  String _createContent(ContentType type) {
    final contentId = const Uuid().v4();

    // Use correct prefixes that match the content detection logic
    String prefix;
    switch (type) {
      case ContentType.todo:
        prefix = 'todos';
        break;
      case ContentType.event:
        prefix = 'events';
        break;
      case ContentType.bullet:
        prefix = 'bullets';
        break;
      case ContentType.text:
        prefix = 'text';
        break;
    }

    final formattedId = '$prefix-$contentId';

    // Create actual content in the appropriate content list
    switch (type) {
      case ContentType.todo:
        final newTodo = TodosContentModel(
          parentId: state.sheet.id,
          id: formattedId,
          title: 'To-do',
          items: [TodoItem(title: '')],
        );
        todosContentList.add(newTodo);
        break;
      case ContentType.event:
        final newEvent = EventsContentModel(
          parentId: state.sheet.id,
          id: formattedId,
          title: 'Events',
          events: [EventItem(title: '')],
        );
        eventsContentList.add(newEvent);
        break;
      case ContentType.bullet:
        final newBullets = BulletsContentModel(
          parentId: state.sheet.id,
          id: formattedId,
          title: 'List',
          bullets: [''],
        );
        bulletsContentList.add(newBullets);
        break;
      case ContentType.text:
        final newText = TextContentModel(
          parentId: state.sheet.id,
          id: formattedId,
          title: 'Text Block',
          data: '',
        );
        textContentList.add(newText);
        break;
    }

    return formattedId;
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

final titleControllerProvider = Provider.family<TextEditingController, String?>(
  (ref, sheetId) {
    return ref.watch(sheetDetailProvider(sheetId)).titleController;
  },
);

final descriptionControllerProvider =
    Provider.family<TextEditingController, String?>((ref, sheetId) {
      return ref.watch(sheetDetailProvider(sheetId)).descriptionController;
    });
