import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/providers/common_providers.dart';
import 'package:zoey/common/widgets/max_width_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:zoey/features/sheet/widgets/sheet_list_widget.dart';
import 'package:zoey/l10n/generated/l10n.dart';

class SheetListScreen extends ConsumerStatefulWidget {
  const SheetListScreen({super.key});

  @override
  ConsumerState<SheetListScreen> createState() => _SheetListScreenState();
}

class _SheetListScreenState extends ConsumerState<SheetListScreen> {
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: MaxWidthWidget(
            child: Column(
              children: [
                ZoeAppBar(title: L10n.of(context).sheets),
                const SizedBox(height: 16),
                ZoeSearchBarWidget(
                  controller: searchController,
                  onChanged: (value) =>
                      ref.read(searchValueProvider.notifier).state = value,
                ),
                const SizedBox(height: 16),
                SheetListWidget(shrinkWrap: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
