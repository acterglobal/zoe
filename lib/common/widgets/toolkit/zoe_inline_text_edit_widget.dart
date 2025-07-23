import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:zoey/common/widgets/toolkit/zoe_html_editor_text_widget.dart';

class ZoeInlineTextEditWidget extends StatefulWidget {
  final String? text;
  final String? hintText;
  final Function(String) onTextChanged;
  final bool isEditing;
  final bool isHtml;
  final TextStyle? textStyle;
  final Function(QuillController?, FocusNode?)? onFocusChanged;

  const ZoeInlineTextEditWidget({
    super.key,
    this.text,
    this.hintText,
    required this.onTextChanged,
    this.isEditing = false,
    this.isHtml = false,
    this.textStyle,
    this.onFocusChanged,
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
    if (widget.isEditing && !widget.isHtml) {
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

    // Rich text editing mode (when onHtmlChanged is provided)
    if (widget.isHtml) {
      return ZoeHtmlTextEditWidget(
        initialContent: controller.text,
        initialRichContent: widget.text,
        isEditing: widget.isEditing,
        hintText: widget.hintText,
        textStyle: widget.textStyle,
        onContentChanged: (plainText, richTextJson) {
          widget.onTextChanged(richTextJson);
        },
        onFocusChanged: widget.onFocusChanged,
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
