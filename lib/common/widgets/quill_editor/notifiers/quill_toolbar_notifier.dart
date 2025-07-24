import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../actions/quill_actions.dart';

/// Represents the state of the Quill toolbar, including which editor is active
/// and whether the toolbar should be visible
typedef QuillToolbarState = ({
  QuillController? activeController,  // The currently active editor's controller
  FocusNode? activeFocusNode,        // The currently active editor's focus node
  bool isToolbarVisible,             // Whether the toolbar should be shown
  String? activeEditorId,            // Unique ID of the active editor
});

/// Manages the global state of the Quill toolbar across multiple editor instances.
/// This notifier ensures that:
/// 1. Only one editor's toolbar is visible at a time
/// 2. Toolbar visibility transitions smoothly between editors
/// 3. Focus changes are properly debounced to prevent flickering
/// 4. Editor state is properly cleaned up when focus is lost
class QuillToolbarNotifier extends StateNotifier<QuillToolbarState> {
  Timer? _focusTimer;
  String? _lastActiveEditorId;

  QuillToolbarNotifier() : super((
    activeController: null,
    activeFocusNode: null, 
    isToolbarVisible: false,
    activeEditorId: null,
  ));

  /// Update the active editor and focus state
  void updateActiveEditor({
    required String editorId,
    QuillController? controller,
    FocusNode? focusNode,
  }) {
    // Cancel any pending focus timer
    _focusTimer?.cancel();

    // Validate FocusNode and get focus state using centralized functions
    final isValidFocusNode = isFocusNodeValid(focusNode);
    final isFocused = getFocusState(focusNode);

    // If this is a different editor than the last active one, update immediately
    if (_lastActiveEditorId != editorId) {
      _lastActiveEditorId = editorId;
      state = (
        activeController: isValidFocusNode ? controller : null,
        activeFocusNode: isValidFocusNode ? focusNode : null,
        isToolbarVisible: isFocused,
        activeEditorId: editorId,
      );
      return;
    }

    // For the same editor, use the focus state to determine visibility
    state = (
      activeController: isValidFocusNode ? controller : null,
      activeFocusNode: isValidFocusNode ? focusNode : null,
      isToolbarVisible: isFocused,
      activeEditorId: editorId,
    );
  }

  /// Clear the active editor (when losing focus)  
  void clearActiveEditor(String editorId) {
    // Only clear if this is the currently active editor
    if (state.activeEditorId == editorId) {
      _focusTimer?.cancel();
      _focusTimer = Timer(const Duration(milliseconds: 100), () {
        if (mounted && state.activeEditorId == editorId) {
          state = (
            activeController: null,
            activeFocusNode: null,
            isToolbarVisible: false,
            activeEditorId: null,
          );
          _lastActiveEditorId = null;
        }
      });
    }
  }

  /// Request focus back to the active editor
  void returnFocusToEditor() {
    final success = requestFocus(state.activeFocusNode);
    
    // If focus request failed, clear the state
    if (!success && state.activeFocusNode != null) {
      state = (
        activeController: null,
        activeFocusNode: null,
        isToolbarVisible: false,
        activeEditorId: null,
      );
    }
  }

  @override
  void dispose() {
    _focusTimer?.cancel();
    super.dispose();
  }
} 