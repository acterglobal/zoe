import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:zoe/features/documents/actions/text_preview_actions.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/widgets/document_error_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class TextPreviewWidget extends ConsumerStatefulWidget {
  final DocumentModel document;

  const TextPreviewWidget({super.key, required this.document});

  @override
  ConsumerState<TextPreviewWidget> createState() => _TextPreviewWidgetState();
}

class _TextPreviewWidgetState extends ConsumerState<TextPreviewWidget> {
  String _fileContent = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTextFile();

    // reset search when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchValueProvider.notifier).update('');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTextFile() async {
    final file = File(widget.document.filePath);
    if (!file.existsSync()) return;

    final content = await file.readAsString();
    setState(() => _fileContent = content);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ZoeSearchBarWidget(
          controller: _searchController,
          onChanged: (value) =>
              ref.read(searchValueProvider.notifier).update(value),
          hintText: L10n.of(context).searchInText,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        Expanded(child: _buildContent(context)),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    if (!File(widget.document.filePath).existsSync() || _fileContent.isEmpty) {
      return DocumentErrorWidget(errorName: L10n.of(context).failedToLoadFile);
    }

    return GlassyContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      child: _buildTextContent(context),
    );
  }

  Widget _buildTextContent(BuildContext context) {
    final searchValue = ref.watch(searchValueProvider);
    final lines = _fileContent.split('\n');

    final matchedIndices = getTextSearchIndices(_fileContent, searchValue);

    return ListView.builder(
      itemCount: lines.length,
      itemBuilder: (context, index) {
        final line = lines[index];
        final isSearchMatch = matchedIndices.contains(index);
        final isCurrentMatch =
            matchedIndices.isNotEmpty && index == matchedIndices.last;

        return _buildLineWidget(
          index: index,
          line: line,
          isSearchMatch: isSearchMatch,
          isCurrentMatch: isCurrentMatch,
          searchValue: searchValue,
        );
      },
    );
  }

  Widget _buildLineWidget({
    required int index,
    required String line,
    required bool isSearchMatch,
    required bool isCurrentMatch,
    required String searchValue,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isCurrentMatch
            ? theme.colorScheme.primary.withValues(alpha: 0.2)
            : isSearchMatch
            ? theme.colorScheme.primary.withValues(alpha: 0.1)
            : null,
        borderRadius: BorderRadius.circular(4),
      ),
      child: searchValue.isNotEmpty && isSearchMatch
          ? _buildHighlightedText(line, searchValue)
          : SelectableText(
              line.isEmpty ? ' ' : line,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                height: 1.4,
              ),
            ),
    );
  }

  Widget _buildHighlightedText(String text, String query) {
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final matches = <TextSpan>[];
    int start = 0;

    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        // remaining text
        if (start < text.length) {
          matches.add(TextSpan(text: text.substring(start)));
        }
        break;
      }

      // text before match
      if (index > start) {
        matches.add(TextSpan(text: text.substring(start, index)));
      }

      // highlighted match
      matches.add(
        TextSpan(
          text: text.substring(index, index + query.length),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );

      start = index + query.length;
    }

    return SelectableText.rich(TextSpan(children: matches));
  }
}
