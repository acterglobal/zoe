import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'dart:convert';
import 'package:zoey/features/sheet/quill_editor/quill_editor_config.dart';

/// Manages QuillController lifecycle and configuration for rich text editing
class QuillEditorManager {
  QuillController? _controller;
  FocusNode? _focusNode;
  ScrollController? _scrollController;
  bool _isInitialized = false;
  bool _isDisposed = false;
  bool _isUpdatingContent = false;
  bool _isReadOnly = false;
  late final QuillEditorStyles _editorStyles;

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
  })  : _initialContent = initialContent,
        _initialRichContent = initialRichContent,
        _onContentChanged = onContentChanged,
        _onFocusChanged = onFocusChanged,
        _isReadOnly = readOnly {
    _editorStyles = QuillEditorStyles();
  }

  /// Initialize the QuillController with proper configuration
  Future<void> initialize() async {
    if (_isDisposed) return;

    try {
      _controller = QuillController.basic(
        config: _editorStyles.getControllerConfig(),
      );
      _focusNode = FocusNode();
      _focusNode!.canRequestFocus = !_isReadOnly; // Set focus based on read-only state
      _scrollController = ScrollController();
      
      _setupListeners();
      await _loadInitialDocument();
      _isInitialized = true;
    } catch (e) {
      // Fallback initialization if the basic config fails
      _controller = QuillController.basic();
      _focusNode = FocusNode();
      _focusNode!.canRequestFocus = !_isReadOnly; // Set focus based on read-only state
      _scrollController = ScrollController();
      
      _setupListeners();
      await _loadInitialDocument();
      _isInitialized = true;
    }
  }

  /// Setup listeners for controller and focus changes
  void _setupListeners() {
    _controller?.addListener(_onControllerChange);
    _focusNode?.addListener(_onFocusChange);
  }

  /// Load initial document content with error handling
  Future<void> _loadInitialDocument() async {
    try {
      if (_controller != null) {
        if (_initialRichContent != null && _initialRichContent.isNotEmpty) {
          // Load rich text content with formatting
          final deltaJson = jsonDecode(_initialRichContent);
          final delta = Delta.fromJson(deltaJson);
          _controller!.document = Document.fromDelta(delta);
        } else if (_initialContent != null && _initialContent.isNotEmpty) {
          // Load plain text content
          _controller!.document = Document()..insert(0, _initialContent);
        } else {
          _controller!.document = Document()..insert(0, '');
        }
      }
    } catch (e) {
      if (_controller != null) {
        _controller!.document = Document()..insert(0, _initialContent ?? '');
      }
    }
  }

  /// Handle controller changes (selection, content, etc.)
  void _onControllerChange() {
    if (_isDisposed || _isUpdatingContent || _isReadOnly) return;
    
    _onContentChanged?.call();
  }

  /// Handle focus changes with delay mechanism
  void _onFocusChange() {
    if (_isDisposed) return;

    final isFocused = _focusNode?.hasFocus ?? false;
    
    if (isFocused) {
      // Immediately show toolbar when focused
      _onFocusChanged?.call(_controller, _focusNode);
    } else {
      // Delay hiding toolbar to allow for toolbar button clicks
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!_isDisposed && !(_focusNode?.hasFocus ?? false)) {
          _onFocusChanged?.call(null, null);
        }
      });
    }
  }

  /// Update content programmatically without triggering change events
  void updateContent(String? content, String? richContent) {
    if (_isDisposed || _controller == null) return;
    
    _isUpdatingContent = true;
    
    try {
      // Preserve cursor position
      final currentSelection = _controller!.selection;
      
      if (richContent != null && richContent.isNotEmpty) {
        // Load rich text content with formatting
        final deltaJson = jsonDecode(richContent);
        final delta = Delta.fromJson(deltaJson);
        _controller!.document = Document.fromDelta(delta);
      } else if (content != null && content.isNotEmpty) {
        // Load plain text content
        _controller!.document = Document()..insert(0, content);
      } else {
        _controller!.document = Document()..insert(0, '');
      }
      
      // Restore cursor position if it's still valid
      if (currentSelection.isValid && 
          currentSelection.end <= _controller!.document.length) {
        _controller!.updateSelection(currentSelection, ChangeSource.local);
      }
    } catch (e) {
      if (_controller != null) {
        _controller!.document = Document()..insert(0, content ?? '');
      }
    } finally {
      _isUpdatingContent = false;
    }
  }

  /// Update read-only state
  void setReadOnly(bool readOnly) {
    _isReadOnly = readOnly;
    if (_focusNode != null) {
      _focusNode!.canRequestFocus = !readOnly;
    }
  }

  /// Get current plain text content
  String get plainText => _controller?.document.toPlainText() ?? '';

  /// Get current rich text content as JSON string
  String get richTextJson {
    if (_controller == null) return '';
    try {
      return jsonEncode(_controller!.document.toDelta().toJson());
    } catch (e) {
      return '';
    }
  }

  /// Get the QuillController
  QuillController? get controller => _controller;

  /// Get the FocusNode
  FocusNode? get focusNode => _focusNode;

  /// Get the ScrollController
  ScrollController? get scrollController => _scrollController;

  /// Check if the manager is initialized
  bool get isInitialized => _isInitialized;

  /// Request focus on the editor
  void requestFocus() {
    _focusNode?.requestFocus();
  }

  /// Clear focus from the editor
  void clearFocus() {
    _focusNode?.unfocus();
  }

  /// Dispose all resources
  void dispose() {
    _isDisposed = true;
    _controller?.removeListener(_onControllerChange);
    _focusNode?.removeListener(_onFocusChange);
    _controller?.dispose();
    _focusNode?.dispose();
    _scrollController?.dispose();
  }
} 