import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/providers/common_providers.dart';
import 'package:zoey/common/utils/file_utils.dart';
import 'package:zoey/common/widgets/glassy_container_widget.dart';
import 'package:zoey/common/widgets/max_width_widget.dart';
import 'package:zoey/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:zoey/common/widgets/styled_icon_container_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:zoey/features/documents/actions/select_document_actions.dart';
import 'package:zoey/features/documents/models/document_model.dart';
import 'package:zoey/features/documents/providers/document_providers.dart';
import 'package:zoey/l10n/generated/l10n.dart';

class DocumentsListScreen extends ConsumerStatefulWidget {
  const DocumentsListScreen({super.key});

  @override
  ConsumerState<DocumentsListScreen> createState() =>
      _DocumentsListScreenState();
}

class _DocumentsListScreenState extends ConsumerState<DocumentsListScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(searchValueProvider.notifier).state = '',
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: ZoeAppBar(title: L10n.of(context).documents),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: MaxWidthWidget(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            ZoeSearchBarWidget(
              controller: searchController,
              onChanged: (value) =>
                  ref.read(searchValueProvider.notifier).state = value,
            ),
            const SizedBox(height: 10),
            Expanded(child: _buildDocumentList(context, ref)),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentList(BuildContext context, WidgetRef ref) {
    final documents = ref.watch(documentListSearchProvider);
    if (documents.isEmpty) {
      return EmptyStateWidget(message: 'No documents found');
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: documents.length,
      padding: const EdgeInsets.only(bottom: 30),
      itemBuilder: (context, index) {
        final document = documents[index];
        return _buildDocumentItem(context, document);
      },
    );
  }

  Widget _buildDocumentItem(BuildContext context, DocumentModel document) {
    final theme = Theme.of(context);
    final fileTypeColor = getFileTypeColor(document.filePath);
    final fileTypeIcon = getFileTypeIcon(document.filePath);

    return GlassyContainer(
      margin: const EdgeInsets.only(bottom: 8),
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: StyledIconContainer(
          icon: fileTypeIcon,
          primaryColor: fileTypeColor,
          size: 48,
          iconSize: 24,
          backgroundOpacity: 0.1,
          borderOpacity: 0.15,
          shadowOpacity: 0.12,
        ),
        title: Text(
          document.title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${getFileSize(document.filePath)}  •  ${getFileType(document.filePath).toUpperCase()}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
