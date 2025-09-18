import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';

part 'quill_toolbar_notifier.g.dart';

typedef QuillToolbarState = ({
  QuillController? activeController,  
  FocusNode? activeFocusNode,        
  bool isToolbarVisible,             
  String? activeEditorId,           
});

@riverpod
class QuillToolbar extends _$QuillToolbar {
  Timer? _focusTimer;
  String? _lastActiveEditorId;

  @override
  QuillToolbarState build() => (
    activeController: null,
    activeFocusNode: null, 
    isToolbarVisible: false,
    activeEditorId: null,
  );

  /// Update the active editor and focus state
  void updateActiveEditor({
    required String editorId,
    QuillController? controller,
    FocusNode? focusNode,
  }) {
    // Cancel any pending focus timer
    _focusTimer?.cancel();

    // Check if focus node is valid and focused
    final isValidFocusNode = focusNode != null;
    final isFocused = focusNode?.hasFocus == true;

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

  void clearActiveEditorState(String editorId) {
    // Only clear if this is the currently active editor
    if (state.activeEditorId == editorId) {
      _focusTimer?.cancel();
      _focusTimer = Timer(const Duration(milliseconds: 100), () {
        if (ref.mounted && state.activeEditorId == editorId) {
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

  void returnFocusToEditor() {
    state.activeFocusNode?.requestFocus();
    // clear the state if the focus node is not available
    if (state.activeFocusNode == null) {
      state = (
        activeController: null,
        activeFocusNode: null,
        isToolbarVisible: false,
        activeEditorId: null,
      );
    }
  }
}