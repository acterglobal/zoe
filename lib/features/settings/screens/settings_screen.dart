import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/providers/package_info_provider.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/features/settings/actions/change_theme.dart';
import 'package:zoe/features/settings/models/language_model.dart';
import 'package:zoe/features/settings/providers/local_provider.dart';
import 'package:zoe/features/settings/providers/theme_provider.dart';
import 'package:zoe/features/settings/widgets/setting_card_widget.dart';
import 'package:zoe/features/settings/widgets/setting_item_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Center(
          child: MaxWidthWidget(
            isScrollable: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildSettingsBodyUI(context, ref),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: ZoeAppBar(title: L10n.of(context).settings),
    );
  }

  Widget _buildSettingsBodyUI(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        // Appearance Section
        _buildAppearanceSection(context, ref),
        const SizedBox(height: 20),

        // Language Section
        _buildLanguageSection(context, ref),
        const SizedBox(height: 20),

        // App Section
        _buildAppSection(context, ref),
        const SizedBox(height: 20),

        // About Section
        _buildAboutSection(context, ref),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildAppearanceSection(BuildContext context, WidgetRef ref) {
    return SettingCardWidget(
      title: L10n.of(context).appearance,
      children: [
        SettingItemWidget(
          title: L10n.of(context).theme,
          subtitle: ref.watch(themeProvider).getTitle(context),
          icon: Icons.palette_outlined,
          iconColor: const Color(0xFF6366F1), // Indigo
          onTap: () => showThemeDialog(context, ref),
        ),
      ],
    );
  }

  Widget _buildLanguageSection(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final currentLanguage = LanguageModel.fromCode(currentLocale);

    return SettingCardWidget(
      title: L10n.of(context).language,
      children: [
        SettingItemWidget(
          title: L10n.of(context).language,
          subtitle: currentLanguage.languageName,
          icon: Icons.language_rounded,
          iconColor: const Color(0xFF10B981), // Emerald
          onTap: () => context.push(AppRoutes.settingLanguage.route),
        ),
      ],
    );
  }

  Widget _buildAppSection(BuildContext context, WidgetRef ref) {
    return SettingCardWidget(
      title: L10n.of(context).app,
      children: [
        SettingItemWidget(
          title: L10n.of(context).shareApp,
          subtitle: L10n.of(context).tellYourFriendsAboutZoey,
          icon: Icons.share_rounded,
          iconColor: const Color(0xFF3B82F6), // Blue
          onTap: () {},
        ),
        const Divider(height: 1),
        SettingItemWidget(
          title: L10n.of(context).rateApp,
          subtitle: L10n.of(context).rateUsOnTheAppStore,
          icon: Icons.star_rounded,
          iconColor: const Color(0xFFF59E0B), // Amber
          onTap: () {},
        ),
        const Divider(height: 1),
        SettingItemWidget(
          title: L10n.of(context).contactUs,
          subtitle: L10n.of(context).getHelpOrSendFeedback,
          icon: Icons.mail_outline_rounded,
          iconColor: const Color(0xFFEF4444), // Red
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context, WidgetRef ref) {
    return SettingCardWidget(
      title: L10n.of(context).about,
      children: [
        SettingItemWidget(
          title: L10n.of(context).appName,
          subtitle: ref.watch(appNameProvider),
          icon: Icons.apps_rounded,
          iconColor: const Color(0xFF8B5CF6), // Violet
          onTap: () {},
        ),
        const Divider(height: 1),
        SettingItemWidget(
          title: L10n.of(context).version,
          subtitle: ref.watch(appVersionProvider),
          icon: Icons.info_outline_rounded,
          iconColor: const Color(0xFF06B6D4), // Cyan
          onTap: () {},
        ),
        const Divider(height: 1),
        SettingItemWidget(
          title: L10n.of(context).buildNumber,
          subtitle: ref.watch(buildNumberProvider),
          icon: Icons.build_rounded,
          iconColor: const Color(0xFF84CC16), // Lime
          onTap: () {},
        ),
      ],
    );
  }
}
