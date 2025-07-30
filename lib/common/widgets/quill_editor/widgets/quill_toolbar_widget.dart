import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../actions/quill_actions.dart';

class QuillToolbar extends StatefulWidget {
  final QuillController controller;
  final FocusNode focusNode;
  final VoidCallback? onButtonPressed;

  const QuillToolbar({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onButtonPressed,
  });

  @override
  State<QuillToolbar> createState() => _QuillToolbarState();
}

class _QuillToolbarState extends State<QuillToolbar> {
  @override
  void initState() {
    super.initState();
    _addListeners();
  }

  void _addListeners() {
    widget.focusNode.addListener(_scheduleRebuild);
    widget.controller.addListener(_scheduleRebuild);
  }

  @override
  void didUpdateWidget(QuillToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_scheduleRebuild);
      widget.controller.addListener(_scheduleRebuild);
    }

    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_scheduleRebuild);
      widget.focusNode.addListener(_scheduleRebuild);
    }
  }

  void _scheduleRebuild() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [..._buildTextStyleButtons(), ..._buildBlockStyleButtons()],
        ),
      ),
    );
  }

  List<Widget> _buildTextStyleButtons() {
    return [
      _buildToolbarButton(Icons.format_bold, Attribute.bold),
      _spacer(),
      _buildToolbarButton(Icons.format_italic, Attribute.italic),
      _spacer(),
      _buildToolbarButton(Icons.format_underline, Attribute.underline),
      _spacer(),
      _buildToolbarButton(Icons.format_strikethrough, Attribute.strikeThrough),
    ];
  }

  List<Widget> _buildBlockStyleButtons() {
    final widgets = [
      _spacer(),
      _buildToolbarButton(Icons.format_quote, Attribute.blockQuote),
      _spacer(),
      _buildToolbarButton(Icons.code, Attribute.codeBlock),
    ];

    // Only show link button if text is selected
    if (_hasTextSelected()) {
      widgets.addAll([
        _spacer(),
        _buildToolbarButton(Icons.insert_link, Attribute.link),
      ]);
    }

    return widgets;
  }

  Widget _buildToolbarButton(
    IconData icon,
    Attribute attribute) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(8);
    final isActive = isAttributeActive(widget.controller, attribute);
    return InkWell(
      borderRadius: borderRadius,
      onTap: () => attribute == Attribute.link
          ? handleLinkAttribute(
              widget.controller,
              context,
              onButtonPressed: widget.onButtonPressed,
            )
          : toggleAttribute(
              widget.controller,
              attribute,
              onButtonPressed: widget.onButtonPressed,
            ),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isActive
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : theme.colorScheme.surface,
          borderRadius: borderRadius,
          border: Border.all(
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _spacer() => const SizedBox(width: 8);

  bool _hasTextSelected() {
    final selection = widget.controller.selection;
    return selection.isValid && 
           selection.baseOffset != selection.extentOffset &&
           selection.baseOffset >= 0 && 
           selection.extentOffset >= 0;
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_scheduleRebuild);
    widget.controller.removeListener(_scheduleRebuild);
    super.dispose();
  }
}
