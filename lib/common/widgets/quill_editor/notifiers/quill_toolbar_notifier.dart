import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Using a record instead of a separate state class
typedef QuillToolbarState = ({
  QuillController? activeController,
  FocusNode? activeFocusNode,
  bool isToolbarVisible,
});

/// Notifier for managing Quill toolbar state
class QuillToolbarNotifier extends StateNotifier<QuillToolbarState> {
  QuillToolbarNotifier() : super((
    activeController: null,
    activeFocusNode: null, 
    isToolbarVisible: false,
  ));

  /// Update the active editor and focus state
  void updateActiveEditor({
    QuillController? controller,
    FocusNode? focusNode,
  }) {
    state = (
      activeController: controller,
      activeFocusNode: focusNode,
      isToolbarVisible: focusNode?.hasFocus ?? false,
    );
  }

  /// Clear the active editor (when losing focus)  
  void clearActiveEditor() {
    state = (
      activeController: null,
      activeFocusNode: null,
      isToolbarVisible: false,
    );
  }

  /// Request focus back to the active editor
  void returnFocusToEditor() {
    if (state.activeFocusNode != null) {
      state.activeFocusNode!.requestFocus();
    }
  }
} 