import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoey/common/widgets/animated_background_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_floating_action_button_widget.dart';
import 'package:zoey/core/constants/app_constants.dart';
import 'package:zoey/core/preference_service/preferences_service.dart';
import 'package:zoey/core/routing/app_routes.dart';
import 'package:zoey/core/theme/colors/app_colors.dart';
import 'package:zoey/features/content/providers/content_menu_providers.dart';
import 'package:zoey/features/home/widgets/greeting_widget.dart';
import 'package:zoey/features/home/widgets/todays_focus_widget.dart';
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
  void initState() {
    super.initState();
    _setLoginUser();
  }

  Future<void> _setLoginUser() async {
    final isUserLoggedIn = await ref.read(isUserLoggedInProvider.future);
    if (!isUserLoggedIn) {
      final prefsService = PreferencesService();
      await prefsService.setLoginUserId('user_1');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFloatingActionButton(context),
      body: SafeArea(
        child: AnimatedBackgroundWidget(
          backgroundOpacity: 0.2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  children: [
                    _buildModernHeader(context),
                    const SizedBox(height: 32),
                    // Today's Focus section
                    const TodaysFocusWidget(),
                    const SizedBox(height: 32),
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

  Widget _buildModernHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Top bar with app name and settings
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // App name with clean styling
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                border: Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.rocket_launch_rounded,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppConstants.appName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
            // Settings button with clean design
            GestureDetector(
              onTap: () => context.push(AppRoutes.settings.route),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.05),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.15)
                        : Colors.black.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.settings_rounded,
                  color: theme.colorScheme.onSurface,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Dashboard header widget
        const DashboardHeaderWidget(),
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
        _buildSectionHeader(context, L10n.of(context).sheets),
        const SizedBox(height: 16),
        SheetListWidget(shrinkWrap: true),
        const SizedBox(height: 100), // Space for FAB
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor.withValues(alpha: 0.1),
            ),
            child: Icon(
              Icons.folder_rounded,
              color: AppColors.primaryColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
