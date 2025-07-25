import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/settings/models/language_model.dart';
import 'package:zoey/features/settings/providers/local_provider.dart';
import 'package:zoey/l10n/generated/l10n.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(appBar: _buildAppbar(context), body: _buildBody(ref));
  }

  AppBar _buildAppbar(BuildContext context) {
    return AppBar(
      title: Text(L10n.of(context).selectLanguage),
      centerTitle: true,
    );
  }

  Widget _buildBody(WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      itemCount: LanguageModel.allLanguagesList.length,
      itemBuilder: (context, index) {
        final language = LanguageModel.allLanguagesList[index];
        return _languageItem(context, ref, language);
      },
    );
  }

  Widget _languageItem(
    BuildContext context,
    WidgetRef ref,
    LanguageModel language,
  ) {
    return Card(
      child: RadioListTile(
        value: language.languageCode,
        groupValue: ref.watch(localeProvider),
        title: Text(language.languageName),
        subtitle: Text(language.languageCode.toUpperCase()),
        onChanged: (val) async {
          if (val != null) {
            final notifier = ref.read(localeProvider.notifier);
            await notifier.setLanguage(val);
          }
        },
      ),
    );
  }
}
