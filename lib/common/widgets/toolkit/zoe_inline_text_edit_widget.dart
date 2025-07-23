import 'package:flutter/material.dart';

class ZoeInlineTextEditWidget extends StatefulWidget {
  final String? text;
  final String? hintText;
  final Function(String) onTextChanged;
  final bool isEditing;
  final TextStyle? textStyle;

  const ZoeInlineTextEditWidget({
    super.key,
    this.text,
    this.hintText,
    required this.onTextChanged,
    this.isEditing = false,
    this.textStyle,
  });

  @override
  State<ZoeInlineTextEditWidget> createState() =>
      _ZoeInlineTextEditWidgetState();
}

class _ZoeInlineTextEditWidgetState extends State<ZoeInlineTextEditWidget> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Plain text editing mode
    if (widget.isEditing) {
      return TextField(
        controller: controller,
        style: widget.textStyle,
        decoration: InputDecoration(
          hintText: widget.hintText,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        maxLines: null,
        onChanged: widget.onTextChanged,
      );
    }

    // View mode (read-only)
    return SelectableText(
      controller.text.isEmpty ? (widget.hintText ?? '') : controller.text,
      style: controller.text.isEmpty && widget.hintText != null
          ? widget.textStyle?.copyWith(color: Theme.of(context).hintColor)
          : widget.textStyle,
    );
  }
}
