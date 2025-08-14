import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Zoe/common/widgets/quill_editor/providers/quill_toolbar_providers.dart';
import 'package:Zoe/common/widgets/quill_editor/widgets/quill_editor_toolbar_widget.dart';

Widget buildQuillEditorPositionedToolbar(
  BuildContext context,
  WidgetRef ref, {
  required bool isEditing,
}) {
  final toolbarState = ref.watch(quillToolbarProvider);

  // Only show toolbar when editing is active and controller/focusNode are available
  if (!isEditing ||
      toolbarState.activeController == null ||
      toolbarState.activeFocusNode == null) {
    return const SizedBox.shrink();
  }

  return Positioned(
    left: 0,
    right: 0,
    bottom: 0,
    child: QuillEditorToolbarWidget(
      controller: toolbarState.activeController!,
      focusNode: toolbarState.activeFocusNode!,
      isToolbarVisible: toolbarState.isToolbarVisible,
      onReturnFocusToEditor: () {
        ref.read(quillToolbarProvider.notifier).returnFocusToEditor();
      },
    ),
  );
}
