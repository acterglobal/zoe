import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoey/common/widgets/app_icon_widget.dart';
import 'package:zoey/common/widgets/animated_background_widget.dart';
import 'package:zoey/core/routing/app_routes.dart';
import 'package:zoey/features/content/providers/content_menu_providers.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';
import 'package:zoey/features/sheet/providers/sheet_providers.dart';
import 'package:zoey/features/sheet/widgets/sheet_list_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildHomeAppBar(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final sheet = SheetModel();
            ref.read(sheetListProvider.notifier).addSheet(sheet);
            ref.read(isEditValueProvider.notifier).state = true;
            context.push(
              AppRoutes.sheet.route.replaceAll(':sheetId', sheet.id),
            );
          },
          child: const Icon(Icons.add_rounded),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: _buildHomeBodyUI(context, ref),
          ),
        ),
      ),
    );
  }

  AppBar _buildHomeAppBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: Row(
        children: [
          const AppIconWidget(size: 32),
          const SizedBox(width: 8),
          Text('Zoey', style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => context.push(AppRoutes.settings.route),
          icon: const Icon(Icons.settings_rounded),
        ),
      ],
    );
  }

  Widget _buildHomeBodyUI(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sheets', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        SheetListWidget(shrinkWrap: true),
        const SizedBox(height: 16),
      ],
    );
  }
}
