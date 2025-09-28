
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/settings/models/theme.dart';
import 'package:zoe/features/settings/providers/theme_provider.dart' hide Theme;
import 'package:zoe/l10n/generated/l10n.dart';

void showThemeDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(L10n.of(context).chooseTheme),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: AppThemeMode.values.map((theme) {
          return RadioListTile<AppThemeMode>(
            title: Text(
              theme.getTitle(context),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              theme.getDescription(context),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            value: theme,
            groupValue: ref.watch(themeProvider),
            onChanged: (value) {
              if (value != null) {
                ref.read(themeProvider.notifier).setTheme(value);
                Navigator.of(context).pop();
              }
            },
          );
        }).toList(),
      ),
    ),
  );
}
