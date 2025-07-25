import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/widgets/quill_editor/config/quill_editor_manager.dart';
import 'package:zoey/common/widgets/quill_editor/config/quill_editor_config.dart';
import 'package:zoey/common/widgets/quill_editor/providers/quill_toolbar_providers.dart';
import 'package:flutter_quill_delta_from_html/flutter_quill_delta_from_html.dart';
import 'dart:convert';

import 'package:zoey/features/sheet/models/sheet_model.dart';

class ZoeHtmlTextEditWidget extends ConsumerStatefulWidget {
  final Description? description;
  final bool isEditing;
  final String? hintText;
  final bool autoFocus;
  final Function(Description)? onContentChanged;
  final Function(QuillController?, FocusNode?)? onFocusChanged;
  final TextStyle? textStyle;
  final String? editorId; // Add editorId parameter

  const ZoeHtmlTextEditWidget({
    super.key,
    this.description,
    required this.isEditing,
    this.hintText,
    this.autoFocus = false,
    this.onContentChanged,
    this.onFocusChanged,
    this.textStyle,
    this.editorId, // Add to constructor
  });

  @override
  ConsumerState<ZoeHtmlTextEditWidget> createState() =>
      _ZoeHtmlTextEditWidgetState();
}

class _ZoeHtmlTextEditWidgetState extends ConsumerState<ZoeHtmlTextEditWidget> {
  late QuillEditorManager _editorManager;
  late QuillEditorStyles _editorStyles;
  bool _isInitialized = false;
  Description? _lastInitialDescription;
  late final String _uniqueEditorId;

  @override
  void initState() {
    super.initState();
    _uniqueEditorId = widget.editorId ?? UniqueKey().toString();
    _editorStyles = QuillEditorStyles(widgetTextStyle: widget.textStyle);
    _lastInitialDescription = widget.description;
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
        _lastInitialDescription != widget.description;

    if (sourceContentChanged && _isInitialized) {
      _lastInitialDescription = widget.description;

      // Convert HTML to Quill Delta if needed for content update
      String? processedRichContent = _convertHtmlToQuillDelta(
        widget.description?.htmlText,
      );

      // Update content without reinitializing to preserve focus
      _editorManager.updateContent(widget.description?.plainText, processedRichContent);
    } else if (sourceContentChanged ||
        oldWidget.textStyle != widget.textStyle) {
      _lastInitialDescription = widget.description;  
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

    // Convert HTML to Quill Delta if needed
    String? processedRichContent = _convertHtmlToQuillDelta(
      widget.description?.htmlText,
    );

    _editorManager = QuillEditorManager(
      initialContent: widget.description?.plainText,
      initialRichContent: processedRichContent,
      onContentChanged: _handleContentChanged,
      onFocusChanged: _handleFocusChanged,
      readOnly: !widget.isEditing,
    );

    await _editorManager.initialize();

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  /// Check if content is HTML (contains HTML tags) rather than Quill Delta JSON
  bool _isHtmlContent(String content) {
    return content.contains('<') &&
        content.contains('>') &&
        !content.startsWith('[');
  }

  /// Convert HTML content to Quill Delta JSON, with fallback handling
  String? _convertHtmlToQuillDelta(String? htmlContent) {
    if (htmlContent == null ||
        htmlContent.isEmpty ||
        !_isHtmlContent(htmlContent)) {
      return htmlContent; // Return as-is if not HTML
    }

    try {
      final delta = HtmlToDelta().convert(htmlContent);
      return jsonEncode(delta.toJson());
    } catch (e) {
      debugPrint('HTML to Delta conversion failed: $e');
      return null; // Return null to fall back to plain text
    }
  }

  /// Handle content changes from the QuillEditor
  void _handleContentChanged() {
    if (widget.onContentChanged != null && widget.isEditing) {
      // Delay the provider update to avoid modifying state during widget lifecycle
      Future.microtask(() {
        if (mounted) {
          widget.onContentChanged?.call((
              plainText: _editorManager.plainText,
              htmlText: _editorManager.richTextJson,
            ));
          }
        });
    }
  }

  /// Handle focus changes - automatically manages toolbar state
  void _handleFocusChanged(QuillController? controller, FocusNode? focusNode) {
    // Update global toolbar state
    Future.microtask(() {
      if (mounted) {
        if (focusNode?.hasFocus == true) {
          ref.read(quillToolbarProvider.notifier).updateActiveEditor(
            editorId: _uniqueEditorId,
            controller: controller,
            focusNode: focusNode,
          );
        } else {
          ref.read(quillToolbarProvider.notifier).clearActiveEditorState(_uniqueEditorId);
        }
      }
    });

    // Still call the original callback for backward compatibility
    if (widget.onFocusChanged != null) {
      widget.onFocusChanged!(controller, focusNode);
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
        focusNode: _editorManager.focusNode,
        scrollController: _editorManager.scrollController,
        controller: _editorManager.controller,
        config: _editorStyles.getEditingConfig(
          hintText: widget.hintText,
          autoFocus: widget.autoFocus,
          context: context,
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
        widget.description?.htmlText != null &&
        widget.description?.htmlText?.isNotEmpty == true;
    final hasPlainContent =
        widget.description?.plainText != null && widget.description?.plainText?.isNotEmpty == true;

    if (hasRichContent) {
      // Show formatted content using QuillEditor in read-only mode
      final disabledFocusNode = FocusNode();
      disabledFocusNode.canRequestFocus = false;

      return QuillEditor(
        controller: _editorManager.controller,
        scrollController: _editorManager.scrollController,
        focusNode: disabledFocusNode,
        config: _editorStyles.getViewConfig(context: context),
      );
    } else if (hasPlainContent) {
      // Show plain text when no rich content is available
      return Text(
        widget.description?.plainText ?? '',
        style: _editorStyles.getDefaultTextStyle(context),
      );
    } else {
      // Show hint text when no content
      return Text(
        widget.hintText ?? '',
        style: _editorStyles
            .getDefaultTextStyle(context)
            .copyWith(color: Theme.of(context).hintColor),
      );
    }
  }
}
