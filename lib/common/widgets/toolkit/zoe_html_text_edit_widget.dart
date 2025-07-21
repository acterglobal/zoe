import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:zoey/features/sheet/quill_editor/quill_editor_manager.dart';
import 'package:zoey/features/sheet/quill_editor/quill_editor_config.dart';

/// A reusable rich text widget that handles both editing and view modes
class ZoeHtmlTextEditWidget extends StatefulWidget {
  final String? initialContent;
  final String? initialRichContent;
  final bool isEditing;
  final String? placeholder;
  final EdgeInsets? padding;
  final bool autoFocus;
  final Function(String plainText, String richTextJson)? onContentChanged;
  final Function(QuillController?, FocusNode?)? onFocusChanged;
  final TextStyle? textStyle;

  const ZoeHtmlTextEditWidget({
    super.key,
    this.initialContent,
    this.initialRichContent,
    required this.isEditing,
    this.placeholder,
    this.padding,
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

  /// Initialize the editor manager
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

  /// Handle content changes from the editor
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
      return QuillEditor(
        focusNode: _editorManager.focusNode!,
        scrollController: _editorManager.scrollController!,
        controller: _editorManager.controller!,
        config: _editorStyles.getEditingConfig(
          placeholder: widget.placeholder,
          padding: widget.padding,
          autoFocus: widget.autoFocus,
        ),
      );
    } else {
      return _buildViewWidget();
    }
  }

  /// Build the view widget
  Widget _buildViewWidget() {
    final hasRichContent =
        widget.initialRichContent != null &&
        widget.initialRichContent!.isNotEmpty;
    final hasPlainContent =
        widget.initialContent != null && widget.initialContent!.isNotEmpty;

    if (hasRichContent) {
      // Create a disabled focus node for view mode
      final disabledFocusNode = FocusNode();
      disabledFocusNode.canRequestFocus = false;

      return QuillEditor(
        controller: _editorManager.controller!,
        scrollController: _editorManager.scrollController!,
        focusNode: disabledFocusNode,
        config: _editorStyles.getViewConfig(padding: widget.padding),
      );
    } else if (hasPlainContent) {
      return Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: Text(
          widget.initialContent!,
          style: widget.textStyle ?? _editorStyles.getDefaultTextStyle(context),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
