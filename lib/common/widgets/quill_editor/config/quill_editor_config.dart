import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Centralized configuration for QuillEditor styling and behavior
class QuillEditorStyles {
  final TextStyle? widgetTextStyle;

  const QuillEditorStyles({this.widgetTextStyle});

  /// Get the default QuillEditor configuration for editing mode
  QuillEditorConfig getEditingConfig({
    String? hintText,
    bool autoFocus = false,
    required BuildContext context,
  }) {
    return QuillEditorConfig(
      placeholder: hintText ?? '',
      autoFocus: autoFocus,
      expands: false,
      embedBuilders: const [],
      customStyles: _getDefaultStyles(context),
    );
  }

  /// Get the default QuillEditor configuration for view mode
  QuillEditorConfig getViewConfig({required BuildContext context}) {
    return QuillEditorConfig(
      autoFocus: false,
      expands: false,
      embedBuilders: const [],
      customStyles: _getDefaultStyles(context),
    );
  }

  /// Get the default QuillController configuration
  QuillControllerConfig getControllerConfig() {
    return QuillControllerConfig(
      clipboardConfig: QuillClipboardConfig(enableExternalRichPaste: true),
    );
  }

  /// Get default styles for code blocks and other elements
  DefaultStyles _getDefaultStyles(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final themeBasedStyle = widgetTextStyle?.copyWith(
      color: colorScheme.onSurface.withValues(alpha: 0.87),
      fontSize: widgetTextStyle?.fontSize ?? textTheme.bodyMedium?.fontSize ?? 14,
    ) ?? TextStyle(
      fontSize: textTheme.bodyMedium?.fontSize ?? 14, 
      height: 1.5,
      color: colorScheme.onSurface.withValues(alpha: 0.87),
    );

    return DefaultStyles(
      paragraph: DefaultTextBlockStyle(
        themeBasedStyle,
        const HorizontalSpacing(0, 0),
        const VerticalSpacing(0, 0),
        VerticalSpacing.zero,
        null,
      ),
      code: DefaultTextBlockStyle(
        TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.6),
          fontFamily: 'Courier New',
          fontSize: widgetTextStyle?.fontSize ?? textTheme.bodySmall?.fontSize ?? 12,
        ),
        const HorizontalSpacing(0, 0),
        const VerticalSpacing(6, 0),
        VerticalSpacing.zero,
        BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.5), 
            width: 1
          ),
        ),
      ),
    );
  }

  /// Get default text style for plain text display
  TextStyle getDefaultTextStyle(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    
    final defaultStyle = TextStyle(
      fontSize: textTheme.bodyMedium?.fontSize ?? 14,
      color: colorScheme.onSurface.withValues(alpha: 0.87),
      height: textTheme.bodyMedium?.height ?? 1.6,
    );
    
    return widgetTextStyle?.copyWith(
      color: colorScheme.onSurface.withValues(alpha: 0.87),
      fontSize: widgetTextStyle?.fontSize ?? textTheme.bodyMedium?.fontSize ?? 14,
      height: widgetTextStyle?.height ?? textTheme.bodyMedium?.height ?? 1.6,
    ) ?? defaultStyle;
  }
}