import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/widgets/quill_editor/providers/quill_toolbar_providers.dart';
import 'package:zoey/common/widgets/quill_editor/widgets/quill_editor_toolbar_widget.dart';
import 'package:zoey/features/content/providers/content_menu_providers.dart';

Widget buildQuillEditorPositionedToolbar(BuildContext context, WidgetRef ref) {
  
    final toolbarState = ref.watch(quillToolbarProvider);
    final isEditing = ref.watch(isEditValueProvider);

     // Only show toolbar when editing is active
    if (!isEditing) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Builder(
        // use builder for local context that extracts nullable values to local variable
        builder: (context) {
          if (toolbarState.activeController == null || toolbarState.activeFocusNode == null) {
            return const SizedBox.shrink();
          }
          
          return QuillEditorToolbarWidget(
            controller: toolbarState.activeController!,
            focusNode: toolbarState.activeFocusNode!,
            isToolbarVisible: toolbarState.isToolbarVisible,
            onReturnFocusToEditor: () {
              ref
                  .read(quillToolbarProvider.notifier)
                  .returnFocusToEditor();
            },
          );
        },
      ),
    );
  }