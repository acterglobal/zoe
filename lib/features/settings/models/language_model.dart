class LanguageModel {
  final String languageName;
  final String languageCode;

  LanguageModel({required this.languageName, required this.languageCode});

  factory LanguageModel.fromCode(String? locale) {
    return switch (locale) {
      'en' => const LanguageModel.english(),
      'hi' => const LanguageModel.hindi(),
      'gu' => const LanguageModel.gujarati(),
      _ => const LanguageModel.english(), 
    };
  }

  const LanguageModel.english() : languageName = 'English', languageCode = 'en';
  const LanguageModel.hindi() : languageName = 'हिंदी', languageCode = 'hi';
  const LanguageModel.gujarati() : languageName = 'ગુજરાતી', languageCode = 'gu';

  static const allLanguagesList = [
    LanguageModel.english(),
    LanguageModel.hindi(),
    LanguageModel.gujarati(),
  ];
}