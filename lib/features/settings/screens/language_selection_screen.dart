import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/features/settings/models/language_model.dart';
import 'package:zoe/features/settings/providers/locale_provider.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(appBar: _buildAppbar(context), body: _buildBody(ref));
  }

  AppBar _buildAppbar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: ZoeAppBar(title: L10n.of(context).selectLanguage),
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
      child: RadioGroup<String>(
        groupValue: ref.watch(appLocaleProvider),
        onChanged: (val) async {
          if (val != null) {
            final notifier = ref.read(appLocaleProvider.notifier);
            await notifier.setLanguage(val);
          }
        },
        child: RadioListTile<String>(
          value: language.languageCode,
          title: Text(language.languageName),
          subtitle: Text(language.languageCode.toUpperCase()),
        ),
      ),
    );
  }
}
