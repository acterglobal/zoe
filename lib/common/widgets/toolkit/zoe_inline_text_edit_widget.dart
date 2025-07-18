import 'package:flutter/material.dart';

class ZoeInlineTextEditWidget extends StatelessWidget {
  final String? hintText;
  final TextEditingController controller;
  final Function(String) onTextChanged;
  final bool isEditing;
  final TextStyle? textStyle;

  const ZoeInlineTextEditWidget({
    super.key,
    this.hintText,
    required this.controller,
    required this.onTextChanged,
    this.isEditing = false,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return isEditing
        ? TextField(
            controller: controller,
            style: textStyle,
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: EdgeInsets.zero,
            ),
            maxLines: null,
            onChanged: onTextChanged,
          )
        : Text(controller.text, style: textStyle);
  }
}
