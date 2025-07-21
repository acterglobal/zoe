import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:zoey/common/utils/utils.dart';
import 'package:zoey/features/sheet/widgets/quill_toolbar/quill_toolbar.dart';

class ViewQuillEditorToolbarWidget extends StatefulWidget {
  final QuillController? controller;
  final FocusNode? focusNode;
  final bool isToolbarVisible;
  final VoidCallback? onReturnFocusToEditor;

  const ViewQuillEditorToolbarWidget({
    super.key,
    this.controller,
    this.focusNode,
    this.isToolbarVisible = false,
    this.onReturnFocusToEditor,
  });

  @override
  State<ViewQuillEditorToolbarWidget> createState() => _ViewQuillEditorToolbarWidgetState();
}

class _ViewQuillEditorToolbarWidgetState extends State<ViewQuillEditorToolbarWidget> {
  @override
  Widget build(BuildContext context) {
    return _buildBottomToolbar(context);
  }

  /// Build the bottom toolbar that appears when text blocks are focused
  Widget _buildBottomToolbar(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isDesktopPlatform = isDesktop(context);
    final shouldShow = widget.isToolbarVisible && 
                      widget.controller != null && 
                      (isDesktopPlatform ? widget.focusNode != null : true);

    return Positioned(
      left: 0,
      right: 0,
      bottom: isDesktopPlatform ? 0 : keyboardHeight,
      child: _buildAnimatedToolbar(
        shouldShow,
        isDesktopPlatform ? 200 : 250,
        controller: widget.controller,
        focusNode: widget.focusNode,
        curve: isDesktopPlatform ? Curves.easeInOut : Curves.easeOut,
      ),
    );
  }

  /// Build animated toolbar container
  Widget _buildAnimatedToolbar(
    bool shouldShow, 
    int duration, {
    Curve? curve, 
    QuillController? controller, 
    FocusNode? focusNode,
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
          child: shouldShow && controller != null && focusNode != null
              ? QuillToolbar(
                  controller: controller,
                  focusNode: focusNode,
                  onButtonPressed: widget.onReturnFocusToEditor,
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}