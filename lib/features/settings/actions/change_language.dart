import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/settings/models/language_model.dart';
import 'package:zoey/features/settings/providers/local_provider.dart';
import 'package:zoey/l10n/generated/l10n.dart';

void showLanguageDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(L10n.of(context).chooseLanguage),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: LanguageModel.allLanguagesList.map((language) {
          return RadioListTile<String>(
            title: Text(
              language.languageName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              language.languageCode.toUpperCase(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            value: language.languageCode,
            groupValue: ref.watch(localeProvider),
            onChanged: (value) {
              if (value != null) {
                ref.read(localeProvider.notifier).setLanguage(value);
                Navigator.of(context).pop();
              }
            },
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(L10n.of(context).cancel),
        ),
      ],
    ),
  );
} 