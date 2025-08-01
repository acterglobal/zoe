import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoey/common/widgets/animated_background_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_floating_action_button_widget.dart';
import 'package:zoey/core/constants/app_constants.dart';
import 'package:zoey/core/preference_service/preferences_service.dart';
import 'package:zoey/core/routing/app_routes.dart';
import 'package:zoey/features/content/providers/content_menu_providers.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';
import 'package:zoey/features/sheet/providers/sheet_providers.dart';
import 'package:zoey/features/sheet/widgets/sheet_list_widget.dart';
import 'package:zoey/features/users/providers/user_providers.dart';
import 'package:zoey/l10n/generated/l10n.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    // Use the provider to check login status and set user if needed
    ref.listen<AsyncValue<bool>>(isUserLoggedInProvider, (previous, next) {
      next.whenData((isLoggedIn) async {
        if (!isLoggedIn) {
          final prefsService = PreferencesService();
          await prefsService.setLoginUserId('user_1');
        }
      });
    });

    return Scaffold(
      floatingActionButton: _buildFloatingActionButton(context),
      body: AnimatedBackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  children: [
                    _buildCustomAppBar(context),
                    const SizedBox(height: 24),
                    _buildHomeBodyUI(context, ref),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return ZoeAppBar(
      title: AppConstants.appName,
      showBackButton: false,
      actions: [
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () => context.push(AppRoutes.settings.route),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.08),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.15),
                width: 0.5,
              ),
            ),
            child: Icon(
              Icons.settings_rounded,
              color: Theme.of(context).colorScheme.onSurface,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return ZoeFloatingActionButton(
      icon: Icons.add_rounded,
      onPressed: () async {
        final sheet = SheetModel();
        ref.read(sheetListProvider.notifier).addSheet(sheet);
        ref.read(isEditValueProvider(sheet.id).notifier).state = true;
        context.push(AppRoutes.sheet.route.replaceAll(':sheetId', sheet.id));
      },
    );
  }

  Widget _buildHomeBodyUI(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 20),
          child: Text(
            L10n.of(context).sheets,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SheetListWidget(shrinkWrap: true),
        const SizedBox(height: 100), // Space for FAB
      ],
    );
  }
}
