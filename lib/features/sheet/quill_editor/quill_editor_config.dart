import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Centralized configuration for QuillEditor styling and behavior
class QuillEditorStyles {
  /// Get the default QuillEditor configuration for editing mode
  QuillEditorConfig getEditingConfig({
    String? hintText,
    EdgeInsets? padding,
    bool autoFocus = false,
  }) {
    return QuillEditorConfig(
      placeholder: hintText ?? '',
      padding: padding ?? const EdgeInsets.all(16),
      autoFocus: autoFocus,
      expands: false,
      embedBuilders: const [],
      customStyles: _getDefaultStyles(),
    );
  }

  /// Get the default QuillEditor configuration for view mode
  QuillEditorConfig getViewConfig({EdgeInsets? padding}) {
    return QuillEditorConfig(
      padding: padding ?? EdgeInsets.zero,
      autoFocus: false,
      expands: false,
      embedBuilders: const [],
      customStyles: _getDefaultStyles(),
    );
  }

  /// Get the default QuillController configuration
  QuillControllerConfig getControllerConfig() {
    return QuillControllerConfig(
      clipboardConfig: QuillClipboardConfig(enableExternalRichPaste: true),
    );
  }

  /// Get default styles for code blocks and other elements
  DefaultStyles _getDefaultStyles() {
    return DefaultStyles(
      code: DefaultTextBlockStyle(
        TextStyle(
          color: Colors.white.withValues(alpha: 0.5),
          fontFamily: 'Courier New',
          fontSize: 14,
        ),
        const HorizontalSpacing(0, 0),
        const VerticalSpacing(6, 0),
        VerticalSpacing.zero,
        BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade700, width: 1),
        ),
      ),
    );
  }

  /// Get default text style for plain text display
  TextStyle getDefaultTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 16,
      color: Theme.of(context).colorScheme.onSurface,
      height: 1.6,
    );
  }

  /// Get description text style
  TextStyle getDescriptionTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 16,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
      height: 1.5,
    );
  }
}
