import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/providers/package_info_provider.dart';
import 'package:zoey/core/theme/colors/app_colors.dart';
import 'package:zoey/features/settings/actions/change_theme.dart';
import 'package:zoey/features/settings/providers/theme_provider.dart';
import 'package:zoey/features/settings/widgets/setting_card_widget.dart';
import 'package:zoey/features/settings/widgets/setting_item_widget.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings'), centerTitle: false),
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
      title: 'Appearance',
      children: [
        SettingItemWidget(
          title: 'Theme',
          subtitle: ref.watch(themeProvider).title,
          icon: Icons.palette_outlined,
          iconColor: AppColors.primaryColor,
          onTap: () => showThemeDialog(context, ref),
        ),
      ],
    );
  }

  Widget _buildLanguageSection(BuildContext context, WidgetRef ref) {
    return SettingCardWidget(
      title: 'Language',
      children: [
        SettingItemWidget(
          title: 'Language',
          subtitle: 'English',
          icon: Icons.language_rounded,
          iconColor: AppColors.successColor,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildAppSection(BuildContext context, WidgetRef ref) {
    return SettingCardWidget(
      title: 'App',
      children: [
        SettingItemWidget(
          title: 'Share App',
          subtitle: 'Tell your friends about Zoe',
          icon: Icons.share_rounded,
          iconColor: AppColors.primaryColor,
          onTap: () {},
        ),
        const Divider(),
        SettingItemWidget(
          title: 'Rate App',
          subtitle: 'Rate us on the App Store',
          icon: Icons.star_rounded,
          iconColor: AppColors.warningColor,
          onTap: () {},
        ),
        const Divider(),
        SettingItemWidget(
          title: 'Contact Us',
          subtitle: 'Get help or send feedback',
          icon: Icons.mail_outline_rounded,
          iconColor: AppColors.errorColor,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context, WidgetRef ref) {
    return SettingCardWidget(
      title: 'About',
      children: [
        SettingItemWidget(
          title: 'App Name',
          subtitle: ref.watch(appNameProvider),
          icon: Icons.apps_rounded,
          iconColor: AppColors.secondaryColor,
          onTap: () {},
        ),
        const Divider(),
        SettingItemWidget(
          title: 'Version',
          subtitle: ref.watch(appVersionProvider),
          icon: Icons.info_outline_rounded,
          iconColor: AppColors.primaryColor,
          onTap: () {},
        ),
        const Divider(),
        SettingItemWidget(
          title: 'Build Number',
          subtitle: ref.watch(buildNumberProvider),
          icon: Icons.build_rounded,
          iconColor: AppColors.warningColor,
          onTap: () {},
        ),
      ],
    );
  }
}
