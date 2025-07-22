import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/models/base_content_model.dart';
import 'package:zoey/features/list/models/list_model.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';
import 'package:zoey/features/sheet/providers/sheet_list_provider.dart';
import 'package:zoey/features/sheet/actions/sheet_actions.dart';
import 'package:zoey/features/text/models/text_content_model.dart';
import 'package:zoey/features/events/models/events_model.dart';
import 'package:zoey/features/text/providers/text_content_list_provider.dart';
import 'package:zoey/features/task/providers/task_list_providers.dart';
import 'package:zoey/features/events/providers/events_list_provider.dart';
import 'package:zoey/features/list/providers/lists_provider.dart';
import 'package:uuid/uuid.dart';

/// State class for sheet detail
class SheetDetailState {
  final SheetModel sheet;
  final bool isEditing;
  final bool showAddMenu;

  SheetDetailState({
    required this.sheet,
    required this.isEditing,
    required this.showAddMenu,
  });

  SheetDetailState copyWith({
    SheetModel? sheet,
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
    SheetModel sheet;
    bool isEditing;

    if (sheetId == null || sheetId == 'new') {
      sheet = SheetModel(title: 'Untitled', description: '', emoji: '📄');
      isEditing = true;
    } else {
      final sheetListNotifier = ref.read(sheetListProvider.notifier);
      final existingSheet = sheetListNotifier.getSheetById(sheetId);

      if (existingSheet != null) {
        sheet = existingSheet;
        isEditing = false;
      } else {
        sheet = SheetModel(
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
  void deleteContent(String contentId) {
    final updatedSheet = state.sheet.copyWith();
    updatedSheet.removeContentId(contentId);
    state = state.copyWith(sheet: updatedSheet);

    // Also remove from the appropriate content list provider
    if (contentId.startsWith('text-')) {
      ref.read(textContentListProvider.notifier).removeTextContent(contentId);
    } else if (contentId.startsWith('todos-')) {
      ref.read(taskListProvider.notifier).deleteTask(contentId);
    } else if (contentId.startsWith('events-')) {
      ref.read(eventsListProvider.notifier).deleteEvent(contentId);
    } else if (contentId.startsWith('list-')) {
      ref.read(listsProvider.notifier).removeBlock(contentId);
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
      case ContentType.text:
        prefix = 'text';
        break;
      case ContentType.event:
        prefix = 'events';
        break;
      case ContentType.list:
        prefix = 'list';
        break;
    }

    final formattedId = '$prefix-$contentId';

    // Create actual content using StateNotifier providers
    switch (type) {
      case ContentType.text:
        final newText = TextContentModel(
          sheetId: state.sheet.id,
          id: formattedId,
          title: 'Text Block',
          plainTextDescription: '',
          htmlDescription: '',
        );
        ref.read(textContentListProvider.notifier).addTextContent(newText);
        break;
      case ContentType.event:
        final newEvent = EventModel(
          sheetId: state.sheet.id,
          id: formattedId,
          title: 'Events',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(hours: 1)),
        );
        ref.read(eventsListProvider.notifier).addEvent(newEvent);
        break;
      case ContentType.list:
        final newBullets = ListModel(
          sheetId: state.sheet.id,
          id: formattedId,
          title: 'List',
          listType: ListType.bulleted,
        );
        ref.read(listsProvider.notifier).addList(newBullets);
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
final sheetProvider = Provider.family<SheetModel, String?>((ref, sheetId) {
  return ref.watch(sheetDetailProvider(sheetId)).sheet;
});

final isEditingProvider = Provider.family<bool, String?>((ref, sheetId) {
  return ref.watch(sheetDetailProvider(sheetId)).isEditing;
});

final showAddMenuProvider = Provider.family<bool, String?>((ref, sheetId) {
  return ref.watch(sheetDetailProvider(sheetId)).showAddMenu;
});
