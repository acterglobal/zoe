import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'dart:convert';

/// Represents the current state of the QuillEditor manager
enum QuillEditorState {
  creating,
  initialized,
  updating,
  readOnly,
  disposed,
}

/// QuillEditor manager that handles configuration, styling, and lifecycle
class QuillEditorManager {
  late QuillController _controller;
  late FocusNode _focusNode;
  late ScrollController _scrollController;
  QuillEditorState _state = QuillEditorState.creating;
  final TextStyle? _widgetTextStyle;

  // Callbacks
  final VoidCallback? _onContentChanged;
  final Function(QuillController?, FocusNode?)? _onFocusChanged;
  final String? _initialContent;
  final String? _initialRichContent;

  QuillEditorManager({
    String? initialContent,
    String? initialRichContent,
    VoidCallback? onContentChanged,
    Function(QuillController?, FocusNode?)? onFocusChanged,
    bool readOnly = false,
    TextStyle? textStyle,
  }) : _initialContent = initialContent,
       _initialRichContent = initialRichContent,
       _onContentChanged = onContentChanged,
       _onFocusChanged = onFocusChanged,
       _widgetTextStyle = textStyle {
    _state = readOnly ? QuillEditorState.readOnly : QuillEditorState.creating;
  }

  /// Initialize the QuillController with proper configuration
  Future<void> initialize() async {
    if (_state == QuillEditorState.disposed) return;

    try {
      _controller = QuillController.basic(
        config: QuillControllerConfig(
          clipboardConfig: QuillClipboardConfig(enableExternalRichPaste: true),
        ),
      );
    } catch (e) {
      // Fallback initialization if the basic config fails
      _controller = QuillController.basic();
    }
    _focusNode = FocusNode();
    _focusNode.canRequestFocus = _state != QuillEditorState.readOnly;
    _scrollController = ScrollController();
    _setupListeners();
    await _loadInitialDocument();
    _state = QuillEditorState.initialized;
  }

  /// Setup listeners for controller and focus changes
  void _setupListeners() {
    _controller.addListener(_onControllerChange);
    _focusNode.addListener(_onFocusChange);
  }

  /// Load initial document content with error handling
  Future<void> _loadInitialDocument() async {
    try {
      if (_initialRichContent != null && _initialRichContent.isNotEmpty) {
        // Load rich text content with formatting
        final deltaJson = jsonDecode(_initialRichContent);
        final delta = Delta.fromJson(deltaJson);
        _controller.document = Document.fromDelta(delta);
      } else if (_initialContent != null && _initialContent.isNotEmpty) {
        // Load plain text content
        _controller.document = Document()..insert(0, _initialContent);
      } else {
        _controller.document = Document()..insert(0, '');
      }
    } catch (e) {
      _controller.document = Document()..insert(0, _initialContent ?? '');
    }
  }

  /// Handle controller changes (selection, content, etc.)
  void _onControllerChange() {
    if (_state == QuillEditorState.disposed || 
        _state == QuillEditorState.updating || 
        _state == QuillEditorState.readOnly) {
          return;
        }

    _onContentChanged?.call();
  }

  /// Handle focus changes with delay mechanism
  void _onFocusChange() {
    if (_state == QuillEditorState.disposed) return;

    // Use the centralized focus state getter
    final isFocused = _focusNode.hasFocus;

    if (isFocused == true) {
      // Immediately show toolbar when focused
      _onFocusChanged?.call(_controller, _focusNode);
    } else {
      // Delay hiding toolbar to allow for toolbar button clicks
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_state != QuillEditorState.disposed) {
          final stillHasFocus = _focusNode.hasFocus;
          if (stillHasFocus == false) {
            _onFocusChanged?.call(null, null);
          }
        }
      });
    }
  }

  /// Update content programmatically without triggering change events
  void updateContent(String? content, String? richContent) {
    if (_state == QuillEditorState.disposed) return;

    _state = QuillEditorState.updating;

    try {
      // Preserve cursor position
      final currentSelection = _controller.selection;

      if (richContent != null && richContent.isNotEmpty) {
        // Load rich text content with formatting
        final deltaJson = jsonDecode(richContent);
        final delta = Delta.fromJson(deltaJson);
        _controller.document = Document.fromDelta(delta);
      } else if (content != null && content.isNotEmpty) {
        // Load plain text content
        _controller.document = Document()..insert(0, content);
      } else {
        _controller.document = Document()..insert(0, '');
      }

      // Restore cursor position if it's still valid
      if (currentSelection.isValid &&
          currentSelection.end <= _controller.document.length) {
        _controller.updateSelection(currentSelection, ChangeSource.local);
      }
    } catch (e) {
      _controller.document = Document()..insert(0, content ?? '');
    } finally {
      _state = QuillEditorState.initialized;
    }
  }

  /// Update read-only state
  void setReadOnly(bool readOnly) {
    _state = readOnly ? QuillEditorState.readOnly : QuillEditorState.initialized;
    _focusNode.canRequestFocus = !readOnly;
  }

  /// Get current plain text content
  String get plainText => _controller.document.toPlainText();

  /// Get current rich text content as JSON string
  String get richTextJson {
    try {
      return jsonEncode(_controller.document.toDelta().toJson());
    } catch (e) {
      return '';
    }
  }

  /// Get the QuillController
  QuillController get controller => _controller;

  /// Get the FocusNode
  FocusNode get focusNode => _focusNode;

  /// Get the ScrollController
  ScrollController get scrollController => _scrollController;

  /// Check if the manager is initialized
  bool get isInitialized => _state == QuillEditorState.initialized;

  /// Get default styles for code blocks and other elements
  DefaultStyles getDefaultStyles(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final themeBasedStyle =
        _widgetTextStyle?.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 0.87),
          fontSize:
              _widgetTextStyle.fontSize ?? textTheme.bodyMedium?.fontSize ?? 14,
        ) ??
        TextStyle(
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
          fontSize:
              _widgetTextStyle?.fontSize ?? textTheme.bodySmall?.fontSize ?? 12,
        ),
        const HorizontalSpacing(0, 0),
        const VerticalSpacing(6, 0),
        VerticalSpacing.zero,
        BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.5),
            width: 1,
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

    return _widgetTextStyle?.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 0.87),
          fontSize:
              _widgetTextStyle.fontSize ?? textTheme.bodyMedium?.fontSize ?? 14,
          height:
              _widgetTextStyle.height ?? textTheme.bodyMedium?.height ?? 1.6,
        ) ??
        defaultStyle;
  }

  /// Dispose all resources
  void dispose() {
    _state = QuillEditorState.disposed;

    // First, notify that focus is cleared to prevent toolbar from using disposed nodes
    _onFocusChanged?.call(null, null);

    // Remove listeners before disposing
    _controller.removeListener(_onControllerChange);
    _focusNode.removeListener(_onFocusChange);

    // Dispose resources
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
  }
}
