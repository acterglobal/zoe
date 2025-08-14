import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:Zoe/common/widgets/animated_background_widget.dart';
import 'package:Zoe/common/widgets/max_width_widget.dart';
import 'package:Zoe/common/widgets/toolkit/zoe_floating_action_button_widget.dart';
import 'package:Zoe/common/widgets/toolkit/zoe_icon_button_widget.dart';
import 'package:Zoe/core/constants/app_constants.dart';
import 'package:Zoe/core/preference_service/preferences_service.dart';
import 'package:Zoe/core/routing/app_routes.dart';
import 'package:Zoe/features/content/providers/content_menu_providers.dart';
import 'package:Zoe/features/home/widgets/section_header/section_header_widget.dart';
import 'package:Zoe/features/home/widgets/stats_section/stats_section_widget.dart';
import 'package:Zoe/features/home/widgets/today_focus/todays_focus_widget.dart';
import 'package:Zoe/features/home/widgets/welcome_section/welcome_section_widget.dart';
import 'package:Zoe/features/sheet/models/sheet_model.dart';
import 'package:Zoe/features/sheet/providers/sheet_providers.dart';
import 'package:Zoe/features/sheet/widgets/sheet_list_widget.dart';
import 'package:Zoe/features/users/providers/user_providers.dart';
import 'package:Zoe/l10n/generated/l10n.dart';

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
    return AnimatedBackgroundWidget(
      backgroundOpacity: 0.2,
      child: Scaffold(
        appBar: _buildAppBar(),
        floatingActionButton: _buildFloatingActionButton(),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: _buildAppNameIconWidget(),
      actions: [
        ZoeIconButtonWidget(
          icon: Icons.settings_rounded,
          onTap: () => context.push(AppRoutes.settings.route),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildAppNameIconWidget() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.rocket_launch_rounded,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            AppConstants.appName,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Center(
        child: MaxWidthWidget(
          isScrollable: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              const WelcomeSectionWidget(),
              const SizedBox(height: 16),
              const StatsSectionWidget(),
              const TodaysFocusWidget(),
              const SizedBox(height: 32),
              _buildSheetsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
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

  Widget _buildSheetsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          title: L10n.of(context).sheets,
          icon: Icons.description,
        ),
        const SizedBox(height: 16),
        SheetListWidget(shrinkWrap: true),
        const SizedBox(height: 100), // Space for FAB
      ],
    );
  }
}
