import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:zoey/features/sheet/quill_editor/quill_editor_manager.dart';
import 'package:zoey/features/sheet/quill_editor/quill_editor_config.dart';

/// Rich text editor widget that handles HTML content with formatting capabilities.
/// 
/// **Features:**
/// - Full QuillEditor with formatting toolbar
/// - Supports bold, italic, lists, etc.
/// - Outputs both plain text and rich HTML
/// - Handles view mode for displaying formatted content
/// 
/// **Usage:**
/// - Use for content that needs text formatting
/// - Typically used by ZoeInlineTextEditWidget when onHtmlChanged is provided
class ZoeHtmlTextEditWidget extends StatefulWidget {
  final String? initialContent;
  final String? initialRichContent;
  final bool isEditing;
  final String? hintText;
  final bool autoFocus;
  final Function(String plainText, String richTextJson)? onContentChanged;
  final Function(QuillController?, FocusNode?)? onFocusChanged;
  final TextStyle? textStyle;

  const ZoeHtmlTextEditWidget({
    super.key,
    this.initialContent,
    this.initialRichContent,
    required this.isEditing,
    this.hintText,
    this.autoFocus = false,
    this.onContentChanged,
    this.onFocusChanged,
    this.textStyle,
  });

  @override
  State<ZoeHtmlTextEditWidget> createState() => _ZoeHtmlTextEditWidgetState();
}

class _ZoeHtmlTextEditWidgetState extends State<ZoeHtmlTextEditWidget> {
  late QuillEditorManager _editorManager;
  late QuillEditorStyles _editorStyles;
  bool _isInitialized = false;
  String? _lastInitialContent;
  String? _lastInitialRichContent;

  @override
  void initState() {
    super.initState();
    _editorStyles = QuillEditorStyles();
    _lastInitialContent = widget.initialContent;
    _lastInitialRichContent = widget.initialRichContent;
    _initializeEditor();
  }

  @override
  void didUpdateWidget(ZoeHtmlTextEditWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update read-only state if editing mode changed
    if (oldWidget.isEditing != widget.isEditing && _isInitialized) {
      _editorManager.setReadOnly(!widget.isEditing);
    }

    // Only update if the source content actually changes (not editor content)
    final sourceContentChanged =
        _lastInitialContent != widget.initialContent ||
        _lastInitialRichContent != widget.initialRichContent;

    if (sourceContentChanged && _isInitialized) {
      _lastInitialContent = widget.initialContent;
      _lastInitialRichContent = widget.initialRichContent;
      // Update content without reinitializing to preserve focus
      _editorManager.updateContent(
        widget.initialContent,
        widget.initialRichContent,
      );
    } else if (sourceContentChanged) {
      _lastInitialContent = widget.initialContent;
      _lastInitialRichContent = widget.initialRichContent;
      _initializeEditor();
    }
  }

  @override
  void dispose() {
    _editorManager.dispose();
    super.dispose();
  }

  /// Initialize the QuillEditor with proper configuration
  Future<void> _initializeEditor() async {
    // Dispose previous manager if it exists
    if (_isInitialized) {
      _editorManager.dispose();
    }

    _editorManager = QuillEditorManager(
      initialContent: widget.initialContent,
      initialRichContent: widget.initialRichContent,
      onContentChanged: _handleContentChanged,
      onFocusChanged: widget.onFocusChanged,
      readOnly: !widget.isEditing,
    );

    await _editorManager.initialize();

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  /// Handle content changes from the QuillEditor
  void _handleContentChanged() {
    if (widget.onContentChanged != null && widget.isEditing) {
      widget.onContentChanged!(
        _editorManager.plainText,
        _editorManager.richTextJson,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || !_editorManager.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.isEditing) {
      // Edit mode: Show QuillEditor with formatting capabilities
      return QuillEditor(
        focusNode: _editorManager.focusNode!,
        scrollController: _editorManager.scrollController!,
        controller: _editorManager.controller!,
        config: _editorStyles.getEditingConfig(
          hintText: widget.hintText,
          autoFocus: widget.autoFocus,
        ),
      );
    } else {
      // View mode: Display formatted content
      return _buildViewWidget();
    }
  }

  /// Build the view widget for displaying formatted content
  Widget _buildViewWidget() {
    final hasRichContent =
        widget.initialRichContent != null &&
        widget.initialRichContent!.isNotEmpty;
    final hasPlainContent =
        widget.initialContent != null && widget.initialContent!.isNotEmpty;

    if (hasRichContent) {
      // Show formatted content using QuillEditor in read-only mode
      final disabledFocusNode = FocusNode();
      disabledFocusNode.canRequestFocus = false;

      return QuillEditor(
        controller: _editorManager.controller!,
        scrollController: _editorManager.scrollController!,
        focusNode: disabledFocusNode,
        config: _editorStyles.getViewConfig(),
      );
    } else if (hasPlainContent) {
      // Show plain text when no rich content is available
      return Text(
          widget.initialContent!,
          style: widget.textStyle ?? _editorStyles.getDefaultTextStyle(context),
      );
    } else {
      // Show hint text when no content
      return Text(
        widget.hintText ?? '',
        style: widget.textStyle?.copyWith(color: Theme.of(context).hintColor),
      );
    }
  }
}
