import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoey/common/providers/package_info_provider.dart';
import 'package:zoey/core/routing/app_routes.dart';
import 'package:zoey/core/theme/colors/app_colors.dart';
import 'package:zoey/features/settings/actions/change_theme.dart';
import 'package:zoey/features/settings/models/language_model.dart';
import 'package:zoey/features/settings/providers/local_provider.dart';
import 'package:zoey/features/settings/providers/theme_provider.dart';
import 'package:zoey/features/settings/widgets/setting_card_widget.dart';
import 'package:zoey/features/settings/widgets/setting_item_widget.dart';
import 'package:zoey/l10n/generated/l10n.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).settings), centerTitle: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 600),
            child: _buildSettingsBodyUI(context, ref),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsBodyUI(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Appearance Section
        _buildAppearanceSection(context, ref),
        const SizedBox(height: 12),

        // Language Section
        _buildLanguageSection(context, ref),
        const SizedBox(height: 12),

        // App Section
        _buildAppSection(context, ref),
        const SizedBox(height: 12),

        // About Section
        _buildAboutSection(context, ref),
        const SizedBox(height: 12),
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
          iconColor: AppColors.primaryColor,
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
          iconColor: AppColors.successColor,
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
          iconColor: AppColors.primaryColor,
          onTap: () {},
        ),
        const Divider(),
        SettingItemWidget(
          title: L10n.of(context).rateApp,
          subtitle: L10n.of(context).rateUsOnTheAppStore,
          icon: Icons.star_rounded,
          iconColor: AppColors.warningColor,
          onTap: () {},
        ),
        const Divider(),
        SettingItemWidget(
          title: L10n.of(context).contactUs,
          subtitle: L10n.of(context).getHelpOrSendFeedback,
          icon: Icons.mail_outline_rounded,
          iconColor: AppColors.errorColor,
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
          iconColor: AppColors.secondaryColor,
          onTap: () {},
        ),
        const Divider(),
        SettingItemWidget(
          title: L10n.of(context).version,
          subtitle: ref.watch(appVersionProvider),
          icon: Icons.info_outline_rounded,
          iconColor: AppColors.primaryColor,
          onTap: () {},
        ),
        const Divider(),
        SettingItemWidget(
          title: L10n.of(context).buildNumber,
          subtitle: ref.watch(buildNumberProvider),
          icon: Icons.build_rounded,
          iconColor: AppColors.warningColor,
          onTap: () {},
        ),
      ],
    );
  }
}
