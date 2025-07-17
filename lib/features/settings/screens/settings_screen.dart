import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:zoey/core/theme/colors/app_colors.dart';
import '../providers/settings_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routing/app_routes.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;

  const SettingsScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => context.go(AppRoutes.home.route),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appearance Section
            _buildSectionHeader('Appearance'),
            const SizedBox(height: 8),
            _buildSettingsCard([_buildThemeOption()]),
            const SizedBox(height: 24),

            // Language Section
            _buildSectionHeader('Language'),
            const SizedBox(height: 8),
            _buildSettingsCard([_buildLanguageOption()]),
            const SizedBox(height: 24),

            // App Section
            _buildSectionHeader('App'),
            const SizedBox(height: 8),
            _buildSettingsCard([
              _buildShareOption(),
              _buildDivider(),
              _buildRateOption(),
              _buildDivider(),
              _buildContactOption(),
            ]),
            const SizedBox(height: 24),

            // About Section
            _buildSectionHeader('About'),
            const SizedBox(height: 8),
            _buildSettingsCard([_buildVersionOption()]),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.getTextSecondary(context),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: Theme.of(context).brightness == Brightness.dark
                  ? 0.3
                  : 0.05,
            ),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildThemeOption() {
    final settings = ref.watch(settingsProvider);
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF6366F1).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.palette_outlined,
          color: Color(0xFF6366F1),
          size: 20,
        ),
      ),
      title: Text(
        'Theme',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        settings.themeName,
        style: TextStyle(
          fontSize: 14,
          color: AppTheme.getTextSecondary(context),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: AppTheme.getTextTertiary(context),
      ),
      onTap: () => _showThemeDialog(context, settings),
    );
  }

  Widget _buildLanguageOption() {
    final settings = ref.watch(settingsProvider);
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.successColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.language_rounded,
          color: AppColors.successColor,
          size: 20,
        ),
      ),
      title: Text(
        'Language',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        settings.languageName,
        style: TextStyle(
          fontSize: 14,
          color: AppTheme.getTextSecondary(context),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: AppTheme.getTextTertiary(context),
      ),
      onTap: () => _showLanguageDialog(context, settings),
    );
  }

  Widget _buildShareOption() {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.share_rounded,
          color: Color(0xFF8B5CF6),
          size: 20,
        ),
      ),
      title: Text(
        'Share App',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        'Tell your friends about Zoe',
        style: TextStyle(
          fontSize: 14,
          color: AppTheme.getTextSecondary(context),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: AppTheme.getTextTertiary(context),
      ),
      onTap: _shareApp,
    );
  }

  Widget _buildRateOption() {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.warningColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.star_rounded,
          color: AppColors.warningColor,
          size: 20,
        ),
      ),
      title: Text(
        'Rate App',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        'Rate us on the App Store',
        style: TextStyle(
          fontSize: 14,
          color: AppTheme.getTextSecondary(context),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: AppTheme.getTextTertiary(context),
      ),
      onTap: _rateApp,
    );
  }

  Widget _buildContactOption() {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.mail_outline_rounded,
          color: Theme.of(context).colorScheme.error,
          size: 20,
        ),
      ),
      title: Text(
        'Contact Us',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        'Get help or send feedback',
        style: TextStyle(
          fontSize: 14,
          color: AppTheme.getTextSecondary(context),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: AppTheme.getTextTertiary(context),
      ),
      onTap: _contactUs,
    );
  }

  Widget _buildVersionOption() {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.info_outline_rounded,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        'Version',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        _packageInfo?.version ?? 'Loading...',
        style: TextStyle(
          fontSize: 14,
          color: AppTheme.getTextSecondary(context),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Theme.of(context).colorScheme.outline,
    );
  }

  void _showThemeDialog(BuildContext context, SettingsState settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppThemeMode.values.map((theme) {
            return RadioListTile<AppThemeMode>(
              title: Text(_getThemeName(theme)),
              subtitle: Text(_getThemeDescription(theme)),
              value: theme,
              groupValue: settings.theme,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).updateTheme(value);
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, SettingsState settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppLanguage.values.map((language) {
            return RadioListTile<AppLanguage>(
              title: Text(_getLanguageName(language)),
              value: language,
              groupValue: settings.language,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).updateLanguage(value);
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  String _getThemeName(AppThemeMode theme) {
    switch (theme) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
    }
  }

  String _getThemeDescription(AppThemeMode theme) {
    switch (theme) {
      case AppThemeMode.light:
        return 'Always use light theme';
      case AppThemeMode.dark:
        return 'Always use dark theme';
      case AppThemeMode.system:
        return 'Follow system setting';
    }
  }

  String _getLanguageName(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.spanish:
        return 'Español';
      case AppLanguage.french:
        return 'Français';
      case AppLanguage.german:
        return 'Deutsch';
      case AppLanguage.japanese:
        return '日本語';
    }
  }

  void _shareApp() {
    Share.share(
      'Check out Zoe - A beautiful personal workspace app! '
      'Organize your thoughts, tasks, and ideas with ease. '
      'Download it now!',
      subject: 'Zoe - Personal Workspace App',
    );
  }

  void _rateApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rate app functionality coming soon!')),
    );
  }

  void _contactUs() {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@zoeapp.com',
      query: 'subject=Zoe App Feedback',
    );

    launchUrl(emailLaunchUri);
  }
}
