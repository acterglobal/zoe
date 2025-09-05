import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/features/home/zoe_preview_widget.dart';
import 'package:widgetbook_workspace/features/settings/mock_theme_providers.dart';
import 'package:zoe/core/theme/app_theme.dart';
import 'package:zoe/features/settings/actions/change_theme.dart';
import 'package:zoe/features/settings/models/theme.dart';
import 'package:zoe/features/settings/providers/theme_provider.dart';
import 'package:zoe/features/settings/screens/settings_screen.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:zoe/l10n/generated/l10n.dart';


String _getThemeDescription(AppThemeMode theme) {
  switch (theme) {
    case AppThemeMode.light:
      return 'Always use light theme';
    case AppThemeMode.dark:
      return 'Always use dark theme';
    case AppThemeMode.system:
      return 'Follow system theme setting';
  }
}

@widgetbook.UseCase(name: 'Theme Dialog', type: SettingsScreen)
Widget buildThemeDialogUseCase(BuildContext context) {
  final selectedTheme = context.knobs.object.dropdown(
    label: 'Theme',
    options: AppThemeMode.values,
    initialOption: AppThemeMode.light,
    labelBuilder: (theme) => theme.name,
  );

  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    themeMode: selectedTheme.themeMode,
    localizationsDelegates: const [
      L10n.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: L10n.supportedLocales,
    home: ProviderScope(
      overrides: [
        themeProvider.overrideWith(
          (ref) => MockThemeNotifier(ref)..setTheme(selectedTheme),
        ),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          return Localizations(
            locale: const Locale('en'),
            delegates: const [
              L10n.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            child: Builder(
              builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('Preview Theme Dialog')),
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Create a custom dialog with localization context
                      showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Choose Theme'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: AppThemeMode.values.map((theme) {
                              return RadioListTile<AppThemeMode>(
                                title: Text(
                                  theme.name,
                                  style: Theme.of(dialogContext).textTheme.titleMedium,
                                ),
                                subtitle: Text(
                                  _getThemeDescription(theme),
                                  style: Theme.of(dialogContext).textTheme.bodySmall,
                                ),
                                value: theme,
                                groupValue: ref.watch(themeProvider),
                                onChanged: (value) {
                                  if (value != null) {
                                    ref.read(themeProvider.notifier).setTheme(value);
                                    Navigator.of(dialogContext).pop();
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                    child: const Text('Open Theme Dialog'),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Settings Screen', type: SettingsScreen)
Widget buildSettingsScreenUseCase(BuildContext context) {
  final selectedTheme = context.knobs.object.dropdown(
    label: 'Current Theme',
    options: AppThemeMode.values,
    initialOption: AppThemeMode.light,
    labelBuilder: (theme) => theme.name,
  );

  final showDialog = context.knobs.boolean(
    label: 'Show Theme Dialog',
    description: 'Toggle to show/hide the theme dialog',
    initialValue: false,
  );

  return Consumer(
    builder: (context, ref, _) {
      if (showDialog) {
        // Use addPostFrameCallback to show dialog after build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showThemeDialog(context, ref);
        });
      }

      return ProviderScope(
        overrides: [
          themeProvider.overrideWith(
            (ref) => MockThemeNotifier(ref)..setTheme(selectedTheme),
          ),
        ],
        child: ZoePreview(child: SettingsScreen()),
      );
    },
  );
}
