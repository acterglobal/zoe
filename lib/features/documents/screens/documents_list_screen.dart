import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Zoe/common/providers/common_providers.dart';
import 'package:Zoe/common/widgets/max_width_widget.dart';
import 'package:Zoe/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:Zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:Zoe/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:Zoe/features/documents/providers/document_providers.dart';
import 'package:Zoe/features/documents/widgets/document_widget.dart';
import 'package:Zoe/l10n/generated/l10n.dart';

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
      return EmptyStateWidget(message: L10n.of(context).noDocumentsFound);
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: documents.length,
      padding: const EdgeInsets.only(bottom: 30),
      itemBuilder: (context, index) {
        final document = documents[index];
        return DocumentWidget(
          documentId: document.id,
          isEditing: false,
          isVertical: true,
        );
      },
    );
  }
}
