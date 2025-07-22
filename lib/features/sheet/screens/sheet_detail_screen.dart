import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';
import 'package:zoey/features/content/widgets/add_content_menu.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/sheet_detail_app_bar.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/sheet_contents.dart';
import 'package:zoey/features/sheet/widgets/quill_toolbar/view_quill_editor_toolbar_widget.dart';

class SheetDetailScreen extends ConsumerStatefulWidget {
  final String? sheetId;

  const SheetDetailScreen({super.key, this.sheetId});

  @override
  ConsumerState<SheetDetailScreen> createState() => _SheetDetailScreenState();
}

class _SheetDetailScreenState extends ConsumerState<SheetDetailScreen> {
  QuillController? _activeController;
  FocusNode? _activeFocusNode;
  bool _isToolbarVisible = false;

  void _handleEditorFocusChanged(QuillController? controller, FocusNode? focusNode) {
    setState(() {
      _activeController = controller;
      _activeFocusNode = focusNode;
      _isToolbarVisible = focusNode?.hasFocus ?? false;
    });
  }

  void _returnFocusToEditor() {
    if (_activeFocusNode != null) {
      _activeFocusNode!.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isEditing = ref.watch(isEditingProvider(widget.sheetId));

    return Scaffold(
      appBar: SheetDetailAppBar(sheetId: widget.sheetId),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                _buildBody(context, ref),
                if (isEditing)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: keyboardHeight,
                    child: ViewQuillEditorToolbarWidget(
                      controller: _activeController,
                      focusNode: _activeFocusNode,
                      isToolbarVisible: _isToolbarVisible,
                      onReturnFocusToEditor: _returnFocusToEditor,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the main body
  Widget _buildBody(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(isEditingProvider(widget.sheetId));
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, ref),
          const SizedBox(height: 16),
          SheetContents(sheetId: widget.sheetId),
          _buildAddContentArea(context, ref),
          // Add padding only when editing to make space for toolbar
          if (isEditing) const SizedBox(height: 80),
        ],
      ),
    );
  }

  /// Builds the header
  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () =>
                  ref.read(sheetDetailProvider(widget.sheetId).notifier).updateEmoji(),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  ref.watch(sheetProvider(widget.sheetId)).emoji ?? '📄',
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: ZoeInlineTextEditWidget(
                hintText: 'Title',
                isEditing: ref.watch(isEditingProvider(widget.sheetId)),
                text: ref.watch(sheetProvider(widget.sheetId)).title,
                textStyle: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.2,
                ),
                onTextChanged: (value) => ref
                    .read(sheetDetailProvider(widget.sheetId).notifier)
                    .updateTitle(value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Description field with rich text editing (HTML formatting support)
        ZoeInlineTextEditWidget(
          hintText: 'Add a description',
          isEditing: ref.watch(isEditingProvider(widget.sheetId)),
          text: ref.watch(sheetProvider(widget.sheetId)).description,
          textStyle: Theme.of(context).textTheme.bodyLarge,
          onTextChanged: (value) => ref
              .read(sheetDetailProvider(widget.sheetId).notifier)
              .updateDescription(value),
          onHtmlChanged: (plainText, richText) => ref
              .read(sheetDetailProvider(widget.sheetId).notifier)
              .updateDescription(plainText, richText: richText),
          onFocusChanged: _handleEditorFocusChanged,
        ),
      ],
    );
  }

  /// Builds the add content area
  Widget _buildAddContentArea(BuildContext context, WidgetRef ref) {
    final showAddMenu = ref.watch(sheetDetailProvider(widget.sheetId)).showAddMenu;
    final isEditing = ref.watch(isEditingProvider(widget.sheetId));
    return isEditing
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => ref
                    .read(sheetDetailProvider(widget.sheetId).notifier)
                    .toggleAddMenu(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 4,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        showAddMenu ? Icons.close : Icons.add,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        showAddMenu ? 'Cancel' : 'Add content',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (showAddMenu) AddContentMenu(sheetId: widget.sheetId),
            ],
          )
        : const SizedBox.shrink();
  }
}
