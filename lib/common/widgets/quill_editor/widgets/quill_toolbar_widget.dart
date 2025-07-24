import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:zoey/common/widgets/quill_editor/widgets/quill_toolbar_button.dart';
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
    addFocusListener(widget.focusNode, _scheduleRebuild);
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
      removeFocusListener(oldWidget.focusNode, _scheduleRebuild);
      addFocusListener(widget.focusNode, _scheduleRebuild);
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
              ..._buildTextStyleButtons(),
              ..._buildBlockStyleButtons(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTextStyleButtons() {
    return [
      _buildFormatButton(Icons.format_bold, Attribute.bold),
      _spacer(),
      _buildFormatButton(Icons.format_italic, Attribute.italic),
      _spacer(),
      _buildFormatButton(Icons.format_underline, Attribute.underline),
      _spacer(),
      _buildFormatButton(Icons.format_strikethrough, Attribute.strikeThrough),
    ];
  }

  List<Widget> _buildBlockStyleButtons() {
    return [
      _spacer(),
      _buildFormatButton(Icons.format_quote, Attribute.blockQuote),
      _spacer(),
      _buildFormatButton(Icons.code, Attribute.codeBlock),
    ];
  }

  Widget _buildFormatButton(IconData icon, Attribute attribute) {
    return buildToolbarButton(
      context: context,
      icon: icon,
      isActive: isAttributeActive(widget.controller, attribute),
      onPressed: () => toggleAttribute(
        widget.controller,
        attribute,
        onButtonPressed: widget.onButtonPressed,
      ),
    );
  }

  Widget _spacer() => const SizedBox(width: 8);

  @override
  void dispose() {
    removeFocusListener(widget.focusNode, _scheduleRebuild);
    widget.controller.removeListener(_scheduleRebuild);
    super.dispose();
  }
}
