import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:zoey/features/sheet/actions/quill_actions.dart';
import 'package:zoey/features/sheet/widgets/quill_toolbar/quill_toolbar_button.dart';

/// Keyboard-aware toolbar that appears above the keyboard
class QuillToolbar extends StatefulWidget {
  const QuillToolbar({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onButtonPressed,
  });

  final QuillController controller;
  final FocusNode focusNode;
  final VoidCallback? onButtonPressed;

  @override
  State<QuillToolbar> createState() => _QuillToolbarState();
}

class _QuillToolbarState extends State<QuillToolbar> {
  @override
  void initState() {
    super.initState();
    _setupListeners();
  }

  /// Setup listeners for focus and controller changes
  void _setupListeners() {
    widget.focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onControllerChange);
  }

  /// Handle focus changes
  void _onFocusChange() {
    if (mounted) {
      setState(() {});
    }
  }

  /// Handle controller changes (selection, content, etc.)
  void _onControllerChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 4,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ..._buildTextFormattingButtons(),
              ..._buildBlockFormattingButtons(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build text formatting buttons (bold, italic, underline, strikethrough)
  List<Widget> _buildTextFormattingButtons() {
    return [
      buildToolbarButton(
        context: context,
        icon: Icons.format_bold,
        isActive: isAttributeActive(widget.controller, Attribute.bold),
        onPressed: () => toggleAttribute(widget.controller, Attribute.bold, onButtonPressed: widget.onButtonPressed),
      ),
      const SizedBox(width: 8),
      buildToolbarButton(
        context: context,
        icon: Icons.format_italic,
        isActive: isAttributeActive(widget.controller, Attribute.italic),
        onPressed: () => toggleAttribute(widget.controller, Attribute.italic, onButtonPressed: widget.onButtonPressed),
      ),
      const SizedBox(width: 8),
      buildToolbarButton(
        context: context,
        icon: Icons.format_underline,
        isActive: isAttributeActive(widget.controller, Attribute.underline),
        onPressed: () => toggleAttribute(widget.controller, Attribute.underline, onButtonPressed: widget.onButtonPressed),
      ),
      const SizedBox(width: 8),
      buildToolbarButton(
        context: context,
        icon: Icons.format_strikethrough,
        isActive: isAttributeActive(widget.controller, Attribute.strikeThrough),
        onPressed: () => toggleAttribute(widget.controller, Attribute.strikeThrough, onButtonPressed: widget.onButtonPressed),
      ),
    ];
  }

  /// Build block formatting buttons (lists, quotes, code blocks)
  List<Widget> _buildBlockFormattingButtons() {
    return [
      const SizedBox(width: 8),
      buildToolbarButton(
        context: context,
        icon: Icons.format_quote,
        isActive: isAttributeActive(widget.controller, Attribute.blockQuote),
        onPressed: () => toggleAttribute(widget.controller, Attribute.blockQuote, onButtonPressed: widget.onButtonPressed),
      ),
      const SizedBox(width: 8),
      buildToolbarButton(
        context: context,
        icon: Icons.code,
        isActive: isAttributeActive(widget.controller, Attribute.codeBlock),
        onPressed: () => toggleAttribute(widget.controller, Attribute.codeBlock, onButtonPressed: widget.onButtonPressed),
      ),
    ];
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onControllerChange);
    super.dispose();
  }
}