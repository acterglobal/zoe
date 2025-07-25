import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:zoey/common/utils/common_utils.dart';
import 'package:zoey/common/widgets/quill_editor/widgets/quill_toolbar_widget.dart';

class QuillEditorToolbarWidget extends StatelessWidget {
  final QuillController? controller;
  final FocusNode? focusNode;
  final bool isToolbarVisible;
  final VoidCallback? onReturnFocusToEditor;

  const QuillEditorToolbarWidget({
    super.key,
    this.controller,
    this.focusNode,
    this.isToolbarVisible = false,
    this.onReturnFocusToEditor,
  });

  @override
  Widget build(BuildContext context) {
    return _buildBottomToolbar(context);
  }

  /// Build the bottom toolbar that appears when text blocks are focused
  Widget _buildBottomToolbar(BuildContext context) {
    final isDesktopPlatform = CommonUtils.isDesktop(context);
    final shouldShow =
        isToolbarVisible &&
        controller != null &&
        focusNode != null && 
        (isDesktopPlatform ? focusNode != null : true);

    return _buildAnimatedToolbar(
      context: context,
      shouldShow,
      isDesktopPlatform ? 200 : 250,
      controller: controller,
      focusNode: focusNode,
      curve: isDesktopPlatform ? Curves.easeInOut : Curves.easeOut,
    );
  }

  /// Build animated toolbar container
  Widget _buildAnimatedToolbar(
    bool shouldShow,
    int duration, {
    Curve? curve,
    QuillController? controller,
    FocusNode? focusNode,
    required BuildContext context,
  }) {
    return Material(
      elevation: shouldShow ? 4 : 0,
      color: Theme.of(context).colorScheme.surface,
      child: AnimatedContainer(
        duration: Duration(milliseconds: duration),
        curve: curve ?? Curves.easeInOut,
        height: shouldShow ? 60 : 0,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: duration),
          opacity: shouldShow ? 1.0 : 0.0,
          child: shouldShow && 
                 controller != null && 
                  focusNode != null
              ? QuillToolbar(
                  controller: controller,
                  focusNode: focusNode,
                  onButtonPressed: onReturnFocusToEditor,
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
