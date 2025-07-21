import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:zoey/common/widgets/toolkit/zoe_html_text_edit_widget.dart';

class ZoeInlineTextEditWidget extends StatefulWidget {
  final String? text;
  final String? hintText;
  final Function(String) onTextChanged;
  final Function(String plainText, String richText)? onHtmlChanged;
  final Function(QuillController? controller, FocusNode? focusNode)? onFocusChanged;
  final bool isEditing;
  final TextStyle? textStyle;

  const ZoeInlineTextEditWidget({
    super.key,
    this.text,
    this.hintText,
    required this.onTextChanged,
    this.onHtmlChanged,
    this.onFocusChanged,
    this.isEditing = false,
    this.textStyle,
  });

  @override
  State<ZoeInlineTextEditWidget> createState() => _ZoeInlineTextEditWidgetState();
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
    return widget.isEditing && widget.onHtmlChanged == null
        ? TextField(
            controller: controller,
            style: widget.textStyle,
            decoration: InputDecoration(
              hintText: widget.hintText,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            maxLines: null,
            onChanged: widget.onTextChanged,
          )
        : widget.onHtmlChanged != null ? ZoeHtmlTextEditWidget(
            initialContent: controller.text,
            initialRichContent: widget.text,
            isEditing: widget.isEditing,
            placeholder: widget.hintText,
            textStyle: widget.textStyle,
            onContentChanged: (plainText, richTextJson) {
              widget.onHtmlChanged!(plainText, richTextJson);
            },
            onFocusChanged: widget.onFocusChanged,
          ) : SelectableText(
            controller.text.isEmpty ? (widget.hintText ?? '') : controller.text,
            style: controller.text.isEmpty && widget.hintText != null
                ? widget.textStyle?.copyWith(color: Theme.of(context).hintColor)
                : widget.textStyle,
          );
  }
}
