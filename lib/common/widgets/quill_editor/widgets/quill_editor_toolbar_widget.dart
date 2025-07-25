import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:zoey/common/utils/common_utils.dart';
import 'package:zoey/common/widgets/quill_editor/widgets/quill_toolbar_widget.dart';

class QuillEditorToolbarWidget extends StatelessWidget {
  final QuillController controller;
  final FocusNode focusNode;
  final bool isToolbarVisible;
  final VoidCallback? onReturnFocusToEditor;

  const QuillEditorToolbarWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    this.isToolbarVisible = false,
    this.onReturnFocusToEditor,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktopPlatform = CommonUtils.isDesktop(context);
    final duration = isDesktopPlatform ? 200 : 250;
    final curve = isDesktopPlatform ? Curves.easeInOut : Curves.easeOut;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: isToolbarVisible ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: duration),
        curve: curve,
        height: isToolbarVisible ? 60 : 0,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: duration),
          opacity: isToolbarVisible ? 1.0 : 0.0,
          child: QuillToolbar(
            controller: controller,
            focusNode: focusNode,
            onButtonPressed: onReturnFocusToEditor,
          ),
        ),
      ),
    );
  }
}
