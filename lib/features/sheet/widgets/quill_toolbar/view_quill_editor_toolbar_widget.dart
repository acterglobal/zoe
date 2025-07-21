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
    
    if (isDesktopPlatform) {
      // Desktop: Show toolbar at bottom when text block is focused
      final shouldShow = widget.isToolbarVisible && 
                        widget.controller != null && 
                        widget.focusNode != null;
      return _buildAnimatedToolbar(
        shouldShow, 
        200, 
        controller: widget.controller, 
        focusNode: widget.focusNode,
      ); // Consistent animation for desktop
    } else {
      // Mobile: Show toolbar above keyboard when keyboard is visible and text block is focused
      final shouldShow = keyboardHeight > 0 && 
                        widget.isToolbarVisible && 
                        widget.controller != null;
      return _buildAnimatedToolbar(
        shouldShow, 
        250, 
        controller: widget.controller, 
        focusNode: widget.focusNode,
        curve: Curves.easeOut,
      ); // Consistent animation for mobile
    }
  }

  /// Build animated toolbar container
  Widget _buildAnimatedToolbar(
    bool shouldShow, 
    int duration, {
    Curve? curve, 
    QuillController? controller, 
    FocusNode? focusNode,
  }) {
    return AnimatedContainer(
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
    );
  }
}