import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/providers/common_providers.dart';
import 'package:zoey/common/widgets/max_width_widget.dart';
import 'package:zoey/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:zoey/features/link/models/link_model.dart';
import 'package:zoey/features/link/providers/link_providers.dart';
import 'package:zoey/features/link/widgets/link_widget.dart';
import 'package:zoey/l10n/generated/l10n.dart';

class LinksListScreen extends ConsumerStatefulWidget {
  const LinksListScreen({super.key});

  @override
  ConsumerState<LinksListScreen> createState() => _LinksListScreenState();
}

class _LinksListScreenState extends ConsumerState<LinksListScreen> {
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
      title: ZoeAppBar(title: L10n.of(context).links),
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
            Expanded(child: _buildLinkList(context, ref)),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkList(BuildContext context, WidgetRef ref) {
    final links = ref.watch(linkListSearchProvider);
    if (links.isEmpty) {
      return EmptyStateWidget(message: L10n.of(context).noLinksFound);
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: links.length,
      padding: const EdgeInsets.only(bottom: 30),
      itemBuilder: (context, index) {
        final link = links[index];
        return _buildLinkItem(context, link);
      },
    );
  }

  Widget _buildLinkItem(BuildContext context, LinkModel link) {
    return Card(
      margin: const EdgeInsets.only(top: 4, bottom: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        child: LinkWidget(
          key: Key(link.id),
          linkId: link.id,
          isEditing: false,
        ),
      ),
    );
  }
}
