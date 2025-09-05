import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:zoe/core/theme/app_theme.dart';

import 'package:zoe/l10n/generated/l10n.dart';
import 'main.directories.g.dart'; // generated

void main() => runApp(const WidgetbookApp());

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      // ✅ v3 uses `directories`, not `categories`
      directories: directories,

      // Wrap all use-cases once (themes, Riverpod, l10n, etc.)
      appBuilder: (context, child) => ProviderScope(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          localizationsDelegates: const [
            ...L10n.localizationsDelegates,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: L10n.supportedLocales,
          home: child,
        ),
      ),

      addons: [
        // Theme addon for testing light/dark themes
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(name: 'Light', data: AppTheme.lightTheme),
            WidgetbookTheme(name: 'Dark', data: AppTheme.darkTheme),
          ],
        ),
        // Text scale for accessibility testing
        TextScaleAddon(
          initialScale: 1.0,
          min: 0.75,
          max: 2.0,
        ),
        // Localization for language testing
        LocalizationAddon(
          locales: L10n.supportedLocales,
          localizationsDelegates: [
            L10n.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
      ],
    );
  }
}
