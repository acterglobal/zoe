import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/features/home/zoe_preview_widget.dart';
import 'package:zoe/features/settings/models/language_model.dart';
import 'package:zoe/features/settings/screens/language_selection_screen.dart';
import '../mock_locale_providers.dart';

@widgetbook.UseCase(name: 'Language Selection Screen', type: LanguageSelectionScreen)
Widget buildLanguageSelectionScreenUseCase(BuildContext context) {
  final selectedLanguage = context.knobs.object.dropdown(
    label: 'Selected Language',
    options: LanguageModel.allLanguagesList,
    initialOption: const LanguageModel.english(),
    labelBuilder: (language) => language.languageName,
  );

  return ProviderScope(
    overrides: [
      mockLocaleProvider.overrideWith(
        (ref) => MockLocaleNotifier()..setLocale(selectedLanguage.languageCode),
      ),
    ],
    child: ZoePreview(child: LanguageSelectionScreen()),
  );
}
