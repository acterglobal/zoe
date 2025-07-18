import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/settings/models/theme.dart';
import 'package:zoey/features/settings/providers/theme_provider.dart';

void showThemeDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Choose Theme'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: AppThemeMode.values.map((theme) {
          return RadioListTile<AppThemeMode>(
            title: Text(
              theme.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              theme.description,
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
