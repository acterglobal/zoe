import 'package:flutter/material.dart';

class ZoeInlineTextEditWidget extends StatefulWidget {
  final String? text;
  final String? hintText;
  final Function(String) onTextChanged;
  final VoidCallback? onEnterPressed;
  final VoidCallback? onBackspaceEmptyText;
  final VoidCallback? onTapText;
  final TextInputAction? textInputAction;
  final bool isEditing;
  final TextStyle? textStyle;
  final bool autoFocus;

  const ZoeInlineTextEditWidget({
    super.key,
    this.text,
    this.hintText,
    required this.onTextChanged,
    this.onEnterPressed,
    this.onBackspaceEmptyText,
    this.onTapText,
    this.textInputAction,
    this.isEditing = false,
    this.textStyle,
    this.autoFocus = false,
  });

  @override
  State<ZoeInlineTextEditWidget> createState() =>
      _ZoeInlineTextEditWidgetState();
}

class _ZoeInlineTextEditWidgetState extends State<ZoeInlineTextEditWidget> {
  late TextEditingController controller;
  late FocusNode textFieldFocusNode;
  late FocusNode keyboardFocusNode;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.text);
    textFieldFocusNode = FocusNode();
    keyboardFocusNode = FocusNode();
    // Request focus on initial build if autoFocus is true
    if (widget.autoFocus && widget.isEditing) {
      textFieldFocusNode.requestFocus();
    }
  }

  @override
  void didUpdateWidget(ZoeInlineTextEditWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Request focus when autoFocus changes to true
    if (widget.autoFocus && !oldWidget.autoFocus && widget.isEditing) {
      textFieldFocusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    textFieldFocusNode.dispose();
    keyboardFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isEditing
        ? TextField(
            focusNode: textFieldFocusNode,
            controller: controller,
            style: widget.textStyle,
            autofocus: widget.autoFocus,
            decoration: InputDecoration(
              hintText: widget.hintText,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            textInputAction: widget.textInputAction,
            maxLines: null,
            onChanged: (value) {
              widget.onTextChanged(value);
              if (value.isEmpty && widget.onBackspaceEmptyText != null) {
                widget.onBackspaceEmptyText!();
              }
            },
            onSubmitted: (value) => widget.onEnterPressed?.call(),
          )
        : SelectableText(
            controller.text.isEmpty ? (widget.hintText ?? '') : controller.text,
            style: controller.text.isEmpty && widget.hintText != null
                ? widget.textStyle?.copyWith(color: Theme.of(context).hintColor)
                : widget.textStyle,
            onTap: widget.onTapText,
          );
  }
}
