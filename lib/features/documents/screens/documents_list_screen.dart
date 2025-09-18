import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_list_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/documents/widgets/document_list_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

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
      (_) => ref.read(searchValueProvider.notifier).update(''),
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
                  ref.read(searchValueProvider.notifier).update(value),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: DocumentListWidget(
                documentsProvider: documentListSearchProvider,
                isEditing: false,
                isVertical: true,
                emptyState: EmptyStateListWidget(message: L10n.of(context).noDocumentsFound, color: AppColors.brightOrangeColor, contentType: ContentType.document),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
